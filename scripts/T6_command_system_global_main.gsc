
#include scripts/cm_system_modules/global_commands;

CMD_INIT()
{
	COM_INIT();
	level.server = spawnStruct();
	level.server.name = "Server";
	level.server.is_server = true;
	level.server.channel = "con";
	level.custom_commands_restart_countdown = 5;
	CMD_ADDCOMMAND( "utility u", "cmdlist cl", "utility:cmdlist", ::CMD_UTILITY_CMDLIST_f, true );
	CMD_ADDCOMMAND( "client c", "cvar cv", "client:cvar <cvarname> <newval>", ::CMD_CLIENT_CVAR_f );
	CMD_ADDCOMMAND( "admin a", "kick k", "admin:kick <name|guid|clientnum>", ::CMD_ADMIN_KICK_f );
	CMD_ADDCOMMAND( "admin a", "lock l", "admin:lock <password>", ::CMD_LOCK_SERVER_f );
	CMD_ADDCOMMAND( "admin a", "unlock ul", "admin:unlock", ::CMD_UNLOCK_SERVER_f );
	CMD_ADDCOMMAND( "admin a", "playerlist plist", "admin:playerlist", ::CMD_PLAYERLIST_f, true );
	CMD_ADDCOMMAND( "admin a", "dvar d", "admin:dvar <dvarname> <newval>", ::CMD_SERVER_DVAR_f );
	CMD_ADDCOMMAND( "admin a", "cvarall ca", "admin:cvarall <dvarname> <newval", ::CMD_ADMIN_CVARALL_f );
	CMD_ADDCOMMAND( "admin a", "restart mr", "admin:restart", ::CMD_RESTART_f, true );
	CMD_ADDCOMMAND( "admin a", "rotate r", "admin:rotate", ::CMD_ROTATE_f, true );
	CMD_ADDCOMMAND( "admin a", "nextmap nm", "admin:nextmap <mapalias>", ::CMD_NEXTMAP_f );
	CMD_ADDCOMMAND( "admin a", "changemap cm", "admin:changemap <mapalias>", ::CMD_CHANGEMAP_f, true );
	CMD_ADDCOMMAND( "admin a", "resetrotation rr", "admin:resetrotation", ::CMD_RESETROTATION_f );
	CMD_ADDCOMMAND( "admin a", "randomnextmap rnm", "admin:randomnextmap", ::CMD_RANDOMNEXTMAP_f );
	CMD_ADDCOMMAND( "vote v", "start s", "vote:start <voteable> [arg1] [arg2]" ::CMD_VOTESTART_f, true );
	VOTE_INIT();

	VOTE_ADDVOTEABLE( "cvarall ca", ::VOTEABLE_CVARALL_PRE_f, ::VOTEABLE_CVARALL_POST_f );
	VOTE_ADDVOTEABLE( "kick k", ::VOTEABLE_KICK_PRE_f, ::VOTEABLE_KICK_POST_f );
	VOTE_ADDVOTEABLE( "nextmap nm", ::VOTEABLE_NEXTMAP_PRE_f, ::VOTEABLE_NEXTMAP_POST_f );

	CMD_ADDCOMMANDLISTENER( "listener_cmdlist", "showmore" );
	CMD_ADDCOMMANDLISTENER( "listener_cmdlist", "page" );
	CMD_ADDCOMMANDLISTENER( "listener_playerlist", "showmore" );
	CMD_ADDCOMMANDLISTENER( "listener_playerlist", "page" );
	CMD_ADDCOMMANDLISTENER( "listener_vote", "yes" );
	CMD_ADDCOMMANDLISTENER( "listener_vote", "no" );

	level thread COMMAND_BUFFER();
	level thread dvar_command_watcher();
}

/*private*/ dvar_command_watcher()
{
	level endon( "end_commands" );
	while ( true )
	{
		dvar_value = getDvar( "scrcmd" );
		if ( dvar_value != "" )
		{
			level notify( "say", dvar_value, undefined );
			setDvar( dvar, "" );
		}
		wait 0.05;
	}
}