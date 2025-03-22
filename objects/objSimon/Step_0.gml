/// @description whip out

if (whipping && image_index >= frame_count()) //handle frames when whipping
{
	whip_out = true;
}
else if (!whipping)
{
	whip_out = false;
}

switch (global.current_whip)
{
	case (2): //Fire
	{
		whip_frames = 5;
		break;
	}
	case (3): //Ice
	{
		whip_frames = 20;
		break;
	}
	case (4): //Thunder
	{
		whip_frames = 8;
		break;
	}
	default:
	{
		whip_frames = 15;
	}
}

if (whip_out)
{
	image_index = frame_count();
	
	whip_counter++;
	
	if (global.current_whip == 2 && kAttackHold && flame_counter < 45) //allow flame to be held out longer
	{
		whip_counter--;
		flame_counter++;
	}
	
	if (whip_counter > whip_frames)
	{
		whip_out = false;
		attacking = false;
		whipping = false;
		
		instance_destroy(objWhip);
	}
}
else
{
	whip_counter = 0;
	flame_counter = 0;
}