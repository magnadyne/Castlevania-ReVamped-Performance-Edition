/// @description nothing baby
bitsound(sndDrip)
with( instance_create_depth(x,y,0,objEnemyBloodSkeletonMelted) )
	image_xscale = other.image_xscale
	
{//BESTIARY
	if ds_map_find_value( global.savedata,"bestiary" + string(enemy_number) ) != undefined
		ds_map_replace( global.savedata,"bestiary" + string(enemy_number),ds_map_find_value(global.savedata,"bestiary" + string(enemy_number)) + 1 )
	else
		{ ds_map_replace( global.savedata,"bestiary" + string(enemy_number),1 ) if enemy_number != 9999 global.enemy_collection += 1 }
				
	if ds_map_find_value( global.savedata,"bestiary_boss" + string(boss_number) ) != undefined
		ds_map_replace( global.savedata,"bestiary_boss" + string(boss_number),ds_map_find_value(global.savedata,"bestiary_boss" + string(boss_number)) + 1 )
	else
		{ ds_map_replace( global.savedata,"bestiary_boss" + string(boss_number),1 ) if boss_number != 9999 global.boss_collection += 1 }
}