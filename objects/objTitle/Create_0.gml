/// @description setup
selection = 0
bitBGM(bgmCastlevania)
instance_create(x,y,objFadeInShutter)
image_speed = 0

loading = false;

version = "v" + string_copy((date_get_year(GM_build_date)),3,2) + "." + 
				string(date_get_month(GM_build_date)) + "." + 
				string(date_get_day(GM_build_date));