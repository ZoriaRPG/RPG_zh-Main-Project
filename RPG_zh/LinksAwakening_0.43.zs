//Pieces of Power, Guardian Acorns, and Secret Shells v0.4.3


//Set-up: Make a new item (Green Ring), set it up/ as follows:
//Item Class Rings
//Level: 1
//Power: 1
//CSet Modifier : None
//Assign this ring to Link's starting equipment in Quest->Init Data->Items

//Change the blue ring to L2, red to L3, and any higher above these. 

int PlayingPowerUp[258]; //An array to hold values for power-ups. Merge with main array later?
int Z4_ItemsAndTimers[9]; //Array to hold the values for the Z4 items. 
int StoneBeaks[10];	//An array to hold if we have a stone beak per level. 
			//Each index corresponds to a level number.
			//If you need levels higher than '9', increase the index size to 
			//be eaqual to the number of levels in your game + 1.
			

//Settings

const int NEEDED_PIECES_OF_POWER = 3; //Number of Pieces of power needed for temporary boost.
const int NEEDED_ACORNS = 3; //Number of Acorns needed for temporary boost.
const int REQUIRED_SECRET_SHELLS = 20; //Number of Secret Shell items to unlock the secret.
const int BUFF_TIME = 900; //Duration of boost, in frames. Default is 15 seconds.

const int PLAY_ACORN_MESSAGE = 1; //Set to 0 to turn off messages.
const int PLAY_PIECE_OF_POWER_MESSAGE = 1; //Set to 0 to disable messages for Piece of Power power-ups.

//Item Numbers : These are here for later expansion, and are unused at present.
const int I_GREEN_RING = 143; //Item number of Green Ring  
const int I_PIECE_POWER = 144; //Item number of Piece of Power
const int I_ACORN = 145; //Item number of Acorn
const int I_SHELL = 146; //Item number of Secret Shell

//Array Indices
const int POWER_TIMER = 0;
const int DEF_TIMER = 1;
const int NUM_PIECES_POWER = 2;
const int NUM_ACORNS = 3;
const int POWER_BOOSTED = 4;
const int DEF_BOOSTED = 5;
const int NUM_SHELLS = 6;
const int MSG_GUARDIAN_PLAYED = 7;
const int MSG_PIECE_POWER_PLAYED = 8;

//Sound effects constants.
const int SFX_POWER_BOOSTED = 65; //Sound to play when Attack Buffed
const int SFX_SECRET_SHELL = 66; //Sound to play when unlocking shell secret.
const int SFX_GUARDIAN_DEF = 68; //Sound to play when Defence buffed.
const int SFX_NERF_POWER = 72; //Sound to play when Piece of Power buff expires.
const int SFX_NERF_DEF = 73; //Sound to play when Guardian Acorn buff expires
const int SFX_BONUS_SHELL = 0; //Sound to play when awarded a bonus Secret Shell.

//MIDI Constants
const int PLAYING_POWER_UP_MIDI = 256;
const int NORMAL_DMAP_MIDI = 0; //Used for two things: Array index of normal DMap MIDIs (base), 
				//and as parameter in function PlayPowerUpMIDI()
const int PLAY_POWERUP_MIDI = 1;

//Power-Up Messages

const int MSG_GUARDIAN_ACORN = 0; //ID of String for Guardian Acorn Message
const int MSG_PIECE_POWER = 0; //ID of String for Piece of Power Message
const int POWERUP_MIDI = 10; //Set the the number of a MIDI to play while a Power-Up is in effect.








//int NerfedAttack[]="Attack power nerfed."; //String for TraceS()

//////////////////////
/// MAIN FUNCTIONS ///
//////////////////////

//Run every frame **BEFORE** both Waitdraw() **AND** LinksAwakeningItems();
void ReduceBuffTimers(){
	if ( Z4_ItemsAndTimers[POWER_TIMER] > 0 ) {
		Z4_ItemsAndTimers[POWER_TIMER]--;
	}
	if ( Z4_ItemsAndTimers[DEF_TIMER] > 0 ) {
		Z4_ItemsAndTimers[DEF_TIMER]--;
	}
}

//Run every frame, before Waitdraw();
void LinksAwakeningItems(){
	PiecesOfPower();
	Acorns();
}

//Returns true if the player has a stone beak for the present level; and returns the number of beaks.
bool StoneBeak(){
	int lvl = Game->GetCurLevel();
	return StoneBeaks[lvl];
}

///Functions called by MAIN functions:

//Runs every frame from LinksAwakeningItems();
void PiecesOfPower(){
	if ( Z4_ItemsAndTimers[NUM_PIECES_POWER] >= NEEDED_PIECES_OF_POWER ) {
		Z4_ItemsAndTimers[NUM_PIECES_POWER] = 0; 
		Z4_ItemsAndTimers[POWER_TIMER] = BUFF_TIME;
		BoostAttack();
	}
	NerfAttack();
}

//Runs every frame from LinksAwakeningItems();
void Acorns(){
	if ( Z4_ItemsAndTimers[NUM_ACORNS] >= NEEDED_ACORNS ) {
		Z4_ItemsAndTimers[NUM_ACORNS] = 0; 
		Z4_ItemsAndTimers[DEF_TIMER] = BUFF_TIME;
		BoostDefence();
	}
	NerfDefence();
}

//Runs from PiecesOfPower()();
void BoostAttack(){
	if ( Z4_ItemsAndTimers[POWER_TIMER] && !Z4_ItemsAndTimers[POWER_BOOSTED] ) {
		BuffSwords();
	}
	if ( PLAY_PIECE_OF_POWER_MESSAGE ) {
		PieceOfPowerMessage(MSG_PIECE_OF_POWER);
	}
}

//Runs from PiecesOfPower()
void NerfAttack(){
	if ( Z4_ItemsAndTimers[POWER_BOOSTED] && Z4_ItemsAndTimers[POWER_TIMER] < 1 ) {
		Z4_ItemsAndTimers[POWER_BOOSTED] = 0;
		NerfSwords();
		Z4_ItemsAndTimers[POWER_TIMER] = 0;
	}
	if ( PLAY_PIECE_OF_POWER_MESSAGE ) {
		Z4_ItemsAndTimers[MSG_PIECE_OF_POWER_PLAYED] = 0;
	}
}

//Runs from Acorns();
void BoostDefence(){
	if ( Z4_ItemsAndTimers[DEF_TIMER] && !Z4_ItemsAndTimers[DEF_BOOSTED] ) {
		BuffRings();
	}
	if ( PLAY_ACORN_MESSAGE ) {
		AcornMessage(MSG_GUARDIAN_ACORN);
	}
}

//Runs from Acorns()
void NerfDefence(){
	if ( Z4_ItemsAndTimers[DEF_BOOSTED] && Z4_ItemsAndTimers[DEF_TIMER] < 1 ) {
		Z4_ItemsAndTimers[DEF_BOOSTED] = 0;
		NerfRings();
		Z4_ItemsAndTimers[DEF_TIMER] = 0;
	}
	if ( PLAY_ACORN_MESSAGE ) {
		Z4_ItemsAndTimers[MSG_GUARDIAN_PLAYED] = 0;
	}
}

//Runs from BoostDefence();
void BuffSwords(){
	float presentPower;
	for ( int q = 0; q <= 255; q++ ) {
		itemdata id = Game->LoadItemData(q);
		if ( id->Family ==  IC_SWORD ) {
			presentPower = id->Power;
			id->Power = presentPower * 2;
		}
	}
	Game->PlaySound(SFX_POWER_BOOSTED);
	Z4_ItemsAndTimers[POWER_BOOSTED] = 1;
}

//Runs from BoostDefence();
void BuffRings(){
	float presentPower;
	for ( int q = 0; q <= 255; q++ ) {
		itemdata id = Game->LoadItemData(q);
		if ( id->Family ==  IC_RING ) {
			presentPower = id->Power;
			id->Power = presentPower * 2;
		}
	}
	Game->PlaySound(SFX_GUARDIAN_DEF);
	Z4_ItemsAndTimers[DEF_BOOSTED] = 1;
}

//Runs from BoostDefence();
void NerfSwords(){
	float presentPower;
	for ( int q = 0; q <= 255; q++ ) {
		itemdata id = Game->LoadItemData(q);
		if ( id->Family ==  IC_SWORD ) {
			presentPower = id->Power;
			id->Power = presentPower * 0.5;
		}
	}
	Game->PlaySound(SFX_NERF_POWER);
}

//Runs from BoostDefence();
void NerfRings(){
	float presentPower;
	for ( int q = 0; q <= 255; q++ ) {
		itemdata id = Game->LoadItemData(q);
		if ( id->Family ==  IC_RING ) {
			presentPower = id->Power;
			id->Power = presentPower * 0.5;
		}
	}
	Game->PlaySound(SFX_NERF_DEF);
}

/////////////////////////
/// Utility Functions ///
/////////////////////////

//Returns number of Secret Shells collected.
int NumShells(){
	return Z4_ItemsAndTimers[NUM_SHELLS];
}

//Awards a bonus Secret Shell
void BonusShell(){
	Z4_ItemsAndTimers[NUM_SHELLS]++;
}

//Returns true if the player has either an active Guardian Acorn Power-Up, or an active Piece of Power power-up.
bool HasPowerUp(){
	if ( Z4_ItemsAndTimers[POWER_BOOSTED] || Z4_ItemsAndTimers[DEF_BOOSTED] ) {
		return true;
	}
	return false;
}


////////////////////
/// Item Scripts ///
////////////////////

//Piece of Power item PICKUP script. 
item script PieceOfPower{
	void run(){
		Z4_ItemsAndTimers[NUM_PIECES_POWER]++;
	}
}

//Acorn item PICKUP script. 
item script GuardianAcorn{
	void run(){
		Z4_ItemsAndTimers[NUM_ACORNS]++;
	}
}

//Shell item PICKUP script. 
item script SecretShell{
	void run(){
		Z4_ItemsAndTimers[NUM_SHELLS]++;
	}
}



//Attach as the Pick-Up script for the stone beak item.
item script StoneBeak_Pickup{
	void run(){
		int level = Game->GetCurLevel();
		StoneBeaks[level]++;
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


/////////////////////////////
/// Sample Global Scripts ///
/////////////////////////////


global script LA_Active{
	void run(){
		while(true){
			ReduceBuffTimers();
			LinksAwakeningItems();
			Waitdraw();
			
			Waitframe();
		}
	}
}

global script LA_OnContinue{
	void run(){
		Z4_ItemsAndTimers[DEF_TIMER] = 0;
		Z4_ItemsAndTimers[POWER_TIMER] = 0;
		//Set timers back to 0, disabling the boost.
	}
}

global script LA_OnExit{
	void run(){
		Z4_ItemsAndTimers[DEF_TIMER] = 0;
		Z4_ItemsAndTimers[POWER_TIMER] = 0;
		//Set timers back to 0, disabling the boost.
	}
}

//void LinksAwakeningItems(int swords, int rings){
//}


//int TempBoostItems[6];
//int TempBoostTimers[2];


//int SwordItems[4]={1};
//int DefItems[4]={64};


// Powerup MIDI




void Backup_MIDIs(){
	for ( int q = 0; q <= 255; q++ ) {
		PlayingPowerUp[q] = Game->DMapMIDI[q];
	}
}

void RestoreNonPowerUpMIDIs(){
	for ( int q = 0; q <= 255; q++ ) {
		Game->DMapMIDI[q] = PlayingPowerUp[q];
	}
}

bool PlayingPowerUpMIDI(){
	return PlayingPowerUp[PLAYING_POWER_UP_MIDI];
}

void PlayingPowerUpMIDI(int setting){
	PlayingPowerUp[PLAYING_POWER_UP_MIDI] = setting;
}

//Copy the POWERUP_MIDI to DMapMIDI[] for this level, and hopefully auto-play it.
void PlayPowerUpMIDI(){
	int lvl = Game->GetCurLevel();
	Game->DMapMIDI[lvl] = POWERUP_MIDI;
}
	



//bool playingPowerUp;

//Plays MIDI set as POWERUP_MIDI while a powerup is in effect.
void PowerUpMIDI(){
	if ( HasPowerUp() && !PlayingPowerUpMIDI() ) {
		PlayingPowerUpMIDI(PLAY_POWERUP_MIDI);
		PlayPowerUpMIDI();
		//Game->PlayMIDI(POWERUP_MIDI);
	}
	if ( !HasPowerUp() && PlayingPowerUpMIDI() ) {
		RestoreNonPowerUpMIDIs();
		PlayingPowerUpMIDI(NORMAL_DMAP_MIDI);
	}
}



//Automatically plays messages when the player has a Guardian Acorn power-up.
void AcornMessage(int msg){
	if ( ! Z4_ItemsAndTimers[MSG_GUARDIAN_PLAYED] && Z4_ItemsAndTimers[DEF_BOOSTED] ){
		Z4_ItemsAndTimers[MSG_GUARDIAN_PLAYED] = 1;
		Screen->Message(msg);
	}
}

//Automatically plays messages when the player has a Piece of Power power-up.
void PieceOfPowerMessage(int msg){
	if ( ! Z4_ItemsAndTimers[MSG_PIECE_POWER_PLAYED] && Z4_ItemsAndTimers[POWER_BOOSTED] ){
		Z4_ItemsAndTimers[MSG_PIECE_OF_POWER_PLAYED] = 1;
		Screen->Message(msg);
	}
}

//FFC Script for Secret Shell Mansion

ffc script SecretShellMansion{
	void run(int reg){
		if ( NumShells % 5 == 0 ) {
			int shellsST = Game->GetScreenD[dat];
			if ( NumShells() > shellsST ) {
				Game->SetScreenD[dat] = NumShells();
				Game->PlaySound(SFX_BONUS_SHELL);
				BonusShell();
			}
		}
		if ( NumShells() >= REQUIRED_SECRET_SHELLS ) {
			Game->PlaySound(SFX_SECRET_SHELL);
			Screen->TriggerSecrets();
		}
	}
}
			


	