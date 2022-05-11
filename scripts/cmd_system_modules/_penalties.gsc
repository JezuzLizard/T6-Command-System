penalties_on_init()
{
	level thread decrement_mute_durations();
}

mute_player( duration )
{
	if ( !isDefined( duration ) )
	{
		duration = -1;
	}
	add_player_to_mute_list( self getGUID(), duration );
}

unmute_player()
{
	remove_player_from_mute_list( self getGUID() );
}

parse_mute_list()
{
	mute_array = [];
	mute_array[ "players" ] = [];
	mute_array[ "times" ] = [];
	mute_list = worldGet( "mute_list" );
	if ( mute_list != "" )
	{
		temp_array = strTok( mute_list, " " );
		foreach ( object in temp_array )
		{
			player_and_time_keys = strTok( object, ":" );
			mute_array[ "players" ][ mute_array[ "players" ].size ] = player_and_time_keys[ 0 ];
			mute_array[ "times" ][ mute_array[ "times" ].size ] = player_and_time_keys[ 1 ];
		}
	}
	return mute_array;
}

save_mute_list( mute_list )
{
	mute_list_string = "";
	if ( mute_list.size > 0 )
	{
		for ( i = 0; i < mute_list[ "players" ].size; i++ )
		{
			if ( mute_list[ "players" ][ i ] == "" || mute_list[ "times" ][ i ] == "" )
			{
				continue;
			}
			mute_list_string += mute_list[ "players" ][ i ] + ":" + mute_list[ "times" ][ i ] + " ";
		}
	}
	if ( mute_list_string != "" )
	{
		worldSet( "mute_list", mute_list_string );
	}
}

add_player_to_mute_list( playerGUID, duration )
{
	playerGUID = playerGUID + "";
	duration = duration + "";
	mute_list = parse_mute_list();
	mute_list[ "players" ][ mute_list[ "players" ].size ] = playerGUID;
	mute_list[ "times" ][ mute_list[ "times" ].size ] = duration;
	save_mute_list( mute_list );
}

remove_player_from_mute_list( playerGUID )
{
	playerGUID = playerGUID + "";
	mute_list = parse_mute_list();
	if ( mute_list.size > 0 )
	{
		for ( i = 0; i < mute_list[ "players" ].size; i++ )
		{
			if ( mute_list[ "players" ][ i ] == playerGUID )
			{
				mute_list[ "players" ][ i ] = "";
				mute_list[ "times" ][ i ] = "";
				break;
			}
		}
		save_mute_list( mute_list );
	}
}

decrement_mute_durations()
{
	while ( true )
	{
		wait 60;
		decrement_mute_durations_internal();
	}
}

decrement_mute_durations_internal()
{
	mute_list = parse_mute_list();
	if ( mute_list.size > 0 )
	{
		for ( i = 0; i < mute_list[ "players" ].size; i++ )
		{
			if ( int( mute_list[ "times" ][ i ] ) != -1 )
			{
				mute_list[ "times" ][ i ] = ( int( mute_list[ "times" ][ i ] ) - 1 ) + "";
			}
			if ( int( mute_list[ "times" ][ i ] ) == 0 )
			{
				mute_list[ "times" ][ i ] = "";
			}
		}
		save_mute_list( mute_list );
	}
}

get_player_mute_duration_from_mute_list( playerGUID )
{
	playerGUID = playerGUID + "";
	mute_list = parse_mute_list();
	if ( mute_list.size > 0 )
	{
		for ( i = 0; i < mute_list[ "players" ].size; i++ )
		{
			if ( mute_list[ "players" ][ i ] == playerGUID )
			{
				return int( mute_list[ "times" ][ i ] );
			}
		}
	}
	return undefined;
}