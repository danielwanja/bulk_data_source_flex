package test.models
{
	import bulk_api.BulkResource;
	
	[RemoteClass(alias="Post")]	
	public dynamic class Post extends BulkResource
	{
		resource("posts", Post)
	}
}