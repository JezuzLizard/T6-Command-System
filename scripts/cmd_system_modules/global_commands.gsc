#include scripts\cmd_system_modules\_cmd_util;
#include scripts\cmd_system_modules\_com;
#include scripts\cmd_system_modules\_listener;
#include scripts\cmd_system_modules\_perms;
#include scripts\cmd_system_modules\_text_parser;
#include scripts\cmd_system_modules\_filesystem;
#include scripts\cmd_system_modules\_persistence;

#include common_scripts\utility;
#include maps\mp\_utility;

CMD_RANDOMNEXTMAP_f( arg_list )
{
	result = [];
	if ( sessionModeIsZombiesGame() )
	{
		if ( level.mod_integrations[ "cut_tranzit_locations" ] )
		{
			string = getDvarStringDefault( "tcs_random_map_list", "prison rooftop tomb processing nuked gcellblock gstreet gfarm gtown gdepot gdiner gtunnel gpower sfarm stown sdepot sdiner stunnel spower" );
		}
		else 
		{
			string = getDvarStringDefault( "tcs_random_map_list", "prison rooftop tomb processing nuked gcellblock gstreet gfarm gtown gdepot sfarm stown sdepot" );
		}
	}
	else 
	{
		string = getDvarStringDefault( "tcs_random_map_list", "aftermath cargo carrier drone express hijacked meltdown overflow plaza raid slums village turbine yemen nuketown downhill mirage hydro grind encore magma vertigo studio uplink detour cove rush dig frost pod takeoff" );
	}
	alias_keys = strTok( string, " " );
	random_alias = alias_keys[ randomInt( alias_keys.size ) ];
	rotation_data = find_map_data_from_alias( random_alias );
	if ( sessionModeIsZombiesGame() )
	{
		rotation_string = va( "exec zm_%s_%s.cfg map %s", rotation_data[ "gamemode" ], rotation_data[ "location" ], rotation_data[ "mapname" ] );
	}
	else 
	{
		rotation_string = va( "exec %s.cfg map %s", getDvar( "g_gametype" ), rotation_data[ "mapname" ] );
	}
	setDvar( "sv_maprotationCurrent", rotation_string );
	result[ "filter" ] = "cmdinfo";
	result[ "message" ] = "Set new secret random map";
	return result;
}

CMD_RESETROTATION_f( arg_list )
{
	result = [];
	setDvar( "sv_maprotationCurrent", getDvar( "sv_maprotation" ) );
	result[ "filter" ] = "cmdinfo";
	result[ "message" ] = "Successfully reset the map rotation";
	return result;
}

CMD_NEXTMAP_f( arg_list )
{
	result = [];
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
			setDvar( "sv_maprotationCurrent", rotation_string );
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = va( "Successfully set next map to %s", display_name );
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = va( "Bad map alias %s", alias );
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage nextmap <mapalias>";
	}
	return result;
}

CMD_LOCK_SERVER_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		password = arg_list[ 0 ];
		setDvar( "g_password", password );
		result[ "filter" ] = "cmdinfo";
		result[ "message" ] = va( "Successfully locked the server with key %s", password );
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage lock <password>";
	}
	return result;
}

CMD_UNLOCK_SERVER_f( arg_list )
{
	result = [];
	setDvar( "g_password", "" );
	result[ "filter" ] = "cmdinfo";
	result[ "message" ] = "Successfully unlocked the server";
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
		result[ "message" ] = va( "Successfully set %s to %s", dvar_name, dvar_value );
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage dvar <dvarname> <newval>";
	}
	return result;
}

CMD_KICK_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		target = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( target ) )
		{
			if ( is_true( self.is_server ) || ( self.player_fields[ "perms" ][ "cmdpower_server" ] > target.player_fields[ "perms" ][ "cmdpower_server" ] ) )
			{
				if ( isDefined( arg_list[ 1 ] ) )
				{
					reason_args = arg_list;
					arrayRemoveIndex( reason_args, 0 );
					reason = repackage_args( reason_args );
					reason = "Kicked for " + reason;
					executecommand( va( "clientkick_for_reason %s \"%s\"", target getEntityNumber(), reason ) );
				}
				else 
				{
					kick( target getEntityNumber() );
				}
				result[ "filter" ] = "cmdinfo";
				result[ "message" ] = va( "Successfully kicked %s", target.name );
			}
			else 
			{
				result[ "filter" ] = "cmderror";
				result[ "message" ] = "Insufficient cmdpower to kick " + target.name + "'s";
			}
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage kick <name|guid|clientnum>";
	}
	return result;
}

CMD_CVARALL_f( arg_list )
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
		new_dvar = [];
		new_dvar[ "name" ] = dvar_name;
		new_dvar[ "value" ] = dvar_value; 
		level.clientdvars[ level.clientdvars.size ] = new_dvar;
		result[ "filter" ] = "cmdinfo";
		result[ "message" ] = va( "Successfully set %s to %s for all players", dvar_name, dvar_value );
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage cvarall <cvarname> <newval>";
	}
	return result;
}

CMD_SETCVAR_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) && arg_list.size == 3 )
	{
		player = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( player ) )
		{
			dvar_name = arg_list[ 1 ];
			dvar_value = arg_list[ 2 ];
			player setClientDvar( dvar_name, dvar_value );
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = va( "Successfully set %s %s to %s", player.name, dvar_name, dvar_value );
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Failed to set cvar due to missing params";
	}
	return result;
}

CMD_MUTE_PLAYER_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		player_object = arg_list[ 0 ];
		duration = arg_list[ 1 ];
		target = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( target ) )
		{
			if ( is_true( self.is_server ) || ( self.player_fields[ "perms" ][ "cmdpower_server" ] > target.player_fields[ "perms" ][ "cmdpower_server" ] ) )
			{
				if ( isDefined( duration ) )
				{
					target.player_fields[ "penalties" ][ "chat_muted" ] = true;
					target.player_fields[ "penalties" ][ "chat_muted_time" ] = getUTC();
					target.player_fields[ "penalties" ][ "perm_chat_length" ] = int( duration ) * 60;
					result[ "filter" ] = "cmdinfo";
					result[ "message" ] = va( "Successfully muted %s for %s minutes", target.name, duration );
					target unmute_player_thread();
				}
				else 
				{
					target.player_fields[ "penalties" ][ "perm_chat_muted" ] = true;
					result[ "filter" ] = "cmdinfo";
					result[ "message" ] = va( "Successfully muted %s permanently", target.name );
				}
				target thread ADD_PERS_FS_FUNC_TO_QUEUE( "update" );
			}
			else 
			{
				result[ "filter" ] = "cmderror";
				result[ "message" ] = "Insufficient cmdpower to mute " + target.name;
			}
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage mute <name|guid|clientnum> [duration_in_minutes]";
	}
	return result;
}

CMD_UNMUTE_PLAYER_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		target = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( target ) )
		{
			target.player_fields[ "penalties" ][ "perm_chat_muted" ] = false;
			target.player_fields[ "penalties" ][ "chat_muted" ] = false;
			target.player_fields[ "penalties" ][ "chat_muted_time" ] = 0;
			target.player_fields[ "penalties" ][ "perm_chat_length" ] = 0;
			target thread ADD_PERS_FS_FUNC_TO_QUEUE( "update" );
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = va( "Successfully unmuted %s", target.name );
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage unmute <name|guid|clientnum>";
	}
	return result;	
}

CMD_TOGGLECHAT_f( arg_list )
{
	result = [];
	level.tcs_chat_disabled = !is_true( level.tcs_chat_disabled );
	on_off = cast_bool_to_str( level.tcs_chat_disabled, "off on" );
	result[ "filter" ] = "cmdinfo";
	result[ "message" ] = va( "Chat is toggled %s", on_off );	
	return result;
}

CMD_TOGGLETEAMCHANGING_f( arg_list )
{
	result = [];
	on_off = ( level.allow_teamchange == "0" ? "on" : "off" );
	if ( on_off == "on" )
	{
		level.allow_teamchange = "1";
	}
	else 
	{
		level.allow_teamchange = "0";
	}
	result[ "filter" ] = "cmdinfo";
	result[ "message" ] = va( "Team changning is toggled %s", on_off );	
	return result;
}

CMD_SETROTATION_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		new_rotation = getDvar( arg_list[ 0 ] );
		if ( new_rotation != "" )
		{
			setDvar( "sv_maprotationCurrent", new_rotation );
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = va( "Successfully set the rotation to %s's value", new_rotation );
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "New rotation dvar is blank";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage: setrotation <rotationdvar>";
	}
	return result;
}

CMD_GIVEGOD_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		target = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( target ) )
		{
			if ( ( target.flags & level.FL_GODMODE ) != 0 )
			{
				target.flags &= level.FL_GODMODE;
			}
			else 
			{
				target.flags |= level.FL_GODMODE;
			}
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = va( "Successfully toggled godmode for %s", target.name );
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage givegod <name|guid|clientnum|self>";
	}
	return result;
}

CMD_GIVENOTARGET_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		target = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( target ) )
		{
			if ( ( target.flags & level.FL_NOTARGET ) != 0 )
			{
				target.flags &= level.FL_NOTARGET;
			}
			else 
			{
				target.flags |= level.FL_NOTARGET;
			}
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = va( "Successfully toggled notarget for %s", target.name );
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage givenotarget <name|guid|clientnum|self>";
	}
	if ( isDefined( target ) )
	{

	}
	return result;
}

CMD_GIVENOCLIP_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		target = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( target ) )
		{
			if ( ( target.flags & level.CFL_NOCLIP ) != 0 )
			{
				target.clientflags &= level.CFL_NOCLIP;
			}
			else 
			{
				target.clientflags |= level.CFL_NOCLIP;
			}
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = va( "Successfully toggled noclip for %s", target.name );
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage givenoclip <name|guid|clientnum|self>";
	}
	return result;
}

CMD_CLANTAG_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		target = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( target ) )
		{
			if ( isDefined( arg_list[ 1 ] ) )
			{
				target setClanTag( arg_list[ 1 ] );
				result[ "filter" ] = "cmdinfo";
				result[ "message" ] = va( "Successfully set %s's clantag to %s", target.name, arg_list[ 0 ] );
			}
			else 
			{
				target resetClanTag();
				result[ "filter" ] = "cmdinfo";
				result[ "message" ] = va( "Successfully reset %s's clantag", target.name );
			}
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage: clantag <name|guid|clientnum> <newtag>";
	}
	return result;
}

CMD_GIVEINVISIBLE_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		target = self find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( target ) )
		{
			if ( !is_true( target.tcs_is_invisible ) )
			{
				target hide();
				target.tcs_is_invisible = true;
			}
			else 
			{
				target show();
				target.tcs_is_invisible = false;
			}
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = "Toggled invisibility for " + target.name;
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";
		}
	}
	else
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage giveinvisible <name|guid|clientnum|self>";
	}
	if ( isDefined( target ) )
	{

	}
	return result;
}

CMD_SETRANK_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		target = self find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( target ) )
		{
			if ( isDefined( arg_list[ 1 ] ) )
			{
				if ( is_true( self.is_server ) || ( self.player_fields[ "perms" ][ "cmdpower_server" ] > target.player_fields[ "perms" ][ "cmdpower_server" ] ) )
				{
					switch ( arg_list[ 1 ] )
					{
						case "none":
							new_cmdpower_server = level.CMD_POWER_NONE;
							new_cmdpower_client = level.CMD_POWER_NONE;
							new_rank = level.TCS_RANK_NONE;
							break;
						case "user":
							new_cmdpower_server = level.CMD_POWER_USER;
							new_cmdpower_client = level.CMD_POWER_USER;
							new_rank = level.TCS_RANK_USER;
							break;
						case "trs":
						case "trusted":
							new_cmdpower_server = level.CMD_POWER_TRUSTED_USER;
							new_cmdpower_client = level.CMD_POWER_TRUSTED_USER;
							new_rank = level.TCS_RANK_TRUSTED_USER;
							break;
						case "ele":
						case "elevated":
							new_cmdpower_server = level.CMD_POWER_ELEVATED_USER;
							new_cmdpower_client = level.CMD_POWER_ELEVATED_USER;
							new_rank = level.TCS_RANK_ELEVATED_USER;
							break;
						case "mod":
						case "moderator":
							new_cmdpower_server = level.CMD_POWER_MODERATOR;
							new_cmdpower_client = level.CMD_POWER_MODERATOR;
							new_rank = level.TCS_RANK_MODERATOR;
							break;
						case "cht":
						case "cheat":
						case "admin":
							new_cmdpower_server = level.CMD_POWER_ADMIN;
							new_cmdpower_client = level.CMD_POWER_ADMIN;
							new_rank = level.TCS_RANK_ADMIN;
							break;
						case "owner":
							new_cmdpower_server = level.CMD_POWER_OWNER;
							new_cmdpower_client = level.CMD_POWER_OWNER;
							new_rank = level.TCS_RANK_OWNER;
							break;
						default:
							break;
					}
					if ( isDefined( new_rank ) )
					{
						target.player_fields[ "rank" ] = new_rank;
						target.player_fields[ "perms" ][ "cmdpower_server" ] = new_cmdpower_server;
						target.player_fields[ "perms" ][ "cmdpower_client" ] = new_cmdpower_client;
						target thread ADD_PERS_FS_FUNC_TO_QUEUE( "update" );
						target set_clantag();
						level COM_PRINTF( target COM_GET_CMD_FEEDBACK_CHANNEL(), "cmdinfo", "Your new rank is " + new_rank, target );
						result[ "filter" ] = "cmdinfo";
						result[ "message" ] = "Target's new rank is " + new_rank;						
					}
					else 
					{
						result[ "filter" ] = "cmderror";
						result[ "message" ] = "Invalid rank " + arg_list[ 1 ];
					}
				}
				else 
				{
					result[ "filter" ] = "cmderror";
					result[ "message" ] = "Insufficient cmdpower to set " + target.name + "'s rank";
				}
			}
			else 
			{
				result[ "filter" ] = "cmderror";
				result[ "message" ] = "Usage setrank <name|guid|clientnum|self> <rank>";	
			}
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Could not find player";	
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "Usage setrank <name|guid|clientnum|self> <rank>";	
	}
	return result;
}

/*
	Executes a client command on all players in the server. 
*/
CMD_EXECONALLPLAYERS_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		cmd_to_execute = get_client_cmd_from_alias( arg_list[ 0 ] );
		if ( cmd_to_execute != "" )
		{
			var_args = [];
			for ( i = 1; i < arg_list.size; i++ )
			{
				var_args[ i - 1 ] = arg_list[ i ];
			}
			foreach ( player in level.players )
			{
				player thread CMD_EXECUTE( cmd_to_execute, var_args, true, level.tcs_use_silent_commands, true );
			}
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = "Executed " + cmd_to_execute + " on all players";			
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			if ( isDefined( arg_list[ 0 ] ) )
			{
				result[ "message" ] = "Cmd " + arg_list[ 0 ] + " is invalid";
			}
			else 
			{
				result[ "message" ] = "Cmd is invalid";
			}
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "execonallplayers <cmdname> [cmdargs]...";
	}
	return result;
}

CMD_EXECONTEAM_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		team = arg_list[ 0 ];
		cmd = arg_list[ 1 ];
		if ( isDefined( level.teams[ team ] ) )
		{
			cmd_to_execute = get_client_cmd_from_alias( cmd );
			if ( cmd_to_execute != "" )
			{
				var_args = [];
				for ( i = 2; i < arg_list.size; i++ )
				{
					var_args[ i - 2 ] = arg_list[ i ];
				}
				players = getPlayers( team );
				foreach ( player in players )
				{
					player thread CMD_EXECUTE( cmd_to_execute, var_args, true, level.tcs_use_silent_commands, true );
				}
				result[ "filter" ] = "cmdinfo";
				result[ "message" ] = "Executed " + cmd_to_execute + " on team " + team;			
			}
			else 
			{
				result[ "filter" ] = "cmderror";
				if ( isDefined( cmd ) )
				{
					result[ "message" ] = "Cmd " + cmd + " is invalid";
				}
				else 
				{
					result[ "message" ] = "Cmd is invalid";
				}
			}
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "Team " + team + " is invalid";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "execonteam <team> <cmdname> [cmdargs]...";
	}
	return result;	
}