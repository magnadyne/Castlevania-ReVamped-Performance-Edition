/// @description loading moment

instance_create(x,y,objBlackoutLoad);

safe_x = x;
safe_y = y;

if (global.arsenalswap_card == 2 && ds_map_find_value(global.savedata,"corpse run") > 0 && ds_map_find_value(global.savedata,"corpse room") == room)
{
	instance_create( ds_map_find_value(global.savedata,"corpse x"),ds_map_find_value(global.savedata,"corpse y"),objCorpseRun );
}

layer_depth(layer_get_id("Tiles"),100);
layer_depth(layer_get_id("Instances"),0);