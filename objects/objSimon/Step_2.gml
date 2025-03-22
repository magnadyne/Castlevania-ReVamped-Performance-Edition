/// @description controlled actions, masks, OoB

scrPhysics();

var _grounded = on_ground();

//Feather is just lying. This is never "undefined".
if (abs(xspeed) < 0.1)
{
	xspeed = 0;
}
//set xspeed to 0 when it has been chopped into small enough pieces

#region //CONTROLLED ACTIONS

if (can_control)
{
	if (kLeft) //turning
	{
		facing = -1;
	}
	else if (kRight)
	{
		facing = 1;
	}
		
	if (_grounded && !kLeft && !kRight) //manual stopping
	{
		xspeed *= walk_deccel;
	}
		
	if (!kAimLock) //walking + duckwalking
	{
		if (kRight && !kLeft)
		{
			xspeed += walk_accel;
		}
		else if (kLeft && !kRight)
		{
			xspeed -= walk_accel;
		}
	}
	
	if (ducking) //slow the walk if you're ducking
	{
		walkspeed *= duck_factor;
	}
		
	if (xspeed > walkspeed) //limit walkspeed
	{
		xspeed = walkspeed;
	}
	if (xspeed < -walkspeed)
	{
		xspeed = -walkspeed;
	}
	//This logic is very strange, and I think adding an "else" would break it.
		
	if (kDown && _grounded && !kAimLock) //ducking
	{
		ducking = true;
	}
	else if (!place_meeting(x,y-3,parSolid))
	{
		ducking = false;
	}
		
	if (kJump && _grounded && !ducking or (on_wall && global.walljump && !_grounded)) //jumping + dubble jumping + walljump takeoff
	{
		if (on_wall)
		{
			if (global.walljump)
			{
				xspeed = facing * -2;
				cling = 0;
				clinging = false;
			}
			
			bitsound(sndSimonWalljump);
		}
		else
		{
			bitsound(sndSimonJump);	
		}
		
		dubble_jumped = false;
		yspeed = -jumpspeed;
	}
		
	if (global.dubble_jump && kJump && !_grounded && !dubble_jumped && !on_wall && !in_water) //jumping + dubble jumping + walljump takeoff
	{
		dubble_jumped = true;
		yspeed = -jumpspeed;
		
		bitsound(sndSimonJump);
	}
		
	if (kAttack) //whipping + whip aiming
	{
		if (global.vibration)
		{
			input_vibrate_constant(0.8,0,5);
		}
			
		attacking = true;
		whipping = true;
		whip_counter = 0;
		aim_dir = FORWARD;
			
		image_speed = 1;
		image_index = 0;
			
		if (global.current_whip == 2) //flame whip is sluggish
		{
			image_speed = 0.7;
		}
		else if (global.current_whip == 3) //ice whip is slow and strong
		{
			image_speed = 0.66;
		}
		else if (global.current_whip == 4) //thunder whip is fast and snappy
		{
			image_speed = 2;
		}
			
		if (global.whip_aim && !ducking)
		{
			if (kUp && !kLeft && !kRight) //aim upwards
			{
				aim_dir = UP;
			}
			else if (kUp)
			{
				aim_dir = UP_DIAG;
			}

			if (kDown && !_grounded) //aim downwards
			{
				if (kLeft || kRight)
				{
					aim_dir = DOWN_DIAG	
				}
				else
				{
					aim_dir = DOWN;
				}
			}
		}
			
		instance_create(x,y,objWhip);
	}
		
	if (global.slide && ducking && kJump && _grounded && !kAimLock) //sliding + super sliding
	{
		bitsound(sndSimonWalljump);
		
		sliding = true;
		xspeed = slidespeed * facing;
		
		if (global.super_slide)
		{
			xspeed = slidespeed * facing;
			
			instance_create(x,y,objSimonSlideShockwave);
		}
	}
	
	on_wall = false;
	//wall-sliding (walljump)
	
	if (global.walljump && !_grounded && yspeed >= 0 && !in_water)
	{
		if (((kLeft or kDash) && position_meeting(x - 6, y, parSolid) && position_meeting(x - 6, y + 9, parSolid) && position_meeting(x - 6, y - 9, parSolid)) ||
		   ((kRight or kDash) && position_meeting(x + 6, y, parSolid) && position_meeting(x + 6, y + 9, parSolid) && position_meeting(x + 6, y - 9, parSolid)))
		{
			if (!clinging)
			{
				cling = 20;
				clinging = true;
			}
			
			on_wall = true;
		}
		
		if (on_wall)
		{
			dashing = false;
			dubble_jumped = false;
		}
		else
		{
			clinging = false;
		}
				
			
	}
		
	if (global.dash && !ducking && kDash && cling == 0 && !in_water) //dashing
	{
		if (kLeft)
		{
			facing = -1;
		}
		else if (kRight)
		{
			facing = 1;
		}
		
		if (global.meteordash_card == 2)
		{
			instance_create(x,y,objMeteorDash);
		}
			
		bitsound(sndSimonDash);
		
		dash_counter = 0;
		dashing = true;
		xspeed = dashspeed * facing;
		
		if (on_wall)
		{
			xspeed *= -1;
			facing *= -1;
			on_wall = false;
		}
	}
		
	if (global.ground_pound && !_grounded && kDown && kJump) //ground poundin'
	{
		if (global.vibration)
		{
			input_vibrate_constant(0.8,0,30);
		}
		
		pounding = true;
		yspeed = 0;
		xspeed = 0;
		pound_counter = 0;
		
		bitsound(sndSimonPound);
		instance_create(x,y,objGroundPound);
	}
	
	if (kSwap) //whip swappin'
	{
		bitsound(sndPickupMoney);
		instance_create(x,y,objWhipMenu);
	}
		
	if (global.morningstar)
	{
		global.current_whip = 1;
	}
	else if (global.flame_whip)
	{
		global.current_whip = 2;
	}
	else if (global.ice_whip)
	{
		global.current_whip = 3;
	}
	else if (global.thunder_whip)
	{
		global.current_whip = 4;
	}
	else 
	{
		global.current_whip = 0;	
	}
	
	if (kSubweapon && global.current_subweapon > 0) //subweapons
	{
		//number-on-screen limits
		var can_subweapon = (instance_number(objWatch) == 0 && instance_number(objBible) == 0 && instance_number(objRosarySpawner) == 0);
		
		//reject sound if u no have hearts
		if (global.hearts < global.subweapon_cost)
		{
			bitsound(sndMenuReject);
			instance_create(x,y,objNoHeartsPopup);
		}
		
		//actual subweapon input and spawning!
		if (global.hearts >= global.subweapon_cost && can_subweapon)
		{
			var throw_y = -4;
			var sub_obj = objKnife;
			
			if (global.vibration)
			{
				input_vibrate_constant(0.5,0,5);
			}
				
			global.hearts -= global.subweapon_cost;
				
			attacking = true;
				
			image_index = 1;
			image_speed = 2;
			
			if (ducking)
			{
				throw_y += 8;
			}
			
			switch (global.current_subweapon)
			{
				case (2): sub_obj = objAxe; break;
				case (3): sub_obj = objHolyWater; break;
				case (4): sub_obj = objBible; break;
				case (5): sub_obj = objBoomerang; break;
				case (6): sub_obj = objRosarySpawner; break;
				case (7): sub_obj = objWatch; break;
				case (8):
				{
					if (global.laurel_card == 2)
					{
						global.hp += 2;
					}
					else
					{
						global.hp += 1;
					}
					
					bitsound(sndLaurel);
					instance_create(x,y,objLaurelPopup);
				}
			}
			
			if (global.current_subweapon != 8)
			{
				instance_create(x,y+throw_y,sub_obj);
			}
		}
	}
		
	if (global.blazingsteps_card == 2 && ++pace_counter >= 15) //blazing pace card
	{
		if (_grounded && xspeed != 0)
		{
			instance_create(x,y,objBlazingPace);
		}
			
		pace_counter = 0;
	}
	
	if (global.kinship_card = 2 && instance_number(objDoveFamiliar) == 0) //kinship card
	{
		instance_create(x,y,objDoveFamiliar);
	}
	
	if (kAimLock) //aim lock
	{
		xspeed *= 0.75;
	}
}

if (kJumpRelease && yspeed < 0) //shortjumping
{
	yspeed *= shortjump_factor;
}

if (attacking && _grounded) //stop when on ground and attackin
{
	xspeed *= walk_deccel;
}

if (whipping && _grounded && (aim_dir == DOWN || aim_dir == DOWN_DIAG)) //handle frames when whipping
{
	//cancel downwards whipping if you land
	attacking = false;
	whipping = false;
}

if (sliding) //slow and return from slide
{
	if (place_meeting(x,y-1,parSolid))
	{
		if (abs(xspeed) < 2) //dont go too slow in a pipe
		{
			xspeed = slidespeed * sign(xspeed);
		
			if (xspeed == 0)
			{
				facing *= -1;
				xspeed = slidespeed * facing;	
			}
		}
		
	}
	else if ((kDown && abs(xspeed) < slidespeed) || !kDown)
	{
		xspeed *= 0.9;
		
		//Make slide never slow down in a pipe
	}
	
	if (xspeed == 0 && _grounded)
	{
		sliding = false;
	}
		
	if (global.vibration)
	{
		input_vibrate_constant(0.01,0,5);
	}
	
	/*if !place_meeting(x + (facing * 12),y + 14,parSolid)
	{
		xspeed = 0
		sliding = false
	}*/
}

if (dashing) //slow and return from slide
{
	//avoid misalignment with platforms when scrPhysics does the 1-block fall check
	if (yspeed == 0 && yspeed_accel != 0 && !place_meeting(x,y+1,parSolid) && (place_meeting(x-xspeed,y+1,parSolid) or place_meeting(x+xspeed,y+1,parSolid)))
	{
		y = round(y/8) * 8;
		_grounded = on_ground();
	}
		
	if (global.vibration)
	{
		input_vibrate_constant(0.1,0,5);
	}
	
	dash_counter++
	
	//if !place_meeting(x + (facing),y,parSolid)
	yspeed = 0;
	
	yprevious = y;
	
	if (!_grounded)
	{
		move_snap(1,8);
	}
	
	if (place_meeting(x,y,parSolid))
	{
		y = yprevious;
		_grounded = on_ground();
	}
	
	if (dash_counter >= 12)
	{
		xspeed *= 0.9;
	}
	
	if (abs(xspeed) < 1 && dash_counter >= 30 && !kDash)
	{
		dashing = false;
	}
	
	if (kDash && position_meeting(x + ( 6 * facing ), y, parSolid) && position_meeting(x + ( 6 * facing ), y + 9, parSolid) && position_meeting(x + ( 6 * facing ), y - 9, parSolid))
	{
		on_wall = true;
		clinging = true;
		cling = 20;
		dashing = false;
		dash_counter = 0;
	}
	
	if (abs(xspeed) < 2 && dash_counter >= 15 && kDash) // allow early repeat if holding
	{
		if (kLeft)
		{
			facing = -1;
		}
		else if (kRight)
		{
			facing = 1;
		}
		
		if (global.meteordash_card == 2 && dash_counter > 20)
		{
			instance_create(x,y,objMeteorDash);
		}
		
		bitsound(sndSimonDash);
		
		dash_counter = 0;
		dashing = true;
		xspeed = dashspeed * facing;
		
		if (on_wall)
		{
			xspeed *= -1;
			facing *= -1;
			on_wall = false;
		}
	}
	
	if (global.dubble_jump && kJump && !_grounded && !dubble_jumped && !on_wall && !in_water)//&& yspeed >=0
	{
		dubble_jumped = true;
		yspeed = -jumpspeed;
		xspeed *= 0.25;
		dashing = false;
		dash_counter = false;
		bitsound(sndSimonJump);
			
		//double jump out of a dash
	}
}

if (pounding) //know when to stop ground pound
{
	xspeed = 0;
	
	if (_grounded)
	{
		if (global.vibration)
		{
			input_vibrate_constant(0.8,0,15);
		}
		
		audio_stop_sound(sndSimonPound);
		
		if (++pound_counter == 1)
		{
			bitsound(sndSimonPoundThud);
		}
		else if (pound_counter == 3)
		{
			instance_create(x,y,objSimonShockwave);
		}
	}
	
	if (pound_counter >= 10 || y >= room_height)
	{
		pounding = false;
	}	
}

if (cling > 0 && position_meeting(x + ( 6 * facing ), y, parSolid) && position_meeting(x + ( 6 * facing ), y + 9, parSolid) && position_meeting(x + ( 6 * facing ), y - 9, parSolid))
{
	on_wall = true
}

if (_grounded)
{
	dubble_jumped = false;
}

#endregion

#region//SFX THAT DON'T FIT INTO OTHER CODE
//landing sound
if (place_meeting(x,y+2,parSolid) && yspeed > 0)
{
	bitsound(sndSimonLand);
	
	if (global.vibration)
	{
		input_vibrate_constant(0.7,0,5);
	}
}
#endregion

#region //MASK + CLIPPING MANAGEMENT

//dont allow standing when crouch walking in a hole
if (!ducking && !sliding && place_meeting(x,y-3,parSolid) && _grounded)
{
	ducking = true;
	dashing = false;
}
if (!_grounded)
{
	ducking = false;
	//sliding = false
}

//assign proper mask

mask_index = (ducking ? sprMaskSimonDuck : sprMaskSimon);
	
if (sliding)
{
	mask_index = sprMaskSimonSlide;
}
	
#endregion

#region//OoB

x = clamp(x, 0, room_width);
y = clamp(y, -8, room_height + 8);

#endregion

//{//aim lock
//	if kAimLock && whipping
//		xspeed *= 0.25
//}