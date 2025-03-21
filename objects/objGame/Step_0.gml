/// @description set cost of subweapons / timestop

global.subweapon_cost = get_subweapon_cost();

global.timestop = max(global.timestop - 1, 0);