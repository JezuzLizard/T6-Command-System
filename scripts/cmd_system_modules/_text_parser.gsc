#include maps/mp/zombies/_zm_utility;
#include maps/mp/_utility;
#include common_scripts/utility;
#include scripts/zm/promod/utility/_grief_util;

/*public*/ parse_cmd_message( message )
{
	if ( message == "" )
	{
		return [];
	}
	multi_cmds = [];
	command_keys = [];
	multiple_cmds_keys = strTok( message, ";" );
	print( va( "message %s", multiple_cmds_keys[ 0 ] ) );
	for ( i = 0; i < multiple_cmds_keys.size; i++ )
	{
		message = multiple_cmds_keys[ i ];
		command_keys[ "cmdname" ] = "";
		command_keys[ "args" ] = [];
		command_keys[ "namespace" ] = get_cmd_namespace( message );
		buffer_index = 0;
		for ( ; command_keys[ "namespace" ] != "" && buffer_index < ( command_keys[ "namespace" ].size + 2 ); buffer_index++ )
		{
		}
		for ( ; isDefined( message[ buffer_index ] ) && message[ buffer_index ] != " " && message[ buffer_index ] != ""; buffer_index++ )
		{
			command_keys[ "cmdname" ] += message[ buffer_index ];
		}
		for ( ; isDefined( message[ buffer_index ] ); buffer_index++ )
		{
			if ( message[ buffer_index ] == " " )
			{
				command_keys[ "args" ][ command_keys[ "args" ].size ] = "";
			}
			else 
			{
				for ( ; isDefined( message[ buffer_index ] ) && message[ buffer_index ] != "" && message[ buffer_index ] != " "; buffer_index++ )
				{
					command_keys[ "args" ][ command_keys[ "args" ].size - 1 ] += message[ buffer_index ];
				}
			}
		}
		multi_cmds[ multi_cmds.size ] = command_keys;
	}
	return multi_cmds;
}

/*private*/ get_cmd_namespace( message )
{
	if ( !isSubStr( message, ":" ) )
	{
		return "";
	}
	message_tokens = strTok( message, ":" );
	for ( i = 0; i < level.custom_commands_namespaces_total; i++ )
	{
		namespace_keys = getArrayKeys( level.custom_commands );
		namespace_aliases = strTok( namespace_keys[ i ], " " );
		for ( j = 0; j < namespace_aliases.size; j++ )
		{
			if ( message_tokens[ 0 ] == namespace_aliases[ j ] )
			{
				return namespace_keys[ i ];
			}
		}
	}
	return "";
}

/*public*/ remove_tokens_from_array( array, token )
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

/*public*/ get_type( var )
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

/*public*/ concatenate_array( array, delimiter )
{
	new_string = "";
	foreach ( token in array )
	{
		new_string += token + delimiter;
	}
	return new_string;
}

/*public*/ clean_player_name_of_clantag( name )
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