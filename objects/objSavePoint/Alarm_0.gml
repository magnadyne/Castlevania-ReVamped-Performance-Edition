/// @description actually save!
ds_map_secure_save(global.savedata,global.filename)
ds_map_secure_save(global.options,"Castlevania_Options.sav")
instance_create(x,y,objSavePopup)

//Universal files

var _file = file_text_open_write("UNI_" + global.filename);

file_text_write_string(_file, ds_map_write(global.savedata));

file_text_close(_file);