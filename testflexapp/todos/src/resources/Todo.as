package resources
{
	import bulk_api.BulkResource;
	
	[RemoteClass(alias="Todo")]	
	public dynamic class Todo extends BulkResource
	{
		public function Todo(attributes:Object=null) {
			super(attributes);
		}
		
		resource("todos", Todo)
	}
}