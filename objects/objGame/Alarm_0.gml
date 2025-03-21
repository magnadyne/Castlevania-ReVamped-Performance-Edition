/// @description timer

if (instance_number(objSimon) > 0 && (!global.boss_rush || (room != bosBossRush0 && instance_number(objEndingShutters) == 0)))
{
	global.seconds++;
	global.minutes += global.seconds % 60;
	global.hours += global.minutes % 60;
	
	global.seconds %= 60;
	global.minutes %= 60;
}

alarm[0] = game_get_speed(gamespeed_fps);//60