#include common_scripts/utility;
#include maps/mp/_utility;
#include scripts/cmd_system_modules/_com;

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
		name = clientnum_guid_or_name;
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
				if ( clean_player_name_of_clantag( toLower( player.name ) ) == clean_player_name_of_clantag( name ) || isSubStr( toLower( player.name ), name ) )
				{
					return player;
				}
			}
			break;
	}
	return undefined;
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
	val = 1;
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
	val = 1;
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

CMD_ADDCOMMAND( cmdname, cmdaliases, cmdusage, cmdfunc, cmdpower, is_threaded_cmd )
{
	aliases = strTok( cmdaliases, " " );
	level.custom_commands[ cmdname ] = spawnStruct();
	level.custom_commands[ cmdname ].usage = cmdusage;
	level.custom_commands[ cmdname ].func = cmdfunc;
	level.custom_commands[ cmdname ].aliases = aliases;
	level.custom_commands[ cmdname ].power = cmdpower;
	level.custom_commands_total++;
	if ( ceil( level.custom_commands_total / level.custom_commands_page_max ) >= level.custom_commands_page_count )
	{
		level.custom_commands_page_count++;
	}
	if ( is_true( is_threaded_cmd ) )
	{
		level.custom_threaded_commands[ cmdname ] = true;
	}

	//New function added by fed's plugin that allows you to use a command in the server console.
	addCommand( cmdname, cmdfunc );
}

VOTE_ADDVOTEABLE( vote_type_aliases, usage, pre_vote_execute_func, post_vote_execute_func )
{
	if ( !isDefined( level.custom_votes ) )
	{
		level.custom_votes = [];
	}
	if ( !isDefined( level.custom_votes[ vote_type_aliases ] ) )
	{
		level.custom_votes_total++;
		if ( ceil( level.custom_votes_total / level.custom_commands_page_max ) >= level.custom_votes_page_count )
		{
			level.custom_votes_page_count++;
		}
		level.custom_votes[ vote_type_aliases ] = spawnStruct();
		level.custom_votes[ vote_type_aliases ].pre_func = pre_vote_execute_func;
		level.custom_votes[ vote_type_aliases ].post_func = post_vote_execute_func;
		level.custom_votes[ vote_type_aliases ].usage = usage;
	}
}

CMD_EXECUTE( cmdname, arg_list )
{
	if ( is_true( level.custom_threaded_commands[ cmdname ] ) )
	{
		self thread [[ level.custom_commands[ cmdname ].func ]]( arg_list );
		return;
	}
	else 
	{
		result = [];
		result = self [[ level.custom_commands[ cmdname ].func ]]( arg_list );
	}
	channel = "tell";
	if ( is_true( self.is_server ) )
	{
		channel = "con";
	}
	if ( result[ "filter" ] != "cmderror" )
	{
		cmd_log = va( "%s executed %s", self.name, result[ "message" ] );
		level COM_PRINTF( "g_log", result[ "filter" ], cmd_log, self );
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