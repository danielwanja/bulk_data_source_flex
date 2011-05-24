package test.models
{
	import bulk_api.BulkResource;
	
	[RemoteClass(alias="Post")]	
	public dynamic class Post extends BulkResource
	{
		public function Post(attributes:Object=null) {
			super(attributes);
		}
		
		resource("posts", Post)
	}
}