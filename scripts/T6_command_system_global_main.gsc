
#include scripts\cmd_system_modules\_cmd_util;
#include scripts\cmd_system_modules\_com;
#include scripts\cmd_system_modules\_text_parser;
#include scripts\cmd_system_modules\_listener;
#include scripts\cmd_system_modules\_perms;
#include scripts\cmd_system_modules\global_client_commands;
#include scripts\cmd_system_modules\global_client_threaded_commands;
#include scripts\cmd_system_modules\global_commands;
#include scripts\cmd_system_modules\global_threaded_commands;
#include scripts\cmd_system_modules\_filesystem;
#include scripts\cmd_system_modules\_persistence;

#include common_scripts\utility;
#include maps\mp\_utility;

main()
{
	COM_INIT();
	level.server = spawnStruct();
	level.server.name = "Server";
	level.server.is_server = true;
	level.custom_commands_restart_countdown = 5;
	level.commands_total = 0;
	level.commands_page_count = 0;
	level.commands_page_max = 7;
	level.custom_commands_cooldown_time = getDvarIntDefault( "tcs_cmd_cd", 5 );
	level.tcs_use_silent_commands = getDvarIntDefault( "tcs_silent_cmds", 0 );
	level.tcs_logprint_cmd_usage = getDvarIntDefault( "tcs_logprint_cmd_usage", 1 );
	level.tcs_listener_timeout_time = getDvarFloatDefault( "tcs_listener_timeout_time", 10.0 );
	level.tcs_default_ban_reason = getDvarStringDefault( "tcs_default_ban_reason", "You are banned from this server" );
	level.tcs_chat_disabled = getDvarIntDefault( "tcs_chat_disabled", 0 );
	level.CMD_POWER_NONE = 0;
	level.CMD_POWER_USER = 1;
	level.CMD_POWER_TRUSTED_USER = 20;
	level.CMD_POWER_ELEVATED_USER = 40;
	level.CMD_POWER_MODERATOR = 60;
	level.CMD_POWER_ADMIN = 80;
	level.CMD_POWER_OWNER = 100;
	level.TCS_RANK_NONE = "none";
	level.TCS_RANK_USER = "user";
	level.TCS_RANK_TRUSTED_USER = "trusted";
	level.TCS_RANK_ELEVATED_USER = "elevated";
	level.TCS_RANK_MODERATOR = "moderator";
	level.TCS_RANK_ADMIN = "admin";
	level.TCS_RANK_OWNER = "owner";
	level.FL_GODMODE = 1;
	level.FL_DEMI_GODMODE = 2;
	level.FL_NOTARGET = 4;
	level.clientdvars = [];
	level.CFL_NOCLIP = 1;
	level.tcs_clantag_worthy_ranks = array( "trusted", "elevated", "moderator", "admin", "owner" );
	tokens = getDvarStringDefault( "tcs_cmd_tokens", "" ); //separated by spaces, good tokens are generally not used at the start of a normal message 
	if ( tokens != "" )
	{
		level.custom_commands_tokens = strTok( tokens, " " );
	}
	// "\" is always useable by default
	INIT_MOD_INTEGRATIONS();
	PERSISTENCE_INIT();
	level.tcs_add_server_command_func = ::CMD_ADDSERVERCOMMAND;
	level.tcs_add_client_command_func = ::CMD_ADDCLIENTCOMMAND;
	level.tcs_remove_server_command = ::CMD_REMOVESERVERCOMMAND;
	level.tcs_remove_client_command = ::CMD_REMOVECLIENTCOMMAND;
	level.tcs_register_generic_player_field = ::PERS_REGISTER_GENERIC_PLAYER_FIELD;
	level.tcs_add_pers_fs_func_to_queue = ::ADD_PERS_FS_FUNC_TO_QUEUE;
	level.tcs_com_printf = ::COM_PRINTF;
	level.tcs_com_get_feedback_channel = ::COM_GET_CMD_FEEDBACK_CHANNEL;
	level.tcs_find_player_in_server = ::find_player_in_server;
	level.tcs_check_cmd_collisions = ::check_for_command_alias_collisions;
	level.server_commands = [];
	CMD_ADDSERVERCOMMAND( "setcvar", "setcvar scv", "setcvar <name|guid|clientnum|self> <cvarname> <newval>", ::CMD_SETCVAR_f, level.CMD_POWER_ADMIN );
	CMD_ADDSERVERCOMMAND( "kick", "kick k", "kick <name|guid|clientnum>", ::CMD_KICK_f, level.CMD_POWER_MODERATOR );
	CMD_ADDSERVERCOMMAND( "lock", "lock lk", "lock <password>", ::CMD_LOCK_SERVER_f, level.CMD_POWER_ELEVATED_USER );
	CMD_ADDSERVERCOMMAND( "unlock", "unlock ul", "unlock", ::CMD_UNLOCK_SERVER_f, level.CMD_POWER_ELEVATED_USER );
	CMD_ADDSERVERCOMMAND( "dvar", "dvar dv", "dvar <dvarname> <newval>", ::CMD_SERVER_DVAR_f, level.CMD_POWER_ADMIN );
	CMD_ADDSERVERCOMMAND( "cvarall", "cvarall cva", "cvarall <cvarname> <newval>", ::CMD_CVARALL_f, level.CMD_POWER_ADMIN );
	CMD_ADDSERVERCOMMAND( "nextmap", "nextmap nm", "nextmap <mapalias>", ::CMD_NEXTMAP_f, level.CMD_POWER_ELEVATED_USER );
	CMD_ADDSERVERCOMMAND( "resetrotation", "resetrotation rr", "resetrotation", ::CMD_RESETROTATION_f, level.CMD_POWER_ELEVATED_USER );
	CMD_ADDSERVERCOMMAND( "randomnextmap", "randomnextmap rnm", "randomnextmap", ::CMD_RANDOMNEXTMAP_f, level.CMD_POWER_ELEVATED_USER );
	CMD_ADDSERVERCOMMAND( "restart", "restart mr", "restart", ::CMD_RESTART_f, level.CMD_POWER_ELEVATED_USER, true );
	CMD_ADDSERVERCOMMAND( "rotate", "rotate ro", "rotate", ::CMD_ROTATE_f, level.CMD_POWER_ELEVATED_USER, true );
	CMD_ADDSERVERCOMMAND( "changemap", "changemap cm", "changemap <mapalias>", ::CMD_CHANGEMAP_f, level.CMD_POWER_ELEVATED_USER, true );
	CMD_ADDSERVERCOMMAND( "setrotation", "setrotation sr", "setrotation <rotationdvar>", ::CMD_SETROTATION_f, level.CMD_POWER_ELEVATED_USER );
	CMD_ADDSERVERCOMMAND( "givegod", "givegod ggd", "givegod <name|guid|clientnum|self>", ::CMD_GIVEGOD_f, level.CMD_POWER_ADMIN );
	CMD_ADDSERVERCOMMAND( "givenotarget", "givenotarget gnt", "givenotarget <name|guid|clientnum|self>", ::CMD_GIVENOTARGET_f, level.CMD_POWER_ADMIN );
	CMD_ADDSERVERCOMMAND( "giveinvisible", "giveinvisible ginv", "giveinvisible <name|guid|clientnum|self>", ::CMD_GIVEINVISIBLE_f, level.CMD_POWER_ADMIN );
	CMD_ADDSERVERCOMMAND( "givenoclip", "givenoclip gino", "givenoclip <name|guid|clientnum|self>", ::CMD_GIVENOCLIP_f, level.CMD_POWER_ADMIN );

	CMD_ADDSERVERCOMMAND( "execonallplayers", "execonallplayers execonall exall", "execonallplayers <cmdname> [cmdargs] ...", ::CMD_EXECONALLPLAYERS_f, level.CMD_POWER_OWNER );
	CMD_ADDSERVERCOMMAND( "execonteam", "execonteam execteam exteam", "execonteam <team> <cmdname> [cmdargs] ...", ::CMD_EXECONTEAM_f, level.CMD_POWER_OWNER );

	//Commands that need to be adde/changed
	CMD_ADDSERVERCOMMAND( "ban", "ban bn", "ban <name|guid|clientnum> [reason]", ::CMD_BAN_f, level.CMD_POWER_ADMIN, true );
	CMD_ADDSERVERCOMMAND( "tempban", "tempban tbn", "tempban <name|guid|clientnum> <duration_in_minutes> [reason]", ::CMD_TEMPBAN_f, level.CMD_POWER_ADMIN, true );
	CMD_ADDSERVERCOMMAND( "setrank", "setrank srnk", "setrank <name|guid|clientnum|self> <rank>", ::CMD_SETRANK_f, level.CMD_POWER_ADMIN );
	CMD_ADDSERVERCOMMAND( "mute", "mute m", "mute <name|guid|clientnum> [duration_in_minutes]", ::CMD_MUTE_PLAYER_f, level.CMD_POWER_MODERATOR );
	CMD_ADDSERVERCOMMAND( "unmute", "unmute um", "unmute <name|guid|clientnum>", ::CMD_UNMUTE_PLAYER_f, level.CMD_POWER_MODERATOR );
	CMD_ADDSERVERCOMMAND( "togglechat", "togglechat togchat", "togglechat", ::CMD_TOGGLECHAT_f, level.CMD_POWER_MODERATOR );
	CMD_ADDSERVERCOMMAND( "clantag", "clantag ct", "clantag <name|guid|clientnum> <newtag>", ::CMD_CLANTAG_f, level.CMD_POWER_ADMIN );
	CMD_ADDSERVERCOMMAND( "toggleteamchanging", "toggleteamchanging togtc", "toggleteamchanging", ::CMD_TOGGLETEAMCHANGING_f, level.CMD_POWER_ADMIN );

	level.client_commands = [];
	CMD_ADDCLIENTCOMMAND( "togglehud", "togglehud toghud", "togglehud", ::CMD_TOGGLEHUD_f, level.CMD_POWER_NONE );
	CMD_ADDCLIENTCOMMAND( "god", "god", "god", ::CMD_GOD_f, level.CMD_POWER_ADMIN );
	CMD_ADDCLIENTCOMMAND( "notarget", "notarget nt", "notarget", ::CMD_NOTARGET_f, level.CMD_POWER_ADMIN );
	CMD_ADDCLIENTCOMMAND( "invisible", "invisible invis", "invisible", ::CMD_INVISIBLE_f, level.CMD_POWER_ADMIN );
	CMD_ADDCLIENTCOMMAND( "printorigin", "printorigin printorg por", "printorigin", ::CMD_PRINTORIGIN_f, level.CMD_POWER_NONE );
	CMD_ADDCLIENTCOMMAND( "printangles", "printangles printang pan", "printangles", ::CMD_PRINTANGLES_f, level.CMD_POWER_NONE );
	CMD_ADDCLIENTCOMMAND( "bottomlessclip", "bottomlessclip botclip bcl", "bottomlessclip", ::CMD_BOTTOMLESSCLIP_f, level.CMD_POWER_ADMIN );
	CMD_ADDCLIENTCOMMAND( "teleport", "teleport tele", "teleport <name|guid|clientnum|origin>", ::CMD_TELEPORT_f, level.CMD_POWER_ADMIN );
	CMD_ADDCLIENTCOMMAND( "cvar", "cvar cv", "cvar <cvarname> <newval>", ::CMD_CVAR_f, level.CMD_POWER_ADMIN );
	CMD_ADDCLIENTCOMMAND( "cmdlist", "cmdlist cl", "cmdlist [pagenumber]", ::CMD_CMDLIST_f, level.CMD_POWER_NONE, true );
	CMD_ADDCLIENTCOMMAND( "playerlist", "playerlist plist", "playerlist [pagenumber] [team]", ::CMD_PLAYERLIST_f, level.CMD_POWER_NONE, true );
	// CMD_ADDCLIENTCOMMAND( "showmore", "showmore show", "showmore", ::CMD_SHOWMORE_f, level.CMD_POWER_NONE );
	// CMD_ADDCLIENTCOMMAND( "page", "page pg", "page <pagenumber>", ::CMD_PAGE_f, level.CMD_POWER_NONE );
	check_for_command_alias_collisions();
	level.tcs_pers_version = 1.0;
	PERS_REGISTER_GENERIC_PLAYER_FIELD( "version", level.tcs_pers_version );
	PERS_REGISTER_GENERIC_PLAYER_FIELD( "rank", "user" );
	penalties_array = [];
	penalties_array[ "perm_banned" ] = false;
	penalties_array[ "ban_reason" ] = "none";
	penalties_array[ "temp_banned" ] = false;
	penalties_array[ "temp_ban_time" ] = 0;
	penalties_array[ "temp_ban_length" ] = 0;
	penalties_array[ "perm_chat_muted" ] = false;
	penalties_array[ "chat_muted" ] = false;
	penalties_array[ "chat_muted_time" ] = 0;
	penalties_array[ "chat_muted_length" ] = 0;
 	PERS_REGISTER_GENERIC_PLAYER_FIELD( "penalties", penalties_array );
	cmdpower = [];
	cmdpower[ "cmdpower_server" ] = level.CMD_POWER_USER;
	cmdpower[ "cmdpower_client" ] = level.CMD_POWER_USER;
	PERS_REGISTER_GENERIC_PLAYER_FIELD( "perms", cmdpower );
	level thread COMMAND_BUFFER();
	level thread scr_dvar_command_watcher();
	level thread end_commands_on_end_game();
	level thread tcs_on_connect();
	onPlayerSay( ::check_mute );
	level.command_init_done = true;
	level COM_PRINTF( "con|g_log", "permsdebug", va( "level.command_init_done is initialized at %s server time", getTime() ), level );
}

check_mute( text, mode )
{
	// mode == 0 -> all
	// mode == 1 -> team
	// self -> player that sent the message
	if ( is_true( level.tcs_chat_disabled ) && self.player_fields[ "perms" ][ "cmdpower_client" ] < level.CMD_POWER_TRUSTED_USER && self.player_fields[ "perms" ][ "cmdpower_server" ] < level.CMD_POWER_TRUSTED_USER )
	{
		level COM_PRINTF( "tell", "notitle", "Chat is disabled", self );
		return false;
	}
	if ( self.player_fields[ "penalties" ][ "perm_chat_muted" ] )
	{
		level COM_PRINTF( "tell", "notitle", "You are permanently muted", self );
		return false;
	}
	if ( self.player_fields[ "penalties" ][ "chat_muted" ] && ( self.player_fields[ "penalties" ][ "chat_muted_time" ] + self.player_fields[ "penalties" ][ "chat_muted_length" ] ) > getUTC() )
	{
		level COM_PRINTF( "tell", "notitle", va( "You are muted for %s minutes", ceil( self.player_fields[ "penalties" ][ "chat_muted_length" ] / 60 ) ), self );
		return false;
	}
	// returning `false` will hide the message, anything else will not
	return true;
}

scr_dvar_command_watcher()
{
	level endon( "end_commands" );
	wait 1;
	while ( true )
	{
		dvar_value = getDvar( "tcscmd" );
		if ( dvar_value != "" )
		{
			level notify( "say", dvar_value, undefined, false );
			setDvar( "tcscmd", "" );
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
		channel = player COM_GET_CMD_FEEDBACK_CHANNEL();
		if ( isDefined( player.cmd_cooldown ) && player.cmd_cooldown > 0 )
		{
			level COM_PRINTF( channel, "cmderror", va( "You cannot use another command for %s seconds", player.cmd_cooldown + "" ), player );
			continue;
		}
		message = toLower( message );
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
			is_clientcmd = multi_cmds[ cmd_index ][ "is_clientcmd" ];
			if ( !player has_permission_for_cmd( cmdname, is_clientcmd ) )
			{
				level COM_PRINTF( channel, "cmderror", "You do not have permission to use " + cmdname + " command", player );
			}
			else
			{
				if ( is_clientcmd && is_true( player.is_server ) )
				{
					level COM_PRINTF( channel, "cmderror", va( "You cannot use %s client command as the server", cmdname ), player );
				}
				else 
				{
					player CMD_EXECUTE( cmdname, args, is_clientcmd, level.tcs_use_silent_commands, level.tcs_logprint_cmd_usage );
					player thread CMD_COOLDOWN();
				}
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