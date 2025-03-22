#region Macros
{
	#macro nes_red #db2c01
	#macro nes_yellow #f2bf3f
	#macro nes_blue #0074ed
	#macro nes_green #00a902
	//Replace make_color_rgb with constants (hex-colors)
	//Replace variables with a macro
}

#region GPU Control
{
	gpu_set_ztestenable(false);  //Primarily for 3D stuff
	gpu_set_zwriteenable(false); //Primarily for 3D stuff
	surface_depth_disable(true); //Disable to cut each surface's VRAM usage in half
}
#endregion

#region Globals
{
	global.message_lifemaxup = @"LIFE MAX UP
	Maximum HP increased by 1. HP fully restored."

	global.message_waterarmor = @"AQUATIC ARMOR
	Allows full range of movement in water. Ability to wall-jump, dash and double-jump underwater restored."
	//These are messages that never change
	
	global.fntOutlineHUD = font_add_sprite_ext(spr_outlineFont, " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ*0123456789[]()!?<>;:+-,'&^{}|/._$#`@%", true, 0);
	//Use this to draw outlined text instead of fntHUD.
	//It only requires 1 draw function, whereas fntHUD would've required 9.
}
#endregion

/*
  Below is a set of functions created to replace pre-existing ones.
  Their purpose is to either improve performance or simplify the code.
*/

function in_view()
{
	var _xv = camera_get_view_x(view_camera[0]);
	var _yv = camera_get_view_y(view_camera[0]);
	//Dynamic - constantly changing
	
	static _wv = camera_get_view_width(view_camera[0]) + 16;
	static _hv = camera_get_view_height(view_camera[0]) + 8;
	//Static - unchanging
	
	return ((x > _xv - 16) && (x < _xv + _wv) && (y > _yv - 8) && (y < _yv + _hv))
	//This logic simplifies into a boolean, so we can return it without using an IF statement.
}

function get_subweapon_cost()
{
	var _multiplier = 1;
	
	if (global.cursed_card == 2)
	{
		_multiplier = 2;
	}
	//I could use a ternary here, but in my experience the Linux compiler breaks
	//when a ternary statement is "too complex".

	if (global.heartdiscount_card == 2) //discounted subweapons
	{
		switch (global.current_subweapon)
		{
			case (1): return _multiplier * 01;	//Knife
			case (2): return _multiplier * 01;	//Axe
			case (3): return _multiplier * 01;	//Holy Water
			case (4): return _multiplier * 02;	//Bible
			case (5): return _multiplier * 01;	//Boomerang
			case (6): return _multiplier * 20;	//Rosary
			case (7): return _multiplier * 05;	//Watch
			case (8): return _multiplier * 05;	//Laurel
		}
	}
	else //normal costs
	{
		switch (global.current_subweapon)
		{
			case (1): return _multiplier * 01;	//Knife
			case (2): return _multiplier * 02;	//Axe
			case (3): return _multiplier * 02;	//Holy Water
			case (4): return _multiplier * 03;	//Bible
			case (5): return _multiplier * 02;	//Boomerang
			case (6): return _multiplier * 25;	//Rosary
			case (7): return _multiplier * 12;	//Watch
			case (8): return _multiplier * 07;	//Laurel
		}
	}
	return 0;
	
	//I've used a function here to avoid the use of Breaks inside the switch statement.
}

function get_area_name(_area = global.area)
{
	switch (_area)
	{
		case (00): return "Entrance Hall";
		case (01): return "Torture Lab";
		case (02): return "Underground Mind";
		case (03): return "Castle Ruins";
		case (04): return "Catacombs";
		case (05): return "Castle Courtyard";
		case (06): return "Tower Bridge";
		case (07): return "Toy Room";
		case (08): return "Dungeon";
		case (09): return "Marble Gallery";
		case (10): return "Clock Tower";
		case (11): return "Castle Keep";
		case (13): return "Boss Rush";
	}

	 return "Unknown";
}

function append_zero (_number)
{
	if (_number < 10)
	{
		return "0" + string(_number);
	}
	else return string(_number);
}

function draw_text_outline_fast(text_x, text_y, out_color, text_color, String)
{
	//Use this when you don't need the formatting that scribble provides.
	//It'll run much faster.
	
	draw_text_color(text_x - 1, text_y + 0, String, out_color, out_color, out_color, out_color, 1);
	draw_text_color(text_x - 1, text_y - 1, String, out_color, out_color, out_color, out_color, 1);
	draw_text_color(text_x - 1, text_y + 1, String, out_color, out_color, out_color, out_color, 1);
	draw_text_color(text_x + 0, text_y - 1, String, out_color, out_color, out_color, out_color, 1);
	draw_text_color(text_x + 0, text_y + 1, String, out_color, out_color, out_color, out_color, 1);
	draw_text_color(text_x + 1, text_y + 0, String, out_color, out_color, out_color, out_color, 1);
	draw_text_color(text_x + 1, text_y + 1, String, out_color, out_color, out_color, out_color, 1);
	draw_text_color(text_x + 1, text_y - 1, String, out_color, out_color, out_color, out_color, 1);

	draw_text_color(text_x, text_y, String, text_color, text_color, text_color, text_color, 1);
}

function item_messages()
{
	static _icon = -1;
	var _attack = input_verb_get_icon("attack");
	
	if (_icon != _attack)
	{
		//Only update the text if the icon has changed
		
		_icon = _attack;
		
		var _swap = input_verb_get_icon("swap");
		var _down = input_verb_get_icon("down");
		var _jump = input_verb_get_icon("jump");
		//Cache the icons that are used more than once
		
		global.message_heartmaxup = @"HEART MAX UP
		Maximum number of hearts increased by 5. Press " + input_verb_get_icon("subweapon") + " to use sub-weapons."

		global.message_whipaim = @"DYNAMIC STRIKE
		Aim your whip in 8 directions. Hold a direction and press " + _attack + ". Hold " + input_verb_get_icon("aimlock") + " to prevent movement while aiming."

		global.message_slide = @"BREEZEY SLIDE
		Pass through tight spaces with an unoffensive slide. Hold " + _down + " and press " + _jump +  " while on the ground. Hold " + _down + " to slide continuously."

		global.message_morningstar = @"MORNING STAR
		Elongated chain whip that can break certain types of blocks. Press " + _attack +  " to strike with the whip."

		global.message_walljump = @"GRIPPING CLAWS
		Slides down walls and grants the ability to wall-jump. Press " + _jump +  " while holding a direction against a wall."

		global.message_groundpound = @"BRIDGE SNAPPER
		Destroy thin blocks with an offensive dive move. Hold " + _down + " and press " + _jump +  " while in the air. A damaging shockwave is released upon landing."

		global.message_flamewhip = @"FLAME WHIP
		A burning chain whip that deals repetitive damage and destroys certain types of blocks. Hold " + _attack + " to keep whip extended. Press " + _swap + " to swap the current whip."

		global.message_icewhip = @"FROST WHIP
		An ice-cold chain whip that deals massive damage and destroys certain types of blocks. Press " + _swap + " to swap the current whip."

		global.message_thunderwhip = @"THUNDER WHIP
		A quick-to-swing electrified chain whip that deals minor damage and destroys certain types of blocks. Press " + _swap + " to swap the current whip."

		global.message_dubblejump = @"LEAP STONE
		Allows a second jump to be performed. Press " + _jump + " while in midair."

		global.message_dash = @"DASH STONE
		Grants the ability to perform a gravity-defying dash. Hold " + input_verb_get_icon("dash") + " to use the dash. A dash can be performed endlessly in the air."

		global.message_superslide = @"SPIKED BOOTS
		A faster slide move with minor offensive capability. Destroys certain kinds of blocks. Hold " + _down + " and press " + _jump +  " while on the ground. Hold " + _down + " to slide continuously."
	}
}

//This only works if it is called once per frame.
//Give it to Simon, and no one else.
// Feather disable all
function scrControlsFast()
{
	static _up = 0;
	static _down = 0;
	static _left = 0;
	static _right = 0;
	static _jump = 0;
	static _pause = 0;
	static _attack = 0;
	
	//0 = Not pressed
	//1 = Intial press
	//2 = Still pressed, waiting for release
	
	kPauseHold = input_check("pause");
	kAttackHold= input_check("attack");
	
	kUp= input_check("up");
	kDown= input_check("down");
	kLeft = input_check("left");
	kRight= input_check("right");
	kSubweapon = input_check_pressed("subweapon");
	kDash = input_check("dash");
	kSwap = input_check_pressed("swap");
	kAimLock = input_check("aimlock");
	kAccept= input_check_pressed("accept");
	kCancel= input_check_pressed("cancel");
	kMap= input_check_pressed("map");
	
	#region Determine press & release using check
	{
		if (input_check("jump"))
		{
			if (_jump == 0) _jump = 1;
			else if (_jump == 1) _jump = 2;
			
			kJumpRelease = false;
		}
		else if (_jump != 0)
		{
			_jump = 0;
			
			kJumpRelease = true;
		}
		
		if (kAttackHold)
		{
			if (_attack == 0) _attack = 1;
			else if (_attack == 1) _attack = 2;
		}
		else if (_attack != 0) _attack = 0;
		
		if (kPauseHold)
		{
			if (_pause == 0) _pause = 1;
			else if (_pause == 1) _pause = 2;
		}
		else if (_pause != 0) _pause = 0;
		
		if (kUp)
		{
			if (_up == 0) _up = 1;	
			else if (_up == 1) _up = 2;		
		}
		else
		{
			_up = 0;	
		}
	
		if (kDown)
		{
			if (_down == 0) _down = 1;	
			else if (_down == 1) _down = 2;		
		}
		else
		{
			_down = 0;	
		}
	
		if (kLeft)
		{
			if (_left == 0) _left = 1;	
			else if (_left == 1) _left = 2;		
		}
		else
		{
			_left = 0;	
		}
	
		if (kRight)
		{
			if (_right == 0) _right = 1;	
			else if (_right == 1) _right = 2;		
		}
		else
		{
			_right = 0;	
		}
	}
	//Doing this saves 7 input calls
	//TL;DR This boolean logic is MUCH faster than input functions

	kJump = (_jump == 1);
	kPause = (_pause == 1);
	kAttack = (_attack == 1);

	//tapping, for menus
	kUpTap = (_up == 1);
	kDownTap = (_down == 1);
	kLeftTap = (_left == 1);
	kRightTap = (_right == 1);
}