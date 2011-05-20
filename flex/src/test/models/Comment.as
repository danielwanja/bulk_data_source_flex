package test.models
{
	import bulk_api.BulkResource;
	
	[RemoteClass(alias="Comment")]	
	public dynamic class Comment extends BulkResource
	{
		resource("comments", Comment);
	}
	
}