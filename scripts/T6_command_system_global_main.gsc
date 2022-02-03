
#include scripts/cmd_system_modules/_cmd_util;
#include scripts/cmd_system_modules/_com;
#include scripts/cmd_system_modules/_text_parser;
#include scripts/cmd_system_modules/_vote;
#include scripts/cmd_system_modules/_listener;
#include scripts/cmd_system_modules/_perms;
#include scripts/cmd_system_modules/global_commands;
#include scripts/cmd_system_modules/global_threaded_commands;
#include scripts/cmd_system_modules/global_voteables;
#include scripts/cmd_system_modules/_filesystem;

#include common_scripts/utility;
#include maps/mp/_utility;

main()
{
	COM_INIT();
	FS_INIT();
	level.server = spawnStruct();
	level.server.name = "Server";
	level.server.is_server = true;
	level.custom_commands_restart_countdown = 5;
	level.custom_commands_total = 0;
	level.custom_commands_page_count = 0;
	level.custom_commands_page_max = 5;
	level.custom_commands_listener_timeout = getDvarIntDefault( "tcs_cmd_listener_timeout", 12 );
	level.custom_commands_cooldown_time = getDvarIntDefault( "tcs_cmd_cd", 5 );
	tokens = getDvarStringDefault( "tcs_cmd_tokens", "" ); //separated by spaces, good tokens are generally not used at the start of a normal message 
	if ( tokens != "" )
	{
		level.custom_commands_tokens = strTok( tokens, " " );
	}
	// "/" is always useable by default
	CMD_INIT_PERMS();
	INIT_MOD_INTEGRATIONS();
	level.custom_commands = [];
	CMD_ADDCOMMAND( "cvar", "cvar cv", "cvar <name|guid|clientnum> <cvarname> <newval>", ::CMD_CVAR_f, 80 );
	CMD_ADDCOMMAND( "kick", "kick k", "kick <name|guid|clientnum>", ::CMD_ADMIN_KICK_f, 100 );
	CMD_ADDCOMMAND( "lock", "lock l", "lock <password>", ::CMD_LOCK_SERVER_f, 40 );
	CMD_ADDCOMMAND( "unlock", "unlock ul", "unlock", ::CMD_UNLOCK_SERVER_f );
	CMD_ADDCOMMAND( "dvar", "dvar dv", "dvar <dvarname> <newval>", ::CMD_SERVER_DVAR_f, 80 );
	CMD_ADDCOMMAND( "cvarall", "cvarall cva", "cvarall <dvarname> <newval", ::CMD_CVARALL_f, 80 );
	CMD_ADDCOMMAND( "nextmap", "nextmap nm", "nextmap <mapalias>", ::CMD_NEXTMAP_f, 20 );
	CMD_ADDCOMMAND( "resetrotation", "resetrotation rr", "resetrotation", ::CMD_RESETROTATION_f, 20 );
	CMD_ADDCOMMAND( "randomnextmap", "randomnextmap rnm", "randomnextmap", ::CMD_RANDOMNEXTMAP_f, 20 );
	CMD_ADDCOMMAND( "cmdlist", "cmdlist cl", "cmdlist", ::CMD_UTILITY_CMDLIST_f, 1, true );
	CMD_ADDCOMMAND( "playerlist", "playerlist plist", "playerlist [team]", ::CMD_PLAYERLIST_f, 20, true );
	CMD_ADDCOMMAND( "restart", "restart mr", "restart", ::CMD_RESTART_f, 40, true );
	CMD_ADDCOMMAND( "rotate", "rotate r", "rotate", ::CMD_ROTATE_f, 40, true );
	CMD_ADDCOMMAND( "changemap", "changemap cm", "changemap <mapalias>", ::CMD_CHANGEMAP_f, 40, true );
	CMD_ADDCOMMAND( "setrotation", "setrotation sr", "setrotation <rotationdvar>", ::CMD_SETROTATION_f, 20 );
	CMD_ADDCOMMAND( "mute", "mute m", "mute <name|guid|clientnum> [duration_in_minutes]", ::CMD_MUTE_PLAYER_f, 40 );
	CMD_ADDCOMMAND( "unmute", "unmute um", "unmute <name|guid|clientnum>", ::CMD_UNMUTE_PLAYER_f, 40 );
	CMD_ADDCOMMAND( "votestart", "votestart vs", "votestart <voteable> [arg1] [arg2] [arg3] [arg4]", ::CMD_VOTESTART_f, 1, true );
	CMD_ADDCOMMAND( "votelist", "votelist vl", "votelist", ::CMD_UTILITY_VOTELIST_f, 1, true );

	VOTE_INIT();

	CMD_ADDCOMMANDLISTENER( "listener_cmdlist", "showmore" );
	CMD_ADDCOMMANDLISTENER( "listener_cmdlist", "page" );
	CMD_ADDCOMMANDLISTENER( "listener_playerlist", "showmore" );
	CMD_ADDCOMMANDLISTENER( "listener_playerlist", "page" );

	level thread COMMAND_BUFFER();
	level thread dvar_command_watcher();
	level thread end_commands_on_end_game();
	onPlayerSay( ::check_mute );
	level notify( "tcs_init_done" );
}

check_mute( text, mode )
{
	// mode == 0 -> all
	// mode == 1 -> team
	// self -> player that sent the message

	if ( is_true( self.chat_muted ) )
	{
		level COM_PRINTF( "tell", "notitle", va( "You were muted for %s minutes. %s minutes remaining", self.chat_muted_duration_minutes, self.chat_muted_remaining_minutes ), self );
		return false;
	}
	// returning `false` will hide the message, anything else will not
	return true;
}

dvar_command_watcher()
{
	level endon( "end_commands" );
	while ( true )
	{
		dvar_value = getDvar( "scrcmd" );
		if ( dvar_value != "" )
		{
			level notify( "say", dvar_value, undefined, false );
			setDvar( "scrcmd", "" );
		}
		wait 0.05;
	}
}

COMMAND_BUFFER()
{
	level endon( "end_commands" );
	while ( true )
	{
		level waittill( "say", message, player, isHidden );
		if ( isDefined( player ) && !isHidden && !is_command_token( message[ 0 ] ) )
		{
			continue;
		}
		if ( !isDefined( player ) )
		{
			player = level.server;
		}
		if ( is_true( player.chat_muted ) )
		{
			level COM_PRINTF( channel, "cmderror", "You cannot use commands while muted", self );
			continue;
		}
		if ( isDefined( player.cmd_cooldown ) && player.cmd_cooldown > 0 )
		{
			level COM_PRINTF( channel, "cmderror", va( "You cannot use another command for %s seconds", player.cmd_cooldown + "" ), player );
			continue;
		}
		message = toLower( message );
		found_listener = false;
		if ( array_validate( player.cmd_listeners ) )
		{
			listener_cmds_args = strTok( message, " " );
			cmdname = listener_cmds_args[ 0 ];
			listener_keys = getArrayKeys( player.cmd_listeners );
			foreach ( listener in listener_keys )
			{
				if ( CMD_ISCOMMANDLISTENER( listener, cmdname ) && player CMD_ISCOMMANDLISTENER_ACTIVE( listener ) )
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
		multi_cmds = parse_cmd_message( message );
		if ( multi_cmds.size < 1 )
		{
			level COM_PRINTF( channel, "cmderror", "Invalid command", self );
			continue;
		}
		if ( multi_cmds.size > 1 && !player can_use_multi_cmds() )
		{
			temp_array_index = multi_cmds[ 0 ];
			multi_cmds = [];
			multi_cmds[ 0 ] = temp_array_index;
			level COM_PRINTF( channel, "cmdwarning", "You do not have permission to use multi cmds; only executing the first cmd" );
		}
		for ( cmd_index = 0; cmd_index < multi_cmds.size; cmd_index++ )
		{
			cmdname = multi_cmds[ cmd_index ][ "cmdname" ];
			args = multi_cmds[ cmd_index ][ "args" ];
			if ( !player has_permission_for_cmd( cmdname ) )
			{
				level COM_PRINTF( channel, "cmderror", va( "You do not have permission to use %s command.", cmdname ), player );
			}
			else
			{
				player CMD_EXECUTE( cmdname, args );
				player thread CMD_COOLDOWN();
			}
		}
	}
}

end_commands_on_end_game()
{
	level waittill_either( "end_game", "game_ended" );
	wait 10;
	level notify( "end_commands" );
}

INIT_MOD_INTEGRATIONS()
{
	if ( !isDefined( level.mod_integrations ) )
	{
		level.mod_integrations = [];
	}
	level.mod_integrations[ "cut_tranzit_locations" ] = getDvarIntDefault( "tcs_integrations_cut_tranzit_locations", 0 );
}