ffc script DiscoRobe{									//Enemy YO!
	void run(int enemyid){								//Run the Void
		
		int phase0[]="We're doing phase 0, phasing.";
		int phase1[]="We're doing phase 1, laser. ";
		int phase2[]="We're doing phase 2, cleanup post-firing.";
		int phase3[]="We're doing phase 3, diagonal phase.";
		int teleportout[]="Teleporting out, because TimeCount1 > 0";
		int timeExpired[]="Stuck in wall, TimeCOunt1 < 0, so time expired.";
		int teleportout2[]="Teleporting out, because TimeCount1 > 0";
		int timecount2GR3[]="TimeCount2 >= 3, so we do that phase here.";
		int timecount2NotGR3[]="TimeCOunt2 is more than 0, but less than three, so we do that phase.";
		int timecountsreset[]="We reached the else block, resetting values. Back to walking.";
		
		
		npc ghost = Ghost_InitAutoGhost(this, enemyid); //Initialization
		Ghost_SetFlag(GHF_SET_DIRECTION); 				//Flags
		Ghost_SetFlag(GHF_4WAY);						//More Flags
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);			//Even More Flags
		int misc = 0; 									//What sick moves is this enemy pulling off?
		int tics = 0; 									//Countdown to sick moves
		int Counter = -1; 								//Walking of the walker
		int Store[18]; 									//Store the defence
		int DISCO_COMBO = Ghost_Data; 					//Save the first combo
		int TimeCount1 = 300; 							//Countdown to unteleport wall
		int TimeCount2 = 0; 							//Countdown to force lock out of wall
		int Meh; //Thanks for the well-named vars. 
		int MehX;
		int MehY;
		int MehC;
		while(true){ 									//The while loop
			if (misc == 0)  							//If walking
			{
				TraceNL(); TraceS(phase0); TraceNL();
				int Rander = Rand(128);
				if (Screen->isSolid(Ghost_X, Ghost_Y) || Screen->isSolid(Ghost_X + 15, Ghost_Y + 15) || Screen->isSolid(Ghost_X + 15, Ghost_Y)
				|| Screen->isSolid(Ghost_X, Ghost_Y + 15) || Screen->isSolid(Ghost_X + 8, Ghost_Y + 15) || Screen->isSolid(Ghost_X + 15, Ghost_Y + 8)
				|| Screen->isSolid(Ghost_X + 8, Ghost_Y + 8) || Screen->isSolid(Ghost_X + 7, Ghost_Y + 15) || Screen->isSolid(Ghost_X + 15, Ghost_Y + 7)
				|| Screen->isSolid(Ghost_X, Ghost_Y + 8) || Screen->isSolid(Ghost_X + 8, Ghost_Y) || Screen->isSolid(Ghost_X + 7, Ghost_Y)
				|| Screen->isSolid(Ghost_X, Ghost_Y + 7) || Screen->isSolid(Ghost_X + 8, Ghost_Y + 7) || Screen->isSolid(Ghost_X + 7, Ghost_Y + 8))
				{										//Long if statement; Is the enemy in a wall?
					if (TimeCount1 > 0)					//Time until teleport out
					{
						TraceNL(); TraceS(teleportout); TraceNL();
						Counter = Ghost_ConstantWalk4(Counter, 100, 1, 0, 0);		//Phase around
						TimeCount1--;												//Countdown
						if (Ghost_Data == DISCO_COMBO + Ghost_Dir)					//Flicker 1
						{
							Ghost_Data += 4;
						}
						else														//Flicker 2
						{
							Ghost_Data = DISCO_COMBO + Ghost_Dir;
						}
					}
					else if (TimeCount1 <= 0)										//Time is up
						//! TimeCount1 should reset here; or do you do that after the other counts?
						//! No, I see what you're doing. I'd set it to = 0 anyhow.
						//! TimeCount should be an array though, to conserve regs.
					{
					
						TraceNL(); TraceS(timeExpired); TraceNL():
						TimeCount2++;												//Setup the chances counter
						if (TimeCount2 >= 3)										//Okay, time out from the wall, mr Wizzrobe.
						//! Conflicting statement: !! This will evaluate true, along with if ( TimeCount > 0 ) !! line 102
						{
							TraceNL(); TraceS(timecount2GR3); TraceNL();
							Ghost_Data = DISCO_COMBO + 4;							//Start Teleport Drawing
							ghost->CollDetection = false;
							
							for (int i = 10; i > 0; i--)
							{
								MehX = (i * 3) / 4;
								MehY = (i * 3) / 2;
								Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost);
							}
							for (int i = 0; i < 60; i++)
							{
								MehX = i * 4;
								MehY = i / 4;
								Screen->DrawCombo(3, Ghost_X - (MehX / 2), Ghost_Y + MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 + MehX, 16 - MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost); //We're doing drawing and movement set-up here; I believe this would work.
							}
							
							//! and what's happening here...
							MehC = FindSpawnPoint(true, false, true, true);
							Ghost_X = ComboX(MehC);
							Ghost_Y = ComboY(MehC);
							
							for (int i = 60; i > 0; i--)
							{
								MehX = i * 4;
								MehY = i / 4;
								Screen->DrawCombo(3, Ghost_X - (MehX / 2), Ghost_Y + MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 + MehX, 16 - MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost); //We're doing drawing and movement set-up here; I believe this would work.
							}
							for (int i = 0; i < 10; i++)
							{
								MehX = (i * 3) / 4;
								MehY = (i * 3) / 2;
								Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost); //We're doing drawing and movement set-up here; I believe this would work.
							}
							for (int i = 30; i > 0; i--)
							{
								MehX = i / 4;
								MehY = i / 2;
								Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost); //We're doing drawing and movement set-up here; I believe this would work.
							}
							ghost->CollDetection = true;
							Ghost_Data = DISCO_COMBO;
							Ghost_SetDefenses(ghost, Store);						//End Teleport Drawing
						}
						else if (TimeCount2 < 3 && TimeCount2 > 0)
							//! !!Conflicting statement: This will evaluate true, along with if ( TimeCount >= 3 ) !! line 44
							//! Changed to prevent conflict. 
									//Don't force it out of the wall.
						{
							TraceNL(); TraceS(timecount2NotGR3); TraceNL();
							TimeCount1 = 180;										//It does get a lower tolerance, though.
							Ghost_Data = DISCO_COMBO + 4;							//More teleport drawing
							ghost->CollDetection = false;
							for (int i = 0; i < 30; i++)
							{
								MehX = i / 4;
								MehY = i / 2;
								Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost);
							}
							for (int i = 10; i > 0; i--)
							{
								MehX = (i * 3) / 4;
								MehY = (i * 3) / 2;
								Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost);
							}
							for (int i = 0; i < 60; i++)
							{
								MehX = i * 4;
								MehY = i / 4;
								Screen->DrawCombo(3, Ghost_X - (MehX / 2), Ghost_Y + MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 + MehX, 16 - MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost);
							}
							MehC = FindSpawnPoint(true, true, true, true);
							Ghost_X = ComboX(MehC);
							Ghost_Y = ComboY(MehC);
							for (int i = 60; i > 0; i--)
							{
								MehX = i * 4;
								MehY = i / 4;
								Screen->DrawCombo(3, Ghost_X - (MehX / 2), Ghost_Y + MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 + MehX, 16 - MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost);
							}
							for (int i = 0; i < 10; i++)
							{
								MehX = (i * 3) / 4;
								MehY = (i * 3) / 2;
								Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost);
							}
							for (int i = 30; i > 0; i--)
							{
								MehX = i / 4;
								MehY = i / 2;
								Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
								Ghost_Waitframe(this, ghost);
							}
							ghost->CollDetection = true;
							Ghost_Data = DISCO_COMBO;
							Ghost_SetDefenses(ghost, Store);							//Less Teleport Drawing
						}
					}
				}
				else																	//Regular Walking
				{
					TraceNL(); TraceS(timecountsreset); TraceNL();
					Counter = Ghost_ConstantWalk4(Counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);			//Walking
					Ghost_Data = DISCO_COMBO;											//Make sure it has the right combo
					int TimeCount1 = 300;												//Reset wall tolerance
					int TimeCount2 = 0;
					if (Rander == 0)													//Phase Diagonally
					{
						misc = 3;
					}
					if (tics < 180)														//tic counter
					{
						tics++;
					}
					else																//Choose an attack
					{
						Meh = Rand(2);
						if (Meh == 0)
						{
							misc = 1;
						}
						else if (Meh == 1)
						{
							misc = 2;
						}
					}
				}
			}
			else if (misc == 1)															//Laser attack
			{
				TraceNL(); TraceS(phase1); TraceNL();
																	//Oh god this is going to be such a pain to comment.
				Ghost_StoreDefenses(ghost, Store);										//Make it invincible
				Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
				for (int i = 60; i > 0; i--)											//Shoot lasers all around.
				{
					int M1 = dirToDeg(Ghost_Dir);
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
					}
					M1 %= 360;
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M1, 230);					//Safety Warning
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M1, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M1, 232);
					Ghost_Waitframe(this, ghost);
				}
				Game->PlaySound(37);													//Play Sound
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);			//Shoot Lasers
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M2, 230);					//Safety Warning
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M2, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M2, 232);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M3, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M3, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M3, 232);
					Ghost_Waitframe(this, ghost);
				}																		//Okay, I think you can figure out the rest of this attack.
				Game->PlaySound(37);													
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M4, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M4, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M4, 232);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M5, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M5, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M5, 232);
					Ghost_Waitframe(this, ghost);
				}
				Game->PlaySound(37);
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M4, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M5, ghost->WeaponDamage, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M6, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M6, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M6, 232);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M7, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M7, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M7, 232);
					Ghost_Waitframe(this, ghost);
				}
				Game->PlaySound(37);
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					int M8 = dirToDeg(Ghost_Dir) - 180;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
						M8 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					M8 %= 360;
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M4, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M5, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M6, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M8, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M8, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M8, 232);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M7, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M7, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M7, 232);
					Ghost_Waitframe(this, ghost);
				}
				Game->PlaySound(37);
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					int M8 = dirToDeg(Ghost_Dir) - 180;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
						M8 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					M8 %= 360;
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M6, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M8, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M8, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M8, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M8, 232);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M7, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M7, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M7, 232);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 30; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					int M8 = dirToDeg(Ghost_Dir) - 180;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
						M8 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					M8 %= 360;
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M6, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M8, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M6, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M6, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M6, 232);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M7, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M7, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M7, 232);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					int M8 = dirToDeg(Ghost_Dir) - 180;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
						M8 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					M8 %= 360;
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M6, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M8, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M6, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M6, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M6, 232);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M7, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M7, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M7, 232);
					Ghost_Waitframe(this, ghost);
				}
				Game->PlaySound(37);
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					int M8 = dirToDeg(Ghost_Dir) - 180;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
						M8 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					M8 %= 360;
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M4, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M5, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M6, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M8, ghost->WeaponDamage, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M4, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M4, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M4, 232);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M5, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M5, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M5, 232);
					Ghost_Waitframe(this, ghost);
				}
				Game->PlaySound(37);
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					int M8 = dirToDeg(Ghost_Dir) - 180;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
						M8 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					M8 %= 360;
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M4, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M5, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M6, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M8, ghost->WeaponDamage, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M2, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M2, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M2, 232);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M3, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M3, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M3, 232);
					Ghost_Waitframe(this, ghost);
				}
				Game->PlaySound(37);
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					int M8 = dirToDeg(Ghost_Dir) - 180;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
						M8 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					M8 %= 360;
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M4, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M5, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M6, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M8, ghost->WeaponDamage, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M1, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M1, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M1, 232);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M3, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M3, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M3, 232);
					Ghost_Waitframe(this, ghost);
				}
				Game->PlaySound(37);
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					int M8 = dirToDeg(Ghost_Dir) - 180;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
						M8 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					M8 %= 360;
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M4, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M5, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M6, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M8, ghost->WeaponDamage, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M1, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M1, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M1, 232);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M3, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M3, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M3, 232);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 15; i > 0; i--)
				{
					int M1 = dirToDeg(Ghost_Dir);
					int M2 = dirToDeg(Ghost_Dir) + 45;
					int M3 = dirToDeg(Ghost_Dir) - 45;
					int M4 = dirToDeg(Ghost_Dir) + 90;
					int M5 = dirToDeg(Ghost_Dir) - 90;
					int M6 = dirToDeg(Ghost_Dir) - 135;
					int M7 = dirToDeg(Ghost_Dir) + 135;
					int M8 = dirToDeg(Ghost_Dir) - 180;
					if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_DOWN)
					{
						M1 += 180;
						M2 += 180;
						M3 += 180;
						M4 += 180;
						M5 += 180;
						M6 += 180;
						M7 += 180;
						M8 += 180;
					}
					M1 %= 360;
					M2 %= 360;
					M3 %= 360;
					M4 %= 360;
					M5 %= 360;
					M6 %= 360;
					M7 %= 360;
					M8 %= 360;
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M1, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M2, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M3, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M4, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M5, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M6, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M7, ghost->WeaponDamage, 230);
					//Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, M8, ghost->WeaponDamage, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M1, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M1, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M1, 232);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, M3, 230);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, M3, 231);
					//DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, M3, 232);
					Ghost_Waitframe(this, ghost);
				}
				Ghost_Data = DISCO_COMBO + 4;									//Finally, that attack is over.				
				ghost->CollDetection = false;									//Set up teleportation
				for (int i = 0; i < 30; i++)
				{
					MehX = i / 4;
					MehY = i / 2;
					Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 10; i > 0; i--)
				{
					MehX = (i * 3) / 4;
					MehY = (i * 3) / 2;
					Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 0; i < 60; i++)
				{
					MehX = i * 4;
					MehY = i / 4;
					Screen->DrawCombo(3, Ghost_X - (MehX / 2), Ghost_Y + MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 + MehX, 16 - MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				MehC = FindSpawnPoint(true, false, true, true);
				Ghost_X = ComboX(MehC);
				Ghost_Y = ComboY(MehC);
				for (int i = 60; i > 0; i--)
				{
					MehX = i * 4;
					MehY = i / 4;
					Screen->DrawCombo(3, Ghost_X - (MehX / 2), Ghost_Y + MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 + MehX, 16 - MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 0; i < 10; i++)
				{
					MehX = (i * 3) / 4;
					MehY = (i * 3) / 2;
					Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 30; i > 0; i--)
				{
					MehX = i / 4;
					MehY = i / 2;
					Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				ghost->CollDetection = true;
				Ghost_Data = DISCO_COMBO;
				Ghost_SetDefenses(ghost, Store);
				tics = 0;
				misc = 0;
			}																	//End Teleport, End Attack.
			else if (misc == 2)													//Attack 2
			{
				TraceNL(); TraceS(phase2); TraceNL();
				Ghost_StoreDefenses(ghost, Store);								//Invincible
				Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
				Ghost_UnsetFlag(GHF_4WAY);
				for (int i = 0; i < 30; i++)									//Attack Warning
				{
					Ghost_Data = DISCO_COMBO + (i % 4);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 0; i < 240; i++)									//Accelerate to player
				{
					Ghost_Data = DISCO_COMBO + (i % 4);
					if (Link->X > Ghost_X)
					{
						Ghost_Ax=0.020;
					}
					else if (Link->X < Ghost_X)
					{
						Ghost_Ax=-0.020;
					}
					if (Link->Y > Ghost_Y)
					{
						Ghost_Ay=0.020;
					}
					else if (Link->Y < Ghost_Y)
					{
						Ghost_Ay=-0.020;
					}
					Ghost_Waitframe(this, ghost);
				}
				Ghost_UnsetFlag(GHF_SET_DIRECTION);								//Okay, set up the regular combo now
				Ghost_SetFlag(GHF_4WAY);
				Ghost_Data = DISCO_COMBO;
				Ghost_Dir = AngleDir4(WrapDegrees(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)));			//Face Link
				int Mangle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);			//Set up angle for lasers
				Ghost_Ax = 0;													//Stop movement
				Ghost_Ay = 0;
				Ghost_Vx = 0;
				Ghost_Vy = 0;
				for (int i = 0; i < 45; i++)									//Wait for it...
				{
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 3, Mangle, 230);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 2, Mangle, 231);
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 8, 1, Mangle, 232);
					Ghost_Waitframe(this, ghost);
				}
				bool Increase = true;											//...
				int Adder = 0;
				for (int i = 0; i < 120; i++)									//DISCO LASER TIME!
				{
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, Mangle, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, (Mangle + Adder) % 360, ghost->WeaponDamage, 230);
					Laser3Color(3, Ghost_X + 8, Ghost_Y + 8, 8, (Mangle - Adder) % 360, ghost->WeaponDamage, 230);
					if (Increase)												//ROTATING LASERS
					{
						Adder++;
						if (Adder >= 45)
						{
							Increase = false;
						}
					}
					else														//HELL YES!
					{
						Adder--;
						if (Adder <= 0)
						{
							Increase = true;
						}
					}
					Ghost_Waitframe(this, ghost);
				}
				Ghost_SetFlag(GHF_SET_DIRECTION);								//... Let's just forget about that.
				Ghost_SetFlag(GHF_4WAY);
				Ghost_Data = DISCO_COMBO + 4;
				ghost->CollDetection = false;
				for (int i = 0; i < 30; i++)									//Teleporting away, see ya!
				{
					MehX = i / 4;
					MehY = i / 2;
					Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 10; i > 0; i--)
				{
					MehX = (i * 3) / 4;
					MehY = (i * 3) / 2;
					Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 0; i < 60; i++)
				{
					MehX = i * 4;
					MehY = i / 4;
					Screen->DrawCombo(3, Ghost_X - (MehX / 2), Ghost_Y + MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 + MehX, 16 - MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				MehC = FindSpawnPoint(true, false, true, true);
				Ghost_X = ComboX(MehC);
				Ghost_Y = ComboY(MehC);
				for (int i = 60; i > 0; i--)
				{
					MehX = i * 4;
					MehY = i / 4;
					Screen->DrawCombo(3, Ghost_X - (MehX / 2), Ghost_Y + MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 + MehX, 16 - MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 0; i < 10; i++)
				{
					MehX = (i * 3) / 4;
					MehY = (i * 3) / 2;
					Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				for (int i = 30; i > 0; i--)
				{
					MehX = i / 4;
					MehY = i / 2;
					Screen->DrawCombo(3, Ghost_X + (MehX / 2), Ghost_Y - MehY, DISCO_COMBO + Ghost_Dir, 1, 1, Ghost_CSet, 16 - MehX, 16 + MehY, 0, 0, 0, -1, 0, true, OP_TRANS);
					Ghost_Waitframe(this, ghost);
				}
				ghost->CollDetection = true;
				Ghost_Data = DISCO_COMBO;
				misc = 0;
				tics = 0;
				Ghost_SetDefenses(ghost, Store);								//...Oh crap, I'm still on the same screen aren't I.
			}
			else if (misc == 3)													//Phase diagonally
			{
				TraceNL(); TraceS(phase3); TraceNL();
				Meh = Rand(7);												//Copied from the source
				int JX = Ghost_X;
				int JY = Ghost_Y;
				if (Meh == 0)
				{
					JX -= 32;
					JY -= 32;
				}
				else if (Meh == 1)
				{
					JX += 32;
					JY -= 32;
				}
				else if (Meh == 2)
				{
					JX -= 32;
					JY += 32;
				}
				else if (Meh == 3)
				{
					JX += 32;
					JY += 32;
				}
				else															//Wait anyways
				{
					for (int i = 0; i < 15; i++) Ghost_Waitframe(this, ghost);
				}
				
				if(JX>=32 && JX<=208 && JY>=32 && JY<=128)						//Okay, is it valid?
					//This checks if it is on the edges of the screen.
				{
					Ghost_UnsetFlag(GHF_4WAY);
					while (Ghost_X != JX && Ghost_Y != JY)
					{
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, JX, JY), 1, 0);		//Phasing time!
						if (Ghost_Data == DISCO_COMBO + Ghost_Dir)
						{
							Ghost_Data += 4;
						}
						else
						{
							Ghost_Data = DISCO_COMBO + Ghost_Dir;
						}
						Ghost_Waitframe(this, ghost);
					}
					Ghost_SetFlag(GHF_4WAY);
					Ghost_Data = DISCO_COMBO;
					misc = 0;													//End of attack.
				}
			}
			Ghost_Waitframe(this, ghost);										//Waitframe is here.
		}
	}
}