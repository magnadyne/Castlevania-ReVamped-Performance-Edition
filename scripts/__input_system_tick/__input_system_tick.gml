// Feather disable all
function __input_system_tick()
{
    __INPUT_GLOBAL_STATIC_LOCAL  //Set static _global
    
    _global.__frame++;
    _global.__previous_current_time = _global.__current_time;
    _global.__current_time = current_time;
    _global.__cleared = false;

    #region Touch
    
    //if (INPUT_PS_TOUCHPAD_ALLOWED && __INPUT_ON_PS)
    //{
    //    //Use first touch (of 2) on active PlayStation gamepad
    //    var _gamepad = _global.__players[0].__source_get_gamepad();
    //    if (_gamepad >= 0 && _gamepad < 4)
    //    {
    //        _global.__pointer_index = _gamepad * 2;
    //        _global.__pointer_pressed  = gamepad_button_check_pressed(_gamepad,  gp_select);
    //        _global.__pointer_released = gamepad_button_check_released(_gamepad, gp_select);
    //    }
    //}
	//Touchpad input is set to false

    if (_global.__touch_allowed)
    {
        var _touch_index = undefined;
        var _touch_press_index = _global.__pointer_pressed_index;

        //Track contact duration per index
        var _i = 0;
        repeat(INPUT_MAX_TOUCHPOINTS)
        {
            if (!device_mouse_check_button(_i, mb_left))
            {
                _global.__pointer_durations[_i] = 0;
            }
            else
            {
                //Get recent active touch
                _global.__pointer_durations[_i] += delta_time;
                if ((_touch_index == undefined) || (_global.__pointer_durations[_i] < _global.__pointer_durations[_touch_index]))
                {
                    _touch_index = _i;
                }
            }

            _i++;
        }
    
        //Set active pointer index
        if (_touch_index == undefined) _touch_index = 0;
        _global.__pointer_pressed  = device_mouse_check_button_pressed(_touch_index, mb_left);
        _global.__pointer_released = ((_global.__pointer_index_previous != undefined) && device_mouse_check_button_released(_global.__pointer_index_previous, mb_left));

        //Touch edge testing
        var _w = display_get_gui_width();
        var _h = display_get_gui_height();
        if (INPUT_TOUCH_EDGE_DEADZONE > 0)
        {
            //Release
            if (_global.__pointer_released)
            {
                var _tx = device_mouse_x_to_gui(_global.__pointer_index_previous);
                var _ty = device_mouse_y_to_gui(_global.__pointer_index_previous);

                if ((_tx < INPUT_TOUCH_EDGE_DEADZONE) || (_tx > (_w - INPUT_TOUCH_EDGE_DEADZONE))
                ||  (_ty < INPUT_TOUCH_EDGE_DEADZONE) || (_ty > (_h - INPUT_TOUCH_EDGE_DEADZONE)))
                {
                    _global.__pointer_released = false;
                }
            }
    
            //Press
            if (_global.__pointer_pressed)
            {
                var _tx = device_mouse_x_to_gui(_touch_index);
                var _ty = device_mouse_y_to_gui(_touch_index);

                if ((_tx < INPUT_TOUCH_EDGE_DEADZONE) || (_tx > (_w - INPUT_TOUCH_EDGE_DEADZONE))
                ||  (_ty < INPUT_TOUCH_EDGE_DEADZONE) || (_ty > (_h - INPUT_TOUCH_EDGE_DEADZONE)))
                {
                    _global.__pointer_pressed = false;
                }
            }
        }

        //Update state
        _global.__pointer_index_previous = _global.__pointer_index;
        _global.__pointer_index = _touch_index;
        if (_global.__pointer_pressed)  _global.__pointer_pressed_index = _touch_index;
    }
    
    #endregion
    
    
    
    #region Application state
    
    if (INPUT_ON_PC && !INPUT_ON_WEB)
    {
        if (os_is_paused())
        {
            //Lost focus
            _global.__window_focus = false;
            
            //Linux app continues to recieve input some number of frames after focus loss
            //Clear IO on focus loss to prevent false positive of subsequent focus regain
            io_clear();
            
            __input_gamepad_stop_trigger_effects(all);
        }
        else
        {
            if (_global.__window_focus)
            {
                if (_global.__window_focus_block_mouse)
                {
                    //Unblock so we can test for a held mouse button
                    _global.__window_focus_block_mouse = false;
                
                    //Sustain mouse block while a button remains held
                    if (__input_mouse_button() != mb_none) _global.__window_focus_block_mouse = true;
                }
            }
            else if ((keyboard_key != vk_nokey) 
                 ||  (mouse_button != mb_none)
                 ||  (__INPUT_ON_WINDOWS && window_has_focus())
                 ||  (__INPUT_ON_MACOS   && _global.__pointer_moved))
            {
                //Regained focus
                _global.__window_focus = true;
                _global.__window_focus_frame = _global.__frame;
                
                //Block mouse button input
                if (!INPUT_ALLOW_OUT_OF_FOCUS) _global.__window_focus_block_mouse = true;
                    
                //Retrigger mouse capture timer to avoid the mouse jumping all over the place when we refocus the window
                if (_global.__mouse_capture) _global.__mouse_capture_frame = _global.__frame;
                
                __input_player_apply_trigger_effects(all);
            }
        }
    }
    
    _global.__overlay_focus = false;
    if (_global.__using_steamworks)
    {
        //Steam overlay
        if (steam_is_overlay_activated())
        {
            _global.__overlay_focus = true;
        }
    }
    
    if (_global.__use_debug_overlay_status)
    {
        //Debug overlay
        if (is_debug_overlay_open())
        {
            _global.__overlay_focus = true;
        }
    }
    
    _global.__game_focus = (INPUT_ALLOW_OUT_OF_FOCUS || (_global.__window_focus && !_global.__overlay_focus));
    
    //Prevent restart thrashing
    if ((_global.__current_time - _global.__restart_time) < 1000)
    {
        __input_clear_all();
    }
    
    #endregion
    
    
    
    #region Mouse
    
    //var _moved = false;    
    //var _m = 0;
    //repeat(INPUT_COORD_SPACE.__SIZE)
    //{
    //    _global.__pointer_dx[@ _m] = 0;
    //    _global.__pointer_dy[@ _m] = 0;
    //    ++_m;
    //}
    
    ////Block mouse capture when focus state changes
    //if (_global.__mouse_capture && _global.__game_focus)
    //{
    //    if (__input_window_changed())
    //    {
    //        _global.__mouse_capture_blocked = true;
    //        if (__INPUT_ON_WINDOWS)
    //        {
    //            input_mouse_capture_set(true, _global.__mouse_capture_sensitivity);        
    //        }
    //    }
    //    else if (_global.__mouse_capture_blocked && device_mouse_check_button_pressed(0, mb_left))
    //    {
    //        input_mouse_capture_set(true, _global.__mouse_capture_sensitivity);        
    //    }
    //}
    
    //if (INPUT_ALLOW_OUT_OF_FOCUS || !_global.__overlay_focus)
    //{
    //    if (_global.__mouse_capture && !_global.__mouse_capture_blocked)
    //    {
    //        if (_global.__window_focus)
    //        {
    //            if (_global.__frame - _global.__mouse_capture_frame > 10)
    //            {
    //                if (__INPUT_ON_WINDOWS)
    //                {
    //                    _pointer_x = display_mouse_get_x() - window_get_x();
    //                    _pointer_y = display_mouse_get_y() - window_get_y();  
    //                }
    //                else
    //                {
    //                    _pointer_x = device_mouse_raw_x(_global.__pointer_index);
    //                    _pointer_y = device_mouse_raw_y(_global.__pointer_index);
    //                }
                
    //                //Only bother updating each coordinate space if we've moved far enough in device space
    //                //This presumes that we don't get better than 1px resolution in device space
    //                if ((abs(_pointer_x - window_get_width()/2)  >= 1)
    //                ||  (abs(_pointer_y - window_get_height()/2) >= 1))
    //                {
    //                    var _m = 0;
    //                    repeat(INPUT_COORD_SPACE.__SIZE)
    //                    {
    //                        switch(_m)
    //                        {
    //                            case INPUT_COORD_SPACE.ROOM:
    //                                if (view_enabled && view_visible[0])
    //                                {
    //                                    var _camera = view_camera[0];
    //                                    var _viewW = camera_get_view_width(_camera);
    //                                    var _viewH = camera_get_view_height(_camera);
    //                                    var _viewX = camera_get_view_x(_camera);
    //                                    var _viewY = camera_get_view_y(_camera);
    //                                    var _old_x = _viewX + _viewW/2;
    //                                    var _old_y = _viewY + _viewH/2;
    //                                }
    //                                else
    //                                {
    //                                    var _old_x = room_width/2;
    //                                    var _old_y = room_height/2;
    //                                }
                                
    //                                var _pointer_x = device_mouse_x(_global.__pointer_index);
    //                                var _pointer_y = device_mouse_y(_global.__pointer_index);
    //                            break;
                            
    //                            case INPUT_COORD_SPACE.GUI:
    //                                var _old_x     = display_get_gui_width()/2;
    //                                var _old_y     = display_get_gui_height()/2;
    //                                var _pointer_x = device_mouse_x_to_gui(_global.__pointer_index);
    //                                var _pointer_y = device_mouse_y_to_gui(_global.__pointer_index);
    //                            break;
                            
    //                            case INPUT_COORD_SPACE.DEVICE:
    //                                var _old_x = window_get_width()/2;
    //                                var _old_y = window_get_height()/2;
                                
    //                                if (__INPUT_ON_WINDOWS)
    //                                {
    //                                    _pointer_x = display_mouse_get_x() - window_get_x();
    //                                    _pointer_y = display_mouse_get_y() - window_get_y();  
    //                                }
    //                                else
    //                                {
    //                                    _pointer_x = device_mouse_raw_x(_global.__pointer_index);
    //                                    _pointer_y = device_mouse_raw_y(_global.__pointer_index);
    //                                }
    //                            break;
    //                        }
                        
    //                        var _dx = (_pointer_x - _old_x)*_global.__mouse_capture_sensitivity;
    //                        var _dy = (_pointer_y - _old_y)*_global.__mouse_capture_sensitivity;
                        
    //                        //Only detect movement in the display coordinate space so that moving a room's view, or moving the window, doesn't trigger movement
    //                        if ((_m == INPUT_COORD_SPACE.DEVICE) && (_dx*_dx + _dy*_dy > INPUT_MOUSE_MOVE_DEADZONE*INPUT_MOUSE_MOVE_DEADZONE)) _moved = true;
                        
    //                        _global.__pointer_dx[@ _m] = _dx;
    //                        _global.__pointer_dy[@ _m] = _dy;
                        
    //                        _global.__pointer_x[@ _m] += _dx;
    //                        _global.__pointer_y[@ _m] += _dy;
                        
    //                        ++_m;
    //                    }
    //                }
    //            }
            
    //            //Recenter mouse cursor
    //            window_mouse_set(window_get_width()/2, window_get_height()/2);
    //        }
    //    }
    //    else if (_global.__window_focus || INPUT_ALLOW_OUT_OF_FOCUS || __INPUT_ON_MACOS)
    //    {
    //        var _m = 0;
    //        repeat(INPUT_COORD_SPACE.__SIZE)
    //        {
    //            var _old_x = _global.__pointer_x[_m];
    //            var _old_y = _global.__pointer_y[_m];
    //            var _pointer_x = _old_x;
    //            var _pointer_y = _old_y;
            
    //            switch(_m)
    //            {
    //                case INPUT_COORD_SPACE.ROOM:
    //                    _pointer_x = device_mouse_x(_global.__pointer_index);
    //                    _pointer_y = device_mouse_y(_global.__pointer_index);
    //                break;
                
    //                case INPUT_COORD_SPACE.GUI:
    //                    _pointer_x = device_mouse_x_to_gui(_global.__pointer_index);
    //                    _pointer_y = device_mouse_y_to_gui(_global.__pointer_index);
    //                break;
                
    //                case INPUT_COORD_SPACE.DEVICE:
    //                    if (__INPUT_ON_WINDOWS)
    //                    {
    //                        _pointer_x = display_mouse_get_x() - window_get_x();
    //                        _pointer_y = display_mouse_get_y() - window_get_y();  
    //                    }
    //                    else
    //                    {
    //                        _pointer_x = device_mouse_raw_x(_global.__pointer_index);
    //                        _pointer_y = device_mouse_raw_y(_global.__pointer_index);
    //                    }
    //                break;
    //            }
            
    //            //Only detect movement in the display coordinate space so that moving a room's view, or moving the window, doesn't trigger movement
    //            if ((_m == INPUT_COORD_SPACE.DEVICE) && (point_distance(_old_x, _old_y, _pointer_x, _pointer_y) > INPUT_MOUSE_MOVE_DEADZONE)) _moved = true;
            
    //            _global.__pointer_dx[@ _m] = _pointer_x - _old_x;
    //            _global.__pointer_dy[@ _m] = _pointer_y - _old_y;
            
    //            _global.__pointer_x[@ _m] = _pointer_x;
    //            _global.__pointer_y[@ _m] = _pointer_y;
            
    //            ++_m;
    //        }
    //    }
    //}
    
    //_global.__pointer_moved = _moved;
    
    //_global.__tap_click = false;    
    //if (__INPUT_ON_WINDOWS)
    //{
    //    //Track clicks from touchpad and touchscreen taps (system-setting dependent)
    //    _global.__tap_presses  += device_mouse_check_button_pressed( 0, mb_left);
    //    _global.__tap_releases += device_mouse_check_button_released(0, mb_left);

    //    if (_global.__tap_releases >= _global.__tap_presses)
    //    {
    //        //Resolve press/release desync (where press failed to register on same frame as release)
    //        _global.__tap_click    = (_global.__tap_releases > _global.__tap_presses);
    //        _global.__tap_presses  = 0;
    //        _global.__tap_releases = 0;
    //    }
    //}
    
    #endregion
    
    
    
    #region Keyboard
    
    //Unstick
    if (_global.__keyboard_allowed && keyboard_check(vk_anykey))
    {
        var _platform = os_type;
        if (INPUT_ON_WEB && __INPUT_ON_APPLE) _platform = "apple_web";

        switch(_platform)
        {
            case os_windows:
                if (keyboard_check(vk_alt) && keyboard_check_pressed(vk_space))
                {
                    //Unstick Alt Space
                    keyboard_key_release(vk_alt);
                    keyboard_key_release(vk_space);
                    keyboard_key_release(vk_lalt);
                    keyboard_key_release(vk_ralt);
                }

                if (keyboard_check(0xE6) && !keyboard_check_pressed(0xE6))
                {
                    //Unstick OEM key (Power button on Steam Deck)
                    keyboard_key_release(0x0E6);
                }
            break;            
            case "apple_web": //This case applies on iOS, tvOS, and MacOS
                if (keyboard_check_released(vk_lmeta) || keyboard_check_released(vk_rmeta))
                {
                    //Meta release sticks every key pressed during hold
                    //This is "the nuclear option", but the problem is severe
                    var _i = 8;
                    var _len = 255 - _i;
                    repeat(_len)
                    {
                        keyboard_key_release(_i);
                        ++_i;
                    }
                }
            break;                
            case os_macosx:
                //Unstick doubled-up control keys
                if (keyboard_check_released(vk_control))
                {
                    keyboard_key_release(vk_lcontrol);
                    keyboard_key_release(vk_rcontrol);
                }
            
                if (keyboard_check_released(vk_shift))
                {
                    keyboard_key_release(vk_lshift);
                    keyboard_key_release(vk_rshift);
                }
            
                if (keyboard_check_released(vk_alt))
                {
                    keyboard_key_release(vk_lalt);
                    keyboard_key_release(vk_ralt);
                }
            
                //Unstick Meta
                if (keyboard_check_released(vk_lmeta))
                {
                    keyboard_key_release(vk_rmeta);
                }
                else if (keyboard_check_released(vk_rmeta) && keyboard_check(vk_lmeta))
                {
                    keyboard_key_release(vk_lmeta);
                }
            break;
        }
    }
    
    #endregion
    
    
    
    #region Gamepads
    
    var _steam_handles_changed = false;
    if (_global.__using_steamworks)
    {
        steam_input_run_frame();
        _steam_handles_changed = __input_steam_handles_changed();        
        _global.__steam_handles = steam_input_get_connected_controllers();
    }
    
    if (_global.__gamepad_allowed && (_global.__frame > __INPUT_GAMEPADS_TICK_PREDELAY))
    {
        //Expand dynamic device count
        var _device_change = max(0, gamepad_get_device_count() - array_length(_global.__gamepads));
        repeat(_device_change) array_push(_global.__gamepads, undefined);
        
        _device_change = max(0, gamepad_get_device_count() - array_length(INPUT_GAMEPAD));
        repeat(_device_change)
        {
            array_push(INPUT_GAMEPAD, new __input_class_source(__INPUT_SOURCE.GAMEPAD, array_length(INPUT_GAMEPAD)));
            
            if ((_global.__source_mode == INPUT_SOURCE_MODE.MIXED) || (_global.__source_mode == INPUT_SOURCE_MODE.MULTIDEVICE))
            {
                _global.__players[0].__source_add(INPUT_GAMEPAD[array_length(INPUT_GAMEPAD)-1]);
            }
        }
        
        var _g = 0;
        repeat(array_length(_global.__gamepads))
        {
            var _gamepad = _global.__gamepads[_g];
            if (is_struct(_gamepad))
            {
                if (gamepad_is_connected(_g))
                {
                    if ((os_type == os_switch) && (_gamepad.description != gamepad_get_description(_g)))
                    {
                        //When Switch L+R assignment is used to pair two gamepads we won't see a normal disconnection/reconnection
                        //Instead we have to check for changes in the description to see if state has changed
                        _gamepad.discover();
                    }
                    else
                    {
                        if (_steam_handles_changed) 
                        {
                            with (_gamepad)
                            {
                                virtual_set();
                                led_set();
                            }
                        }
                        
                        _gamepad.tick();
                    }
                }
                else
                {
                    //Remove our gamepad handler
                    if (!__INPUT_SILENT) __input_trace("Gamepad ", _g, " disconnected");
                    
                    gamepad_set_vibration(_global.__gamepads[@ _g].index, 0, 0);
                    _global.__gamepads[@ _g] = undefined;
                    
                    //Also report gamepad changes for any active players
                    if ((_global.__source_mode != INPUT_SOURCE_MODE.MIXED) && (_global.__source_mode != INPUT_SOURCE_MODE.MULTIDEVICE))
                    {                    
                        var _p = 0;
                        repeat(INPUT_MAX_PLAYERS)
                        {
                            with(_global.__players[_p])
                            {
                                if (__source_contains(INPUT_GAMEPAD[_g]))
                                {
                                    __input_trace("Player ", _p, " gamepad disconnected");
                                    __source_remove(INPUT_GAMEPAD[_g]);
                                }
                            }
                        
                            ++_p;
                        }
                    }
                }
            }
            else
            {
                if (gamepad_is_connected(_g))
                {
                    __input_trace("Gamepad ", _g, " connected");
                    if (!__INPUT_SILENT) __input_trace("New gamepad = \"", gamepad_get_description(_g), "\", GUID=\"", gamepad_get_guid(_g), "\", buttons = ", gamepad_button_count(_g), ", axes = ", gamepad_axis_count(_g), ", hats = ", gamepad_hat_count(_g));
                    
                    _global.__gamepads[@ _g] = new __input_class_gamepad(_g);
                }
            }
            
            ++_g;
        }
    }
    
    #endregion
    
    
    
    #region Players
    
    var _p = 0;
    repeat(INPUT_MAX_PLAYERS)
    {
        _global.__players[_p].tick();
        ++_p;
    }
    
    #endregion
    
    
    
    #region Virtual Buttons
    
    //Reorder virtual buttons if necessary, from highest priority to lowest
    if (_global.__virtual_order_dirty)
    {
        //Clean up any destroyed virtual buttons
        var _i = 0;
        repeat(array_length(_global.__virtual_array))
        {
            if (_global.__virtual_array[_i].__destroyed)
            {
                array_delete(_global.__virtual_array, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        _global.__virtual_order_dirty = false;
        array_sort(_global.__virtual_array, function(_a, _b)
        {
            return sign(_b.__priority - _a.__priority);
        });
    }
    
    if (is_struct(_global.__touch_player))
    {
        //Detect any new touch points and find the top-most button to handle it
        var _i = 0;
        repeat(INPUT_MAX_TOUCHPOINTS)
        {
            if (device_mouse_check_button_pressed(_i, mb_left))
            {
                var _j = 0;
                repeat(array_length(_global.__virtual_array))
                {
                    if (_global.__virtual_array[_j].__capture_touchpoint(_i)) break;
                    ++_j;
                }
            }
            
            ++_i;
        }
        
        //Update any virtual buttons that are currently being interacted with
        var _i = 0;
        repeat(array_length(_global.__virtual_array))
        {
            _global.__virtual_array[_i].__tick();
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Players status struct
    
    var _any_players_changed = false;
    
    var _connection_array    = _global.__players_status.new_connections;
    var _disconnection_array = _global.__players_status.new_disconnections;
    var _status_array        = _global.__players_status.players;
    
    array_resize(_connection_array,    0);
    array_resize(_disconnection_array, 0);
    
    var _p = 0;
    repeat(INPUT_MAX_PLAYERS)
    {
        var _old_status = _status_array[_p];
        
        if (_global.__players[_p].__connected)
        {
            if ((_old_status == INPUT_STATUS.NEWLY_DISCONNECTED) || (_old_status == INPUT_STATUS.DISCONNECTED))
            {
                _any_players_changed = true;
                _status_array[@ _p] = INPUT_STATUS.NEWLY_CONNECTED;
                array_push(_global.__players_status.new_connections, _p);
            }
            else
            {
                _status_array[@ _p] = INPUT_STATUS.CONNECTED;
            }
        }
        else
        {
            if ((_old_status == INPUT_STATUS.NEWLY_CONNECTED) || (_old_status == INPUT_STATUS.CONNECTED))
            {
                _any_players_changed = true;
                _status_array[@ _p] = INPUT_STATUS.NEWLY_DISCONNECTED;
                array_push(_global.__players_status.new_disconnections, _p);
            }
            else
            {
                _status_array[@ _p] = INPUT_STATUS.DISCONNECTED;
            }
        }
        
        ++_p;
    }
    
    _global.__players_status.any_changed = _any_players_changed;
    
    #endregion
    
    
    
    #region Gamepads status struct
    
    var _any_gamepads_changed = false;
    
    var _connection_array    = _global.__gamepads_status.new_connections;
    var _disconnection_array = _global.__gamepads_status.new_disconnections;
    var _status_array        = _global.__gamepads_status.gamepads;
    
    array_resize(_connection_array,    0);
    array_resize(_disconnection_array, 0);
    
    var _device_count = gamepad_get_device_count();
    if (array_length(_status_array) != _device_count)
    {
        //Resize the gamepad status array if the total device count has changed
        //This should be rare but we need to cover it anyway
        //array_resize() fills new array elements with zeroes but leaves old array values untouched
        //Since INPUT_STATUS.DISCONNECTED === 0 this means new gamepads initialize as disconnected
        array_resize(_status_array, _device_count);
    }
    
    var _g = 0;
    repeat(_device_count)
    {
        var _old_status = _status_array[_g];
        
        if (input_gamepad_is_connected(_g))
        {
            if ((_old_status == INPUT_STATUS.NEWLY_DISCONNECTED) || (_old_status == INPUT_STATUS.DISCONNECTED))
            {
                _any_gamepads_changed = true;
                _status_array[@ _g] = INPUT_STATUS.NEWLY_CONNECTED;
                array_push(_connection_array, _g);
            }
            else
            {
                _status_array[@ _g] = INPUT_STATUS.CONNECTED;
            }
        }
        else
        {
            if ((_old_status == INPUT_STATUS.NEWLY_CONNECTED) || (_old_status == INPUT_STATUS.CONNECTED))
            {
                _any_gamepads_changed = true;
                _status_array[@ _g] = INPUT_STATUS.NEWLY_DISCONNECTED;
                array_push(_disconnection_array, _g);
            }
            else
            {
                _status_array[@ _g] = INPUT_STATUS.DISCONNECTED;
            }
        }
        
        ++_g;
    }
    
    _global.__gamepads_status.any_changed = _any_gamepads_changed;
    
    #endregion
    
    
    
    switch(_global.__source_mode)
    {
        case INPUT_SOURCE_MODE.FIXED:       /* Do nothing! */                      break;
        case INPUT_SOURCE_MODE.JOIN:        __input_multiplayer_assignment_tick(); break;
        case INPUT_SOURCE_MODE.HOTSWAP:     __input_hotswap_tick();                break;
        case INPUT_SOURCE_MODE.MIXED:                                              break;
        case INPUT_SOURCE_MODE.MULTIDEVICE:                                        break;
    }
    
    
    
    if (_global.__allow_gamepad_tester && _global.__gamepad_tester_data.__enabled)
    {
        __input_gamepad_tester_tick();
    }
}
