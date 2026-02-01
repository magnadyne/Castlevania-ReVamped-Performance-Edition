/// @description ds map! + gates
if global.boss_music = true
{
	instance_create(x,y,objExplosion)
	instance_create(x,y,objEarthquake)
	if global.nodamage == 0 && instance_number(objItemCrown) == 0
		instance_create(x,y,objItemCrown)
}

var _savedata = ds_map_find_value(global.savedata,key);
	
if (!is_undefined(_savedata) && _savedata == true)
{
	instance_destroy(parGate, false);
}
else
{
	instance_destroy(parGate);
}

global.boss_music = false
collected()

instance_create(room_width/2,room_height/2 - 32,objBossOrbSpawnIn)

