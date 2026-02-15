/// @description stuff
application_surface_enable(true);
gamepad_set_vibration(0,0,0)

bitBGM(bgmUnderground)

selection = 0

instance_create(x,y,objFadeInShutter)

global.fileselect = 0

//file variables
simon0 = 0
simon0_new = false
simon0_collection = 0
simon0_area = 0
simon0_hours = 0
simon0_minutes = 0

simon1 = 0
simon1_new = false
simon1_collection = 0
simon1_area = 0
simon1_hours = 0
simon1_minutes = 0

simon2 = 0
simon2_new = false
simon2_collection = 0
simon2_area = 0
simon2_hours = 0
simon2_minutes = 0

deleted = false
deleted0 = false
deleted1 = false
deleted2 = false

bossrush_record = ds_map_find_value(global.gallery,"record")

//load file info

var _num = 0;
var _map = noone;

for (var _a = 0; _a < 3; _a++)
{
	_num = string(_a);
	
	try
	{
		//We're using a try-catch so forget about the safety checks and just do it.
		//This is in case something doesn't save correctly and the UNI save corrupts.
		
		var _file = file_text_open_read("UNI_Simon" + _num + ".sav");
		
		var _string = file_text_read_string(_file);
		
		file_text_close(_file);
		
		_map = ds_map_create();
		
		variable_instance_set(id, "simon" + _num, _map);
		
		ds_map_read(_map, _string);
		
		show_debug_message("Loaded Universal File: " + _num);
	}
	catch (_e)
	{
		if (file_exists("Simon" + _num + ".sav"))
		{
			variable_instance_set(id, "simon" + _num, ds_map_secure_load("Simon" + _num + ".sav"));
			
			show_debug_message("Loaded Legacy File: " + _num);
		}
		else
		{
			variable_instance_set(id, "simon" + _num + "_new", true);
			
			show_debug_message("No File: " + _num);
		}
	}
	//Using the variable_instance funtions allows us to shrink alot of code into a single loop.
	//Though, for something small like this, I would usually recommend against it.
	//This method will always be slower than simply writing out all of the variables and setting them.
	//But I'm being lazy and cannot be bothered to write all that 3 times.
}


if (!simon0_new)
{
	simon0_collection = ds_map_find_value(simon0,"collection")
	simon0_area = ds_map_find_value(simon0,"area")
	simon0_hours = ds_map_find_value(simon0,"hours")
	simon0_minutes = ds_map_find_value(simon0,"minutes")
}

if (!simon1_new)
{
	simon1_collection = ds_map_find_value(simon1,"collection")
	simon1_area = ds_map_find_value(simon1,"area")
	simon1_hours = ds_map_find_value(simon1,"hours")
	simon1_minutes = ds_map_find_value(simon1,"minutes")
}

if (!simon2_new)
{
	simon2_collection = ds_map_find_value(simon2,"collection")
	simon2_area = ds_map_find_value(simon2,"area")
	simon2_hours = ds_map_find_value(simon2,"hours")
	simon2_minutes = ds_map_find_value(simon2,"minutes")
}