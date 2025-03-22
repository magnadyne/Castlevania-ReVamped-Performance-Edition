/// @description CRT
if (instance_number(objCRTFilter) = 0)
{
	instance_create(-128,-128,objCRTFilter);
}

global.oldtvfilter_enabled = global.crt;