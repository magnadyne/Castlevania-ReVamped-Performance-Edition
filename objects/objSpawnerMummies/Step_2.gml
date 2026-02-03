/// @description sense player and start fight
if mummy_order = 0
{
	if active && instance_number(objSimonDie) = 0
	{
		global.boss_music = true
		bitBGM(bgmCreaturesInTheDepth)
	}
	else
		global.boss_music = false


	if !active && abs(parPlayer.x - x) < eyesight
	{
		active = true
		alarm[0] = 120
		
		var _layer = layer_get_id("Instances");

		instance_create_layer(16, 160, _layer, objGateMummies);
		instance_create_layer(16, 176, _layer, objGateMummies);
		instance_create_layer(16, 192, _layer, objGateMummies);
		
		instance_create_layer(368, 160, _layer, objGateMummies);
		instance_create_layer(368, 176, _layer, objGateMummies);
		instance_create_layer(368, 192, _layer, objGateMummies);
	}
}
