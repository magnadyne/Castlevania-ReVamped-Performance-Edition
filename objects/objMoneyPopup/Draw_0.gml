/// @description draw the woooorrrds
//nes_colors()
draw_set_font(global.fntOutlineHUD);
draw_set_halign(fa_center);

draw_text_color(round(x),round(y),"$" + string(bag), nes_yellow, nes_yellow, nes_yellow, nes_yellow, 1);