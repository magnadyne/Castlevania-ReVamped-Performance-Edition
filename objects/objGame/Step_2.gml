/// @description pause / load file / max managing / text scripts / area names

global.hp = clamp(global.hp, 0, global.hp_max);
global.hearts = clamp(global.hearts, 0, global.hearts_max);
	
item_messages();

if (room == rmLoadGame)
{
	load_game();
}

//scrControls()

if (input_check_pressed("pause"))
{
	global.screen_sprite = sprite_create_from_surface(application_surface, 0, 0, 400, 224, false, false, 0, 0);
	
	bitsound(sndMenuPause);
	
	instance_create(x,y,(global.boss_rush ? objPauseMenuBossRush : objPauseMenu));
}

//area name tracker
if (area_tracker != global.area) //if the area has changed and isn't a transition room...
{
	area_tracker = global.area;
	
	if (area_tracker != 12)
	{
		instance_create(x,y,objAreaName);
	}
}