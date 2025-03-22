/// @description sprites!!

scrPlayerSprites();

var _grounded = on_ground();

if (!attacking)
{
	if (can_control)
	{
		if (_grounded)
		{
			if (xspeed = 0)
			{
				if (ducking)
				{
					sprite_set(sDuck,0);
				}
				else
				{
					sprite_set(sIdle,1);	
				}
			}
			else
			{
				sprite_set((ducking ? sDuck : sWalk),abs(xspeed/walkspeed))
			}	
		}
		else if (on_wall)
		{
			sprite_set(sWalljump,1);
		}
		else
		{
			sprite_set((dubble_jumped ? sDubble : sJump),1);
		}
	}
	
	if (sliding)
	{
		sprite_set(sSlide,1);
	}
		
	if (dashing)
	{
		sprite_set(sDash,0);
		
		image_index = ceil(dash_counter % 1)
			
		if (dash_counter > 20)
		{
			image_index = 2;
		}
	}
		
	if (pounding)
	{
		sprite_set(sPound,1);
	}
}

if (attacking)
{
	if (whipping)// && whip_counter == 0)
	{
		//This whip_counter check seems to have no use, and it causes Simon to get locked
		//in the jump whip animation when landing during the attack.
		
		switch (aim_dir)
		{
			case (FORWARD):
			{
				if (ducking)
				{
					sprite_index = sWhipDuck;
				}
				else
				{
					sprite_index = (_grounded ? sWhip : sWhipJump);	
				}
				
				break;
			}
			case (UP):
			{
				sprite_index = (_grounded ? sWhipUp : sWhipJumpUp);
				
				break;
			}
			case (UP_DIAG):
			{
				sprite_index = (_grounded ? sWhipUpDiag : sWhipJumpUpDiag);
				
				break;
			}
			case (DOWN):
			{
				sprite_index = sWhipDown;
				
				break;
			}
			case (DOWN_DIAG):
			{
				sprite_index = sWhipDownDiag;
				
				break;
			}
		}
	}
	else
	{
		image_speed = 1;
		
		if (ducking)
		{
			sprite_index = sWhipDuck;
		}
		else
		{
			sprite_index = (_grounded ? sWhip : sWhipJump);	
		}
	}
}

if (hurting)
{
	image_index = 0;
	image_speed = 0;
	sprite_index = sHurt;
	
	if (_grounded)
	{
		image_index = (ducking ? 2 : 1);
	}	
}

#region//actually draw simon!

current_pal = (global.water_armor ? 1 : 0);

if (i_frames % 1 == 0)
{
	draw_palette_ext(palSimon,current_pal,x,y);
}
	
if (hurt_time > 6 && !hazard_damage)
{
	draw_palette_ext(palGlobal,7 + ceil(hurt_time % 1),x,y);
}

#endregion

if (kAimLock)
{
	draw_sprite_ext(sprAimLock,-1,x,y,1,1,0,c_white,1);
}