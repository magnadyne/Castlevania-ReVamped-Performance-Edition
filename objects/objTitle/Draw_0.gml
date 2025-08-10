/// @description start or quit
draw_self();

var _text = "[[ START ]\nQUIT";

if selection = 1
	_text = "START\n[[ QUIT ]"
else if selection >= 2
{
	if selection/2 = round(selection/2)
		_text = "\nQUIT"
	else
		_text = "START\nQUIT"
}

draw_set_halign(fa_center)
draw_set_font(fntHUD)

if image_index >= 3
	draw_text_outline(200,160,c_black,nes_red,_text)
	
draw_set_halign(fa_left)

if (code_is_compiled())
{
	draw_text(8,224-12,"Performance Edition YYC");
}
else
{
	draw_text(8,224-12,"Performance Edition VM");
}