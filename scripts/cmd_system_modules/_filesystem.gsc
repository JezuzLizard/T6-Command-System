
FS_INIT()
{
	level.FS_basepath = va( "%s/scriptdata/", getDvar( "fs_homepath" ) );
	level.max_open_files = 10;
	level.FS_open_files = [];
	level.files = [];
	level thread filespump();
}

filespump()
{
    while ( true )
    {
        level waittill( "filesystem_queue" );
        do
        {
			level.files[ 0 ].player [[ level.files[ 0 ].func ]]( level.files[ 0 ].path, level.files[ 0 ].arg2, level.files[ 0 ].arg3 );
			arrayRemoveIndex( level.files, 0 );
			wait 0.06;
        }
        while ( level.files.size > 0 );
    }
}