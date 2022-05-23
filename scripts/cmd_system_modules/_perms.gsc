#include common_scripts\utility;
#include maps\mp\_utility;
#include scripts\cmd_system_modules\_cmd_util;
#include scripts\cmd_system_modules\_com;

CMD_COOLDOWN()
{
	if ( is_true( self.is_server ) )
	{
		return;
	}
	if ( self.player_fields[ "perms" ][ "cmdpower_server" ] >= level.CMD_POWER_TRUSTED_USER || self.player_fields[ "perms" ][ "cmdpower_client" ] >= level.CMD_POWER_TRUSTED_USER )
	{
		return;
	}
	self.cmd_cooldown = level.custom_commands_cooldown_time;
	while ( self.cmd_cooldown > 0 )
	{
		self.cmd_cooldown--;
		wait 1;
	}
}

can_use_multi_cmds()
{
	if ( is_true( self.is_server ) )
	{
		return true;
	}
	if ( self.player_fields[ "perms" ][ "cmdpower_server" ] >= level.CMD_POWER_ADMIN || self.player_fields[ "perms" ][ "cmdpower_client" ] >= level.CMD_POWER_ADMIN )
	{
		return true;
	}
	return false;
}

has_permission_for_cmd( cmdname, is_clientcmd )
{
	if ( is_true( self.is_server ) )
	{
		return true;
	}
	if ( is_clientcmd && isDefined( level.client_commands[ cmdname ] ) && ( self.player_fields[ "perms" ][ "cmdpower_client" ] >= level.client_commands[ cmdname ].power ) )
	{
		return true;
	}
	if ( isDefined( level.server_commands[ cmdname ] ) && self.player_fields[ "perms" ][ "cmdpower_server" ] >= level.server_commands[ cmdname ].power )
	{
		return true;
	}
	return false;
}