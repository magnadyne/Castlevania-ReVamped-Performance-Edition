/// @description change sprite

if saved
{
	if place_meeting(x,y,parPlayer)
		sprite_index = sprSaveUsedPrompt
	else
		sprite_index = sprSaveUsed	
		
	if input_check("up") && place_meeting(x,y,parPlayer)
	{
		instance_create(x,y,objCardsMenu)
		alarm[0] = 5
	}
}
	