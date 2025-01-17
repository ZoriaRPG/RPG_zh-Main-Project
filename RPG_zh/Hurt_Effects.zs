import "std.zh"

//Disable Engine Hurt Effects

/////////////////
/// VARIABLES ///
/////////////////

// Sound Effect Arrays: These store the value of SFX to play. 
//    You can expand this array by adding a comma, followed by a number, or reduce it by removing values.
//    You may adjust probabilities of specific sounds, by increasing the number of values here, and duplicating 
//    values to produce a custom bell curve.

float HurtSFX[]={61,62,63,68,70,71,72,73,74,76,75}; //Pupulate with sounds to play when hurt. 

float HurtSFX_Water[]={62,64,65,78,66,67,69,77}; //Special sounnds to play if Link is hurt while in water. 

// This is a game variables array. the first five values (index 0 to index 4) are used by the functions here.
//    You do not need to modify these first five indices--they should all be '0' when compiling--but you may 
//    expand it as desired, by adding values after the first four elements. 

float LinkStats[100]={0,0,0,0,0}; // An arbitrary size, so that we can expand it. 
				  // At present, we're using five indixes (indixes [0]. [1]. and [2], and [3]).


/////////////////
/// CONSTANTS ///
/////////////////

const int WATER_HURT_SOUNDS = 1; // If this value is '1' or above, the functions will draw from the  
				 // HurtSFX_Water[] array, when Link is swimming.


// LinkStats[] Array Indices
const int CURRENT_HP = 0;
const int LAST_HP = 1;
const int LINK_HURT = 2;
const int WATER_IS_DIFFERENT = 3; 
const int HURT_TIMER = 4;
// Expand here, if desired. 
// These constants may be used with the utility functions (see below) to allow a vast number of globak vars
// that you may call with simple functions and constants. 
// 					(See: 	Understanding_ZScript_Arrays_BASIC_INTERMEDIATE_ADVANCED.zs )


/////////////////
/// FUNCTIONS ///
//////////////////////////////////////////////////////////////////////////////


// Call in Global script init, and in global script OnContinue, global script active; before StoreLinkHP()
//         ! This is used to auto-enable separate water sound effects from the constant WATER_HURT_SOUNDS.
void SetHurtSFX(){ 
	if ( WATER_HURT_SOUNDS ) {
		LinkStats[WATER_IS_DIFFERENT] = 1;
	}
}

// Call in global script init, and global script OnContinue, global script active; after SetHurtSFX().
//                                          ! This ensures the correct values are stored at game init. 
void StoreLinkHP(){ 
      LinkStats[CURRENT_HP] = Link->HP;
      LinkStats[LAST_HP] = Link->HP;
}

// Call every frame *before* Waitdraw().
//           ! Keeps LinkStats[] sync'd. 
void UpdateLinkHP(){ 
     if ( Link->HP != LinkStats[CURRENT_HP] ){
           LinkStats[CURRENT_HP] = Link->HP;
     }
}

// Call every frame *after* Waitdraw(), before LinkHurtSound();
//   	            ! Determines if Link was damaged this frame. 
void LinkIsDamaged(){ 
     if ( LinkStats[CURRENT_HP] < LinkStats[LAST_HP] ){
          LinkStats[LINK_HURT] = 1;
          LinkStats[LAST_HP] = LinkStats[CURRENT_HP];
     }
}

// Call every frame, *after* Waitdraw(), after LinkIsDamaged();
//           ! Plays appropriate sound effects based on terrain.
void LinkHurtSound(){
	if ( LinkStats[WATER_IS_DIFFERENT] ) {
		
		if ( Link->Action == LA_GOTHURTLAND && LinkStats[LINK_HURT] ) {
			LinkStats[LINK_HURT] = 0;
			int HurtSound = HurtSFX[Rand(SizeOfArray(HurtSFX))];
			Game->PlaySound(HurtSound);
		}
		
		if ( Link->Action == LA_GOTHURTWATER && LinkStats[LINK_HURT] ) {
			LinkStats[LINK_HURT] = 0;
			int HurtSound = HurtSFX_Water[Rand(SizeOfArray(HurtSFX_Water))];
			Game->PlaySound(HurtSound);
		}
	}
	
		
	else if ( !LinkStats[WATER_IS_DIFFERENT] && ( Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER ) && LinkStats[LINK_HURT] != 0 ) {
		int HurtSound = HurtSFX[Rand(SizeOfArray(HurtSFX))];
		Game->PlaySound(HurtSound);
	}
}


// Call every frame *before* Waitdraw, after UpdateLinkHP(), and before NoLinkInvincibility().
//                            ! If this is enabled, Link will not be pushed backward when hit. 
void NoKnockBack(){
	if ( ( Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER ) && Link->HitDir != -1 ) {
		Link->HitDir = -1;
	}
}


// The following two functions prevent Link from taking damage EVERY FRAME, and move it to every X frames, 
// instead. 

// Call every frame, before Waitdraw(), before UpdateLinkHP().
// !           Sets the decrement for the invincibility timer. 
void Invincibility_Timer(int decrement){
	if ( LinkStats[HURT_TIMER] > 0 ) {
		LinkStats[HURT_TIMER] -= decrement;
	}
}



// Call every frame, *before* Waitdraw(), and after NoKnockback() to override engine invincibility.
//               ! Ghosted enemies (other than autoghost) will require additional work, to use this.
//                                 ! If this is enabled, Link's invincibility frames are *negated*!
void NoLinkInvincibility(int frames){
	for ( int q = 1; q <= Screen->NumEWeapons(); q++ ) {
		if ( Screen->NumEWeapons() <= 0 ) {
			break;
		}
		eweapon e = Screen->LoadEWeapon(q);
		if ( LinkCollision(e) ) {
			int dmg = e->Damage;
			if ( LinkStats[HURT_TIMER] <= 0 ) {
				Set_Invincibility_Timer(frames);
				Link->HP -= dmg;
			}
				
		}
	}
	for ( int w = 1; w <= Screen->NumNPCs(); w++ ) {
		if ( Screen->NumNPCs() <= 0 ) {
			break;
		}
		npc n = Screen->LoadNPC(w);
		if ( LinkCollision(n) ) {
			int dmg = n->Damage;
			if ( LinkStats[HURT_TIMER] <= 0 ) {
				Set_Invincibility_Timer(frames);
				Link->HP -= dmg;
			}
		}
	}
}

// DO NOT CALL in Global while(true) infinite loop. This is called from other routines. 
//                                ! Sets the starting value of the invincibility timer.
void Set_Invincibility_Timer(int setting){
	LinkStats[HURT_TIMER] = setting;
}


/////////////////////////
/// UTILITY FUNCTIONS ///
////////////////////////////////////////////////////////////////////////////////////
/// Some utility functions for optimising reading from, or writing to arrays. 


//Constants for Functions

const int BUMP = -32000; //Set a value to pass to allow ++ easily.
const int KICK = -32001; //Set a value to pass to allow -- easily.

//Simple functions for returning a value, or setting a value in LinkStats[]/
float Tis(int pos){
	return LinkStats[pos];
}

void Tis(int pos, float value){
	LinkStats[pos] = value;
}

// Sets a value in LinkStats[] and allows passing BUMP or KICK to do ++ or --, or a static value:
//	                                                   e.g. LStat(HURT_TIMER,KICK); would do:
//                                                                       LinkStats[HURT_TIMER]--; 
void LStat(int var, float value){
	if ( value == BUMP ) {
		LinkStats[var]++;
	}
	else if ( value == KICK ) {
		LinkStats[var]--;
	}
	else {
		LinkStats[var] = value;
	}
}

/////////////////////////////
/// SAMPLE GLOBAL SCRIPTS ///
/////////////////////////////

global script init{
	void run(){
		SetHurtSFX(); //Writes '1' to LinkStats[WATER_IS_DIFFERENT] if const WATER_HURT_SOUNDS is > 0.
		StoreLinkHP(); //Stores initial Link HP into array LinkStats[].
	}
}

global script active{
	void run(){
		SetHurtSFX(); //Writes '1' to LinkStats[WATER_IS_DIFFERENT] if const WATER_HURT_SOUNDS is > 0.
		StoreLinkHP(); //Stores initial Link HP into array LinkStats[] at the start of each game. 
		while(true){
			Invincibility_Timer(1); //This decrements LinkStats[HURT+TIMER} by the value of its arg every frame.
			UpdateLinkHP(); //Keeps LinkStats[] values in sync. 
			
			NoKnockBack(); //Prevents Link from being knocked back when hit. 
					//Disable this to use internal knockback.
			
			NoLinkInvincibility(34); //Disables (overrides) in-built invincibility frames. 
						//Its arg is the value of frames of invincibility to grant. 
						//Disable to use in-built invincibility frames. 
			Waitdraw();
			
			LinkIsDamaged(); //
			LinkHurtSound();
			
			Waitframe();
		}
	}
}

global script onContinue{
	void run(){
		SetHurtSFX(); //Writes '1' to LinkStats[WATER_IS_DIFFERENT] if const WATER_HURT_SOUNDS is > 0.
		StoreLinkHP(); //Stores initial Link HP into array LinkStats[].
	}
}


////////////
/// MISC ///
////////////

/// Alternate versions of LinkHurtSound() function:
//      This version relies directly on a constant that you may set. 
//      It does not allow you to change using water SFX at any arbitrary point in the game. 

void __LinkHurtSound(){
	if ( WATER_HURT_SOUNDS ) {
		
		if ( Link->Action == LA_GOTHURTLAND && LinkStats[LINK_HURT] ) {
			LinkStats[LINK_HURT] = 0;
			int HurtSound = HurtSFX[Rand(SizeOfArray(HurtSFX))];
			Game->PlaySound(HurtSound);
		}
		
		if ( Link->Action == LA_GOTHURTWATER && LinkStats[LINK_HURT] ) {
			LinkStats[LINK_HURT] = 0;
			int HurtSound = HurtSFX_Water[Rand(SizeOfArray(HurtSFX_Water))];
			Game->PlaySound(HurtSound);
		}
	}
	
		
	else if ( !WATER_HURT_SOUNDS && ( Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER ) && LinkStats[LINK_HURT] != 0 ) {
		int HurtSound = HurtSFX[Rand(SizeOfArray(HurtSFX))];
		Game->PlaySound(HurtSound);
	}
}

//       This version always uses the base HurtSFX[] array, and ignores terrain.
void _LinkHurtSound(){
     if ( ( Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER ) && LinkStats[LINK_HURT] != 0 ){
           LinkStats[LINK_HURT] = 0;
           int HurtSound = HurtSFX[Rand(SizeOfArray(HurtSFX))];
           Game->PlaySound(HurtSound);
     }
}
