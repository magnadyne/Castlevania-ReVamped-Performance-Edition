/// @description start or quit
draw_self();

var _text = "[  START  ]\nQUIT";

if selection = 1
	_text = "START\n[  QUIT  ]"
else if selection >= 2
{
	if selection/2 = round(selection/2)
		_text = "\nQUIT"
	else
		_text = "START\nQUIT"
}

draw_set_halign(fa_center)
draw_set_font(global.fntOutlineHUD)

if image_index >= 3
	draw_text_color(200, 160, _text, nes_red, nes_red, nes_red, nes_red, 1);
	
draw_set_halign(fa_right);

if (code_is_compiled())
{
	draw_text(room_width - 4,224 - 12,"Performance - YYC");
}
else
{
	draw_text(room_width - 4,224 - 12,"Performance - VM");
}

draw_set_halign(fa_left);

draw_text(4,224-12,version);

