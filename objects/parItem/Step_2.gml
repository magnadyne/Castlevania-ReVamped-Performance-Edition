/// @description physics for falling + invisible when hidden

if place_meeting(x,y,parSolid)
{
	visible = false;
}
else
{
	visible = true;
	scrPhysics();
}
	
xspeed *= 0.9