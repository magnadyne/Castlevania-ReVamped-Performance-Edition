/// @description emit sparkles
if (visible && in_view())
{
	instance_create(x-12+irandom(24),y-12+irandom(24),objBoomerangFX1);
}
alarm[0] = 5