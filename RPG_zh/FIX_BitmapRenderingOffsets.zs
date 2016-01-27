float Version = 250; //Assume 2.50.0 first. 
int Bitmap_Offset = 56;
int Detect250_1[2]={0,0};

const int DETECT_250_1_PASS1 = 0;
const int DETECT_250_1_PASS2 = 1;
const int DETECT_250_1_WEAPON_INDEX = 15;
const int DETECT_250_1_WEAPON_ARB_VAL = 1023.9187; //A sufficiently arbitrary value to check the index. 


//Check for 2.50.1

//Run before Waitdraw();
void Detect250_1_Phase1(){
	if ( !Detect250_1[0] ) {
		eweapon e; //Make an eweapon offscreen...
		e->X = -32;
		e->Y = -32;
		e->Misc[DETECT_250_1_WEAPON_INDEX] = DETECT_250_1_WEAPON_ARB_VAL; //Set an index so that we can look for it later.
		e->CollisionDetection = false; //Turn off its CollDetection.
		Detect250_1[DETECT_250_1_PASS1] = 1; //Mark that pass 1 is complete. 
		Waitframe(); //Wait one frame, to check if the pointer is removed. 
	}
}

//Run before Waitdraw(), before Detect250_2();
void Detect250_1_Phase2(){
	bool detected250;
	if ( Detect250_1[DETECT_250_1_PASS1] && !Detect250_1[DETECT_250_1_PASS2] ) { //Start pass 2.
		for ( int q = 1; q <= Screen->NumEWeapons(); q++ ) { //Look for that eweapon.
			eweapon e = Screen->LoadEWeapon(q);
			if ( e->Misc[DETECT_250_1_WEAPON_INDEX] == DETECT_250_1_WEAPON_ARB_VAL ) { //by finding its index with our arbitrary value...
				decected250 = true; //If it stille xists after that one Waitframe, then it is 2.50.2, as it would have been removed. 
			}
		}
		Detect250_1[DETECT_250_1_PASS2] = 1; //Mark that we completed this pass, so that we never check again.
		if ( !detected250 ) Version = 250.1; //If the weapon was not there, we didn't detect 2.50, so we must be using 2.50.1, or 2.50.2 with thie rule to remove them enabled.
	}
}

//Then check for 2.50.2

//Run ONE INSTRUCTION before Waitdraw();
void Detect250_2(){
	if ( Link->Action=LA_SCROLLING ) Version = 250.2;
}
	

//Run at any point before Waitdraw();
//Note that this will only work after the screen has scrolled, at least one time in a game.  
void FixBitmapOffsets(){
	if ( Version > 250.1 ) Bitmap_Offset = 0;
}


//Draw an inverted circle (fill whole screen except circle)
void InvertedCircle(int bitmapID, int layer, int x, int y, int radius, int scale, int fillcolor){
    Screen->SetRenderTarget(bitmapID);     //Set the render target to the bitmap.
    Screen->Rectangle(layer, 0, 0, 256, 176, fillcolor, 1, 0, 0, 0, true, 128); //Cover the screen
    Screen->Circle(layer, x, y, radius, 0, scale, 0, 0, 0, true, 128); //Draw a transparent circle.
    Screen->SetRenderTarget(RT_SCREEN); //Set the render target back to the screen.
    Screen->DrawBitmap(layer, bitmapID, 0, 0, 256, 176, 0, Bitmap_Offset, 256, 176, 0, true); //Draw the bitmap
}