#include common_scripts\utility;
#include maps\mp\_utility;
#include scripts\cmd_system_modules\_com;
#include scripts\cmd_system_modules\_cmd_util;

PERSISTENCE_INIT()
{
	level.homepath = getDvar( "fs_homepath" );
	level.script_data = level.homepath + "/scriptdata";
	level.fs_timeout = getDvarFloatDefault( "tcs_fs_timeout", 5.0 );
	if ( !directoryExists( level.script_data ) )
	{
		createDirectory( level.script_data );
	} 
	level.script_data_player_entries = level.script_data + "/player_entries";
	if ( !directoryExists( level.script_data_player_entries ) )
	{
		createDirectory( level.script_data_player_entries );
	}
	level.script_data_player_entries_backup = level.script_data + "/player_entries_backup";
	if ( !directoryExists( level.script_data_player_entries_backup ) )
	{
		createDirectory( level.script_data_player_entries_backup );
	}
	REGISTER_PERS_FS_FUNC( "new", ::PERS_CREATE_NEW_PLAYER_ENTRY );
	REGISTER_PERS_FS_FUNC( "load", ::PERS_LOAD_EXISTING_PLAYER_ENTRY );
	REGISTER_PERS_FS_FUNC( "delete", ::PERS_DELETE_PLAYER_ENTRY );
	REGISTER_PERS_FS_FUNC( "update", ::PERS_UPDATE_PLAYER_ENTRY );
	REGISTER_PERS_FS_FUNC( "get", ::PERS_GET_PLAYER_ENTRY_FIELD_VALUE );
	REGISTER_PERS_FS_FUNC( "set", ::PERS_SET_PLAYER_ENTRY_FIELD_VALUE );
	level thread PERS_FILESYSTEM_QUEUE_PUMP();
}

REGISTER_PERS_FILESYSTEM_FUNC( func_alias, func )
{
	if ( !isDefined( level.persistence_funcs ) )
	{
		level.persistence_funcs = [];
	}
	level.persistence_funcs[ func_alias ] = func;
}

ADD_PERS_FS_FUNC_TO_QUEUE( func_alias, arg1, arg2, arg3 )
{
	if ( isDefined( self ) && self != level )
	{
		player = self;
	}
	else 
	{
		player = level find_player_in_server( arg1 );
	}
	if ( !isDefined( player ) || player isTestClient() )
	{
		return;
	}
	path = va( "%s/%s_%s.json", level.script_data_player_entries, player.name, player getGUID() );
	struct = spawnStruct();
	struct.player = player;
	struct.func = level.persistence_funcs[ func_alias ];
	struct.path = path;
	struct.arg2 = arg2;
	struct.arg3 = arg3;
	level.files[ level.files.size ] = struct;
}

PERS_FILESYSTEM_QUEUE_PUMP()
{
	while ( true )
	{
		wait 0.1;
		level notify( "filesystem_queue" );
	}
}

PERS_PLAYER_INIT()
{
	if ( !isDefined( self.player_fields ) )
	{
		self.player_fields = [];
	}
	self.player_fields = level.pers_generic_player_fields_registry;
	self.player_fields[ "name" ] = self.name;
	self.player_fields[ "guid" ] = self getGUID();
	self thread ADD_PERS_FS_FUNC_TO_QUEUE( "new", undefined, undefined, undefined );
	self waittill( "pers_fs_result_new", outcome );
	if ( !outcome )
	{
		self thread ADD_PERS_FS_FUNC_TO_QUEUE( "new", undefined, undefined, undefined );
		self waittill( "pers_fs_result_load", outcome );
		if ( !outcome )
		{
			level COM_PRINTF( "con|g_log", "permserror", va( "Failed to create and load new player entry for %s", self.name ), self );
			return;
		}
	}
	self.player_fields_fetched = true;
}

PERS_REGISTER_GENERIC_PLAYER_FIELD( fieldname, defaultvalue )
{
	if ( !isDefined( level.pers_generic_player_fields_registry ) )
	{
		level.pers_generic_player_fields_registry = [];
	}
	level.pers_generic_player_fields_registry[ fieldname ] = defaultvalue;
}

PERS_UNREGISTER_GENERIC_PLAYER_FIELD( fieldname )
{
	if ( !isDefined( level.pers_generic_player_fields_registry ) || !isDefined( level.pers_generic_player_fields_registry[ fieldname ] ) )
	{
		return;
	}
	level.pers_generic_player_fields_registry[ fieldname ] = undefined;
}

PERS_CREATE_NEW_PLAYER_ENTRY( path, arg2, arg3 )
{
	if ( !fileexists( path ) )
	{
		json = jsonserialize( self.player_fields, 4 );
		writefile( path, json );
		success = true;
	}
	else 
	{
		success = false;
	}
	self notify( "pers_fs_result_new", success );
}

PERS_LOAD_EXISTING_PLAYER_ENTRY( path, arg2, arg3 )
{
	if ( fileexists( path ) )
	{
		buffer = readfile( path );
		self.player_fields = jsonparse( buffer );
		success = true;
	}
	else 
	{
		success = false;
	}
	self notify( "pers_fs_result_load", success );
}

PERS_DELETE_PLAYER_ENTRY( path, arg2, arg3 )
{
	if ( fileexists( path ) )
	{
		removefile( path );
		success = true;
	}
	else 
	{
		succes = false;
	}
	self notify( "pers_fs_result_delete", success );
}

PERS_UPDATE_PLAYER_ENTRY( path, arg2, arg3 )
{
	if ( !isDefined( self.player_fields ) )
	{
		success = false;
	}
	else if ( fileexists( path ) )
	{
		json = jsonserialize( self.player_fields, 4 );
		writefile( path, json );
		success = true;
	}
	else 
	{
		success = false;
	}
	self notify( "pers_fs_result_update", success );
}

PERS_GET_PLAYER_ENTRY_FIELD_VALUE( path, fieldname, arg3 )
{
	if ( isDefined( self ) )
	{
		return self.player_fields[ fieldname ];
	}
	return undefined;
}

PERS_SET_PLAYER_ENTRY_FIELD_VALUE( path, fieldname, value )
{
	if ( isDefined( self ) )
	{
		self.player_fields[ fieldname ] = value;
		json = jsonserialize( self.player_fields, 4 );
		writefile( path, json );
		success = true;
	}
	else 
	{
		success = false;
	}
	self notify( "pers_fs_result_set", success );
}