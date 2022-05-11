#include common_scripts/utility;
#include maps/mp/_utility;
#include maps/mp/gametypes/_globallogic_player;

main()
{
	while ( !is_true( level.command_init_done ) )
	{
		wait 0.05;
	}
	//CMD_ADDCOMMAND( "codcaster", "codcaster codcast", "codcaster [name|guid|clientnum]", ::CMD_CODCASTER_f, CMD_POWER_ADMIN );
}

CMD_CODCASTER_f( arg_list )
{
	result = [];
	if ( array_validate( arg_list ) )
	{
		target = find_player_in_server( arg_list[ 0 ] );
		if ( !isDefined( target ) )
		{
			result[ "filter" ] = "cmderror";
			result[ "message" ] = "god: Could not find player";
		}
		else 
		{
			result[ "filter" ] = "cmdinfo";
			result[ "message" ] = va( "god: Successfully gave %s godmode", target.name );
		}
	}
	else if ( !is_true( self.is_server ) )
	{
		target = self;
		result[ "filter" ] = "cmdinfo";
		result[ "message" ] = "god: Successfully gave you godmode";
	}
	else 
	{
		result[ "filter" ] = "cmderror";
		result[ "message" ] = "god: No valid target";
	}
	if ( isDefined( target ) )
	{
		if ( ( target.flags & FL_GODMODE ) != 0 )
		{
			target.flags &= FL_GODMODE;
		}
		else 
		{
			target.flags |= FL_GODMODE;
		}
	}
	target setclientscriptmainmenu( game["menu_class"] );
	target [[ level.spawnspectator ]]();
	target.sessionteam = "spectator";
	target.sessionstate = "spectator";

	if ( !level.teambased )
		target.ffateam = "spectator";

	target thread spectate_player_watcher();
}