/// Global Constants, Arrays, and Variables

//Common Constant, only need to define once per script file.
const int BIG_LINK                  = 0;   //Set this constant to 1 if using the Large Link Hit Box feature.
 
//Constants used by Bottomless Pits & Lava.
const int CT_HOLELAVA              = 128; //Combo type to use for pit holes and lava."No Ground Enemies by default"
const int CF_PIT                   = 101;  //The combo flag to register combos as pits.
const int CF_LAVA                  = 102;  //The combo flag to register combos as lava.
const int WPS_LINK_FALL            = 89;  //The weapon sprite to display when Link falls into a pit. "Sprite 88 by default"
const int WPS_LINK_LAVA            = 90;  //The weapon sprite to display when Link drowns in lava. "Sprite 89 by default"
const int SFX_LINK_FALL            = 38;  //The sound to play when Link falls into a pit. "SFX_FALL by default"
const int SFX_LINK_LAVA            = 55;  //The sound to play when Link drowns in Lava. "SFX_SPLASH by default.
const int CMB_AUTOWARP             = 48;  //The first of your four transparent autowarp combos.
const int HOLELAVA_DAMAGE          = 8;   //Damage in hit points to inflict on link. "One Heart Container is worth 16 hit points"

//Global variables used by Bottomless Pits & Lava.

float PitsLava[2];
const int HL_FALLING = 0;
const int HL_WARPING = 1;




/// FFC Scripts
 
ffc script Holelava
{
	void run(int warp, bool position, int damage)
	{
		while(true)
		{
			while(!PitsLava[HL_WARPING]) Waitframe();
			if(warp > 0)
			{
				this->Data = CMB_AUTOWARP+warp-1;
				this->Flags[FFCF_CARRYOVER] = true;
				Waitframe();
				this->Data = FFCS_INVISIBLE_COMBO;
				this->Flags[FFCF_CARRYOVER] = false;
				Link->Z = Link->Y;
				PitsLava[HL_WARPING] = 0;
				Link->DrawXOffset -= Cond(Link->DrawXOffset < 0, -1000, 1000);
				Link->HitXOffset -= Cond(Link->HitXOffset < 0, -1000, 1000);
				Quit();
			}
			if(position)
			{
				Link->X = this->X;
				Link->Y = this->Y;
			}
			else
			{
				Link->X = this->InitD[6];
				Link->Y = this->InitD[7];
			}
			if(damage)
			{
				Link->HP -= damage;
				Link->Action = LA_GOTHURTLAND;
				Link->HitDir = -1;
				Game->PlaySound(SFX_OUCH);
			}
			Link->DrawXOffset -= Cond(Link->DrawXOffset < 0, -1000, 1000);
			Link->HitXOffset -= Cond(Link->HitXOffset < 0, -1000, 1000);
			PitsLava[HL_WARPING] = 0;
			Waitframe();
		}
	}
}
 

/// Global Scripts

global script active{                           
	void run(){
		StartGhostZH();
		while(true){
			UpdateGhostZH1();
			InitHoleLava();
			Waitdraw();
			UpdateGhostZH2();
			LREx1Ex2ItemSwitch();
			RunHoleLava();
			Waitframe();
		}//end whileloop
	}//end run
}//end global slot2


/// Global Functions

//Used to determine if Link is on a Pit or Lava combo.
int OnPitCombo()
{
	int comboLoc = ComboAt(Link->X+8, Link->Y + Cond(BIG_LINK==0, 12, 8));
	if(Screen->ComboT[comboLoc] != CT_HOLELAVA)
		return 0;
	else if(Screen->ComboI[comboLoc] == CF_PIT || Screen->ComboI[comboLoc] == CF_LAVA)
		return Screen->ComboI[comboLoc];
	else if(Screen->ComboF[comboLoc] == CF_PIT || Screen->ComboF[comboLoc] == CF_LAVA)
		return Screen->ComboF[comboLoc];
	else
		return 0;
}
 
 
//Snaps Link to the combo so he appears completely over pit and lava combos.
void SnaptoGrid()
{
	int x = Link->X;
	int y = Link->Y + Cond(BIG_LINK==0, 8, 0);
	int comboLoc = ComboAt(x, y);
 
	//X Axis
	if(Screen->ComboT[comboLoc] == CT_HOLELAVA && Cond(x % 16 == 0, true, Screen->ComboT[comboLoc+1] != CT_HOLELAVA))
		Link->X = ComboX(comboLoc);
	else if(Screen->ComboT[comboLoc+1] == CT_HOLELAVA && Cond(x % 16 == 0, true, Screen->ComboT[comboLoc] != CT_HOLELAVA))
		Link->X = ComboX(comboLoc+1);
	if(Cond(y % 16 == 0, false, Screen->ComboT[comboLoc+16] == CT_HOLELAVA) && Cond(x % 16 == 0, true, Screen->ComboT[comboLoc+17] != CT_HOLELAVA))
		Link->X = ComboX(comboLoc+16);
	else if(Cond(y % 16 == 0, false, Screen->ComboT[comboLoc+17] == CT_HOLELAVA) && Cond(x % 16 == 0, true, Screen->ComboT[comboLoc+16] != CT_HOLELAVA))
		Link->X = ComboX(comboLoc+17);
 
	//Y Axis
	if(Screen->ComboT[comboLoc] == CT_HOLELAVA && Cond(y % 16 == 0, true, Screen->ComboT[comboLoc+16] != CT_HOLELAVA))
		Link->Y = ComboY(comboLoc);
	else if(Screen->ComboT[comboLoc+16] == CT_HOLELAVA && Cond(y % 16 == 0, true, Screen->ComboT[comboLoc] != CT_HOLELAVA))
		Link->Y = ComboY(comboLoc+16);
	if(Cond(x % 16 == 0, false, Screen->ComboT[comboLoc+1] == CT_HOLELAVA) && Cond(y % 16 == 0, true, Screen->ComboT[comboLoc+17] != CT_HOLELAVA))
		Link->Y = ComboY(comboLoc+1);
	else if(Cond(x % 16 == 0, false, Screen->ComboT[comboLoc+17] == CT_HOLELAVA) && Cond(y % 16 == 0, true, Screen->ComboT[comboLoc+1] != CT_HOLELAVA))
		Link->Y = ComboY(comboLoc+17);
}

void LREx1Ex2ItemSwitch()
{
	if (Link->PressL && Link->Action != LA_SCROLLING)
	{
		Link->SelectBWeapon(DIR_LEFT);
	}
	if (Link->PressR && Link->Action != LA_SCROLLING)
	{
		Link->SelectBWeapon(DIR_RIGHT);
	}
	if (Link->PressEx1 && Link->Action != LA_SCROLLING)
	{
		Link->SelectAWeapon(DIR_LEFT);
	}
	if (Link->PressEx2 && Link->Action != LA_SCROLLING)
	{
		Link->SelectAWeapon(DIR_RIGHT);
	}
}

//Hole_Lava Init. Call before Waitdraw().
void InitHoleLava(){
	//Initialize variables used to store Link's strating position on Screen Init.
			int olddmap = Game->GetCurDMap();
			int oldscreen = Game->GetCurDMapScreen();
			int startx = Link->X;
			int starty = Link->Y;
			int startdir = Link->Dir;
 
			//Clear global variables used by Bottomless pits.
			PitsLava[HL_FALLING] = 0;
			PitsLava[HL_WARPING] = 0;
}

//Main Hole_Lava Rountine. Call after Waitdraw().
void RunHoleLava(){
	if(Link->Action != LA_SCROLLING)
	{
		Update_HoleLava(startx, starty, olddmap, oldscreen, startdir);
		if(Link->Z==0 && !PitsLava[HL_FALLING] && (oldscreen != Game->GetCurDMapScreen() || olddmap != Game->GetCurDMap()))
		{
			olddmap = Game->GetCurDMap();
			oldscreen = Game->GetCurDMapScreen();
			startx = Link->X;
			starty = Link->Y;
			startdir = Link->Dir;
		}
	}
}

//Handles Pit Combo Functionality.
void Update_HoleLava(int x, int y, int dmap, int scr, int dir)
{
	lweapon hookshot = LoadLWeaponOf(LW_HOOKSHOT);
	if(hookshot->isValid()) return;
 
	if(PitsLava[HL_FALLING])
	{
		if(IsSideview()) Link->Jump=0;
		PitsLava[HL_FALLING]--;
		if(PitsLava[HL_FALLING] == 1)
		{
			int buffer[] = "Holelava";
			if(CountFFCsRunning(Game->GetFFCScript(buffer)))
			{
				ffc f = Screen->LoadFFC(FindFFCRunning(Game->GetFFCScript(buffer)));
				PitsLava[HL_WARPING] = 1;
				if(f->InitD[1]==0)
				{
					f->InitD[6] = x;
					f->InitD[7] = y;
				}
			}
			else
			{
				Link->X = x;
				Link->Y = y;
				Link->Dir = dir;
				Link->DrawXOffset -= Cond(Link->DrawXOffset < 0, -1000, 1000);
				Link->HitXOffset -= Cond(Link->HitXOffset < 0, -1000, 1000);
				Link->HP -= HOLELAVA_DAMAGE;
				Link->Action = LA_GOTHURTLAND;
				Link->HitDir = -1;
				Game->PlaySound(SFX_OUCH);
				if(Game->GetCurDMap()!=dmap || Game->GetCurDMapScreen()!=scr)
				Link->PitWarp(dmap, scr);
			}
			NoAction();
			Link->Action = LA_NONE;
		}
	}
	else if(Link->Z==0 && OnPitCombo() && !PitsLava[HL_WARPING])
	{
		Link->DrawXOffset += Cond(Link->DrawXOffset < 0, -1000, 1000);
		Link->HitXOffset += Cond(Link->HitXOffset < 0, -1000, 1000);
		int comboflag = OnPitCombo();
		SnaptoGrid();
		Game->PlaySound(Cond(comboflag == CF_PIT, SFX_LINK_FALL, SFX_LINK_LAVA));
		lweapon dummy = CreateLWeaponAt(LW_SCRIPT10, Link->X, Link->Y);
		dummy->UseSprite(Cond(comboflag == CF_PIT, WPS_LINK_FALL, WPS_LINK_LAVA));
		dummy->DeadState = dummy->NumFrames*dummy->ASpeed;
		dummy->DrawXOffset = 0;
		dummy->DrawYOffset = 0;
		PitsLava[HL_FALLING] = dummy->DeadState;
		NoAction();
		Link->Action = LA_NONE;
	}
}