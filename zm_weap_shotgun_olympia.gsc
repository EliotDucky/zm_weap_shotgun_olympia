#using scripts\shared\aat_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\spawner_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\aats\_zm_aat_blast_furnace;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\aat_shared.gsh;
#insert scripts\shared\aat_zm.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\zm\aats\_zm_aat_blast_furnace.gsh;

#insert scripts\zm\weapons\zm_weap_shotgun_olympia\zm_weap_shotgun_olympia.gsh;

REGISTER_SYSTEM("zm_weap_shotgun_olympia", &__init__, undefined)

function __init__(){
	callback::on_connect(&upgradeWatcher);
	registerClientfields();
}

function registerClientfields(){
	clientfield::register("actor", "hades_burn", VERSION_SHIP, 1, "counter" );
}

//Call On: Player
//Callback on connect
function upgradeWatcher(){
	while(true){
		self waittill("pap_taken"); //notify set when player picks gun out of pap
		wait(0.05);
		self waittill("weapon_change_complete", wpn);
		if(wpn.name == HADES){
			//Callback on damage if Hades received from PAP
			zm_spawner::register_zombie_damage_callback(&zombieDragonsBreath);
			break; //end the while
		}
	}
}

//Call On: damaged zombie
function zombieDragonsBreath(str_mod, str_hit_location, v_hit_origin, e_attacker, n_amount, w_weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel){
	self endon("death");
	// if we have instakill, apply that
	self thread zm_powerups::check_for_instakill( e_attacker, str_mod, str_hit_location );
	if(w_weapon.name == HADES && !IS_TRUE(self.dragons_breath)){
		//only run if not already on fire
		self.dragons_breath = true;

		//fire FX
		if(IsVehicle(self)){
			self thread clientfield::increment( ZM_AAT_BLAST_FURNACE_CF_NAME_BURN_VEH );
		}else{
			self thread clientfield::increment( ZM_AAT_BLAST_FURNACE_CF_NAME_BURN );
			self thread clientfield::increment("hades_burn");
		}

		for(i = 0; i<NUM_OF_TICKS; i++){
			wait(TICK_RATE);
			self DoDamage(DMG_PER_TICK, self.origin, e_attacker, undefined, "none", "MOD_BURNED", 0, w_weapon);
			
		}
		//reset once this burn is over
		self.dragons_breath = false;
	}
}