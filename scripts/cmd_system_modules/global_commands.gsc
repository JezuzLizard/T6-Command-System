#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;
#include scripts/zm/promod/utility/_grief_util;
#include maps/mp/zombies/_zm_perks;
#include scripts/zm/promod/zgriefp;
#include scripts/zm/promod/zgriefp_overrides;
#include scripts/zm/promod/utility/_vote;
#include scripts/zm/promod/utility/_com;
#include scripts/zm/promod/_gametype_setup;
#include scripts/zm/promod/utility/_text_parser;

CMD_VOTESTART_f( arg_list )
{
	channel = self COM_GET_CMD_FEEDBACK_CHANNEL();
	if ( !is_true( self.is_server ) && !is_true( self.is_admin ) )
	{
		if ( is_true( self.vote_started ) )
		{
			COM_PRINTF( channel, "cmderror", "vote:start: You cannot start a new vote for the remainder of this match.", self );
			return;
		}
	}
	if ( is_true( level.vote_in_progress ) )
	{
		COM_PRINTF( channel, "cmderror", va( "vote:start: You cannot start a new vote until the current vote is finished in %s seconds.", level.vote_in_progress_timeleft ), self );
		return;
	}
	key_type = arg_list[ 0 ];
	cmd_arg_1 = arg_list[ 1 ];
	cmd_arg_2 = arg_list[ 2 ];
	cmd_arg_3 = arg_list[ 3 ];
	cmd_arg_4 = arg_list[ 4 ];
	if ( !isDefined( key_type ) )
	{
		COM_PRINTF( channel, "cmderror", "vote:start: Missing params, 2 args required <key_type>, <key_value>.", self );
		return;
	}
	if ( level.vote_start_anonymous )
	{
		name = "Anon";
	}
	else 
	{
		name = self.name;
	}
	cmd_alias_keys = getArrayKeys( level.custom_votes );
	cmd_index = get_alias_index( key_type, cmd_alias_keys );
	if ( cmd_index != -1 )
	{
		func_args = [];
		func_args[ 0 ] = name;
		func_args[ 1 ] = cmd_arg_1;
		func_args[ 2 ] = cmd_arg_2;
		func_args[ 3 ] = cmd_arg_3;
		func_args[ 4 ] = cmd_arg_4;
		pre_message_result = self [[ level.custom_votes[ cmd_alias_keys[ cmd_index ] ].pre_func ]]( func_args );
		COM_PRINTF( pre_message_result[ "channels" ], pre_message_result[ "filter" ], pre_message_result[ "message" ], self );
		if ( pre_message_result[ "filter" ] == "cmderror" )
		{
			return;
		}
	}
	else 
	{
		COM_PRINTF( channel, "cmderror", va( "vote:start: Unsupported key_type %s recevied." ), self );
		return;
	}
	COM_PRINTF( "con say", "notitle", va( "You have %s seconds to cast your vote.", level.vote_timeout ), self );
	COM_PRINTF( "con say", "notitle", "Do /yes or /no to vote.", self );
	COM_PRINTF( "con say", "notitle", "Outcome is determined from players who cast a vote, not from the total players.", self );
	level thread vote_timeout_countdown();
	level.vote_in_progress_votes = [];
	foreach ( player in level.players )
	{
		if ( player != self )
		{
			player thread player_track_vote();
		}
	}
	level thread count_votes();
	level.vote_in_progress = true;
	self.vote_started = true;
	level waittill( "vote_ended", result );
	level.vote_in_progress = false;
	if ( !result )
	{
		return;
	}
	self [[ level.custom_votes[ cmd_alias_keys[ cmd_index ] ].post_func ]]( func_args );
}

CMD_RANDOMNEXTMAP_f( arg_list )
{
	string = "c s f t b d tu p";
	alias_keys = strTok( string, " " );
	random_alias = random( alias_keys );
	rotation_data = find_map_data_from_alias( random_alias );
	if ( sessionModeIsZombiesGame() )
	{
		rotation_string = va( "exec zm_%s_%s.cfg map %s", rotation_data[ "gamemode" ], rotation_data[ "location" ], rotation_data[ "mapname" ] );
	}
	else 
	{
		rotation_string = va( "exec %s.cfg map %s", rotation_data[ "gamemode" ], rotation_data[ "mapname" ] );
	}
	setDvar( "sv_maprotation", rotation_string );
	setDvar( "sv_maprotationCurrent", rotation_string );
	result[ "filter" ] = "cmdinfo";
	result[ "message" ] = "admin:randomnextmap: Set new secret random map";
	return result;
}

CMD_RESETROTATION_f( arg_list )
{
	setDvar( "sv_maprotation", getDvar( "sv_maprotation_old" ) );
	setDvar( "sv_maprotationCurrent", getDvar( "sv_maprotation_old" ) );
	result[ "filter" ] = "cmdinfo";
	result[ "message" ] = "admin:resetrotation: Successfully reset the map rotation";
	return result;
}

CMD_CHANGEMAP_f( arg_list )
{
	self notify( "changemap_f" );
	self endon( "changemap_f" );
	channel = self COM_GET_CMD_FEEDBACK_CHANNEL();
	if ( array_validate( arg_list ) )
	{
		alias = toLower( arg_list[ 0 ] );
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
			message = va( "admin:changemap: %s second rotate to map %s countdown started", level.custom_commands_restart_countdown, display_name );
			COM_PRINTF( "g_log say con", "cmdinfo", self.name + " executed " + message );
			setDvar( "sv_maprotation", rotation_string );
			setDvar( "sv_maprotationCurrent", rotation_string );
			for ( i = level.custom_commands_restart_countdown; i > 0; i-- )
			{
				COM_PRINTF( "con say", "cmdinfo", va( "%s seconds", i ) );
				wait 1;
			}
			level notify( "end_commands" );
			wait 0.5;
			exitLevel( false );
			return;
		}
	}
	COM_PRINTF( channel, "cmderror", va( "admin:changemap: alias %s is invalid", alias ), self );
}

CMD_NEXTMAP_f( arg_list )
{
	if ( array_validate( arg_list ) )
	{
		alias = toLower( arg_list[ 0 ] );
		rotation_data = find_map_data_from_alias( alias );
		if ( rotation_data[ "mapname" ] != "" )
		{
			if ( sessionModeIsZombiesGame() )
			{
				display_name = get_ZM_map_display_name_from_location_gametype( rotation_data[ "location" ] );
				rotation_string = va( "exec zm_%s_%s.cfg map %s", rotation_data[ "gamemode" ], rotation_data[ "location" ], rotation_data[ "mapname" ] );
			}
			else 
			{
				display_name = get_MP_map_name( rotation_data[ "mapname" ] );
				rotation_string = va( "exec %s.cfg map %s", rotation_data[ "gamemode" ], rotation_data[ "mapname" ] );
			}
			setDvar( "sv_maprotation", rotation_string );
			setDvar( "sv_maprotationCurrent", rotation_string );
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = va( "admin:nextmap: Successfully set next map to %s", display_name );
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = va( "admin:nextmap: Bad map alias %s", alias );
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "admin:nextmap: Failed to set next map due to missing param";
	}
	return result;
}

CMD_ROTATE_f( arg_list )
{
	self notify( "rotate_f" );
	self endon( "rotate_f" );
	message = va( "admin:rotate: %s second rotate countdown started", level.custom_commands_restart_countdown );
	COM_PRINTF( "g_log say con" + channel, "cmdinfo", self.name + " executed " + message );
	for ( i = level.custom_commands_restart_countdown; i > 0; i-- )
	{
		wait 1;
		COM_PRINTF( "con say", "cmdinfo", va( "%s seconds", i ) );
	}
	level notify( "end_commands" );
	wait 0.5;
	exitLevel( false );
}

CMD_RESTART_f( arg_list )
{
	self notify( "restart_f" );
	self endon( "restart_f" );
	message = va( "admin:restart: %s second restart countdown started", level.custom_commands_restart_countdown );
	COM_PRINTF( "g_log say con", "cmdinfo", self.name + " executed " + message );
	for ( i = level.custom_commands_restart_countdown; i > 0; i-- )
	{
		wait 1;
		COM_PRINTF( "con say", "cmdinfo", va( "%s seconds", i ) );
	}
	level notify( "end_commands" );
	wait 0.5;
	map_restart( false );
}

CMD_PLAYERLIST_f( arg_list )
{
	self notify( "listener_playerlist" );
	self endon( "listener_playerlist" );
	channel = self COM_GET_CMD_FEEDBACK_CHANNEL();
	current_page = 1;
	user_defined_page = 1;
	if ( array_validate( arg_list ) )
	{
		team_name = arg_list[ 0 ];
	}
	if ( isDefined( team_name ) && isDefined( level.teams[ team_name ] ) )
	{
		players = getPlayers( team_name );
	}
	else 
	{
		players = getPlayers();
	}
	remaining_players = players.size;
	remaining_pages = ceil( remaining_players / level.custom_commands_page_max );
	for ( j = 0; j < players.size; j++ )
	{
		message = va( "^3%s ^2%s ^4%s", players[ i ].name, players[ i ] getGUID(), players[ i ] getEntityNumber() ); //remember to add rank as a listing option
		if ( channel == "con" )
		{
			COM_PRINTF( channel, "cmdinfo", message, self );
		}
		else 
		{
			cmds_to_display[ cmds_to_display.size ] = message;
		}
		remaining_players--;
		if ( ( cmds_to_display.size > remaining_pages ) && channel == "tell" && remaining_players != 0 )
		{
			if ( current_page == user_defined_page )
			{
				foreach ( message in cmds_to_display )
				{
					COM_PRINTF( channel, "cmdinfo", message, self );
				}
				COM_PRINTF( channel, "cmdinfo", va( "Displaying page %s out of %s do /showmore or /page(num) to display more players.", current_page, remaining_pages ), self );
				setup_temporary_command_listener( "listener_playerlist", level.custom_commands_listener_timeout, self );
				result = wait_temporary_command_listener( listener_name )
				clear_temporary_command_listener( "listener_playerlist", self );
				if ( result[ 0 ] == "timeout" )
				{
					return;
				}
				else if ( isSubStr( result[ 0 ], "page" ) )
				{
					user_defined_page = int( result[ 1 ] );
					if ( !isDefined( user_defined_page ) )
					{
						COM_PRINTF( channel, "cmderror", va( "Page number arg sent to utility:cmdlist is undefined. Valid inputs are 1 thru %s.", remaining_pages ), self );
						return;
					}
					if ( user_defined_page > remaining_pages || user_defined_page == 0 )
					{
						COM_PRINTF( channel, "cmderror", va( "Page number %s sent to utility:cmdlist is invalid. Valid inputs are 1 thru %s.", result[ 1 ], remaining_pages ), self );
						return;
					}
				}
				else if ( result[ 0 ] == "showmore" )
				{
					user_defined_page++;
				}
			}
			current_page++;
			cmds_to_display = [];
		}
		else if ( remaining_players == 0 )
		{
			foreach ( message in cmds_to_display )
			{
				COM_PRINTF( channel, "cmdinfo", message, self );
			}
		}
	}
}

CMD_LOCK_SERVER_f( arg_list )
{
	if ( array_validate( arg_list ) )
	{
		password = arg_list[ 0 ];
		setDvar( "g_password", password );
		result[ "filter" ] = "cmdinfo";
		result[ "message" ] = va( "admin:lock: Successfully locked the server with key %s", password );
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "admin:lock: Failed to lock server due to missing param";
	}
	return result;
}

CMD_UNLOCK_SERVER_f( arg_list )
{
	setDvar( "g_password", "" );
	result[ "filter" ] = "cmdinfo";
	result[ "message" ] = "admin:unlock: Successfully unlocked the server";
	return result;
}

CMD_SERVER_DVAR_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) && arg_list.size == 2 )
	{
		dvar_name = arg_list[ 0 ];
		dvar_value = arg_list[ 1 ];
		setDvar( dvar_name, dvar_value );
		result[ "filter" ] = "cmdinfo";
		result[ "message" ] = va( "admin:dvar: Successfully set %s to %s", dvar_name, dvar_value );
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "admin:dvar: Failed to set dvar due to missing params";
	}
	return result;
}

CMD_ADMIN_KICK_f( arg_list )
{
	result = [];
	kicked = false;
	if ( array_validate( arg_list ) )
	{
		player_data = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( player_data ) )
		{
			kick( player_data[ "clientnum" ] );
			kicked = true;
		}
	}
	if ( kicked )
	{
		result[ "filter" ] = "cmdinfo";
		result[ "message" ] = va( "admin:kick: Successfully kicked %s", player.name );
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = va( "admin:kick: Failed to kick %s", player.name );
	}
	return result;
}

CMD_ADMIN_CVAR_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) && arg_list.size == 2 )
	{
		dvar_name = arg_list[ 0 ];
		dvar_value = arg_list[ 1 ];
		self setClientDvar( dvar_name, dvar_value );
		result[ "filter" ] = "cmdinfo";
		result[ "message" ] = va( "client:cvar: Successfully set %s %s to %s", self.name, dvar_name, dvar_value );
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = va( "client:cvar: Failed to set cvar for %s due to missing params", self.name );
	}
	return result;
}

CMD_CLIENT_CVARALL_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) && arg_list.size == 2 )
	{
		dvar_name = arg_list[ 0 ];
		dvar_value = arg_list[ 1 ];
		foreach ( player in level.players )
		{
			player setClientDvar( dvar_name, dvar_value );
		}
		result[ "filter" ] = "cmdinfo";
		result[ "message" ] = va( "admin:cvarall: Successfully set %s to %s for all players", dvar_name, dvar_value );
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = va( "admin:cvarall: Failed to set cvar for all players due to missing params", self.name );
	}
	return result;
}

CMD_ADDCOMMANDLISTENER( listener_name, listener_cmd )
{
	if ( !isDefined( level.listener_commands ) )
	{
		level.listener_commands = [];
	}
	if ( !isDefined( level.listener_commands[ listener_name ] ) )
	{
		level.listener_commands[ listener_name ] = [];
	}
	if ( !isDefined( level.listener_commands[ listener_name ][ listener_cmd ] ) )
	{
		level.listener_commands[ listener_name ][ listener_cmd ] = true;
	}
}

CMD_ISCOMMANDLISTENER( listener_name, listener_cmd )
{
	return is_true( level.listener_commands[ listener_name ][ listener_cmd ] );
}

CMD_EXECUTELISTENER( listener_name, arg_list )
{
	self.temp_listeners[ listener_name ].data = arg_list;
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

//Command struture - namespace:cmd(...);
/*public*/ COMMAND_BUFFER()
{
	level endon( "end_commands" );
	level thread end_commands_on_end_game();
	while ( true )
	{
		level waittill( "say", message, player, ishidden );
		if ( isDefined( player ) && !isSubStr( message, ":" ) && !array_validate( player.temp_listeners ) )
		{
			continue;
		}
		/*
		if ( isDefined( player ) && !ishidden && !is_command_token( message[ 0 ] ) )
		{
			continue;
		}
		*/
		if ( !isDefined( player ) )
		{
			player = level.server;
		}
		found_listener = false;
		message = toLower( message );
		if ( array_validate( player.temp_listeners ) )
		{
			listener_cmds_args = strTok( message, " " );
			cmdname = listener_cmds_args[ 0 ];
			listener_keys = getArrayKeys( player.temp_listeners );
			foreach ( listener in listener_keys )
			{
				if ( CMD_ISCOMMANDLISTENER( listener, cmdname ) )
				{
					player CMD_EXECUTELISTENER( listener, listener_cmds_args );
					found_listener = true;
					break;
				}
			}
			if ( found_listener )
			{
				continue;
			}
		}
		channel = player COM_GET_CMD_FEEDBACK_CHANNEL();
		if ( isDefined( player.cmd_cooldown ) && player.cmd_cooldown > 0 )
		{
			COM_PRINTF( channel, "cmderror", va( "You cannot use another command for %s seconds", player.cmd_cooldown ), player );
			continue;
		}
		multi_cmds = parse_cmd_message( message );
		if ( !array_validate( multi_cmds ) )
		{
			continue;
		}
		if ( multi_cmds.size > 1 && !player can_use_multi_cmds() )
		{
			temp_array_index = multi_cmds[ 0 ];
			multi_cmds = [];
			multi_cmds[ 0 ] = temp_array_index;
		}
		for ( cmd_index = 0; cmd_index < multi_cmds.size; cmd_index++ )
		{
			namespace = toLower( multi_cmds[ cmd_index ][ "namespace" ] );
			cmdname = toLower( multi_cmds[ cmd_index ][ "cmdname" ] );
			args = multi_cmds[ cmd_index ][ "args" ];
			if ( !player has_permission_for_cmd( namespace, cmdname ) )
			{
				COM_PRINTF( "tell", "cmderror", va( "You do not have permission to use %s command.", cmdname ), player );
			}
			else 
			{
				player CMD_EXECUTE( namespace, cmdname, args );
				player thread CMD_COOLDOWN();
			}
		}
	}
}

CMD_COOLDOWN()
{
	if ( is_true( self.is_server ) )
	{
		return;
	}
	if ( is_true( self.is_admin ) )
	{
		return;
	}
	player_guid = self getGUID();
	foreach ( guid in level.server_users[ "admins" ].guids )
	{
		if ( player_guid == guid )
		{
			self.is_admin = true;
			return;
		}
	}
	player.cmd_cooldown = level.custom_commands_cooldown_time;
	while ( player.cmd_cooldown > 0 )
	{
		player.cmd_cooldown--;
		wait 1;
	}
}

can_use_multi_cmds()
{
	if ( is_true( self.is_server ) )
	{
		return true;
	}
	if ( is_true( self.is_admin ) )
	{
		return true;
	}
	player_guid = self getGUID();
	foreach ( guid in level.server_users[ "admins" ].guids )
	{
		if ( player_guid == guid )
		{
			self.is_admin = true;
			return true;
		}
	}
	return false;
}

/*public*/ has_permission_for_cmd( namespace, cmd )
{
	if ( is_true( self.is_server ) || is_true( self.is_admin ) )
	{
		return true;
	}
	player_guid = self getGUID();
	foreach ( guid in level.server_users[ "admins" ].guids )
	{
		if ( player_guid == guid )
		{
			self.is_admin = true;
			return true;
		}
	}
	foreach ( namespace in level.grief_no_permissions_required_namespaces )
	{
		namespace_keys = strTok( namespace, " " );
		for ( i = 0; i < namespace_keys.size; i++ )
		{
			if ( namespace == namespace_keys[ i ] )
			{
				return true;
			}
		}
	}
	return false;
}

/*private*/ CMD_UTILITY_CMDLIST_f( arg_list )
{
	self notify( "listener_cmdlist" );
	self endon( "listener_cmdlist" );
	namespace_filter = arg_list[ 0 ];
	self.printing_commands = 1;
	cmds_to_display = [];
	channel = self COM_GET_CMD_FEEDBACK_CHANNEL();
	namespace_keys = getArrayKeys( level.custom_commands );
	current_page = 1;
	user_defined_page = 1;
	remaining_cmds = level.custom_commands_total;
	for ( i = 0; i < level.custom_commands_namespaces_total; i++ )
	{
		if ( !isDefined( namespace_filter ) || isSubStr( namespace_filter, namespace_keys[ i ] ) )
		{
			namespace_aliases = strTok( namespace_keys[ i ], " " );
			cmdnames = getArrayKeys( level.custom_commands[ namespace_keys[ i ] ] );
			for ( j = 0; j < cmdnames.size; j++ )
			{
				cmd_aliases = strTok( cmdnames[ j ], " " );
				if ( self has_permission_for_cmd( namespace_aliases[ 0 ], cmd_aliases[ 0 ] ) )
				{
					message = va( "^4%s", level.custom_commands[ namespace_keys[ i ] ][ cmdnames[ j ] ].usage );
					if ( channel == "con" )
					{
						COM_PRINTF( channel, "cmdinfo", message, self );
					}
					else 
					{
						cmds_to_display[ cmds_to_display.size ] = message;
					}
				}
				remaining_cmds--;
				if ( ( cmds_to_display.size > level.custom_commands_page_max ) && channel == "tell" && remaining_cmds != 0 )
				{
					if ( current_page == user_defined_page )
					{
						foreach ( message in cmds_to_display )
						{
							COM_PRINTF( channel, "cmdinfo", message, self );
						}
						COM_PRINTF( channel, "cmdinfo", va( "Displaying page %s out of %s do /showmore or /page(num) to display more commands.", current_page, level.custom_commands_page_count ), self );
						setup_temporary_command_listener( "listener_cmdlist", level.custom_commands_listener_timeout, self );
						result = self wait_temporary_command_listener( "listener_cmdlist" );
						clear_temporary_command_listener( "listener_cmdlist", self );
						if ( result[ 0 ] == "timeout" )
						{
							return;
						}
						else if ( isSubStr( result[ 0 ], "page" ) )
						{
							user_defined_page = int( result[ 1 ] );
							if ( !isDefined( user_defined_page ) )
							{
								COM_PRINTF( channel, "cmderror", va( "Page number arg sent to utility:cmdlist is undefined. Valid inputs are 1 thru %s.", level.custom_commands_page_count ), self );
								return;
							}
							if ( user_defined_page > level.custom_commands_page_count || user_defined_page == 0 )
							{
								COM_PRINTF( channel, "cmderror", va( "Page number %s sent to utility:cmdlist is invalid. Valid inputs are 1 thru %s.", result[ 1 ], level.custom_commands_page_count ), self );
								return;
							}
						}
						else if ( result[ 0 ] == "showmore" )
						{
							user_defined_page++;
						}
					}
					current_page++;
					cmds_to_display = [];
				}
				else if ( remaining_cmds == 0 )
				{
					foreach ( message in cmds_to_display )
					{
						COM_PRINTF( channel, "cmdinfo", message, self );
					}
				}
			}
		}
	}
}

setup_temporary_command_listener( listener_name, timelimit, player )
{
	if ( !isDefined( player.temp_listeners ) )
	{
		player.temp_listeners = [];
	}
	if ( !isDefined( player.temp_listeners[ listener_name ] ) )
	{
		player.temp_listeners[ listener_name ] = spawnStruct();
		player.temp_listeners[ listener_name ].data = [];
		player.temp_listeners[ listener_name ].timeout = false;
		player thread temporary_command_listener_timelimit( listener_name, timelimit );
	}
}

wait_temporary_command_listener( listener_name )
{
	self endon( listener_name );
	result = [];
	while ( true )
	{
		if ( array_validate( self.temp_listeners[ listener_name ].data ) )
		{
			result = self.temp_listeners[ listener_name ].data;
			return result;
		}
		else if ( self.temp_listeners[ listener_name ].timeout )
		{
			result[ 0 ] = "timeout";
			return result;
		}
		wait 0.05;
	}
}

clear_temporary_command_listener( listener_name, player )
{
	arrayRemoveIndex( player.temp_listeners, listener_name );
}

temporary_command_listener_timelimit( listener_name, timelimit )
{
	self endon( listener_name );
	for ( i = timelimit; i > 0; i-- )
	{
		wait 1;
	}
	self.temp_listeners[ listener_name ].timeout = true;
}

/*private*/ end_commands_on_end_game()
{
	level waittill( "end_game" );
	wait 15;
	level notify( "end_commands" );
}

/*public*/ setup_permissions()
{
	level.server_users = [];
	level.server_users[ "admins" ] = spawnStruct();
	level.server_users[ "admins" ].names = [];
	level.server_users[ "admins" ].guids = [];
	level.server_users[ "admins" ].cmd_rate_limit = -1;
	str_keys = strTok( getDvar( "server_admin_guids" ), ";" );
	int_keys = [];
	foreach ( key in str_keys )
	{
		int_keys[ int_keys.size ] = int( key );
	}
	level.server_users[ "admins" ].guids = int_keys;
	level.grief_no_permissions_required_namespaces = [];
	level.grief_no_permissions_required_namespaces[ 0 ] = "vote v";
}