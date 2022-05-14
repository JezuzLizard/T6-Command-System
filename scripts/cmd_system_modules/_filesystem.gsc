filespump()
{
	self endon( "disconnect" );
	if ( !isDefined( self.files ) )
	{
		self.files = [];
	}
	while ( self.files.size < 1 )
	{
		wait 0.05;
	}
	while ( true )
	{
		while ( self.files.size > 0 )
		{
			self [[ self.files[ 0 ].func ]]( self.files[ 0 ].path, self.files[ 0 ].id );
			arrayRemoveIndex( self.files, 0 );
		}
		wait 0.05;
	}
}