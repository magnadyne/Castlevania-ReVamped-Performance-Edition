/// @description toggle fullscreen

var _full = !window_get_fullscreen();

window_set_fullscreen(_full);

ds_map_replace(global.options,"fullscreen",_full);