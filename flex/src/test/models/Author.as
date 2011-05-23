package test.models
{
	import bulk_api.BulkResource;
	
	[RemoteClass(alias="Author")]
	public dynamic class Author extends BulkResource
	{
		// FIXME: name could be inferred...Unfortunaltely static class not.
		//		  shall we use the singular form: resource("author", Author);
		//		  could default to class name i.e. resource(Author)
		resource("authors", Author); 
	}
}