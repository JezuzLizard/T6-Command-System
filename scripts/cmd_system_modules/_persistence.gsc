#include common_scripts\utility;
#include maps\mp\_utility;
#include scripts\cmd_system_modules\_com;
#include scripts\cmd_system_modules\_cmd_util;
#include scripts\cmd_system_modules\_filesystem;

PERSISTENCE_INIT()
{
	level.homepath = getDvar( "fs_homepath" );
	level.script_data = level.homepath + "/scriptdata";
	level.fs_timeout = getDvarFloatDefault( "tcs_fs_timeout", 4.0 );
	if ( !directoryExists( level.script_data ) )
	{
		createDirectory( level.script_data );
	} 
	level.script_data_player_entries = level.script_data + "/tcs_player_entries";
	if ( !directoryExists( level.script_data_player_entries ) )
	{
		createDirectory( level.script_data_player_entries );
	}
	level.script_data_player_entries_backup = level.script_data + "/tcs_player_entries_backup";
	if ( !directoryExists( level.script_data_player_entries_backup ) )
	{
		createDirectory( level.script_data_player_entries_backup );
	}
	REGISTER_PERS_FS_FUNC( "new", ::PERS_CREATE_NEW_PLAYER_ENTRY );
	REGISTER_PERS_FS_FUNC( "load", ::PERS_LOAD_EXISTING_PLAYER_ENTRY );
	REGISTER_PERS_FS_FUNC( "delete", ::PERS_DELETE_PLAYER_ENTRY );
	REGISTER_PERS_FS_FUNC( "update", ::PERS_UPDATE_PLAYER_ENTRY );
	level thread PERS_CONNECTING_THREAD();
}

PERS_CONNECTING_THREAD()
{
	while ( true )
	{
		level waittill( "connecting", player );
		level COM_PRINTF( "con|g_log", "permsdebug", va( "%s is connecting at %s server time", player.name, getTime() ), level );
		player remove_square_brackets_from_name();
		player thread filespump();
		player thread PERS_PLAYER_INIT();
		player thread set_clantag();
		player thread check_banned();
		player thread check_muted();
	}
}

remove_square_brackets_from_name()
{
	if ( self isTestClient() )
	{
		return;
	}
	if ( isSubStr( self.name, "[" ) || isSubStr( self.name, "]" ) )
	{
		new_name = "";
		for ( i = 0; i < self.name.size; i++ )
		{
			if ( self.name[ i ] == "[" || self.name[ i ] == "]" )
			{
				continue;
			}
			new_name += self.name[ i ];
		}
		if ( new_name == "" )
		{
			new_name = "Unknown Soldier";
		}
		self setName( new_name );
	}
}

set_clantag()
{
	self endon( "disconnect" );	
	while ( !is_true( self.player_fields_fetched ) )
	{
		wait 0.05;
	}
	foreach ( rank in level.tcs_clantag_worthy_ranks )
	{
		if ( self.player_fields[ "rank" ] == rank )
		{
			new_string = "";
			new_string += toUpper( rank[ 0 ] );
			for ( i = 1; i < rank.size; i++ )
			{
				new_string += rank[ i ];
			}
			self setClantag( new_string );
			break;
		}
	}
}

check_banned()
{
	self endon( "disconnect" );	
	while ( !is_true( self.player_fields_fetched ) )
	{
		wait 0.05;
	}
	if ( self.player_fields[ "penalties" ][ "temp_banned" ] )
	{
		if ( ( self.player_fields[ "penalties" ][ "temp_ban_time" ] + self.player_fields[ "penalties" ][ "temp_ban_length" ] ) < getUTC() )
		{
			self.player_fields[ "penalties" ][ "temp_banned" ] = false;
			self.player_fields[ "penalties" ][ "temp_ban_time" ] = 0;
			self.player_fields[ "penalties" ][ "temp_ban_length" ] = 0;
			self.player_fields[ "penalties" ][ "ban_reason" ] = "none";
		}
		else 
		{
			ban_reason = self.player_fields[ "penalties" ][ "ban_reason" ];
			if ( ban_reason == "none" )
			{
				ban_reason = level.tcs_default_ban_reason;
			}
			else 
			{
				ban_reason = "Tempbanned for " + ban_reason;
			}
			executecommand( va( "clientkick_for_reason %s \"%s\"", self getEntityNumber(), ban_reason ) );
		}
	}
	else if ( self.player_fields[ "penalties" ][ "perm_banned" ] )
	{
		ban_reason = self.player_fields[ "penalties" ][ "ban_reason" ];
		if ( ban_reason == "none" )
		{
			ban_reason = level.tcs_default_ban_reason;
		}
		else 
		{
			ban_reason = "Permbanned for " + ban_reason;
		}
		executecommand( va( "clientkick_for_reason %s \"%s\"", self getEntityNumber(), ban_reason ) );
	}
}

check_muted()
{
	self endon( "disconnect" );
	while ( !is_true( self.player_fields_fetched ) )
	{
		wait 0.05;
	}	
	if ( self.player_fields[ "penalties" ][ "chat_muted" ] )
	{
		if ( ( self.player_fields[ "penalties" ][ "chat_muted_time" ] + self.player_fields[ "penalties" ][ "chat_muted_length" ] ) < getUTC() )
		{
			self.player_fields[ "penalties" ][ "chat_muted" ] = false;
			self.player_fields[ "penalties" ][ "chat_muted_time" ] = 0;
			self.player_fields[ "penalties" ][ "chat_muted_length" ] = 0;
		}
		else 
		{
			self thread unmute_player_thread();
		}
	}
}

unmute_player_thread()
{
	self endon( "disconnect" );
	while ( ( self.player_fields[ "penalties" ][ "chat_muted_time" ] + self.player_fields[ "penalties" ][ "chat_muted_length" ] ) > getUTC() )
	{
		wait 1;
	}
	self.player_fields[ "penalties" ][ "chat_muted" ] = false;
	self.player_fields[ "penalties" ][ "chat_muted_time" ] = 0;
	self.player_fields[ "penalties" ][ "chat_muted_length" ] = 0;
}

REGISTER_PERS_FS_FUNC( func_alias, func )
{
	if ( !isDefined( level.persistence_funcs ) )
	{
		level.persistence_funcs = [];
	}
	level.persistence_funcs[ func_alias ] = func;
}

ADD_PERS_FS_FUNC_TO_QUEUE( func_alias )
{
	if ( !isDefined( self ) )
	{
		level COM_PRINTF( "con|g_log", "permsdebug", va( "add_pers_fs_func_to_queue() called on undefined player", level ) );
		return;
	}
	if ( !isPlayer( self ) )
	{
		level COM_PRINTF( "con|g_log", "permsdebug", va( "add_pers_fs_func_to_queue() called on a non player", level ) );
		return;
	}
	if ( ( self isTestClient() && !getDvarIntDefault( "perms_testing", 0 ) ) )
	{
		return;
	}
	if ( !isDefined( self.pers_fs_id ) )
	{
		self.pers_fs_id = 0;
	}
	else 
	{
		self.pers_fs_id++;
	}
	id = self.pers_fs_id;
	if ( self isTestClient() )
	{
		path = va( "%s/%s_%s.json", level.script_data_player_entries, self.name, self getGUID() );
	}
	else 
	{
		path = va( "%s/%s.json", level.script_data_player_entries, self getGUID() );
	}
	struct = spawnStruct();
	struct.func = level.persistence_funcs[ func_alias ];
	struct.path = path;
	struct.id = id;
	self.files[ self.files.size ] = struct;
	self thread timeout( func_alias, id );
}

timeout( func_alias, id )
{
	self endon( va( "pers_fs_result_%s", func_alias ) );
	for ( i = 0; i < level.fs_timeout; i += 0.05 )
	{
		wait 0.05;
	}
	self notify( va( "pers_fs_result_%s", func_alias ), "timeout" );
	self notify( va( "pers_fs_timeout_%s", id ) );
}

PERS_PLAYER_INIT()
{
	self endon( "disconnect" );
	if ( !isDefined( self.player_fields ) )
	{
		self.player_fields = [];
	}
	self.player_fields = level.pers_generic_player_fields_registry;
	self.player_fields[ "name" ] = simplify_player_name_for_code( self.name );
	self.player_fields[ "guid" ] = self getGUID();
	self thread ADD_PERS_FS_FUNC_TO_QUEUE( "new" );
	self waittill( "pers_fs_result_new", outcome );
	if ( outcome == "failure" || outcome == "timeout" )
	{
		self thread ADD_PERS_FS_FUNC_TO_QUEUE( "load" );
		self waittill( "pers_fs_result_load", outcome );
		if ( outcome == "failure" || outcome == "timeout" )
		{
			level COM_PRINTF( "con|g_log", "permsdebug", va( "Failed to create or load new player entry for %s", simplify_player_name_for_code( self.name ) ), self );
			return;
		}
		else 
		{
			level COM_PRINTF( "con|g_log", "permsdebug", va( "Loaded existing player entry for %s", simplify_player_name_for_code( self.name ) ), self );
		}
	}
	else 
	{
		level COM_PRINTF( "con|g_log", "permsdebug", va( "Created new player entry for %s", simplify_player_name_for_code( self.name ) ), self );
	}
	self.player_fields_fetched = true;
}

PERS_REGISTER_GENERIC_PLAYER_FIELD( fieldname, defaultvalue )
{
	if ( !isDefined( level.pers_generic_player_fields_registry ) )
	{
		level.pers_generic_player_fields_registry = [];
	}
	level.tcs_pers_version += 0.1;
	round = ceil( level.tcs_pers_version * 1000 );
	level.tcs_pers_version = round / 1000;
	level.pers_generic_player_fields_registry[ fieldname ] = defaultvalue;
	level.pers_generic_player_fields_registry[ "version" ] = level.tcs_pers_version;
}

PERS_UNREGISTER_GENERIC_PLAYER_FIELD( fieldname )
{
	if ( !isDefined( level.pers_generic_player_fields_registry ) || !isDefined( level.pers_generic_player_fields_registry[ fieldname ] ) )
	{
		return;
	}
	level.tcs_pers_version += 0.1;
	round = ceil( level.tcs_pers_version * 1000 );
	level.tcs_pers_version = round / 1000;
	level.pers_generic_player_fields_registry[ fieldname ] = undefined;
	level.pers_generic_player_fields_registry[ "version" ] = level.tcs_pers_version;
}

check_for_newer_version( path )
{
	if ( !fileExists( path ) )
	{
		return false;
	}
	buffer = readfile( path );
	json_array = jsonparse( buffer );
	if ( json_array[ "version" ] < level.tcs_pers_version )
	{
		new_fields = [];
		player_fields_keys = getArrayKeys( self.player_fields );
		for ( i = 0; i < player_fields_keys.size; i++  )
		{
			found_key = false;
			json_array_keys = getArrayKeys( json_array );
			for ( j = 0; j < json_array_keys.size; j++ )
			{
				if ( player_fields_keys[ i ] == json_array_keys[ j ] )
				{
					found_key = true;
					break;
				}
			}
			if ( !found_key )
			{
				new_fields[ player_fields_keys[ i ] ] = self.player_fields[ player_fields_keys[ i ] ];
			}
		}
		if ( new_fields.size > 0 )
		{
			combined_array = arrayCombine( json_array, new_fields, false, true );
			json = jsonserialize( combined_array, 4 );
			writefile( path, json );
			return true;
		}
	}
	return false;
}

PERS_CREATE_NEW_PLAYER_ENTRY( path, id )
{
	self endon( "disconnect" );
	self endon( va( "pers_fs_timeout_%s", id ) );
	if ( self check_for_newer_version( path ) )
	{
		success = "success";
	}
	else if ( !fileexists( path ) )
	{
		json = jsonserialize( self.player_fields, 4 );
		writefile( path, json );
		success = "success";
	}
	else 
	{
		success = "failure";
	}
	self notify( "pers_fs_result_new", success );
}

PERS_LOAD_EXISTING_PLAYER_ENTRY( path, id )
{
	self endon( "disconnect" );
	self endon( va( "pers_fs_timeout_%s", id ) );
	if ( fileexists( path ) )
	{
		buffer = readfile( path );
		self.player_fields = jsonparse( buffer );
		success = "success";
	}
	else 
	{
		success = "failure";
	}
	self notify( "pers_fs_result_load", success );
}

PERS_DELETE_PLAYER_ENTRY( path, id )
{
	self endon( "disconnect" );
	self endon( va( "pers_fs_timeout_%s", id ) );
	if ( fileexists( path ) )
	{
		removefile( path );
		success = "success";
	}
	else 
	{
		succes = "failure";
	}
	self notify( "pers_fs_result_delete", success );
}

PERS_UPDATE_PLAYER_ENTRY( path, id )
{
	self endon( "disconnect" );
	self endon( va( "pers_fs_timeout_%s", id ) );
	if ( !isDefined( self.player_fields ) )
	{
		success = "failure";
	}
	else if ( fileexists( path ) )
	{
		json = jsonserialize( self.player_fields, 4 );
		writefile( path, json );
		success = "success";
	}
	else 
	{
		success = "failure";
	}
	self notify( "pers_fs_result_update", success );
}