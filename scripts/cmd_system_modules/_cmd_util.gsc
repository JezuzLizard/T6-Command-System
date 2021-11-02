#include maps/mp/zombies/_zm_utility;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/zombies/_zm_laststand;
#include scripts/zm/promod/plugin/commands;
#include maps/mp/zombies/_zm;
#include scripts/zm/promod/_teams;
#include maps/mp/zombies/_zm_perks;
#include scripts/zm/promod/utility/_text_parser;

/*public*/ array_validate( array )
{
	return isDefined( array ) && isArray( array ) && array.size > 0;
}

/*public*/ find_map_data_from_alias( alias )
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
				gamemode = "classic";
				location = "prison";
				mapname = "zm_prison";
				break;
			case "dr":
			case "dierise":
			case "rooftop":
				gamemode = "classic";
				location = "rooftop";
				mapname = "zm_highrise";
				break;
			case "or":
			case "origins":
			case "tomb":
				gamemode = "classic";
				location = "tomb";
				mapname = "zm_tomb";
				break;
			case "buried":
				gamemode = "classic";
				location = "processing";
				mapname = "zm_buried";
				break;
			case "nuke":
			case "nuked":
			case "nuketown":
				gamemode = "standard";
				location = "nuked";
				mapname = "zm_nuked";
			case "gc":
			case "gcell":
			case "gblock":
			case "gcellblock":
				gamemode = "grief";
				location = "cellblock";
				mapname = "zm_prison";
				break;
			case "gs":
			case "gstreet":
			case "gborough":
				gamemode = "grief";
				location = "street";
				mapname = "zm_buried";
				break;
			case "gf":
			case "gfarm":
				gamemode = "grief";
				location = "farm";
				mapname = "zm_transit";
				break;
			case "gt":
			case "gtown":
				gamemode = "grief";
				location = "town";
				mapname = "zm_transit";
				break;
			case "gb":
			case "gbus":
			case "gdepot":
				gamemode = "grief";
				location = "transit";
				mapname = "zm_transit";
				break;
			case "gd":
			case "gdin":
			case "gdiner":
				gamemode = "grief";
				location = "diner";
				mapname = "zm_transit";
				break;
			case "gtu":
			case "gtunnel":
				gamemode = "grief";
				location = "tunnel";
				mapname = "zm_transit";
				break;
			case "gp":
			case "gpow":
			case "gpower":
				gamemode = "grief";
				location = "power";
				mapname = "zm_transit";
				break;
			case "sf":
			case "sfarm":
				gamemode = "standard";
				location = "farm";
				mapname = "zm_transit";
				break;
			case "st":
			case "stown":
				gamemode = "standard";
				location = "town";
				mapname = "zm_transit";
				break;
			case "sb":
			case "sbus":
			case "sdepot":
				gamemode = "standard";
				location = "transit";
				mapname = "zm_transit";
				break;
			case "sd":
			case "sdin":
			case "sdiner":
				gamemode = "standard";
				location = "diner";
				mapname = "zm_transit";
				break;
			case "stu":
			case "stunnel":
				gamemode = "standard";
				location = "tunnel";
				mapname = "zm_transit";
				break;
			case "sp":
			case "spow":
			case "spower":
				gamemode = "standard";
				location = "power";
				mapname = "zm_transit";
				break;
			default:
				result[ "gamemode" ] = "";
				result[ "location" ] = "";
				result[ "mapname" ] = "";
				return result;
		}
		result[ "gamemode" ] = gamemode;
		result[ "location" ] = location;
		result[ "mapname" ] = mapname;
		return result;
	}
	else 
	{
		switch ( alias )
		{
			case "a":
			case "after":
			case "aftermath":
				mapname = "mp_la";
				break;
			case "cargo":
			case "dockside":
				mapname = "mp_dockside";
				break;
			case "carrier":
				mapname = "mp_carrier";
				break;
			case "drone":
				mapname = "mp_drone";
				break;
			case "express":
				mapname = "mp_express";
				break;
			case "hijacked":
				mapname = "mp_hijacked";
				break;
			case "meltdown":
				mapname = "mp_meltdown";
				break;
			case "overflow":
				mapname = "mp_overflow";
				break;
			case "plaza":
			case "nightclub":
				mapname = "mp_nightclub";
				break;
			case "raid":
				mapname = "mp_raid";
				break;
			case "slums":
				mapname = "mp_slums";
				break;
			case "village":
			case "standoff":
				mapname = "mp_village";
				break;
			case "turbine":
				mapname = "mp_turbine";
				break;
			case "yemen":
			case "socotra":
				mapname = "mp_socotra";
				break;
			case "nuketown":
				mapname = "mp_nuketown_2020";
				break;
			case "downhill":
				mapname = "downhill";
				break;
			case "mirage":
				mapname = "mp_mirage";
				break;
			case "hydro":
				mapname = "mp_hydro";
				break;
			case "grind":
			case "skate":
				mapname = "mp_skate";
				break;
			case "encore":
			case "concert":
				mapname = "mp_concert";
				break;
			case "magma":
				mapname = "mp_magma";
				break;
			case "vertigo":
				mapname = "mp_vertigo";
				break;
			case "studio":
				mapname = "mp_studio";
				break;
			case "uplink":
				mapname = "mp_uplink";
				break;
			case "detour":
			case "bridge":
				mapname = "mp_bridge";
				break;
			case "cove":
			case "castaway":
				mapname = "mp_castaway";
				break;
			case "rush":
			case "paintball":
				mapname = "mp_paintball";
				break;
			case "dig":
				mapname = "mp_dig";
				break;
			case "frost":
			case "frostbite":
				mapname = "mp_frostbite";
				break;
			case "pod":
				mapname = "mp_pod";
				break;
			case "takeoff":
				mapname = "mp_takeoff";
				break;
			default:
				result[ "mapname" ] = "";
				return result;
		}
	}
	result[ "mapname" ] = mapname;
	return result;
}

/*public*/ get_ZM_map_display_name_from_location_gametype( location, gametype )
{
	switch ( location )
	{
		case "transit":
			if ( gametype == "classic" )
			{
				return "Tranzit";
			}
			return "Bus Depot";
		case "town":
			return "Town";
		case "farm":
			return "Farm";
		case "diner":
			return "Diner";
		case "Power":
			return "Power";
		case "cornfield":
			return "Cornfield";
		case "Tunnel":
			return "Tunnel";
		case "cellblock":
			return "Cellblock";
		case "street":
		case "processing":
			return "Buried";
		case "prison":
			return "Alcatraz";
		case "rooftop":
			return "Die Rise";
		case "tomb":
			return "Origins";
		default:
			return location;
	}
}

/*public*/ get_MP_map_name( mapname )
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

/*public*/ cast_to_vector( vector_string )
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

/*private*/ add_new_dvar_command( dvar_name )
{
	if ( !isDefined( level.dvar_commands ) ) 
	{
		level.dvar_commands = [];
	}
	if ( !isDefined( level.dvar_commands[ dvar_name ] ) )
	{
		level.dvar_commands[ dvar_name ] = true;
		setDvar( dvar_name, "" );
	}
}

/*public*/ init_player_session_data()
{
	if ( !isDefined( level.players_in_session ) )
	{
		level.players_in_session = [];
	}
	if ( !isDefined( level.players_in_session[ self.name ] ) )
	{
		level.players_in_session[ self.name ] = spawnStruct();
	}
	if ( !isDefined( level.players_in_session[ self.name ].command_cooldown ) )
	{
		level.players_in_session[ self.name ].command_cooldown = 0;
	}
}

server_safe_notify_thread( notify_name, index )
{
	wait( level.SERVER_FRAME * index );
	level notify( notify_name );
}

find_player_in_server( clientnum_guid_or_name )
{
	max_players_str = getDvarInt( "sv_maxclients" ) + "";
	if ( is_str_int( clientnum_guid_or_name ) && int( clientnum_guid_or_name ) < getDvarInt( "sv_maxclients" ) )
	{
		client_num = int( clientnum_guid_or_name );
	}
	else if ( is_str_int( clientnum_guid_or_name ) )
	{
		GUID = int( clientnum_guid_or_name );
	}
	else 
	{
		name = clientnum_guid_or_name;
	}
	player_data = [];
	foreach ( player in level.players )
	{
		if ( isDefined( name ) && clean_player_name_of_clantag( player.name ) == clean_player_name_of_clantag( name ) || isDefined( name ) && isSubStr( player.name, name ) || isDefined( client_num ) && player getEntityNumber() == client_num || player getGUID() == GUID )
		{
			player_data[ "name" ] = player.name;
			player_data[ "guid" ] = player getGUID();
			player_data[ "clientnum" ] = player getEntityNumber();
			return player_data;
		}
	}
	return undefined;
}

get_alias_index( alias, array_of_aliases )
{
	foreach ( alias_group in array_of_aliases )
	{
		alias_keys = strTok( alias_group, " " );
		for ( i = 0; i < alias_keys.size; i++ )
		{
			if ( alias == alias_leys[ i ] )
			{
				return i;
			}
		}
	}
	return -1;
}