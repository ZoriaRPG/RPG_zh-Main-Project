//Pieces of Power, Guardian Acorns, and Secret Shells v0.52
//3rd July, 2015


//Set-up: Make a new item (Green Ring), set it up/ as follows:
//Item Class Rings
//Level: 1
//Power: 1
//CSet Modifier : None
//Assign this ring to Link's starting equipment in Quest->Init Data->Items

//Change the blue ring to L2, red to L3, and any higher above these. 

int PlayingPowerUp[258]; //An array to hold values for power-ups. Merge with main array later?
int Z4_ItemsAndTimers[22]; //Array to hold the values for the Z4 items. 
int StoneBeaks[10];	//An array to hold if we have a stone beak per level. 
			//Each index corresponds to a level number.
			//If you need levels higher than '9', increase the index size to 
			//be eaqual to the number of levels in your game + 1.
			

//Settings

const int NEEDED_PIECES_OF_POWER = 3; //Number of Pieces of power needed for temporary boost.
const int NEEDED_ACORNS = 3; //Number of Acorns needed for temporary boost.
const int REQUIRED_SECRET_SHELLS = 20; //Number of Secret Shell items to unlock the secret.
const int BUFF_TIME = 900; //Duration of boost, in frames. Default is 15 seconds.

const int REQUIRE_CONSECUTIVE_KILLS = 12; 	//The number of enemies the player must kill without being hurt,
						// to obtain a free Guardian Acorn.
const int REQUIRE_KILLS_PIECE_OF_POWER_MIN = 40; //The minimum number of enemies to kill (random number min) 
						 //to obtain a free Piece of Power.
const int REQUIRE_KILLS_PIECE_OF_POWER_MAX = 45; //The maximum number of enemies to kill (random number max)
						 //to obtain a free Piece of Power.

const int PLAY_ACORN_MESSAGE = 1; //Set to 0 to turn off messages.
const int PLAY_PIECE_OF_POWER_MESSAGE = 1; //Set to 0 to disable messages for Piece of Power power-ups.
const int BONUS_SHELL_DIVISOR = 5; //Award bonus Secret Shell if number on hand is this number, on each visit to Seashell mansion.
const int WALK_SPEED_POWERUP = 4; //Number of extra Pixels Link walks when he has a Piece of Power

const int RANDOMISE_PER_PLAY = 0; //Set to '1' if you want to randomise the number of kills on each load (continue).
const int PLAY_POWERUP_MIDI = 1; //Set to '1' to play a MIDI while a power-up boost is in effect.
const int KILL_AWARDS = 1; //Set to '0' to disable automatic awards of Pieces of Power and Guardian Acorns
				//based on enemy kill counts.
const int REMOVE_ATTACK_BOOST_WHEN_PLAYER_DAMAGED = 1; //Set to '0' to disable removing the boost when player is damaged X times.
const int NUM_HITS_TO_LOSE_POWER_BOOST = 3; //The number of times a player with a Piece of Power power-up boost
					    //must be hit, before the effect prematurely ends.

const int ENEMIES_ALWAYS_EXPLODE = 1; //Set to '0' if enemies only explode when a player has a Piece of Power power-up.
const int EXPLOSIONS_RUN_WITH_FFCS = 0; //If set to 1, enemy explosions on death will run from FFCs
					//rather than from the global active infinite loop.

//Item Numbers : These are here for later expansion, and are unused at present.
const int I_GREEN_RING = 143; //Item number of Green Ring  
const int I_PIECE_POWER = 144; //Item number of Piece of Power
const int I_ACORN = 145; //Item number of Acorn
const int I_SHELL = 146; //Item number of Secret Shell

//Array Indices ( ! Do not change these ! )
const int POWER_TIMER = 0; //The timer for Piece of Power damage boost duration.
const int DEF_TIMER = 1; //The timer for Guardian Acorn defence boost duration.
const int NUM_PIECES_POWER = 2; //The present number of Pieces of Power held by the player.
const int NUM_ACORNS = 3; //The present number of Guardian Acorns held by the player.
const int POWER_BOOSTED = 4; //This == 1 if the player has a Piece of Power power-up boost.
const int DEF_BOOSTED = 5; //This == 1 if the player has a Guardian Acorn power-up boost.
const int NUM_SHELLS = 6; //The present number of Secret Shells held by player.
const int MSG_GUARDIAN_PLAYED = 7; //Reports if a message has played for a Guardian Acorn boost.
const int MSG_PIECE_POWER_PLAYED = 8; //Reports if a message has played for a Piece of Power boost.
const int POWERUP_PLAYER_HP = 9; //Holds player HP for this frame to compare to...
const int POWERUP_PLAYER_OLD_HP = 10; //Holds previous player HP.
const int POWERUP_ENEMY_KILLS = 11; //Number of enemies killed since last free Piece of Power.
const int POWERUP_CONSECUTIVE_ENEMY_KILLS = 12; //Number of enemies killed since player was last hurt.
const int POWERUP_NUM_ENEMIES = 13; //The number of enemies at present.
const int POWERUP_CURDMAP = 14; //The current DMap. used to determine if screen has changed.
const int POWERUP_CURSCREEN = 15; //The current Screen. used to determine if screen has changed.
const int POWERUP_SCREEN_HAS_CHANGED = 16; //Will return '1' (true) if screen has changed; otherwise '0' (false).
const int POWERUP_LINK_DAMAGED = 17; //Stores a value if Link was hit. Cleared after killing a monster.
const int POWERUP_PIECE_OF_POWER_NEEDED_KILLS = 18; //The present number of total enemy deaths needed for a free
						    //Piece of Power. Updated by PieceOfPowerKills() with a 
						    //randomly generated value each time a free Piece of Power
						    //is awarded from this value.
const int POWERUP_LINK_HURT_COUNTER = 19;
const int POWERUP_LINK_HURT_COUNTER_LAST = 20;

//Sound effects constants.
const int SFX_POWER_BOOSTED = 65; //Sound to play when Attack Buffed
const int SFX_SECRET_SHELL = 66; //Sound to play when unlocking shell secret.
const int SFX_GUARDIAN_DEF = 68; //Sound to play when Defence buffed.
const int SFX_NERF_POWER = 72; //Sound to play when Piece of Power buff expires.
const int SFX_NERF_DEF = 73; //Sound to play when Guardian Acorn buff expires
const int SFX_BONUS_SHELL = 0; //Sound to play when awarded a bonus Secret Shell.

//Enemy Explosion Constants
const int FFC_ENEMY_EXPLODE = 0; //Set to FFC script slot for death explosion FFC animation.
const int FFC_NUM_OF_EXPLOSIONS = 4; //Base number of explosions when killing an enemy.
const int FFC_EXPLOSION_SPRITE = 0; //Sprite for the explosion.
const int FFC_EXPLOSION_EXTEND = 4; //Size of explosion eweapon.
const int FFC_EXPLOSION_TILEWIDTH = 2; //Width of explosion, in tiles.
const int FFC_EXPLOSION_TILEHEIGHT = 2; //Height of explosion, in tiles.

const int FFC_EXPLOSIONS_MINIBOSS_EXTRA = 4; //Add this many explosions if the enemy is a miniboss.
const int FFC_EXPLOSIONS_BOSS_EXTRA = 12; //Add this many explosions if the enemy is a full boss.
const int FFC_EXPLOSIONS_FINALBOSS_EXTRA = 16; //Add this many explosions if the enemy is the FINAL boss.

const int FFC_EXPLOSION_PIECE_OF_POWER_EXTRA_BLASTS = 2; //Number of extra explosions if player has Piece of Power
							 //power-up (attack) boost.

//MIDI Constants
const int PLAYING_POWER_UP_MIDI = 256;
const int NORMAL_DMAP_MIDI = 0; //Used for two things: Array index of normal DMap MIDIs (base), 
				//and as parameter in function PlayPowerUpMIDI()


//Power-Up Messages

const int MSG_GUARDIAN_ACORN = 0; //ID of String for Guardian Acorn Message
const int MSG_PIECE_POWER = 0; //ID of String for Piece of Power Message
const int POWERUP_MIDI = 10; //Set the the number of a MIDI to play while a Power-Up is in effect.


//Enemy Tables

const int FINAL_BOSS_ID = 78; //Enemy ID of the FINAL boss. Ganon, by default. 

//Arrays

// A list of Boss enemies, by Enemy ID
// Add, or remove values from this list, to increase, or decrease the enemies treated 
// as Bosses for determining the number of explosions.
int BossList[]={	58,	61,	62,	63, 
			64, 	65, 	71, 	72, 
			73, 	76, 	77, 	93, 	
			94, 	103, 	104, 	105, 	
			109, 	110, 	111, 	112, 	
			114, 	121, 	122};
	
// A list of Mini-boss enemies by Enemy ID
// Add, or remove values from this list, to increase, or decrease the enemies treated 
// as Mini-bosses for determining the number of explosions.
int MiniBossList[]={	59, 	66,	67,	68,	
			69, 	70,	71,	74,	
			75};



//int NerfedAttack[]="Attack power nerfed."; //String for TraceS()

//////////////////////
/// MAIN FUNCTIONS ///
//////////////////////

//Run every frame **BEFORE** both Waitdraw() **AND** LinksAwakeningItems();
void ReduceBuffTimers(){
	if ( Z4_ItemsAndTimers[POWER_TIMER] > 0 ) { //If the Piece of Power timer is active...
		Z4_ItemsAndTimers[POWER_TIMER]--; //Reduce Piece of Power timer.
	}
	if ( Z4_ItemsAndTimers[DEF_TIMER] > 0 ) { //If the Guardian Acorn timer is active...
		Z4_ItemsAndTimers[DEF_TIMER]--; //Reduce the timer
	}
}

//Run every frame, before Waitdraw();
void LinksAwakeningItems(){ //This is a container function. Using these simplifies reading your global acript later, by reducing the number of direct calls.
	//Now we need only call this one function, to run all of these. This is a *true function*, while the functions it calls are *routines*. 
	PiecesOfPower(); //Call these functions, as routines, and sub-routines.
	Acorns();
	WalkSpeed();
	
}

void Z4_EnemyKillRoutines(){ //This is a container function. Using these simplifies reading your global acript later, by reducing the number of direct calls.
	Z4ScreenChanged(); //Call these functions:
	CountEnemies();
	StoreLinkHP();
	UpdateKilledEnemies();
	EnemiesExplodeOnDeath();
	KillPieceOfPower();
	KillAwards();
	
}


//Increase walking speed when Link has a Piece of Power and LA_NONE
void WalkSpeed(){
	if ( Z4_ItemsAndTimers[POWER_BOOSTED] ) { //Check to see if Link has a Piece of Power power-up boost...
		if ( Link->Action == LA_NONE && !LinkJump() && Link->Z == 0 ) { //If he isnt attacking, swimming, hurt, or casting, and h
			if ( Link->PressDown && !isSideview() //If the player presses down, and we aren't in sideview mode...
				&& !Screen->isSolid(Link->X,Link->Y+17) //SW Check Solidity
				&& !Screen->isSolid(Link->X+7,Link->Y+17) //S Check Solidity
				&& !Screen->isSolid(Link->X+15,Link->Y+17) //SE Check Solidity
			) {
				//Do we also need isSolid() checks here?
				Link->X += WALK_SPEED_POWERUP;
			}
			if ( Link->PressUp && !isSideview()  //If the player presses up, and we aren't in sideview mode...
				&& !Screen->isSolid(Link->X,Link->Y+6) //NW Check Solidity
				&& !Screen->isSolid(Link->X+7,Link->Y+6) //N Check Solidity
				&& !Screen->isSolid(Link->X+15,Link->Y+6) //NE Check Solidity
			) {
				Link->X -= WALK_SPEED_POWERUP; //Increase the distance the player moves down, by this constant.
			}
			if ( Link->PressRight && !Screen->isSolid(Link->X+17,Link->Y+8) //If the player presses right, check NE solidity...
				&& !Screen->isSolid(Link->X+17,Link->Y+15) //and check SE Solidity 
			) { 
				Link->Y += WALK_SPEED_POWERUP; //Increase the distance the player moves down, by this constant.
			}
			if ( Link->PressLeft && !Screen->isSolid(Link->X-2,Link->Y+8)  //If the player presses right, check NW solidity...
				&& !Screen->isSolid(Link->X-2,Link->Y+15) //SW Check Solidity
			) {
				Link->Y -= WALK_SPEED_POWERUP; //Increase the distance the player moves down, by this constant.
			}
		}
	}
}

//We check for Solidity above, to prevent the game forcing Link->X/Y into a solid combo, and we also check 
//sideview mode, as in sideview gravity, with this, would allow the player to walk upwards or downwards, where he shouldn't.


///Functions called by MAIN functions:

//Runs every frame from LinksAwakeningItems();
void PiecesOfPower(){
	if ( Z4_ItemsAndTimers[NUM_PIECES_POWER] >= NEEDED_PIECES_OF_POWER ) { //Check to see if the number of Pieces of Power collected by ther player
										//is at least the number required in settings.
		//if so...
		Z4_ItemsAndTimers[NUM_PIECES_POWER] = 0;  //Clear the number of Pieces of Power collected.
		Z4_ItemsAndTimers[POWER_TIMER] = BUFF_TIME; //Set the timer to the value of this constant, set in settings. This allows the timer to start.
							//When the timer is active, other functions that rely on it will run.
		BoostAttack();	//Run this routine.
	}
	NerfAttack(); //Otherwise, run this routine.
}

//Runs every frame from LinksAwakeningItems();
void Acorns(){
	if ( Z4_ItemsAndTimers[NUM_ACORNS] >= NEEDED_ACORNS ) { //Check to see if the number of Guardian Acorns that the
								//player collected is at least the amount specified in the settings
		//If so...
		Z4_ItemsAndTimers[NUM_ACORNS] = 0;  //Clear the number of acorns collected.
		Z4_ItemsAndTimers[DEF_TIMER] = BUFF_TIME; //Set the timer, to the value of this constant. 
		//When the timer is active, functions that rely on it run automatically.
		BoostDefence(); //Run this routine.
	}
	NerfDefence(); //Otherwise, run this routine. 
}

//Runs from PiecesOfPower()();
void BoostAttack(){
	if ( Z4_ItemsAndTimers[POWER_TIMER] && !Z4_ItemsAndTimers[POWER_BOOSTED] ) { //If Link's power is not boosted, and the timer has a positive value above 0...
		BuffSwords(); //Run this function to double his sword attacks.
	}
	if ( PLAY_PIECE_OF_POWER_MESSAGE ) { //If this setting is a value of '1'...
		PieceOfPowerMessage(MSG_PIECE_OF_POWER); //Play a message specified by this constant.
	}
}

//Runs from PiecesOfPower()
void NerfAttack(){
	if ( Z4_ItemsAndTimers[POWER_BOOSTED] && Z4_ItemsAndTimers[POWER_TIMER] < 1 ) { //If Link's power is boosted, and the timer has expired...
		Z4_ItemsAndTimers[POWER_BOOSTED] = 0; //Clear the flag that tells us that his power is boosted.
		NerfSwords(); //Run this function to reduce his attack back to normal.
		Z4_ItemsAndTimers[POWER_TIMER] = 0; //Ensure that the timer is exactly zero.
	}
}

//Runs from Acorns();
void BoostDefence(){
	if ( Z4_ItemsAndTimers[DEF_TIMER] && !Z4_ItemsAndTimers[DEF_BOOSTED] ) { //If Link's defence is NOT boosted by an acorn powerup and the timer is running...
		BuffRings(); //Run this dunction to double his defence.
	}
	if ( PLAY_ACORN_MESSAGE ) { //If this setting is '1'...
		AcornMessage(MSG_GUARDIAN_ACORN); //Play the message specified by this constant.
	}
}

//Runs from Acorns()
void NerfDefence(){
	if ( Z4_ItemsAndTimers[DEF_BOOSTED] && Z4_ItemsAndTimers[DEF_TIMER] < 1 ) { //If Link';s def is boosted and the timer has expired...
		Z4_ItemsAndTimers[DEF_BOOSTED] = 0; //Clear the flag that tells us that his defense was boosted...
		NerfRings(); //Run this function to reduce his defs back to normal.
		Z4_ItemsAndTimers[DEF_TIMER] = 0; //Ensure that the timer is exactly zero.
	}
}

//Runs from BoostDefence();
void BuffSwords(){
	float presentPower; //Make a variable so that we can write to it.
	for ( int q = 0; q <= 255; q++ ) { //Go through all Link's inventory (in one frame)...
		itemdata id = Game->LoadItemData(q); //Load each item, once per loop...
		if ( id->Family ==  IC_SWORD ) { //If an item is Itemclass SWORD
			presentPower = id->Power; //Set our variable to its present ->Power
			id->Power = presentPower * 2; //Write that value * 2 to its ->Power, doubling its attack strength.
		}
	}
	Game->PlaySound(SFX_POWER_BOOSTED); //Play a sound effect to indicate this happened.
	Z4_ItemsAndTimers[POWER_BOOSTED] = 1; //Set the flag that allows us to determine if Link's attack is boosted by a power-up.
}

//Runs from BoostDefence();
void BuffRings(){
	float presentPower; //Make a variable so that we can write to it.
	for ( int q = 0; q <= 255; q++ ) { //Go through all Link's inventory (in one frame)...
		itemdata id = Game->LoadItemData(q); //Load each item, once per loop...
		if ( id->Family ==  IC_RING ) { //If an item is Itemclass RING...
			presentPower = id->Power; //Set our variable to its present ->Power
			id->Power = presentPower * 2; //Write back that value * 2 to double the defense modifier.
		}
	}
	Game->PlaySound(SFX_GUARDIAN_DEF); //Play a sound so that the player knows it happened.
	Z4_ItemsAndTimers[DEF_BOOSTED] = 1; //Set the flag that allows us to determine if Link's defense is boosted by a power-up.
}

//Runs from BoostDefence();
void NerfSwords(){
	float presentPower;  //Make a variable so that we can write to it.
	for ( int q = 0; q <= 255; q++ ) { //Go through all Link's inventory (in one frame)...
		itemdata id = Game->LoadItemData(q);  //Load each item, once per loop...
		if ( id->Family ==  IC_SWORD ) { //If an item is Itemclass SWORD...
			presentPower = id->Power; //Set our variable to its present ->Power
			id->Power = presentPower * 0.5; //Write back that value * 0.5 to halve the defense modifier.
			//We use multiplication here, to avoid a division by zero error, however unlikely that may be.
		}
	}
	Game->PlaySound(SFX_NERF_POWER); //Play a sound to indicate that this happened.
	//Because this only runs if the timer is zero, and because the function NerfDefence() already sets the flag
	//that tells us that Link's attack is boosted back to '0', we dont need to have an instruction here to do that.
}

//Runs from BoostDefence();
void NerfRings(){
	float presentPower; //Make a variable so that we can write to it.
	for ( int q = 0; q <= 255; q++ ) { //Go through all Link's inventory (in one frame)...
		itemdata id = Game->LoadItemData(q); //Load each item, once per loop...
		if ( id->Family ==  IC_RING ) { //If an item is Itemclass RING...
			presentPower = id->Power; //Set our variable to its present ->Power
			id->Power = presentPower * 0.5;//Write back that value * 0.5 to halve the defense modifier.
			//We use multiplication here, to avoid a division by zero error, however unlikely that may be.
		}
	}
	Game->PlaySound(SFX_NERF_DEF); //Play a sound to indicate that this happened.
	//Because this only runs if the timer is zero, and because the function NerfDefence() already sets the flag
	//that tells us that Link's attack is boosted back to '0', we dont need to have an instruction here to do that.
}

/////////////////////////
/// Utility Functions ///
/////////////////////////

//Returns number of Secret Shells collected.
int NumShells(){
	return Z4_ItemsAndTimers[NUM_SHELLS]; //When calling NumShells() ZC will tell us how many Secret Shells the player has
						//by reading this value, and returning it.
}

//Awards a bonus Secret Shell
void BonusShell(){
	Z4_ItemsAndTimers[NUM_SHELLS]++; //Add one Secret Shell to out array counter.
}

//Returns true if the player has either an active Guardian Acorn Power-Up, or an active Piece of Power power-up.
bool HasPowerUp(){
	if ( Z4_ItemsAndTimers[POWER_BOOSTED] || Z4_ItemsAndTimers[DEF_BOOSTED] ) { 
		//If either attack, or defence is boosted, return true.
		return true;
	}
	//If neither are boosted, return false.
	return false;
}

//Returns true if the player has a stone beak for the present level; and returns the number of beaks.
bool StoneBeak(){
	int lvl = Game->GetCurLevel(); //Store the current level to a variable.
	return StoneBeaks[lvl]; //Return the number of stone beaks the player has for this level. 
	//Remember, a value of '0' is treated as 'false', and '1' or more as 'true', so this allows us
	//either boolean, or integer control.
}

//Returns Link->Jump as an int. For whatever reason, this is recorded to allegro.log as a float, and some ZC versions
//have a bug involving this value, so we Floor it first.
int LinkJump(){
	int jmp = Floor(Link->Jump); //Floor Link->Jump to ensure that a value of 0.050 is '0'.
	return jmp; //Return the floored value.
}

//Automatically plays messages when the player has a Guardian Acorn power-up.
void AcornMessage(int msg){
	if ( ! Z4_ItemsAndTimers[MSG_GUARDIAN_PLAYED] && Z4_ItemsAndTimers[DEF_BOOSTED] ){ //If we haven't played the message, and Link's defence is boosted by an acorn...
		Z4_ItemsAndTimers[MSG_GUARDIAN_PLAYED] = 1; //Set the flag that tells us that ZC played the message...
		Screen->Message(msg); //Play the message input as arg 'msg', which is not the same as the cooking ingredient..
	}
}

//Automatically plays messages when the player has a Piece of Power power-up.
void PieceOfPowerMessage(int msg){
	if ( ! Z4_ItemsAndTimers[MSG_PIECE_POWER_PLAYED] && Z4_ItemsAndTimers[POWER_BOOSTED] ){ //If we haven't played the message, and Link's defence is boosted by a Piece of Power...
		Z4_ItemsAndTimers[MSG_PIECE_OF_POWER_PLAYED] = 1; //Set the flag that tells us that ZC played the message...
		Screen->Message(msg); //Play the message input as arg 'msg', which is not the same as the cooking ingredient..
	}
}

//////////////////////////////
/// Powerup MIDI Functions ///
//////////////////////////////

//Back up the original MIDIs so that we can later restore them.
void Backup_MIDIs(){
	for ( int q = 0; q <= 255; q++ ) { //A for loop with a size matching the size of Game->DMapMIDI[]
		PlayingPowerUp[q] = Game->DMapMIDI[q]; //Copy the first 256 elements of Game->DMapMIDI[] to PlayingPowerUp[].
		//This ensures that we can always restore them when we're done.
	}
}

//Copies all original MIDIs back to Game->DMapMIDI[]
void RestoreNonPowerUpMIDIs(){ 
	for ( int q = 0; q <= 255; q++ ) { //A for loop with a size matching the size of Game->DMapMIDI[]
		Game->DMapMIDI[q] = PlayingPowerUp[q]; //Copy the first 256 elements of  PlayingPowerUp[] to Game->DMapMIDI[].
	}
	//This restores the MIDIs set by the quest file, when we're done playing alternate MIDIs.
}

//An easy way to determine if we are playing a special MIDI for the power-ups.
bool _PlayingPowerUpMIDI(){
	return PlayingPowerUp[PLAYING_POWER_UP_MIDI]; 
}
//Above function replaced, with PlayingPowerUpMIDI() below.

//Change the value of this index, from 0 to 1, or 1 to 0, so that we can use it as a boolean flag to determine
//if we are playing a power-up MIDI.
void PlayingPowerUpMIDI(int setting){
	PlayingPowerUp[PLAYING_POWER_UP_MIDI] = setting;
}

//Copy the POWERUP_MIDI to DMapMIDI[] for this level, and hopefully auto-play it.
void PlayPowerUpMIDI(){
	int lvl = Game->GetCurLevel(); //Determine the present Level
	Game->DMapMIDI[lvl] = POWERUP_MIDI; //Change the value of the index of Game->DMapMIDI[] matching this level, to the MIDI of the Power-up MIDI
// This should, in theory, automatically play it, and it should not change if we leave the screen
// as it would with Game->PlayMIDI
// ZC should always play MIDIs with the new values for matching DMAPs.
}


//An easy way to determine if we are playing a special MIDI for the power-ups.
bool PlayingPowerUpMIDI(){
	int lvl = Game->GetCurLevel(); //Store the present level in a variable...
	if ( Game->DMapMIDI[lvl] == POWERUP_MIDI ){ //Check if the index lvl of Game->DMapMIDI[] is set to the special MIDI for power-ups.
		return true; //if so, return true.
	}
	return false; //Otherwise, return false.
}
	

void PowerUpMIDI(){
	if ( HasPowerUp() && !PlayingPowerUpMIDI() ) { //if Link has a power-up and we are not yet playing the special MIDI
		PlayingPowerUpMIDI(PLAY_POWERUP_MIDI); //Toggle this flag on.
		PlayPowerUpMIDI(); //Copy the special power-up MIDI to the index of Game->DMapMIDI[] for this level, and hopefully automatically play it.
		//Game->PlayMIDI(POWERUP_MIDI); //Removed in an old version, because this resets when leaving the screen.
	}
	if ( !HasPowerUp() && PlayingPowerUpMIDI() ) { //If Link does not have an active power-up, and we *are* still playing the power-up MIDI...
		RestoreNonPowerUpMIDIs(); //COpy the original MIDIs back to Game->DMapMIDIs[]
		PlayingPowerUpMIDI(NORMAL_DMAP_MIDI); //Toggle this flag back off.
	}
}



////////////////////
/// Item Scripts ///
////////////////////

//Piece of Power item PICKUP script. 
item script PieceOfPower{
	void run(){
		Z4_ItemsAndTimers[NUM_PIECES_POWER]++; //When the player touches this item, add one to the array counter.
	}
}

//Acorn item PICKUP script. 
item script GuardianAcorn{
	void run(){
		Z4_ItemsAndTimers[NUM_ACORNS]++; //When the player touches this item, add one to the array counter.
	}
}

//Shell item PICKUP script. 
item script SecretShell{
	void run(){
		Z4_ItemsAndTimers[NUM_SHELLS]++; //When the player touches this item, add one to the array counter.
	}
}



//Attach as the Pick-Up script for the stone beak item.
item script StoneBeak_Pickup{
	void run(){
		int level = Game->GetCurLevel(); //Determine the present level, and store it in this variable.
		StoneBeaks[level]++; ////When the player touches this item, add one to the array counter for this level.
	}
}

///////////////////
/// FFC Scripts ///
///////////////////

// Attach to an FFC of an owl statue. If Link has a stone beak for this level, this statue will play
// the message set by arg D0.
ffc script OwlStatue {
	void run (int msg){
		if ( DistanceLink(this->X+8,this->Y+8) < 14 && StoneBeak() && Link->PressA ){ //
			//If Link has the stone beak for this level, and presses A...
			Screen->Message(msg); //Display the string set by arg D0.
			Link->InputA = false; //Don't swing sword.
		}
	}
}

// FFC Script for Secret Shell Mansion
// D0: The Screen->D Register to use to store datum. 
// D1: Set to a value of '1' or higher, to make secret permanent. 
ffc script SecretShellMansion{
	void run(int reg){
		if ( NumShells % BONUS_SHELL_DIVISOR == 0 ) { //If the number of shells is an *exact multiple* of the value set by BONUS_SHELL_DIVISOR
			int shellsST = Game->GetScreenD[dat]; //Store the present value of Screen->D register 'dat' in a variable, so that we can safely change the value of the register.
			if ( NumShells() > shellsST ) { //If the number of shells is higher than the value stored in Screen->D register 'dat' 
				Game->SetScreenD[dat] = NumShells(); //Set the register to the present number of shells, then...
				Game->PlaySound(SFX_BONUS_SHELL); //Play a special sound effect...
				BonusShell(); //...and award a bonus shell.
				//This replicates the bonus shell you may obtain at the Seashell manion in Z4 
				//by having exactly five shells, or multiples of 5 
				//on repeated visits. 
			}
		}
		if ( NumShells() >= REQUIRED_SECRET_SHELLS ) { //If we have enough shells to unlock a secret, as set by this constant
			Game->PlaySound(SFX_SECRET_SHELL); //Play a special sound to indicate that we unlocked a secret...
			if ( perm ) { //If arg D1 is '1' or higher...
				Screen->State[ST_SECRET] = true; //Set the secret state as permanent, then... 
			}
			Screen->TriggerSecrets(); //Trigger the secrets for this screen. 
						//This will be temporary if arg D1 is '0'.
		}
	}
}


/////////////////////////////
/// Sample Global Scripts ///
/////////////////////////////


global script LA_Active{ //An example global active script.
	void run(){
		while(true){
			Z4_EnemyKillRoutines();
			ReduceBuffTimers();
			LinksAwakeningItems();
			TestRoutines();
			Waitdraw();
			
			Waitframe();
		}
	}
}

global script LA_OnContinue{ //An example OnContinue script
	void run(){
		if ( RANDOMISE_PER_PLAY ) { //If this flag in settings is enabled, we will randomise the number of 
					    // enemies that Link must kill, each time he loads the game, so that 
					    // the number required when we saved is re-rolled. 
			PieceOfPowerKills(); //Randomise the value. 
		}
		InitLinkHP(); //Store Link's HP again, so that if we continue with more HP, the values aren;t out of sync.
		Z4_ItemsAndTimers[DEF_TIMER] = 0; //Reset timers for power-ups back to zero, so that they don;t carry over through F6
		Z4_ItemsAndTimers[POWER_TIMER] = 0; //or through saving.
		//Set timers back to 0, disabling the boost.
	}
}

global script LA_OnExit{
	void run(){
		Z4_ItemsAndTimers[DEF_TIMER] = 0;//Reset timers for power-ups back to zero, so that they don;t carry over through F6
		Z4_ItemsAndTimers[POWER_TIMER] = 0; //or through saving.
		//Set timers back to 0, disabling the boost.
	}
}

global Script Init{
	void run(){
		InitZ4(); //Set up the initial values used by this script. 
	}
}

//void LinksAwakeningItems(int swords, int rings){
//}


//int TempBoostItems[6];
//int TempBoostTimers[2];


//int SwordItems[4]={1};
//int DefItems[4]={64};


//Drop one Guardian Acorn if the player kills 12 consecutive enemies without being hurt.

//Call in Global Script ~Init.
void InitZ4(){
	InitScreenChanged(); //Set the intitial screen, and DMAP values, for checking if the screen changes.
	InitLinkHP(); //Store Link's HP initially, so that we know when he is hit. 
	PieceOfPowerKills(); //Establish how many enemies Link must kill for the first possible Piece of Power in the game.
}

//Run before Waitdraw.
void Z4ScreenChanged(){ //Determines if the screen changed from scrolling, or warping. 
	PowerupStoreScreenChange();  //Store change values.
	PowerupScreenUpdateScrolling(); //and update them. 
}


////

//Runs from InitZ4 in Global script ~Init
void InitScreenChanged(){
	Z4_ItemsAndTimers[POWERUP_SCREEN_HAS_CHANGED] = 1; //Set this flag to '1' so that the game isn't confused. 
}

//Runs from InitZ4 in Global script ~Init
void InitLinkHP(){
	Z4_ItemsAndTimers[POWERUP_PLAYER_HP] = Link->HP; //Store the initial values of these, as a reference.
	Z4_ItemsAndTimers[POWERUP_PLAYER_OLD_HP] = Link->HP;
}
	
//Runs from InitZ4 in Global script ~Init
//Call elsewhere to reset the value.
void PieceOfPowerKills(){
	int numKills = Rand(REQUIRE_KILLS_PIECE_OF_POWER_MIN,REQUIRE_KILLS_PIECE_OF_POWER_MAX); //Randomly generate the next number of required kills.
	Z4_ItemsAndTimers[POWERUP_PIECE_OF_POWER_NEEDED_KILLS] = numKills; //Set that to the value in the array.
}

/// ! Check these functions to ensure they aren't broken !
	
//Runs before Waitdraw() from Z4ScreenChanged()
void PowerupStoreScreenChange(){
	int thisScreen = Game->GetCurScreen(); //Store the present screen ID in a variable.
	int thisDMap = Game->GetCurDMap(); //Store the present DMAP ID in a variable.
	if ( thisScreen != Z4_ItemsAndTimers[POWERUP_CURSCREEN] || thisDMap != Z4_ItemsAndTimers[POWERUP_CURDMAP] ){
			//If the present screen and DMAP are not the same as the ones stored, we know that tje screen has changed.
		Z4_ItemsAndTimers[POWERUP_CURSCREEN] = thisScreen; //Then we update the values for the screen...
		Z4_ItemsAndTimers[POWERUP_CURDMAP] = thisDMap; //...and the DMAP in the array
		Z4_ItemsAndTimers[POWERUP_SCREEN_HAS_CHANGED] = 1; //and set this flag.
	}
	else (Z4_ItemsAndTimers[POWERUP_SCREEN_HAS_CHANGED] = 0); //Otherwise, the screen HAS NOT changed, so we set this flag to '0'.
}

//Run in conjunction with PowerupStoreScreenChange(). Runs from Z4ScreenChanged()
void PowerupScreenUpdateScrolling(){
	if ( Link->Action == LA_SCROLLING ) { //If Link moves between screens with scrolling
		Z4_ItemsAndTimers[POWERUP_SCREEN_HAS_CHANGED] = 1; //Set this flag so that we know that the screen has changed.
	}
}

//Utility function to determine if screen has changed.
int PowerUpScreenChanged(){
	if ( Z4_ItemsAndTimers[POWERUP_SCREEN_HAS_CHANGED] ) { //If this value is '1' or higher...
		return true; //The screen has changed, so this will return true.
	}
	return false; //If it has a value of '0', the screen has not changed, so we don;t run routines that we want to run when the screen changes.
	//This is important when determining how many enemies we killed on this screen, before leaving it, so that we don't
	//set up a huge loop where the number infinitely increases.
}
	

//void Update_Powerup_HP(){
//	
//}

/// ! Check these functions to ensure they aren't broken !


//Count screen enemies and store the value.
void CountEnemies(){
	if ( PowerUpScreenChanged() ) { //If the screen has changed
		if ( Z4_ItemsAndTimers[POWERUP_NUM_ENEMIES] > 0 ) { //If the number of enemies that are on the screen is not zero
			Z4_ItemsAndTimers[POWERUP_NUM_ENEMIES] = 0; //Change it to zero...then...
		}
		Z4_ItemsAndTimers[POWERUP_NUM_ENEMIES] = ( Screen->NumNPCs() - NumNPCsOf(NPCT_FAIRY) ); 
		//Check the number of enemies on the screen (other than faerie NPCs) and store the value.
		//This ensures that if we kill enemies, and leave the screen, the number that we use
		//as a reference to determine how many enemies we've killed, doesn't become desync'd. 
		
}
	
//Check if any enemies have been killed.
void UpdateKilledEnemies(){
	int diff; //A variable for operations.
	int numEnem = ( Screen->NumNPCs() - NumNPCsOf(NPCT_FAIRY) ); //Count the (non-faerie) enemies on the screen, and store that value.
	if  ( numEnem < Z4_ItemsAndTimers[POWERUP_NUM_ENEMIES] ) { //If the number of enemies is fewer than the value we stored last frame...
		diff = ( Z4_ItemsAndTimers[POWERUP_NUM_ENEMIES] - numEnem ); //Calculate the difference.
		Z4_ItemsAndTimers[POWERUP_ENEMY_KILLS] += diff; //This is how many enemies we killed this frame, so add that to our kill counter.
		Z4_ItemsAndTimers[POWERUP_NUM_ENEMIES] = numEnem; //Change the array value of the number of on-screen enemies, so that we don't award extra kills.
		if ( Z4_ItemsAndTimers[POWERUP_LINK_DAMAGED] == 0 ) { //If Link was *NOT* hurt...
			Z4_ItemsAndTimers[POWERUP_CONSECUTIVE_ENEMY_KILLS] += diff; //also increase the value of consecutive kills by the same amoumt.
		}
		else if Z4_ItemsAndTimers[POWERUP_LINK_DAMAGED] == 1 ) { //but if Link was hurt this frame...we don;t award that...
			Z4_ItemsAndTimers[POWERUP_CONSECUTIVE_ENEMY_KILLS] = 0; //we set it back to zero instead.
			Z4_ItemsAndTimers[POWERUP_LINK_DAMAGED] = 0; //Then we reset the flag, to restart the count of consecutive kills w/o being hurt.
		}
	}
}

//Store Link HP to check if he was hurt.
int StoreLinkHP(){
	Z4_ItemsAndTimers[POWERUP_PLAYER_HP] = Link->HP; //Store the present HP for Link this frame.
	if ( Z4_ItemsAndTimers[POWERUP_PLAYER_OLD_HP] > Z4_ItemsAndTimers[POWERUP_PLAYER_HP] ){ 
		//If this is lower than it was last frame (or at the atart of the game if this is the first frame of the game)
		//Link was hit.
		Z4_ItemsAndTimers[POWERUP_LINK_DAMAGED] = 1; //Set the flag that tells us that Link was hurt.
		Z4_ItemsAndTimers[POWERUP_PLAYER_OLD_HP] = Link->HP; //Store his new HP into the OLD_HP reference, so that
								     //we may use it next frame to repeat the check.
		//This value is set back to 0 by UpdateKilledEnemies(). 
	}
}



//End timer for a Piece of Power if the player was hurt a specified number of times.
void KillPieceOfPower(){
	if ( Z4_ItemsAndTimers[POWER_BOOSTED] && REMOVE_ATTACK_BOOST_WHEN_PLAYER_DAMAGED ) {
		if ( Z4_ItemsAndTimers[POWERUP_LINK_DAMAGED] ) {
			//this is set to either 0 or 1 each frame by UpdateKilledEnemies()
			Z4_ItemsAndTimers[POWERUP_LINK_HURT_COUNTER]++; //Increase this counter if Link was hurt.
			//Because Z4_ItemsAndTimers[POWERUP_LINK_DAMAGED] is set to either 0 or 1 before this runs, it 
			//should only increase once, unless Link is hurt multiple times in consecutive frames. 
		}
		
		if ( Z4_ItemsAndTimers[POWERUP_LINK_HURT_COUNTER] >= NUM_HITS_TO_LOSE_POWER_BOOST ){
			//If Link was hurt more times than specified by constant NUM_HITS_TO_LOSE_POWER_BOOST
			Z4_ItemsAndTimers[POWERUP_LINK_HURT_COUNTER] = 0; //Reset hurt counters.
			Z4_ItemsAndTimers[POWERUP_LINK_HURT_COUNTER_LAST] = 0; //Reset hurt counters.
			Z4_ItemsAndTimers[POWER_TIMER] = 0; //Set POWER_TIMER to 0, ending the effect of a Piece of Power boost.
		}
	}
}
	
	

//If the flag KILL_AWARDS is set true, award buff items for killing enemies. 
void KillAwards(){
	if ( KILL_AWARDS ) { //If this setting is enabled..
		GiveAcorn(); //Run these functions.
		GivePieceOfPower();
	}
}

//Award a free GFuardian Acorn for killing a number of monsters specified in settings, without being hit. 
void GiveAcorn(){
	if ( Z4_ItemsAndTimers[POWERUP_CONSECUTIVE_ENEMY_KILLS] >= REQUIRE_CONSECUTIVE_KILLS ){
		//If we consecutively kill a number of enemies equal to, or greater than the minimum
		//specified by the constant REQUIRE_CONSECUTIVE_KILLS:
		item itm = Screen->CreateItem(I_ACORN); //Create an item, ID I_ACORN
		itm->X = Link->X; //Place it at Link's coordinates...
		itm->Y = Link->Y;
		itm->Z = Link->Z;
		Link->Action = LA_HOLD1LAND; //Cause Link to hold it up.
		Link->HeldItem = itm; //Set the item Link holds manually.
		Z4_ItemsAndTimers[POWERUP_CONSECUTIVE_ENEMY_KILLS] = 0; //Reset the consecutive kills counter. 
	}
}

//Drop one Piece of Power after killing a number of monsters specified by settings.
void GivePieceOfPower(){
	if ( Z4_ItemsAndTimers[POWERUP_ENEMY_KILLS] >= Z4_ItemsAndTimers[POWERUP_PIECE_OF_POWER_NEEDED_KILLS]){
		//If we  kill a number of enemies equal to, or greater than the minimum
		//specified by the random value generated by PieceOfPowerKills(), that we've stored in 
		// array index Z4_ItemsAndTimers[POWERUP_PIECE_OF_POWER_NEEDED_KILLS] :
		
		item itm = Screen->CreateItem(I_PIECE_POWER); //Create an item with the ID I_PIECE_POWER
		itm->X = Link->X; //Place it at Link's coordinates.
		itm->Y = Link->Y;
		itm->Z = Link->Z;
		Link->Action = LA_HOLD1LAND; //Cause Link to hold it up.
		Link->HeldItem = itm; //Set the item Link holds, manually. 
		Z4_ItemsAndTimers[POWERUP_ENEMY_KILLS] = 0; //Reset the total kills counter.
		PieceOfPowerKills(); //Randomly generate the new number of kills needed, for the next Piece of Power 
				     //awarded this way.
	}
}



//Cause enemies to have a death animation explosion with custom sprites.
//Run before Waitdraw() in the infinite ( while(true) ) loop of your global active script. 
//You need only call this one function to run the entirety of this code.
void EnemiesExplodeOnDeath(){
	if ( EXPLOSIONS_RUN_WITH_FFCS ) { //If this setting is enabled...
		EnemyExplosionFFC(); //Run this function.
	}
	else { //Otherwise...
		EnemyExplosion(); //Run this instead.
	}
}

//Example global script:

global script active_explosions{
	void run(){
		while(true){
			EnemiesExplodeOnDeath();
			Waitdraw();
			Waitframe();
		}
	}
}

//Routines

/// ! Check these functions to ensure they aren't broken !

//Death explosion animation function, for global use.
void EnemyExplosion(){
	int fX; //Set up variables to hold X/Y coordinates.
	int fY;
	bool isBoss;
	bool isMiniBoss;
	bool isFinalBoss;
	int numExplosions;
	int enemID;
	
	for ( int q = 1; q <= Screen->NumNPCs(); q++ ) { //Run a for loop to read every enemy on the screen...
		//Otherwise...
		npc n = Screen->LoadNPC(q); //Declare an npc variable, 
		if ( n->isValid() ) {
			
			if n->ID == FINAL_BOSS_ID {
				isFinalBoss = true;
			}
			
			for ( int e = 0; 0 <= SizeOfArray(BossList); e++ ) {
				if ( isFinalBoss) break;
				enemID = BossList[e];
				if ( n->ID == enemID ) {
					isBoss = true;
					break;
				}
			}
			
			for ( int e = 0; 0 <= SizeOfArray(MiniBossList); e++ ) {
				if ( isBoss ) break;
				enemID = MiniBossList[e];
				if ( n->ID == enemID ) {
					isMiniBoss = true;
					break;
				}
			}
			
			
			if ( !ENEMIES_ALWAYS_EXPLODE && !isBoss && !isMiniBoss && !isFinalBoss && !Z4_ItemsAndTimers[POWER_BOOSTED] ){ //If these flags are all disabled, exit this function.
				break;
			}
			
			//Determine number of explosions by type of enemy...
			if ( isMiniBoss ) {
				numExplosions = FFC_NUM_OF_EXPLOSIONS + FFC_EXPLOSIONS_MINIBOSS_EXTRA;
			}
			else if ( isBoss ) {
				numExplosions = FFC_NUM_OF_EXPLOSIONS + FFC_EXPLOSIONS_BOSS_EXTRA;
			}
			else if ( isFinalBoss ) {
				numExplosions = FFC_NUM_OF_EXPLOSIONS + FFC_EXPLOSIONS_FINALBOSS_EXTRA;
			}
			else ( numExplosions = FFC_NUM_OF_EXPLOSIONS );
			
			if ( Z4_ItemsAndTimers[POWER_BOOSTED] ) {
				numExplosions += FFC_EXPLOSION_PIECE_OF_POWER_EXTRA_BLASTS; 
			}
			
			//and assign it to each valid NPC in the for loop.
			if ( q->HP <= 0 ) { //if the NPC is dead, or dying...
				fX = q->X; //Set the variables to the coordinates of that NPC.
				fY = q->Y;
				eweapon explosion; //Create a dummy eweapon to use for animations...
				for ( int q = 0; q <= numExplosions; q++ ) {
					//Run a for loop, to make a timed series of explosions...
					if ( numExplosions) { //Run only if there are explision to make.
						explosion = Screen->CreateEWeapon(EW_BOMBBLAST); //Make an explosion..
						Game->PlaySound(SFX_ENEMY_EXPLOSION);
						explosion->CollDetection = false; //...that doesn;t hurt anyone...
						explosion->X = fX + Rand(1,16)-8; //at X coordinates fX plus a slightly randomised offset.
						explosion->Y = fY + Rand(1,16)-8; //at Y coordinates fX plus a slightly randomised offset.
						explosion->UseSprite(FFC_EXPLOSION_SPRITE); //...using this sprite
						explosion->Extend = FFC_EXPLOSION_EXTEND; //...with extended size
						explosion->TileWidth = FFC_EXPLOSION_TILEWIDTH; //...this many tiles wide
						explosion->TileHeight = FFC_EXPLOSION_TILEHEIGHT; ///...this many tiles high
						Waitframe(); //..pause, then go back to the top of this loop, to repeat until the number of
							     // explosions is a total matching FFC_NUM_OF_EXPLOSIONS + FFC_EXPLOSION_PIECE_OF_POWER_EXTRA_BLASTS
					}
				}
				explosion->DeadState = WDS_DEAD; //Kill the dummy eweapon
				Remove(explosion); //and remove it.
			}
		}
	}
}

//Alternate to EnemyExplosion() that calls an FFC with its own Waitframe().
void EnemyExplosionFFC(){
	int fX; //Set up variables to hold X/Y coordinates.
	int fY;
	bool isBoss;
	bool isMiniBoss;
	bool isFinalBoss;
	int numExplosions;
	int enemID;
	
	for ( int q = 1; q <= Screen->NumNPCs(); q++ ) { //Run a for loop to read every enemy on the screen...
		npc n = Screen->LoadNPC(q); //Declare an npc variable, 
		if ( n->isvalid() ) { //and assign it to each valid NPC in the for loop.

			
			if n->ID == FINAL_BOSS_ID {
				isFinalBoss = true;
			}
			
			for ( int e = 0; 0 <= SizeOfArray(BossList); e++ ) {
				if ( isFinalBoss) break;
				enemID = BossList[e];
				if ( n->ID == enemID ) {
					isBoss = true;
					break;
				}
			}
			
			for ( int e = 0; 0 <= SizeOfArray(BossList); e++ ) {
				enemID = BossList[e];
				if ( n->ID == enemID ) {
					isBoss = true;
					break;
				}
			}
			for ( int e = 0; 0 <= SizeOfArray(MiniBossList); e++ ) {
				if ( isBoss ) break;
				enemID = MiniBossList[e];
				if ( n->ID == enemID ) {
					isMiniBoss = true;
					break;
				}
			}
			
			
			if ( !ENEMIES_ALWAYS_EXPLODE && !isBoss && !isMiniBoss && !isFinalBoss && !Z4_ItemsAndTimers[POWER_BOOSTED] ){ //If these flags are both disabled, exit this function.
				break;
			}
			//Determine number of explosions by type of enemy...
			if ( isMiniBoss ) {
				numExplosions = FFC_NUM_OF_EXPLOSIONS + FFC_EXPLOSIONS_MINIBOSS_EXTRA;
			}
			else if ( isBoss ) {
				numExplosions = FFC_NUM_OF_EXPLOSIONS + FFC_EXPLOSIONS_BOSS_EXTRA;
			}
			else if ( isFinalBoss ) {
				numExplosions = FFC_NUM_OF_EXPLOSIONS + FFC_EXPLOSIONS_FINALBOSS_EXTRA;
			}
			else ( numExplosions = FFC_NUM_OF_EXPLOSIONS );
			
			if ( Z4_ItemsAndTimers[POWER_BOOSTED] ) {
				numExplosions += FFC_EXPLOSION_PIECE_OF_POWER_EXTRA_BLASTS; 
			}
			
			if ( q->HP <= 0 ) { //if the NPC is dead, or dying...
				fX = q->X; //Assign its coordinates to the variables...
				fY = q->Y;
				int f_args[2]={fX,fY,numExplosions}; //...then make an array, and assign those variables as its indices.
				
				if ( numExplosions ) RunFFCScript(FFC_ENEMY_EXPLODE, f_args); //Launch the FFC script designated by FFC_ENEMY_EXPLODE
									 //using the values stored in the array f_args as the FFC 
									 //arguments D0 and D1.
			}
		}
	}
}

//FFC Script: If you wish to use an FFC to generate this effect, assign this to a slot, update the constant above, then recompile. 

//FFC of death animation explosion, to use as alternative to global function.
//Do not call this directly, by assigning it to a screen FFC. This is designed to automatically run when needed.
//...unless you want something to look like it is perpetually exploding, but then, this will need modification to do that.
ffc script Explosion{
	void run (int fX, int fY, int numExplosions){ //Inputs for coordinates. 
		//These args are to accept input by the instruction: RunFFCScript(FFC_ENEMY_EXPLODE, args[]) from other functions.
		eweapon explosion; //Create a dummy eweapon.
		for ( int q = 0; q <= numExplosions; q++ ) {
			//Run a for loop, to make a timed series of explosions...
			if ( numExplosions) { //Run only if there are explision to make.
				explosion = Screen->CreateEWeapon(EW_BOMBBLAST); //Make an explosion..
				Game->PlaySound(SFX_ENEMY_EXPLOSION);
				explosion->CollDetection = false; //...that doesn;t hurt anyone...
				explosion->X = fX + Rand(1,16)-8; //at X coordinates fX plus a slightly randomised offset.
				explosion->Y = fY + Rand(1,16)-8; //at Y coordinates fX plus a slightly randomised offset.
				explosion->UseSprite(FFC_EXPLOSION_SPRITE); //...using this sprite
				explosion->Extend = FFC_EXPLOSION_EXTEND; //...with extended size
				explosion->TileWidth = FFC_EXPLOSION_TILEWIDTH; //...this many tiles wide
				explosion->TileHeight = FFC_EXPLOSION_TILEHEIGHT; ///...this many tiles high
				Waitframe(); //..pause, then go back to the top of this loop, to repeat until the number of
					     // explosions is a total matching FFC_NUM_OF_EXPLOSIONS + FFC_EXPLOSION_PIECE_OF_POWER_EXTRA_BLASTS
			}
		}
		explosion->DeadState = WDS_DEAD; //Kill the eweapon
		Remove(explosion); //...and remove it.
		this->Data = 0; //...set the FFC script slot back to a usable state.
		return; //...and exit. 
	}
}

const int SFX_SCREEN_CHANGED = 100;

void TestRoutines(){
	TestEnemyCounters();
	TestScreenChanged();
}

//Testing routines.
void TestEnemyCounters(){
	Game->Counter[CR_SCRIPT1] = Z4_ItemsAndTimers[POWERUP_PIECE_OF_POWER_NEEDED_KILLS];
	Game->Counter[CR_SCRIPT2] = Z4_ItemsAndTimers[POWERUP_NUM_ENEMIES];
	Game->Counter[CR_SCRIPT3] = Z4_ItemsAndTimers[POWERUP_CONSECUTIVE_ENEMY_KILLS];
	Game->Counter[CR_SCRIPT4] = Z4_ItemsAndTimers[POWERUP_PLAYER_HP];
	Game->Counter[CR_SCRIPT5] = Z4_ItemsAndTimers[POWERUP_PLAYER_OLD_HP];
	Game->Counter[CR_SCRIPT6] = Z4_ItemsAndTimers[POWERUP_LINK_DAMAGED];
	Game->Counter[CR_SCRIPT7] = Z4_ItemsAndTimers[POWERUP_LINK_HURT_COUNTER_LAST];
	Game->Counter[CR_SCRIPT8] = Z4_ItemsAndTimers[POWERUP_LINK_HURT_COUNTER];
}

void TestScreenChanged(){
	if ( Z4_ItemsAndTimers[POWERUP_SCREEN_HAS_CHANGED] ) {
		Game->PlaySound(SFX_SCREEN_CHANGED);
	}
}