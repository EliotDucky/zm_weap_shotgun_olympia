#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#using scripts\zm\aats\_zm_aat_blast_furnace;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

REGISTER_SYSTEM("zm_weap_shotgun_olympia", &__init__, undefined)

function __init__(){
	registerClientfields();
}

function registerClientfields(){
	clientfield::register( "actor", "hades_burn", VERSION_SHIP, 1, "counter", &hadesBurn, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function hadesBurn( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump ){
	tag = "j_spine4";
	
	// Checks if tag exists
	v_tag = self gettagorigin( tag );
	if ( !isdefined( v_tag ) )
	{
		tag = "tag_origin";
	}
	zm_aat_blast_furnace::zm_aat_blast_furnace_burn_think(localClientNum, self, tag);
}
