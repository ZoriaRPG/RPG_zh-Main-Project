////////////////////////////
/// ZC Version Detecting ///
///        v0.6.5        ///
///  3rd December, 2015  ///
///     By: ZoriaRPG     ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Note: The ZC Dev Staff will *never* support this. Provided as-is, with limited supprort by author. ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Crediting:           /// Testing:             /// Discussion:          /// Misc. / Feedback        ///
/// Saffith, Information /// Epad                 /// Dimentio             /// Avataro                 ///
/// Saffith, Gen. Assist /// Moosh                /// Evan                 /// elektriktoad            ///
///                      ///                      /// Grayswandir          /// Tamamo                  ///
///                      ///                      /// Moosh                /// SUCCESSOR               ///
///                      ///                      /// TheBlueTophat        ///                         ///
///                      ///                      /// ywkls                ///                         ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////

//Prime Settings
const int VERSION_CHECK_CANNOT_USE_GLOBAL_VARIABLES = 0; 

//Version array, and constants for its indices.
float Version[20]={250,0,0,0,0,0,0}; //Assume 2.50.0 first.
const int ZC_VERSION 				= 0; //Index 0, to hold the version.
const int DETECT_250_1_PASS1 			= 1; //Holds 2.50.1 check passes. 
const int DETECT_250_1_PASS2 			= 2; //...
const int DETECT_250_2_JUMP 			= 3; //Detect 2.50.2 from Link->Jump values. 
const int VERSION_CLEANUP 			= 4; //Flag that we're done. 

//Constants for the temporary weapon used to detect 2,50.1. 
const int DETECT_250_1_WEAPON_INDEX = 15; //The Misc[] index to check for the 2.50.1 validation. 
const int DETECT_250_1_WEAPON_ARB_VAL = 1023.9187; //A sufficiently arbitrary value to store in the index. 

const int DEBUG_VERSION_FUNCTIONS = 1; //Set to '1' if you want to enable debugging. 
const int VERSION_ENABLE_RECHECK = 1; //Set to '1' to enable re-checking between saving. Set to '0' to disable.

const float CHECK_250_3_VAL = -93897.0134

const int DETECT_250_3_PASS = 5;

void Check250_3(){
	if ( !Version[DETECT_250_3_PASS]){
		int x = CHECK_250_3_VAL;
		if ( x < 21473.0001 ) Version[ZC_VERSION] = 250.3;
	}
}

//////////////////////
/// User Functions ///
//////////////////////


//Returns the verion of ZC that the player is using as ( 250.0, 250.1, or 250.2 ).
float Version(){
	return Version[ZC_VERSION];
}

//Boolean for checking the ZC Version.
bool Version(float vers){
	return Version[ZC_VERSION] == vers;
}
		//Call as :
		//if ( Version(250.2) ) 
		//or 
		//if ( Version(250.0) )

//Replacement for InvertedCircle() in stdExtra.zh, that is compliant with this header. 
//Draw an inverted circle (fill whole screen except circle)
void InvertedCircle(int bitmapID, int layer, int x, int y, int radius, int scale, int fillcolor){
	Screen->SetRenderTarget(bitmapID);     //Set the render target to the bitmap.
	Screen->Rectangle(layer, 0, 0, 256, 176, fillcolor, 1, 0, 0, 0, true, 128); //Cover the screen
	Screen->Circle(layer, x, y, radius, 0, scale, 0, 0, 0, true, 128); //Draw a transparent circle.
	Screen->SetRenderTarget(RT_SCREEN); //Set the render target back to the screen.
	if ( Version() < 250.2 ) Screen->DrawBitmap(layer, bitmapID, 0, 0, 256, 176, 0, 56, 256, 176, 0, true); //Draw the bitmap for 2.50.0/1
	else Screen->DrawBitmap(layer, bitmapID, 0, 0, 256, 176, 0, 0, 256, 176, 0, true); //Draw the bitmap for 2.50.2
}


///////////////////////
/// Forced Updating ///
///////////////////////

const int UPDATE_ZC = 0; //Set to ID of message reading 'Please update to Zelda Classic v2.50.2 before playing.'
const int UPDATE_ZC_DMAP_MUSIC_ID = 0; //Set to an music file to play for the loading screen error. 
const int UPDATE_ZC_SFX = 0; //Set to an error noise to play before displaying the UPDATE_ZC string, or changing the music. 
const int ZC_MIN_VERSION = 250.2; //Set to the minimum version of ZC that you wish to enforce, using the format '250', '250.1', and '250.2'

//Call after Waitdraw();
void ForceUpdate(){
	if ( Version() <= ZC_MIN_VERSION ) {
		if ( UPDATE_ZC_SFX ) Game->PlaySound(UPDATE_ZC_SFX);
		if ( UPDATE_ZC_DMAP_MUSIC_ID ) Game->PlayMIDI(UPDATE_ZC_DMAP_MUSIC_ID);
		Screen->Message(UPDATE_ZC);
		Game->End();
	}
}

//Call after Waitdraw();
void ForceUpdate(bool specific){
	if ( ( specific && Version() != ZC_MIN_VERSION ) || ( !specific && Version() <= ZC_MIN_VERSION ) ) {
		if ( UPDATE_ZC_SFX ) Game->PlaySound(UPDATE_ZC_SFX);
		if ( UPDATE_ZC_DMAP_MUSIC_ID ) Game->PlayMIDI(UPDATE_ZC_DMAP_MUSIC_ID);
		Screen->Message(UPDATE_ZC);
		Game->End();
	}
}


////////////////////////
/// Global Functions ///
////////////////////////

////////////////////////
/// Check for 2.50.1 ///
////////////////////////

//Run before Waitdraw();
void Detect250_1_Phase1(){
	if ( !Version[DETECT_250_1_PASS1] ) {
		eweapon e = Screen->CreateEWeapon(EW_SCRIPT1); //Make an eweapon offscreen...
		e->X = -32; //Set its position to be off-screen, so that 2.50.1 will remove it, and we can check against that.
		e->Y = -32;
		e->Misc[DETECT_250_1_WEAPON_INDEX] = DETECT_250_1_WEAPON_ARB_VAL; //Set an index so that we can look for it later.
		e->CollDetection = false; //Turn off its CollDetection.
		Version[DETECT_250_1_PASS1] = 1; //Mark that pass 1 is complete. 
		Waitframe(); //Wait one frame, to check if the pointer is removed. 
	}
}

//Run before Waitdraw(), before Detect250_2();
void Detect250_1_Phase2(){
	bool detected250;
	if ( Version[DETECT_250_1_PASS1] && !Version[DETECT_250_1_PASS2] ) { //Start pass 2.
		for ( int q = 1; q <= Screen->NumEWeapons(); q++ ) { //Look for that eweapon.
			eweapon e = Screen->LoadEWeapon(q);
			if ( e->Misc[DETECT_250_1_WEAPON_INDEX] == DETECT_250_1_WEAPON_ARB_VAL ) { //by finding its index with our arbitrary value...
				detected250 = true; //If it still exists after that one Waitframe, then it is 2.50.2, as it would have been removed. 
			}
		}
		Version[DETECT_250_1_PASS2] = 1; //Mark that we completed this pass, so that we never check again.
		if ( !detected250 ) Version[ZC_VERSION] = 250.1; //If the weapon was not there, we didn't detect 2.50, so we must be using 2.50.1, or 2.50.2 with thie rule to remove them enabled.
	}
}



/////////////////////////////
/// Then check for 2.50.2 ///
/////////////////////////////


//Detects if the return value for Link->Jump > 3.2 is correct (2.50.2).
void Detect250_2(){
	if ( !Version[DETECT_250_2_JUMP] ) {
		Version[DETECT_250_2_JUMP] = 1;
		if ( Detect_250_2_Jump() == 10 ) Version[ZC_VERSION] = 250.2;
	}
}

//Sets, and returns Link->Jump = 10;
float Detect_250_2_Jump(){
	Link->Jump = 10;
	return Link->Jump;
}

void Version_Check_Cleanup(){
	if ( !Version[VERSION_CLEANUP] ) {
		Version[VERSION_CLEANUP] = 1;
		Link->Jump = 0;
	}
}


//In the event that a user changes ZC versions between saves, we reset this, and re-check on continue.
void CheckVersionOnContinue(){
	for ( int q = 1; q < SizeOfArray(Version); q++ ) Version[q] = 0;
}

	
////////////////////////////////////
/// Example Global Active Script ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Set up the functions in this header in your global active script, in the same manner as you see below. ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

global script CheckVersion{
	void run(){
		while(true){
			Detect250_1_Phase1(); //Check to see if we are using 2.50.1...
			Detect250_1_Phase2(); //2.50.1 Checking confirmed to work at this point (v0.4.2)
			Detect250_2(); //Check for v2.50.2  ia Jumping mechanics. 
			Version_Check_Cleanup();
			Waitdraw();
			if ( DEBUG_VERSION_FUNCTIONS && Link->PressEx2 ) { //If debugging is on and Link presses Ex2
				TraceNL(); //Put some useful traces in allegro.log. 
				Trace(Version[ZC_VERSION]);
			}
			Waitframe();
		}
	}
}

//Sample global OnContinue script to reset parameters, and recheck version each time that a game is loaded.
global script OnContinue{
	void run(){
		if ( VERSION_ENABLE_RECHECK ) CheckVersionOnContinue();
	}
}

