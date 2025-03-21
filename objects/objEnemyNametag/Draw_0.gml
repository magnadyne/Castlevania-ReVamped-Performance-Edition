/// @description draw it

scrViewData();
//nes_colors()

draw_set_halign(fa_right);
draw_set_font(fntHUD);

if (fade == 0 || fade == 10)
{
	draw_text_outline_fast(xview + 400 - 8,yview + 224 - 12,c_black,c_black,name_text);
}
else if (fade == 1 || fade == 9)
{
	draw_text_outline_fast(xview + 400 - 8,yview + 224 - 12,c_black,c_navy,name_text);
}
else if (fade >= 2 && fade <= 8)
{
	draw_text_outline_fast(xview + 400 - 8,yview + 224 - 12,c_black,c_white,name_text);
}

draw_set_halign(fa_left);