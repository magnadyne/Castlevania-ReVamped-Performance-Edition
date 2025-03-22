/// @description HUD!
scrViewData();

var _text = string(global.hearts) + "/" + string(global.hearts_max);
var _sprite = hud_sprite[ds_map_find_value(global.savedata,"spiciness")];

draw_sprite_stretched(_sprite, 0, xview + 2,yview + 2, (global.hp_max * 4) + sprite_get_width(_sprite) - 4, sprite_get_height(_sprite));
draw_sprite_stretched(sprHealthbar, 0, xview + 2 + 40,yview + 2 + 9, global.hp * sprite_get_width(sprHealthbar), sprite_get_height(sprHealthbar));

draw_sprite(sprHUDSubweapons,global.current_subweapon,xview + 2,yview + 2);
draw_sprite(sprHUDWhip,global.current_whip,xview + wview - 2 - 24,yview + 2);

draw_set_font(global.fntOutlineHUD);
draw_set_halign(fa_left);

draw_text(xview + 2 + 42,yview + 2 + 17,_text);

_text = "$  " + string(global.gold);

draw_text(xview + 2 + 32 ,yview + 2 + 25,_text);

//debug text
if (debug_mode)
{
	if (round(fps) < 60)
	{
		draw_text_color( xview + wview - 32,yview + hview - 8,round(fps),nes_red,nes_red,nes_red,nes_red,1);	
	}
	if (global.mx == 0 && global.my == 0)
	{
		draw_text_color(xview + 8,yview + hview - 8,"Map coordinates not set",nes_red,nes_red,nes_red,nes_red,1);
	}
}
	
//boss rush timer
if (global.boss_rush)
{
	_text = append_zero(global.hours) + ":" + append_zero(global.u) + ":" + append_zero(global.seconds);
	
	draw_set_halign(fa_center);
	draw_set_font(fntMessage);
	draw_text_outline_fast(xview + 200,yview + 16,nes_blue,c_white,_text);
	draw_set_halign(fa_left);
}