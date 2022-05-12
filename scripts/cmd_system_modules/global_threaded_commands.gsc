#include scripts\cmd_system_modules\_cmd_util;
#include scripts\cmd_system_modules\_com;
#include scripts\cmd_system_modules\_listener;
#include scripts\cmd_system_modules\_perms;
#include scripts\cmd_system_modules\_text_parser;

#include common_scripts\utility;
#include maps\mp\_utility;

CMD_CHANGEMAP_f( arg_list )
{
	self notify( "changemap_f" );
	self endon( "changemap_f" );
	channel = self COM_GET_CMD_FEEDBACK_CHANNEL();
	if ( array_validate( arg_list ) )
	{
		alias = arg_list[ 0 ];
		rotation_data = find_map_data_from_alias( alias );
		if ( rotation_data[ "mapname" ] != "" )
		{
			if ( sessionModeIsZombiesGame() )
			{
				display_name = get_ZM_map_display_name_from_location_gametype( rotation_data[ "location" ], rotation_data[ "gametype" ] );
				rotation_string = va( "exec zm_%s_%s.cfg map %s", rotation_data[ "gamemode" ], rotation_data[ "location" ], rotation_data[ "mapname" ] );
			}
			else 
			{
				display_name = get_MP_map_name( rotation_data[ "mapname" ] );
				rotation_string = va( "exec %s.cfg map %s", getDvar( "g_gametype" ), rotation_data[ "mapname" ] );
			}
			message = va( "%s second rotate to map %s countdown started.", level.custom_commands_restart_countdown + "", display_name );
			level COM_PRINTF( "g_log", "cmdinfo", va( "Changemap Usage: %s changed map to %s.", self.name, display_name ), self );
			level COM_PRINTF( "say|con", "notitle", message, self );
			setDvar( "sv_maprotationCurrent", rotation_string );
			for ( i = level.custom_commands_restart_countdown; i > 0; i-- )
			{
				level COM_PRINTF( "con|say", "notitle", va( "%s seconds", i ) );
				wait 1;
			}
			level notify( "end_commands" );
			wait 0.5;
			exitLevel( false );
			return;
		}
		level COM_PRINTF( channel, "cmderror", va( "alias %s is invalid.", alias ), self );
	}
	else 
	{
		level COM_PRINTF( channel, "cmderror", "Usage changemap <mapalias>", self );
	}
}

CMD_ROTATE_f( arg_list )
{
	self notify( "rotate_f" );
	self endon( "rotate_f" );
	message = va( "%s second rotate countdown started", level.custom_commands_restart_countdown + "", self );
	level COM_PRINTF( "g_log", "cmdinfo", va( "Rotate Usage: %s rotated the map.", self.name ), self );
	level COM_PRINTF( "say|con", "notitle", message, self );
	for ( i = level.custom_commands_restart_countdown; i > 0; i-- )
	{
		wait 1;
		level COM_PRINTF( "con|say", "notitle", va( "%s seconds", i ) );
	}
	level notify( "end_commands" );
	wait 0.5;
	exitLevel( false );
}

CMD_RESTART_f( arg_list )
{
	self notify( "restart_f" );
	self endon( "restart_f" );
	message = va( "%s second restart countdown started", level.custom_commands_restart_countdown + "" );
	level COM_PRINTF( "g_log", "cmdinfo", va( "Restart Usage: %s restarted the map.", self.name ), self );
	level COM_PRINTF( "say|con", "notitle", message, self );
	for ( i = level.custom_commands_restart_countdown; i > 0; i-- )
	{
		wait 1;
		level COM_PRINTF( "con|say", "notitle", va( "%s seconds", i ) );
	}
	level notify( "end_commands" );
	wait 0.5;
	map_restart( false );
}