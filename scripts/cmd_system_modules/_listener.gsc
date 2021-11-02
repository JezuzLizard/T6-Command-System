#include common_scripts/utility;
#include maps/mp/_utility;
#include scripts/cmd_system_modules/_com;

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

setup_temporary_command_listener( listener_name, timelimit )
{
	if ( !isDefined( self.temp_listeners ) )
	{
		self.temp_listeners = [];
	}
	if ( !isDefined( self.temp_listeners[ listener_name ] ) )
	{
		self.temp_listeners[ listener_name ] = spawnStruct();
		self.temp_listeners[ listener_name ].data = [];
		self.temp_listeners[ listener_name ].timeout = false;
		self thread temporary_command_listener_timelimit( listener_name, timelimit );
		self thread clear_temporary_command_listener_on_cmd_reuse( listener_name );
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

clear_temporary_command_listener_on_cmd_reuse( listener_name )
{
	self waittill( listener_name );
	arrayRemoveIndex( self.temp_listeners, listener_name, true );
}

clear_temporary_command_listener( listener_name )
{
	arrayRemoveIndex( self.temp_listeners, listener_name, true );
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