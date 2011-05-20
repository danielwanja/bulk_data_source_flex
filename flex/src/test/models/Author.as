package test.models
{
	import bulk_api.BulkResource;
	
	[RemoteClass(alias="Author")]
	public dynamic class Author extends BulkResource
	{
		resource("authors", Author); // FIXME: name could be inferred...Unfortunaltely static class not.
	}
}