#include scripts/cmd_system_modules/_cmd_util;
#include scripts/cmd_system_modules/_com;
#include scripts/cmd_system_modules/_listener;
#include scripts/cmd_system_modules/_perms;
#include scripts/cmd_system_modules/_text_parser;
#include scripts/cmd_system_modules/_filesystem;

#include common_scripts/utility;
#include maps/mp/_utility;

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
	random_alias = random( alias_keys );
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
	result[ "message" ] = "admin:randomnextmap: Set new secret random map";
	return result;
}

CMD_RESETROTATION_f( arg_list )
{
	result = [];
	setDvar( "sv_maprotationCurrent", getDvar( "sv_maprotation" ) );
	result[ "filter" ] = "cmdinfo";
	result[ "message" ] = "admin:resetrotation: Successfully reset the map rotation";
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

CMD_LOCK_SERVER_f( arg_list )
{
	result = [];
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
		result[ "message" ] = "admin:lock: Failed to lock server due to missing <password> param";
	}
	return result;
}

CMD_UNLOCK_SERVER_f( arg_list )
{
	result = [];
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
		player = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( player ) )
		{
			kick( player getEntityNumber() );
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
		result[ "message" ] = "admin:kick: Could not find player";
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
		result[ "filter" ] = "cmdinfo";
		result[ "message" ] = va( "admin:cvarall: Successfully set %s to %s for all players", dvar_name, dvar_value );
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "admin:cvarall: Failed to set cvar for all players due to missing params";
	}
	return result;
}

CMD_CVAR_f( arg_list )
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
			result[ "message" ] = va( "admin:cvar: Successfully set %s %s to %s", player.name, dvar_name, dvar_value );
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "admin:cvar: Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "admin:cvar: Failed to set cvar due to missing params";
	}
	return result;
}

CMD_MUTE_PLAYER_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		player = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( player ) )
		{
			if ( !is_true( player.chat_muted ) )
			{
				if ( !is_true( player.is_admin ) )
				{
					player.chat_muted = true;
					result[ "filter" ] = "cmdinfo";
					result[ "message" ] = va( "admin:mute: Successfully muted %s until next map", player.name );
				}
				else 
				{
					result[ "filter" ] = "cmderror";
					result[ "message" ] = va( "admin:mute: Failed to mute player %s player is admin", player.name );
				}
			}
			else 
			{
				result[ "filter" ] = "cmderror";
				result[ "message" ] = va( "admin:mute: Failed to mute player %s player already muted", player.name );
			}
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "admin:mute: Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "admin:mute: Failed to mute due to missing player arg";
	}
	return result;
}

CMD_UNMUTE_PLAYER_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		player = find_player_in_server( arg_list[ 0 ] );
		if ( isDefined( player ) )
		{
			if ( is_true( player.chat_muted ) )
			{
				player.chat_muted = undefined;
				result[ "filter" ] = "cmdinfo";
				result[ "message" ] = va( "admin:unmute: Successfully unmuted %s", player.name );
			}
			else 
			{
				result[ "filter" ] = "cmderror";
				result[ "message" ] = va( "admin:unmute: Failed to unmute player %s player not muted", player.name );
			}
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "admin:unmute: Could not find player";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "admin:unmute: Failed to unmute due to missing player arg";
	}
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
			result[ "message" ] = va( "admin:setrotation: Successfully set the rotation to %s's value", new_rotation );
			return result;
		}
		else 
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "admin:setrotation: New rotation dvar is blank";
		}
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "admin:setrotation: Missing dvar name arg";
	}
	return result;
}