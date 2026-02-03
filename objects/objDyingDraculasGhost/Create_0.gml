/// @description sink and shit
alarm[0] = 15
bitsound(sndBossDie2)
alarm[2] = 120
alarm[1] = 240
image_speed = 2

face_player(0)

if !global.boss_rush
{
	ds_map_secure_save(global.savedata,global.filename)
	instance_create(x,y,objSavePopup)
	
	//Universal files

	var _file = file_text_open_write("UNI_" + global.filename);

	file_text_write_string(_file, ds_map_write(global.savedata));

	file_text_close(_file);
}

if global.nodamage = 0
	instance_create(x,y,objItemCrown)