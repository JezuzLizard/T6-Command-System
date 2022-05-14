#include common_scripts\utility;
#include maps\mp\_utility;
#include scripts\cmd_system_modules\_com;
#include scripts\cmd_system_modules\_persistence;

array_validate( array )
{
	return isDefined( array ) && isArray( array ) && array.size > 0;
}

find_map_data_from_alias( alias )
{
	result = [];
	if ( sessionModeIsZombiesGame() )
	{
		switch ( alias )
		{
			case "p":
			case "prison":
			case "mob":
			case "alcatraz":
				result[ "gamemode" ] = "classic";
				result[ "location" ] = "prison";
				result[ "mapname" ] = "zm_prison";
				break;
			case "dr":
			case "dierise":
			case "rooftop":
				result[ "gamemode" ] = "classic";
				result[ "location" ] = "rooftop";
				result[ "mapname" ] = "zm_highrise";
				break;
			case "or":
			case "origins":
			case "tomb":
				result[ "gamemode" ] = "classic";
				result[ "location" ] = "tomb";
				result[ "mapname" ] = "zm_tomb";
				break;
			case "buried":
			case "processing":
				result[ "gamemode" ] = "classic";
				result[ "location" ] = "processing";
				result[ "mapname" ] = "zm_buried";
				break;
			case "nuke":
			case "nuked":
			case "nuketown":
				result[ "gamemode" ] = "standard";
				result[ "location" ] = "nuked";
				result[ "mapname" ] = "zm_nuked";
				break;
			case "gc":
			case "gcell":
			case "gblock":
			case "gcellblock":
				result[ "gamemode" ] = "grief";
				result[ "location" ] = "cellblock";
				result[ "mapname" ] = "zm_prison";
				break;
			case "gs":
			case "gstreet":
			case "gborough":
				result[ "gamemode" ] = "grief";
				result[ "location" ] = "street";
				result[ "mapname" ] = "zm_buried";
				break;
			case "gf":
			case "gfarm":
				result[ "gamemode" ] = "grief";
				result[ "location" ] = "farm";
				result[ "mapname" ] = "zm_transit";
				break;
			case "gt":
			case "gtown":
				result[ "gamemode" ] = "grief";
				result[ "location" ] = "town";
				result[ "mapname" ] = "zm_transit";
				break;
			case "gb":
			case "gbus":
			case "gdepot":
				result[ "gamemode" ] = "grief";
				result[ "location" ] = "transit";
				result[ "mapname" ] = "zm_transit";
				break;
			case "sf":
			case "sfarm":
				result[ "gamemode" ] = "standard";
				result[ "location" ] = "farm";
				result[ "mapname" ] = "zm_transit";
				break;
			case "st":
			case "stown":
				result[ "gamemode" ] = "standard";
				result[ "location" ] = "town";
				result[ "mapname" ] = "zm_transit";
				break;
			case "sb":
			case "sbus":
			case "sdepot":
				result[ "gamemode" ] = "standard";
				result[ "location" ] = "transit";
				result[ "mapname" ] = "zm_transit";
				break;
			default:
				result[ "gamemode" ] = "";
				result[ "location" ] = "";
				result[ "mapname" ] = "";
				break;

		}
		if ( result[ "mapname" ] == "" && level.mod_integrations[ "cut_tranzit_locations" ] )
		{
			switch ( alias )
			{
				case "gd":
				case "gdin":
				case "gdiner":
					result[ "gamemode" ] = "grief";
					result[ "location" ] = "diner";
					result[ "mapname" ] = "zm_transit";
					break;
				case "gtu":
				case "gtunnel":
					result[ "gamemode" ] = "grief";
					result[ "location" ] = "tunnel";
					result[ "mapname" ] = "zm_transit";
					break;
				case "gp":
				case "gpow":
				case "gpower":
					result[ "gamemode" ] = "grief";
					result[ "location" ] = "power";
					result[ "mapname" ] = "zm_transit";
					break;
				case "gcorn":
				case "gcornfield":
					result[ "gamemode" ] = "grief";
					result[ "location" ] = "cornfield";
					result[ "mapname" ] = "zm_transit";
					break;
				case "sd":
				case "sdin":
				case "sdiner":
					result[ "gamemode" ] = "standard";
					result[ "location" ] = "diner";
					result[ "mapname" ] = "zm_transit";
					break;
				case "stu":
				case "stunnel":
					result[ "gamemode" ] = "standard";
					result[ "location" ] = "tunnel";
					result[ "mapname" ] = "zm_transit";
					break;
				case "sp":
				case "spow":
				case "spower":
					result[ "gamemode" ] = "standard";
					result[ "location" ] = "power";
					result[ "mapname" ] = "zm_transit";
					break;
				case "scorn":
				case "scornfield":
					result[ "gamemode" ] = "standard";
					result[ "location" ] = "cornfield";
					result[ "mapname" ] = "zm_transit";
					break;
				default:
					result[ "gamemode" ] = "";
					result[ "location" ] = "";
					result[ "mapname" ] = "";
					break;
			}
		}
	}
	else 
	{
		switch ( alias )
		{
			case "aftermath":
				result[ "mapname" ] = "mp_la";
				break;
			case "cargo":
			case "dockside":
				result[ "mapname" ] = "mp_dockside";
				break;
			case "carrier":
				result[ "mapname" ] = "mp_carrier";
				break;
			case "drone":
				result[ "mapname" ] = "mp_drone";
				break;
			case "express":
				result[ "mapname" ] = "mp_express";
				break;
			case "hijacked":
				result[ "mapname" ] = "mp_hijacked";
				break;
			case "meltdown":
				result[ "mapname" ] = "mp_meltdown";
				break;
			case "overflow":
				result[ "mapname" ] = "mp_overflow";
				break;
			case "plaza":
			case "nightclub":
				result[ "mapname" ] = "mp_nightclub";
				break;
			case "raid":
				result[ "mapname" ] = "mp_raid";
				break;
			case "slums":
				result[ "mapname" ] = "mp_slums";
				break;
			case "village":
			case "standoff":
				result[ "mapname" ] = "mp_village";
				break;
			case "turbine":
				result[ "mapname" ] = "mp_turbine";
				break;
			case "yemen":
			case "socotra":
				result[ "mapname" ] = "mp_socotra";
				break;
			case "nuketown":
				result[ "mapname" ] = "mp_nuketown_2020";
				break;
			case "downhill":
				result[ "mapname" ] = "downhill";
				break;
			case "mirage":
				result[ "mapname" ] = "mp_mirage";
				break;
			case "hydro":
				result[ "mapname" ] = "mp_hydro";
				break;
			case "grind":
			case "skate":
				result[ "mapname" ] = "mp_skate";
				break;
			case "encore":
			case "concert":
				result[ "mapname" ] = "mp_concert";
				break;
			case "magma":
				result[ "mapname" ] = "mp_magma";
				break;
			case "vertigo":
				result[ "mapname" ] = "mp_vertigo";
				break;
			case "studio":
				result[ "mapname" ] = "mp_studio";
				break;
			case "uplink":
				result[ "mapname" ] = "mp_uplink";
				break;
			case "detour":
			case "bridge":
				result[ "mapname" ] = "mp_bridge";
				break;
			case "cove":
			case "castaway":
				result[ "mapname" ] = "mp_castaway";
				break;
			case "rush":
			case "paintball":
				result[ "mapname" ] = "mp_paintball";
				break;
			case "dig":
				result[ "mapname" ] = "mp_dig";
				break;
			case "frost":
			case "frostbite":
				result[ "mapname" ] = "mp_frostbite";
				break;
			case "pod":
				result[ "mapname" ] = "mp_pod";
				break;
			case "takeoff":
				result[ "mapname" ] = "mp_takeoff";
				break;
			default:
				result[ "mapname" ] = "";
				break;
		}
	}
	return result;
}

get_ZM_map_display_name_from_location_gametype( location, gametype )
{
	switch ( location )
	{
		case "town":
			location_str = "Town";
			break;
		case "farm":
			location_str = "Farm";
			break;
		case "diner":
			location_str = "Diner";
			break;
		case "power":
			location_str = "Power";
			break;
		case "cornfield":
			location_str = "Cornfield";
			break;
		case "tunnel":
			location_str = "Tunnel";
			break;
		case "cellblock":
			location_str = "Cellblock";
			break;
		case "street":
			location_str = "Borough";
			break;
		case "processing":
			location_str = "Buried";
			break;
		case "prison":
			location_str = "Alcatraz";
			break;
		case "rooftop":
			location_str = "Die Rise";
			break;
		case "tomb":
			location_str = "Origins";
			break;
		default:
			break;
	}
	switch ( gametype )
	{
		case "classic":
			gametype_str = "Classic";
			break;
		case "standard":
			gametype_str = "Survival";
			break;
		case "grief":
			gametype_str = "Grief";
			break;
		case "cleansed":
			gametype_str = "Turned";
			break;
		default:
			break;
	}
	if ( location_str == "" )
	{
		if ( location == "transit" )
		{
			if ( gametype == "classic" )
			{
				location_str = "Tranzit";
			}
			else 
			{
				location_str = "Bus Depot";
			}
		}
	}
	return va( "%s %s", gametype_str, location_str );
}

get_MP_map_name( mapname )
{
	switch ( mapname )
	{
		case "mp_la":
			return "Aftermath";
		case "mp_dockside":
			return "Cargo";
		case "mp_carrier":
			return "Carrier";
		case "mp_drone":
			return "Drone";
		case "mp_express":
			return "Express";
		case "mp_hijacked":
			return "Hijacked";
		case "mp_meltdown":
			return "Meltdown";
		case "mp_overflow":
			return "Overflow";
		case "mp_nightclub":
			return "Plaza";
		case "mp_raid":
			return "Raid";
		case "mp_slums":
			return "Slums";
		case "mp_village":
			return "Standoff";
		case "mp_turbine":
			return "Turbine";
		case "mp_socotra":
			return "Yemen";
		case "mp_nuketown_2020":
			return "Nuketown 2025";
		case "mp_downhill":
			return "Downhill";
		case "mp_mirage":
			return "Mirage";
		case "mp_hydro":
			return "Hydro";
		case "mp_skate":
			return "Grind";
		case "mp_concert":
			return "Encore";
		case "mp_magma":
			return "Magma";
		case "mp_vertigo":
			return "Vertigo";
		case "mp_studio":
			return "Studio";
		case "mp_uplink":
			return "Uplink";
		case "mp_bridge":
			return "Detour";
		case "mp_castaway":
			return "Cove";
		case "mp_paintball":
			return "Rush";
		case "mp_dig":
			return "Dig";
		case "mp_frostbite":
			return "Frost";
		case "mp_pod":
			return "Pod";
		case "mp_takeoff":
			return "Takeoff";
		default:
			return mapname;
	}
}

get_perk_from_alias_zm( alias )
{
	switch ( alias )
	{
		case "ju":
		case "jug":
		case "jugg":
		case "juggernog":
			return "specialty_armorvest";
		case "ro":
		case "rof":
		case "double":
		case "doubletap":
			return "specialty_rof";
		case "qq":
		case "quick":
		case "revive":
		case "quickrevive":
			return "specialty_quickrevive";
		case "sp":
		case "speed":
		case "fastreload":
		case "speedcola":
			return "specialty_fastreload";
		case "st":
		case "staminup":
		case "longersprint":
			return "specialty_longersprint";
		case "fl":
		case "flakjacket":
		case "flopper":
			return "specialty_flakjacket";
		case "ds":
		case "deadshot":
			return "specialty_deadshot";
		case "mk":
		case "mulekick":
			return "specialty_additionalprimaryweapon";
		case "tm":
		case "tombstone":
			return "specialty_scavenger";
		case "ww":
		case "whoswho":
			return "specialty_finalstand";
		case "ec":
		case "electriccherry":
			return "specialty_grenadepulldeath";
		case "va":
		case "vultureaid":
			return "specialty_nomotionsensor";
		case "all":
			return "all";
		default:
			return alias;
	}
}

perk_list_zm()
{
	gametype = getDvar( "ui_zm_mapstartlocation" );
	switch ( level.script )
	{
		case "zm_transit":
			return array( "specialty_armorvest", "specialty_rof", "specialty_quickrevive", "specialty_fastreload", "specialty_longersprint", "specialty_scavenger" );
		case "zm_nuked":
			return array( "specialty_armorvest", "specialty_rof", "specialty_quickrevive", "specialty_fastreload" );
		case "zm_highrise":
			return array( "specialty_armorvest", "specialty_rof", "specialty_quickrevive", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_finalstand" );
		case "zm_prison":
			if ( gametype == "zgrief" )
			{
				return array( "specialty_armorvest", "specialty_rof", "specialty_fastreload", "specialty_deadshot", "specialty_grenadepulldeath" );
			}
			else 
			{
				return array( "specialty_armorvest", "specialty_rof", "specialty_fastreload", "specialty_deadshot", "specialty_additionalprimaryweapon", "specialty_flakjacket" );
			}
		case "zm_buried":
			if ( gametype == "zgrief" )
			{
				return array( "specialty_armorvest", "specialty_rof", "specialty_quickrevive", "specialty_fastreload", "specialty_longersprint", "specialty_additionalprimaryweapon" );
			}
			else 
			{
				return array( "specialty_armorvest", "specialty_rof", "specialty_quickrevive", "specialty_fastreload", "specialty_longersprint", "specialty_additionalprimaryweapon", "specialty_nomotionsensor" );
			}
		case "zm_tomb":
			return level._random_perk_machine_perk_list;
	}
}

get_powerup_from_alias_zm( alias )
{
	switch ( alias )
	{
		case "nuke":
			return "nuke";
		case "insta":
		case "instakill":
			return "insta_kill";
		case "double":
		case "doublepoints":
			return "double_points";
		case "max":
		case "ammo":
		case "maxammo":
			return "full_ammo";
		case "carp":
		case "carpenter":
			return "carpenter";
		case "sale":
		case "firesale":
			return "fire_sale";
		case "perk":
		case "freeperk":
			return "free_perk";
		case "blood":
		case "zombieblood":
			return "zombie_blood";
		case "points":
			return "bonus_points";
		case "teampoints":
			return "bonus_points_team";
		default:
			return alias;
	}
}

powerup_list_zm()
{
	gametype = getDvar( "g_gametype" );
	switch ( level.script )
	{
		case "zm_transit":
			if ( gametype == "zgrief" )
			{
				return array( "nuke", "insta_kill", "double_points", "full_ammo", "meat_stink", "teller_withdrawl" );
			}
			else 
			{
				return array( "nuke", "insta_kill", "double_points", "full_ammo", "carpenter", "teller_withdrawl" );
			}
		case "zm_nuked":
			return array( "nuke", "insta_kill", "double_points", "full_ammo", "fire_sale" );
		case "zm_highrise":
			return array( "nuke", "insta_kill", "double_points", "full_ammo", "carpenter", "free_perk" );
		case "zm_prison":
			if ( gametype == "zgrief" )
			{
				return array( "nuke", "insta_kill", "double_points", "full_ammo", "fire_sale", "meat_stink" );
			}
			else 
			{
				return array( "nuke", "insta_kill", "double_points", "full_ammo", "fire_sale" );
			}
		case "zm_buried":
			if ( gametype == "zgrief" )
			{
				return array( "nuke", "insta_kill", "double_points", "full_ammo", "carpenter", "free_perk", "fire_sale", "teller_withdrawl", "random_weapon", "meat_stink" );
			}
			else 
			{
				return array( "nuke", "insta_kill", "double_points", "full_ammo", "carpenter", "free_perk", "fire_sale", "teller_withdrawl", "random_weapon" );
			}
		case "zm_tomb":
			return array( "nuke", "insta_kill", "double_points", "full_ammo", "free_perk", "fire_sale", "zombie_blood", "bonus_points", "bonus_points_team" );
	}
}

get_perma_perk_from_alias( alias )
{
	switch ( alias )
	{
		case "bo":
		case "boards":
			return "pers_boarding";
		case "re":
		case "revive":
			return "pers_reviveonperk";
		case "he":
		case "headshots":
			return "pers_multikill_headshots";
		case "ca":
		case "cashback":
			return "pers_cash_back_prone";
		case "in":
		case "instakill":
			return "pers_insta_kill";
		case "ju":
		case "jugg":
			return "pers_jugg";
		case "cr":
		case "carpenter":
			return "pers_carpenter";
		case "fl":
		case "flopper":
			return "pers_flopper_counter";
		case "pe":
		case "perklose":
			return "pers_perk_lose_counter";
		case "pp":
		case "pistolpoints":
			return "pers_double_points_counter";
		case "sn":
		case "sniperpoints":
			return "pers_sniper_counter";
		case "bx":
		case "boxweapon":
			return "pers_box_weapon_counter";
		case "nu":
		case "nube":
			return "pers_nube_counter";
		case "all":
			return "all";
		default: 
			return alias;
	}
}

weapon_is_available( weapon )
{
	possible_weapons = getArrayKeys( level.zombie_include_weapons );
	weapon_is_available = false;
	for ( i = 0; i < possible_weapons.size; i++ )
	{
		if ( weapon == possible_weapons[ i ] )
		{
			weapon_is_available = true;
			break;
		}
	}
	return weapon_is_available;
}

get_all_weapons()
{
	return getArrayKeys( level.zombie_include_weapons );
}

weapon_is_upgrade( weapon )
{
	return isSubStr( weapon, "upgraded" );
}

cast_to_vector( vector_string )
{
	keys = strTok( vector_string, "," );
	vector_array = [];
	for ( i = 0; i < keys.size; i++ )
	{
		vector_array[ i ] = float( keys[ i ] ); 
	}
	vector = ( vector_array[ 0 ], vector_array[ 1 ], vector_array[ 2 ] );
	return vector;
}

server_safe_notify_thread( notify_name, index )
{
	wait( ( 0.05 * index ) + 0.05 );
	level notify( notify_name );
}

find_player_in_server( clientnum_guid_or_name )
{
	if ( !isDefined( clientnum_guid_or_name ) )
	{
		return undefined;
	}
	if ( clientnum_guid_or_name == "self" )
	{
		return self;
	}
	is_int = is_str_int( clientnum_guid_or_name );
	if ( is_int && ( int( clientnum_guid_or_name ) < getDvarInt( "sv_maxclients" ) ) )
	{
		client_num = int( clientnum_guid_or_name );
		enum = 0;
	}
	else if ( is_int )
	{
		GUID = int( clientnum_guid_or_name );
		enum = 1;
	}
	else 
	{
		name = simplify_player_name_for_code( clientnum_guid_or_name );
		enum = 2;
	}
	player_data = [];
	switch ( enum )
	{
		case 0:
			foreach ( player in level.players )
			{
				if ( player getEntityNumber() == client_num )
				{
					return player;
				}
			}
			break;
		case 1:
			foreach ( player in level.players )
			{
				if ( player getGUID() == GUID )
				{
					return player;
				}
			}
			break;
		case 2:
			foreach ( player in level.players )
			{
				if ( simplify_player_name_for_code( player.name ) == name || isSubStr( simplify_player_name_for_code( player.name ), name ) )
				{
					return player;
				}
			}
			break;
	}
	return undefined;
}

simplify_player_name_for_code( name )
{
	return clean_player_name_of_clantag( toLower( name ) );
}

getDvarStringDefault( dvarname, default_value )
{
	cur_dvar_value = getDvar( dvarname );
	if ( cur_dvar_value != "" )
	{
		return cur_dvar_value;
	}
	else 
	{
		return default_value;
	}
}

is_command_token( char )
{
	if ( isDefined( level.custom_commands_tokens ) )
	{
		foreach ( token in level.custom_commands_tokens )
		{
			if ( char == token )
			{
				return true;
			}
		}
	}
	return false;
}

remove_tokens_from_array( array, token )
{
	new_tokens = [];
	foreach ( string in array )
	{
		if ( isSubStr( string, token ) )
		{
		}
		else 
		{
			new_tokens[ new_tokens.size ] = string;
		}
	}
	return new_tokens;
}

is_str_int( str )
{
	val = 0;
	list_num = [];
	list_num[ "0" ] = val;
	val++;
	list_num[ "1" ] = val;
	val++;
	list_num[ "2" ] = val;
	val++;
	list_num[ "3" ] = val;
	val++;
	list_num[ "4" ] = val;
	val++;
	list_num[ "5" ] = val;
	val++;
	list_num[ "6" ] = val;
	val++;
	list_num[ "7" ] = val;
	val++;
	list_num[ "8" ] = val;
	val++;
	list_num[ "9" ] = val;
	for ( i = 0; i < str.size; i++ )
	{
		if ( !isDefined( list_num[ str[ i ] ] ) )
		{
			return false;
		}
	}
	return true;
}

is_str_bool( str )
{
	if ( str == "false" || str == "true" || str == "0" || str == "1" )
	{
		return true;
	}
	return false;
}

is_str_float( str )
{
	val = 0;
	list_num = [];
	list_num[ "0" ] = val;
	val++;
	list_num[ "1" ] = val;
	val++;
	list_num[ "2" ] = val;
	val++;
	list_num[ "3" ] = val;
	val++;
	list_num[ "4" ] = val;
	val++;
	list_num[ "5" ] = val;
	val++;
	list_num[ "6" ] = val;
	val++;
	list_num[ "7" ] = val;
	val++;
	list_num[ "8" ] = val;
	val++;
	list_num[ "9" ] = val;
	val++;
	list_period = [];
	list_period[ "." ] = val;
	decimals_found = 0;
	for ( i = 0; i < str.size; i++ )
	{
		if ( isDefined( list_period[ str[ i ] ] ) )
		{
			decimals_found++;
		}
		else if ( !isDefined( list_num[ str[ i ] ] ) )
		{
			return false;
		}
	}
	if ( str.size <= 10 && decimals_found == 0 )
	{
		return false;
	}
	else if ( decimals_found > 1 )
	{
		return false;
	}
	return true;
}

is_str_vec( str )
{
	if ( !isSubStr( str, "," ) )
	{
		return false;
	}
	if ( str[ 0 ] != "(" && str[ str.size - 1 ] != ")" )
	{
		return false;
	}
	keys = strTok( str, "," );
	if ( keys.size != 3 )
	{
		return false;
	}
	keys[ 2 ][ str.size - 1 ] = "";
	keys[ 0 ][ 0 ] = "";
	vec_checks_passed = 0;
	for ( i = 0; i < keys.size; i++ )
	{
		if ( is_str_float( keys[ i ] ) || is_str_int( keys[ i ] ) )
		{
			vec_checks_passed++;
		}
	}
	return vec_checks_passed == keys.size;
}

cast_str_to_vec( str )
{
	str[ str.size - 1 ] = "";
	str[ 0 ] = "";
	keys = strTok( str, "," );
	return ( float( keys[ 0 ] ), float( keys[ 1 ] ), float( keys[ 2 ] ) );
}

cast_str_to_bool( str )
{
	return str == "true";
}

get_type( var )
{
	is_int = is_str_int( var );
	is_float = is_str_float( var );
	is_vec = is_str_vec( var );
	is_bool = is_str_bool( var );
	if ( is_vec )
	{
		return "vec";
	}
	if ( is_bool )
	{
		return "bool";
	}
	if ( is_int )
	{
		return "int";
	}
	if ( is_float )
	{
		return "float";
	}
	if ( isString( var ) )
	{
		return "str";
	}
	return "unknown";
}

concatenate_array( array, delimiter )
{
	new_string = "";
	foreach ( token in array )
	{
		new_string += token + delimiter;
	}
	return new_string;
}

clean_player_name_of_clantag( name )
{
	if ( isSubStr( name, "]" ) )
	{
		keys = strTok( name, "]" );
		return keys[ 1 ];
	}
	return name;
}

cast_bool_to_str( bool, binary_string_options )
{
	options = strTok( binary_string_options, " " );
	if ( options.size == 2 )
	{
		if ( bool )
		{
			return options[ 0 ];
		}
		else 
		{
			return options[ 1 ];
		}
	}
	return bool + "";
}

is_even( int )
{
	return ( int % 2 ) == 0;
}

is_odd( int )
{
	return ( int % 2 ) == 1;
}

repackage_args( arg_list )
{
	args_string = "";
	foreach ( index, arg in arg_list )
	{
		if ( index == ( arg_list.size - 1 ) )
		{
			args_string = args_string + arg;
			break;
		}
		args_string = args_string + arg + " ";
	}
	return args_string;
}

CMD_ADDSERVERCOMMAND( cmdname, cmdaliases, cmdusage, cmdfunc, cmdpower, is_threaded_cmd )
{
	aliases = strTok( cmdaliases, " " );
	level.server_commands[ cmdname ] = spawnStruct();
	level.server_commands[ cmdname ].usage = cmdusage;
	level.server_commands[ cmdname ].func = cmdfunc;
	level.server_commands[ cmdname ].aliases = aliases;
	level.server_commands[ cmdname ].power = cmdpower;
	level.commands_total++;
	if ( ceil( level.commands_total / level.commands_page_max ) >= level.commands_page_count )
	{
		level.commands_page_count++;
	}
	if ( is_true( is_threaded_cmd ) )
	{
		level.threaded_commands[ cmdname ] = true;
	}
}

CMD_REMOVESERVERCOMMAND( cmdname )
{
	new_command_array = [];
	cmd_keys = getArrayKeys( level.server_commands );
	foreach ( cmd in cmd_keys )
	{
		if ( cmdname != cmd )
		{
			new_command_array[ cmd ] = spawnStruct();
			new_command_array[ cmd ].usage = level.server_commands[ cmd ].usage;
			new_command_array[ cmd ].func = level.server_commands[ cmd ].func;
			new_command_array[ cmd ].aliases = level.server_commands[ cmd ].aliases;
			new_command_array[ cmd ].power = level.server_commands[ cmd ].power;
		}
		else 
		{
			level.threaded_commands[ cmd ] = false;
		}
	}
	level.server_commands = new_command_array;
	recalculate_command_page_counts();
} 

CMD_ADDCLIENTCOMMAND( cmdname, cmdaliases, cmdusage, cmdfunc, cmdpower, is_threaded_cmd )
{
	aliases = strTok( cmdaliases, " " );
	level.client_commands[ cmdname ] = spawnStruct();
	level.client_commands[ cmdname ].usage = cmdusage;
	level.client_commands[ cmdname ].func = cmdfunc;
	level.client_commands[ cmdname ].aliases = aliases;
	level.client_commands[ cmdname ].power = cmdpower;
	level.commands_total++;
	if ( ceil( level.commands_total / level.commands_page_max ) >= level.commands_page_count )
	{
		level.commands_page_count++;
	}
	if ( is_true( is_threaded_cmd ) )
	{
		level.threaded_commands[ cmdname ] = true;
	}
}

CMD_REMOVECLIENTCOMMAND( cmdname )
{
	new_command_array = [];
	cmd_keys = getArrayKeys( level.client_commands );
	foreach ( cmd in cmd_keys )
	{
		if ( cmdname != cmd )
		{
			new_command_array[ cmd ] = spawnStruct();
			new_command_array[ cmd ].usage = level.client_commands[ cmd ].usage;
			new_command_array[ cmd ].func = level.client_commands[ cmd ].func;
			new_command_array[ cmd ].aliases = level.client_commands[ cmd ].aliases;
			new_command_array[ cmd ].power = level.client_commands[ cmd ].power;
		}
		else 
		{
			level.threaded_commands[ cmd ] = false;
		}
	}
	level.client_commands = new_command_array;
	recalculate_command_page_counts();
} 

recalculate_command_page_counts()
{
	total_commands = arrayCombine( level.server_commands, level.client_commands, 1, 0 );
	level.commands_page_count = 0;
	for ( level.commands_total = 0; level.commands_total < total_commands.size; level.commands_total++ )
	{
		if ( ceil( level.commands_total / level.commands_page_max ) >= level.commands_page_count )
		{
			level.commands_page_count++;
		}
	}

}

CMD_EXECUTE( cmdname, arg_list, is_clientcmd, silent, nologprint )
{
	if ( is_true( level.threaded_commands[ cmdname ] ) )
	{
		if ( is_clientcmd )
		{
			self thread [[ level.client_commands[ cmdname ].func ]]( arg_list );
		}
		else 
		{
			self thread [[ level.server_commands[ cmdname ].func ]]( arg_list );
		}
		return;
	}
	else 
	{
		result = [];
		if ( is_clientcmd )
		{
			result = self [[ level.client_commands[ cmdname].func ]]( arg_list );
		}
		else 
		{
			result = self [[ level.server_commands[ cmdname ].func ]]( arg_list );
		}
	}
	if ( !isDefined( result ) || result.size == 0 || is_true( silent ) )
	{
		return;
	}
	channel = self COM_GET_CMD_FEEDBACK_CHANNEL();
	if ( result[ "filter" ] != "cmderror" )
	{
		cmd_log = self.name + " executed " + result[ "message" ];
		if ( !is_true( nologprint ) )
		{
			level COM_PRINTF( "g_log", result[ "filter" ], cmd_log, self );
		}
		if ( isDefined( result[ "channels" ] ) )
		{
			level COM_PRINTF( result[ "channels" ], result[ "filter" ], result[ "message" ], self );
		}
		else 
		{
			level COM_PRINTF( channel, result[ "filter" ], result[ "message" ], self );
		}
	}
	else
	{
		level COM_PRINTF( channel, result[ "filter" ], result[ "message" ], self );
	}
}

tcs_on_connect()
{
	level endon( "end_commands" );
	while ( true )
	{
		level waittill( "connected", player );
		foreach ( index, dvar in level.clientdvars )
		{
			player thread setClientDvarThread( dvar[ "name" ], dvar[ "value" ], index );
		}
	}
}

//If we have a lot of clientdvars in the pool delay setting them to prevent client command overflow error.
setClientDvarThread( dvar, value, index )
{
	wait( index * 0.25 );
	self setClientDvar( dvar, value );
}

check_for_command_alias_collisions()
{
	server_command_keys = getArrayKeys( level.server_commands );
	client_command_keys = getArrayKeys( level.client_commands );
	aliases = [];
	for ( i = 0; i < client_command_keys.size; i++ )
	{
		for ( j = 0; j < level.client_commands[ client_command_keys[ i ] ].aliases.size; j++ )
		{
			aliases[ aliases.size ] = level.client_commands[ client_command_keys[ i ] ].aliases[ j ];
		}
	}
	for ( i = 0; i < server_command_keys.size; i++ )
	{
		for ( j = 0; j < level.server_commands[ server_command_keys[ i ] ].aliases.size; j++ )
		{
			aliases[ aliases.size ] = level.server_commands[ server_command_keys[ i ] ].aliases[ j ];
		}
	}
	for ( i = 0; i < aliases.size; i++ )
	{
		for ( j = i + 1; j < aliases.size; j++ )
		{
			if ( aliases[ i ] == aliases[ j ] )
			{
				level COM_PRINTF( "con", "cmderror", va( "Command alias collision detected alias %s is duplicated", aliases[ i ] ), level );
				break;
			}
		}
	}
}