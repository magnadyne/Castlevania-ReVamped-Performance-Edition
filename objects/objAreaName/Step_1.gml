/// @description grow the bar

if (shrink)
{
	if (bar_height <= 0)
	{
		instance_destroy();
	}
	else
	{
		bar_height -= 0.05;	
	}
}
else if (bar_height < 0.5)
{
	bar_height += 0.05
}