package test.models
{
	import bulk_api.BulkResource;
	
	[RemoteClass(alias="Comment")]	
	public dynamic class Comment extends BulkResource
	{
		public function Comment(attributes:Object=null) {
			super(attributes);
		}		
		
		resource("comments", Comment);
	}
	
}