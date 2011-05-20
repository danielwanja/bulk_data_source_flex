package test.models
{
	import bulk_api.BulkResource;
	
	[RemoteClass('Author')]
	public dynamic class Author extends BulkResource
	{
		public function Author()
		{
			super();
		}
	}
}