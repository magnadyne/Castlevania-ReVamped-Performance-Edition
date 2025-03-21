/// @description draw the woooorrrds
//nes_colors()
draw_set_font(fntHUD);
draw_set_halign(fa_center);

draw_text_outline_fast(round(x),round(y),c_black,nes_yellow,"$" + string(bag));