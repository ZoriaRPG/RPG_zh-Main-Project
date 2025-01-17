//Lens of Truth only in Water

int OwnsItems[2048];
const int I_LENS_WATER = 100; //Set to ID of Dummy Lens Item to use only in water. Lens Class, Level 1
const int I_LENS1 = 101; //Set to Lens of Truth Class item Level 2

void WaterLens(){
	if ( OwnsItems(I_LENS_WATER) && !OwnsItems[I_LENS] && !Link->Item[I_LENS1] && (
		( Link->Action == LA_SWIMMING || Link->Action == LA_DIVING ) ){
		Link->Item[I_LENS1] = true;
	}
	if ( OwnsItems(I_LENS_WATER) && !OwnsItems[I_LENS] && Link->Item[I_LENS1] && (
		( Link->Action != LA_SWIMMING || Link->Action != LA_DIVING ) ){
		Link->Item[I_LENS1] = false;
	}
}

item script PickupWaterLens{
	void run(){
		OwnsItems[I_LENS_WATER] = 1;
	}
}


const int OWNS_ITEMS_INIT = 512;
const int OWNS_ITEMS_EQUIPPED = 1024;
const int OWNS_ITEMS_DISABLED = 1536;

//Automatically sets ownership of an item to OwnsItems when Link Picks It Up, so that Pick-Up scripts
//are NO LONGER MANDATORY for this. 
void ItemOwnershipManager(){
	for ( int q = 0; q < 255; q++ ) {
		if ( Link->Item[q] && !OwnsItems[q+OWNS_ITEMS_INIT] && !OwnsItems[q] ){
			OwnsItems[q+OWNS_ITEMS_INIT] = 1;
			OwnsItems[q] = 1;
		}
	}
}