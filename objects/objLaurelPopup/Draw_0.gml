/// @description draw the woooorrrds
//nes_colors()
draw_set_font(fntMessage)
draw_set_halign(fa_center)

if (global.laurel_card < 2)
{
	draw_text_outline_fast(round(x),round(y),c_black,nes_green,"+1 HP");
}
else
{
	draw_text_outline_fast(round(x),round(y),c_black,nes_green,"+2 HP");
}