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

get_ZM_map_display_name_from_location_gametype( location, gametype )
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

getDvarStringDefault( dvarname, default_value )
{
	cur_dvar_value = getDvar( dvarname );
	return cur_dvar_value != "" ? cur_dvar_value : default_value;
}

is_command_token( char )
{
	foreach ( token in level.custom_commands_tokens )
	{
		if ( char == token )
		{
			return true;
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
	number_chars = "0123456789";
	int_checks_passed = 0;
	for ( i = 0; i < str.size; i++ )
	{
		if ( int_checks_passed != i )
		{
			break;
		}
		for ( j = 0; j < number_chars; j++ )
		{
			if ( str[ i ] == number_chars[ j ] )
			{
				int_checks_passed++;
				break;
			}
		}
	}
	return int_checks_passed == str.size;
}

is_str_bool( str )
{
	if ( str == "false" || str == "true" )
	{
		return true;
	}
	return false;
}

is_str_float( str )
{
	number_chars = "0123456789";
	decimals_found = 0;
	float_checks_passed = 0;
	for ( i = 0; i < str.size; i++ )
	{
		if ( float_checks_passed != i )
		{
			break;
		}
		for ( j = 0; j < number_chars; j++ )
		{
			if ( str[ i ] == number_chars[ j ] )
			{
				float_checks_passed++;
				break;
			}
			else if ( str[ i ] == "." )
			{
				decimals_found++;
				float_checks_passed++;
				break;
			}
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
	return float_checks_passed == str.size;
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
	is_int = isInt( var );
	is_float = isFloat( var );
	is_vec = isVec( var );
	if ( is_vec )
	{
		return "vec";
	}
	if ( ( var == 0 || var == 1 ) && is_int )
	{
		return "bool";
	}
	if ( is_int )
	{
		return "int";
	}
	if ( isString( var ) )
	{
		return "str";
	}
	if ( is_float )
	{
		return "float";
	}
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
		return bool ? options[ 0 ] : options[ 1 ];
	}
	return bool + "";
}

is_even( int )
{
	return int % 2 == 0;
}

is_odd( int )
{
	return int % 2 == 1;
}

CMD_ADDCOMMAND( namespace_aliases, cmdaliases, cmd_usage, cmdfunc, is_threaded_cmd )
{
	if ( !isDefined( level.custom_commands ) )
	{
		level.custom_commands = [];
	}
	if ( !isDefined( level.custom_commands[ namespace_aliases ] ) )
	{
		level.custom_commands[ namespace_aliases ] = [];
		level.custom_commands_namespaces_total++;
	}
	if ( !isDefined( level.custom_commands[ namespace_aliases ][ cmdaliases ] ) )
	{
		level.custom_commands[ namespace_aliases ][ cmdaliases ] = spawnStruct();
		level.custom_commands[ namespace_aliases ][ cmdaliases ].usage = cmd_usage;
		level.custom_commands[ namespace_aliases ][ cmdaliases ].func = cmdfunc;
		level.custom_commands_total++;
		if ( isInt( level.custom_commands_total / 6 ) )
		{
			level.custom_commands_page_count++;
		}
		if ( is_true( is_threaded_cmd ) )
		{
			level.custom_threaded_commands[ cmdaliases ] = true;
		}
	}
	else 
	{
		COM_PRINTF( "con con_log", "error", va( "Command %s is already defined in namespace %s", cmdaliases, namespace_aliases ) );
	}
}

VOTE_ADDVOTEABLE( vote_type_aliases, pre_vote_execute_func, post_vote_execute_func )
{
	if ( !isDefined( level.custom_votes ) )
	{
		level.custom_votes = [];
	}
	if ( !isDefined( level.custom_votes[ vote_type_aliases ] ) )
	{
		level.custom_votes[ vote_type_aliases ] = spawnStruct();
		level.custom_votes[ vote_type_aliases ].pre_func = pre_vote_execute_func;
		level.custom_votes[ vote_type_aliases ].post_func = post_vote_execute_func;
	}
}

CMD_EXECUTE( namespace, cmdname, arg_list )
{
	indexable_cmdname = "";
	is_threaded_cmd = false;
	if ( namespace != "" )
	{
		cmd_keys = getArrayKeys( level.custom_commands[ namespace ] );
		cmd_keys_index = get_alias_index( cmdname, cmd_keys );
		if ( cmd_keys_index != -1 )
		{
			indexable_cmdname = cmd_keys[ cmd_keys_index ];
			if ( is_true( level.custom_threaded_commands[ indexable_cmdname ] ) )
			{
				is_threaded_cmd = true;
			}
		}
	}
	can_execute_cmd = indexable_cmdname != "";
	if ( can_execute_cmd )
	{
		if ( is_threaded_cmd )
		{
			self thread [[ level.custom_commands[ namespace ][ indexable_cmdname ].func ]]( arg_list );
		}
		else 
		{
			result = self [[ level.custom_commands[ namespace ][ indexable_cmdname ].func ]]( arg_list );
		}
	}
	channel = self COM_GET_CMD_FEEDBACK_CHANNEL();
	if ( isDefined( result ) && result[ "filter" ] != "cmderror" )
	{
		cmd_log = self.name + " executed " + result[ "message" ];
		COM_PRINTF( "g_log", result[ "filter" ], cmd_log, self );
		if ( isDefined( result[ "channels" ] ) )
		{
			COM_PRINTF( result[ "channels" ], result[ "filter" ], message, self );
		}
		else 
		{
			COM_PRINTF( channel, result[ "filter" ], message, self );
		}
	}
	else if ( !is_threaded_cmd )
	{
		if ( namespace == "" )
		{
			COM_PRINTF( channel, "cmderror", "Command bad namespace", self );
		}
		else if ( indexable_cmdname == "" )
		{
			COM_PRINTF( channel, "cmderror", "Command not found in namespace", self );
			COM_PRINTF( channel, "cmdinfo", "Got:" + namespace, self );
		}
		else 
		{
			message = self.name + " executed " + result[ "message" ];
			COM_PRINTF( channel, result[ "filter" ], message, self );
		}
	}
}