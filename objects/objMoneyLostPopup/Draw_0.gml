/// @description draw the woooorrrds
//nes_colors()
draw_set_font(fntMessage);
draw_set_halign(fa_center);

draw_text_outline_fast(round(x),round(y),c_black,nes_red,"-$" + string(bag));