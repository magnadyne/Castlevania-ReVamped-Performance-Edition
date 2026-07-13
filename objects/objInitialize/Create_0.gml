/// @description file independent variables + BGM loop points

if (!ds_exists(global.options, ds_type_map))
{
	//If it doesn't exist, then this is the first run.	
	
	set_loop_points();

	if (!window_get_fullscreen())
	{
		alarm[0] = game_get_speed(gamespeed_fps) / 5;
		//Center the window 1/5 a second later.
		//It has to be delayed else it won't work.
	}
	
	global.options = ds_map_create();
}
else
{
	ds_map_clear(global.options);	
	
	//I don't think we should re-read the options everytime, but this is how the game was setup to function.
}

//load options
if (!file_exists("Castlevania_Options.sav"))
{
	global.volumeSFX = 1
	global.volumeBGM = 1
	global.vibration = true
	global.crt = false
	global.vsync = true
	
	if ds_map_find_value( global.options,"icon files 0" ) = undefined
		ds_map_replace( global.options,"icon file 0",0 )
	if ds_map_find_value( global.options,"icon files 1" ) = undefined
		ds_map_replace( global.options,"icon file 1",0 )
	if ds_map_find_value( global.options,"icon files 2" ) = undefined
		ds_map_replace( global.options,"icon file 2",0 )
}
else
{
	global.options = ds_map_secure_load("Castlevania_Options.sav")
	
	global.volumeSFX = ds_map_find_value(global.options,"volumeSFX")
	global.volumeBGM = ds_map_find_value(global.options,"volumeBGM")
	global.vibration = ds_map_find_value(global.options,"vibration")
	if ds_map_find_value(global.options,"crt") != undefined
		global.crt = ds_map_find_value(global.options,"crt")
	else
		global.crt = false
		
	if ds_map_find_value(global.options,"vsync") != undefined
		global.vsync = ds_map_find_value(global.options,"vsync")
	else
		global.vsync = false
	
	if ds_map_find_value(global.options,"windowscale") = undefined
		ds_map_replace(global.options,"windowscale",1)
	if ds_map_find_value(global.options,"fullscreen") = undefined
		ds_map_replace(global.options,"fullscreen",false)
		
	display_reset(0, global.vsync);
		
	window_set_fullscreen(ds_map_find_value(global.options,"fullscreen"))
	window_set_size(400 * ds_map_find_value(global.options,"windowscale"), 224 * ds_map_find_value(global.options,"windowscale"));
}

//load controls if they exist
if ds_map_find_value(global.options,"controls") != undefined
	input_system_import(ds_map_find_value(global.options,"controls"))
	
//load ending cards
if (!ds_exists(global.gallery, ds_type_map))
{
	global.gallery = ds_map_create();
}
else
{
	ds_map_clear(global.gallery);	
}

if (!file_exists("Castlevania_Endings.sav"))
{
	ds_map_replace(global.gallery,"ending0",0)
	ds_map_replace(global.gallery,"ending1",0)
	ds_map_replace(global.gallery,"ending2",0)
	ds_map_replace(global.gallery,"ending3",0)
	ds_map_replace(global.gallery,"bossrush",0)
	ds_map_replace(global.gallery,"record_secs",359999)
	ds_map_replace(global.gallery,"record","--:--:--\n$----")
	ds_map_secure_save(global.gallery,"Castlevania_Endings.sav")
}
else
	global.gallery = ds_map_secure_load("Castlevania_Endings.sav")

//ds_map_set(global.gallery,"bossrush", 1);

//First Init the System, specify the name of the pal swap shader in case you've changed it for some reason.
pal_swap_init_system(shd_pal_swapper);