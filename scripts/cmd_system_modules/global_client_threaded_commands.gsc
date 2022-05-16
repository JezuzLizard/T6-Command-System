#include scripts\cmd_system_modules\_cmd_util;
#include scripts\cmd_system_modules\_com;
#include scripts\cmd_system_modules\_listener;
#include scripts\cmd_system_modules\_perms;
#include scripts\cmd_system_modules\_text_parser;
#include common_scripts\utility;
#include maps\mp\_utility;

CMD_PLAYERLIST_f( arg_list )
{
	channel = self COM_GET_CMD_FEEDBACK_CHANNEL();
	if ( channel != "con" )
	{
		channel = channel + "|iprint";
	}
	if ( array_validate( arg_list ) )
	{
		team = arg_list[ 0 ];
		if ( isDefined( level.teams[ team ] ) )
		{
			players = getPlayers( team );
			if ( players.size == 0 )
			{
				level COM_PRINTF( channel, "cmderror", "Team " + team + " is empty", self );
				return;
			}
		}
		else 
		{
			level COM_PRINTF( channel, "cmderror", "Received bad team " + team, self );
			return;
		}
	}
	else 
	{
		players = getPlayers();
	}
	for ( i = 0; i < players.size; i++ )
	{
		message = va( "^3%s %s %s", players[ i ].name, players[ i ] getGUID(), players[ i ] getEntityNumber() );
		level COM_PRINTF( channel, "notitle", message, self );
	}
	if ( !is_true( self.is_server ) )
	{
		level COM_PRINTF( channel, "cmdinfo", "Use shift + ` and scroll to the bottom to view the full list", self );
	}
}

CMD_CMDLIST_f( arg_list )
{
	channel = self COM_GET_CMD_FEEDBACK_CHANNEL();
	if ( channel != "con" )
	{
		channel = channel + "|iprint";
	}
	all_commands = arraycombine( level.server_commands, level.client_commands, 1, 0 );
	cmdnames = getArrayKeys( all_commands );
	for ( i = 0; i < cmdnames.size; i++ )
	{
		if ( self has_permission_for_cmd( cmdnames[ i ] ) )
		{
			message = "^3" + all_commands[ cmdnames[ i ] ].usage;
			level COM_PRINTF( channel, "notitle", message, self );
		}
	}
	if ( !is_true( self.is_server ) )
	{
		level COM_PRINTF( channel, "cmdinfo", "Use shift + ` and scroll to the bottom to view the full list", self );
	}
}