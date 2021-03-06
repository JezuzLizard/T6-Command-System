#include common_scripts\utility;
#include maps\mp\_utility;
#include scripts\cmd_system_modules\_cmd_util;

COM_INIT()
{
	COM_ADDFILTER( "cominfo", 1 );
	COM_ADDFILTER( "comwarning", 1 );
	COM_ADDFILTER( "comerror", 1 );
	COM_ADDFILTER( "cmdinfo", 1 );
	COM_ADDFILTER( "cmdwarning", 1 );
	COM_ADDFILTER( "cmderror", 1 );
	COM_ADDFILTER( "scrinfo", 1 );
	COM_ADDFILTER( "scrwarning", 1 );
	COM_ADDFILTER( "screrror", 1 );
	COM_ADDFILTER( "permsinfo", 1 );
	COM_ADDFILTER( "permswarning", 1 );
	COM_ADDFILTER( "permserror", 1 ); 
	COM_ADDFILTER( "permsdebug", 0 );
	COM_ADDFILTER( "debug", 0 );
	COM_ADDFILTER( "obituary", 1 );
	COM_ADDFILTER( "notitle", 1 );

	COM_ADDCHANNEL( "con", ::COM_PRINT );
	COM_ADDCHANNEL( "g_log", ::COM_LOGPRINT );
	COM_ADDCHANNEL( "iprint", ::COM_IPRINTLN );
	COM_ADDCHANNEL( "iprintbold", ::COM_IPRINTLNBOLD );
	COM_ADDCHANNEL( "say", ::COM_SAY );
	COM_ADDCHANNEL( "tell", ::COM_TELL );
	COM_ADDCHANNEL( "obituary", ::COM_OBITUARY );
	COM_ADDCHANNEL( "debug_log", ::COM_DEBUG_LOGPRINT );
}

COM_ADDFILTER( filter, default_value )
{
	if ( !isDefined( level.com_filters ) )
	{
		level.com_filters = [];
	}
	if ( !isDefined( level.com_filters[ filter ] ) )
	{
		level.com_filters[ filter ] = getDvarIntDefault( va( "com_script_channel_%s", filter ), default_value );
	}
}

COM_ADDCHANNEL( channel, func )
{
	if ( !isDefined( level.com_channels ) )
	{
		level.com_channels = [];
	}
	if ( !isDefined( level.com_channels[ channel ] ) )
	{
		level.com_channels[ channel ] = func;
	}
}

COM_IS_FILTER_ACTIVE( filter )
{
	return is_true( level.com_filters[ filter ] );
}

COM_IS_CHANNEL_ACTIVE( channel )
{
	return isDefined( level.com_channels[ channel ] );
}

COM_CAPS_MSG_TITLE( channel, filter, players )
{
	if ( filter == "notitle" )
	{
		return "";
	}
	if ( channel == "con" || channel == "g_log" )
	{
		return toUpper( filter ) + ":";
	}
	if ( isSubStr( filter, "error" ) )
	{
		color_code = "^1";
	}
	else if ( isSubStr( filter, "warning" ) )
	{
		color_code = "^3";
	}
	else if ( isSubStr( filter, "info" ) )
	{
		color_code = "^2";
	}
	else 
	{
		color_code = "";
	}
	return color_code + toUpper( filter ) + ":";
}

COM_DEBUG_LOGPRINT( channel, message, players, arg_list )
{
	writeFile( va( "%s//%s", level.FS_basepath, channel ), va( "%s\n", message ), true );
}

COM_PRINT( channel, message, players, arg_list )
{
	print( message );
}

COM_LOGPRINT( channel, message, players, arg_list )
{
	logPrint( message + "\n" );
}

COM_IPRINTLN( channel, message, players, arg_list )
{
	if ( array_validate( players ) )
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( isPlayer( players[ i ] ) && !is_true( players[ i ].is_server ) )
			{
				players[ i ] iPrintLn( message );
			}
		}
	}
	else if ( isDefined( players ) && !is_true( players.is_server ) )
	{
		players iPrintLn( message );
	}
	else 
	{
		COM_PRINT( "con", va( "COM_PRINTF() msg %s sent for channel %s has bad players arg", message, channel ) );
	}
}

COM_IPRINTLNBOLD( channel, message, players, arg_list )
{
	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[ i ] iPrintLnBold( message );
	}
}

COM_SAY( channel, message, players, arg_list )
{
	say( message );
}

COM_TELL( channel, message, players, arg_list )
{
	if ( array_validate( players ) )
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( isPlayer( players[ i ] ) && !is_true( players[ i ].is_server ) )
			{
				players[ i ] tell( message );
			}
		}
	}
	else if ( isDefined( players ) && !is_true( players.is_server ) )
	{
		players tell( message );
	}
	else 
	{
		COM_PRINT( "con", va( "COM_PRINTF() msg %s sent for channel %s has bad players arg", message, channel ) );
	}
}

COM_OBITUARY( channel, message, players, arg_list )
{
	if ( array_validate( players ) && players.size == 2 )
	{
		if ( !isDefined( arg_list[ 0 ] ) || !isDefined( arg_list[ 1 ] ) )
		{
			COM_PRINT( "con", va( "COM_PRINTF() channel %s arg_list requires <weapon> <mod>", channel ) );
		}
		victim = players[ 0 ];
		attacker = players[ 1 ];
		weapon = arg_list[ 0 ];
		MOD = arg_list[ 1 ];
		obituary( victim, attacker, weapon, MOD );
	}
	else 
	{
		COM_PRINT( "con", va( "COM_PRINTF() channel %s requires an array of two players", channel ) );
	}
}

COM_PRINTF( channels, filter, message, players, arg_list )
{
	if ( !isDefined( channels ) )
	{
		return;
	}
	if ( !isDefined( filter ) )
	{
		return;
	}
	if ( !isDefined( message ) )
	{
		return;
	}
	channel_keys = strTok( channels, "|" );
	foreach ( channel in channel_keys )
	{
		if ( COM_IS_CHANNEL_ACTIVE( channel ) && COM_IS_FILTER_ACTIVE( filter ) )
		{
			message_final = va( "%s%s", COM_CAPS_MSG_TITLE( channel, filter, players ), message );
			[[ level.com_channels[ channel ] ]]( channel, message_final, players, arg_list );
		}
	}
}

COM_GET_CMD_FEEDBACK_CHANNEL()
{
	if ( is_true( self.is_server ) )
	{
		return "con";
	}
	else 
	{
		return "tell";
	}
}