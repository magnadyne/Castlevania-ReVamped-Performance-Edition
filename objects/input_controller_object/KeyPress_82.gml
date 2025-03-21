/// @description debug reset room
	
if (debug_mode && keyboard_check(vk_control))
{
	if (keyboard_check(vk_shift))
	{
		title_screen();
	}
	else
	{
		room_restart();	
	}
}