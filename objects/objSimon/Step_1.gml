/// @description moving vars, water, safe spots

var _grounded = on_ground();

scrControls();

if (_grounded && !hurting && !ducking && can_control && i_frames == 0 && !hazard_damage && yspeed == 0 && !place_meeting(x,y,parSolid) && !place_meeting(x,y+1,objConveyorBelt) && !place_meeting(x,y+1,objUnsafeBlock))
{
	safe_x = x;
	safe_y = y;
	//safe spots for hazard respawning
}

in_water = (place_meeting(x,y,parWater) && !global.water_armor) || place_meeting(x,y,parSticky);
	
//constant physics
yspeed_accel = 0.2;
	
//general movement
walk_accel = 0.25;
walk_deccel = 0.75;
walkspeed = 1.75;
jumpspeed = 4.75;
fallspeed = 6;

//physics for upgrades
wallspeed = 1;
slidespeed = 2;
dashspeed = 2.5;
poundspeed = 8;
pound_accel = 1;

if (global.super_slide)
{
	slidespeed *= 2;
}

//fall speed caps
if (on_wall && can_control)
{
	if (cling > 0)
	{
		yspeed = 0;
	}
	
	fallspeed = wallspeed;
}

if (pounding)
{
	fallspeed = poundspeed;
	yspeed_accel = pound_accel;
}

cling = max(cling - 1, 0);

//water physics
if (in_water)
{
	//general movement
	walk_accel *= water_factor;
	walk_deccel *= water_factor;
	walkspeed *= water_factor;
	jumpspeed *= water_factor;
	fallspeed *= water_factor;
	
	//physics for upgrades
	wallspeed *= water_factor;
	slidespeed *= water_factor;
	dashspeed *= water_factor;
	poundspeed *= water_factor;
}

//can control?
can_control = !(hurting || attacking || sliding || dashing || pounding);
//Use the Inverse Law to reduce the number of NOT operators

//trails
if (++trail_counter > 1)
{
	trail_counter = 0;
	
	if (pounding or dashing or sliding)
	{
		instance_create(x,y,objPlayerTrail);
	}
}

//pain
if (hurting)
{
	hurt_time = max(hurt_time - 1, 0);
	
	if (hurt_time <= 0 && _grounded)
	{
		i_frames = 60;
		hurting = false;
		whipping = false;
		attacking = false;
		
		instance_destroy(objWhip);
		
		if (sliding)
		{
			i_frames = 30;
		}
		else
		{
			xspeed = 0;
		}
			
		if (global.hp <= 0)
		{
			instance_change(objSimonDie,true);
		}
			
		if (hazard_damage && global.hp > 0)
		{
			x = safe_x;
			y = safe_y;
			
			i_frames = 120;
			hazard_damage = false;
			
			instance_create(x,y,objFadeInShutter);
			instance_create(x,y,objFadeOutShutter);
		}
	}
	
	if (hazard_damage)
	{
		xspeed = 0;
	}
}

i_frames = max(i_frames - 1, 0);