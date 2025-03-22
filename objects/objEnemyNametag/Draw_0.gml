/// @description draw it

scrViewData();
//nes_colors()

draw_set_halign(fa_right);
draw_set_font(global.fntOutlineHUD);

if (fade == 0 || fade == 10)
{
	draw_text_color(xview + 400 - 8,yview + 224 - 12,name_text,c_black,c_black,c_black,c_black,1);
}
else if (fade == 1 || fade == 9)
{
	draw_text_color(xview + 400 - 8,yview + 224 - 12,name_text,c_navy,c_navy,c_navy,c_navy,1);
}
else if (fade >= 2 && fade <= 8)
{
	draw_text_color(xview + 400 - 8,yview + 224 - 12,name_text,c_white,c_white,c_white,c_white,1);
}

draw_set_halign(fa_left);