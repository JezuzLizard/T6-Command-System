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

/*public*/ get_map_display_name_from_location( location )
{
	switch ( location )
	{
		case "transit":
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
			return "Buried";
	}
	return "NULL";
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
	else if ( is_str_int( clientnum_guid_or_name ) && clientnum_guid_or_name.size > max_players_str.size )
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