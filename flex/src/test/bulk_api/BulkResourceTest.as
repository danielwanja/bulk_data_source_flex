package test.bulk_api
{
	import bulk_api.BulkResource;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.AbstractEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	
	import test.models.Post;

	// FIXME: mock call to server.
	// Reset the Rails testrailsapp:
	//    $ rake db:reset
	//    $ rake db:fixtures:load
	// Start the Rails testrailsapp:
	//   $ rails s
	public class BulkResourceTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[Test(async)]
		public function testFindAll():void {
			invoke( BulkResource.findAll(Post), assertTestFindAll);
		}
		
		private function assertTestFindAll(event:AbstractEvent, token:Object=null):void
		{
			assertTrue(event is ResultEvent);
			var data:Object = (event as ResultEvent).result;
			assertTrue("Expected data.posts to be an ArrayCollection", data.posts is ArrayCollection);
			assertEquals(11, data.posts.length);
			assertTrue("Expected Post instance in result", data.posts.getItemAt(0) is Post);
		}
		
		[Test(async)]
		public function testFindOne():void {
			invoke( BulkResource.find(Post, 1), assertTestFindOne);
		}
		
		private function assertTestFindOne(event:AbstractEvent, token:Object=null):void
		{
			assertTrue(event is ResultEvent);
			var data:Object = (event as ResultEvent).result;
			assertTrue("Expected data.posts to be an ArrayCollection", data.posts is ArrayCollection);
			assertEquals(1, data.posts.length);
			assertTrue("Expected Post instance in result", data.posts.getItemAt(0) is Post);
		}		
		
		[Test(async)]
		public function testCreate():void {
			var post1:Post = new Post({title:"Rails Rocks!", body:"A long description..."});
			var post2:Post = new Post({title:"another title", body:"another description"});
			invoke( BulkResource.create(Post, {posts:new ArrayCollection([post1, post2])}),
					assertTestCreate );
		}
		
		private function assertTestCreate(event:AbstractEvent, token:Object=null):void
		{
			assertTrue(event is ResultEvent);
			var data:Object = (event as ResultEvent).result;
			assertTrue("Expected data.posts to be an ArrayCollection", data.posts is ArrayCollection);
			assertEquals(2, data.posts.length);  // <-- Test Fails, only last post is returned. Would expect all posts.
			assertTrue("Expected Post instance in result", data.posts.getItemAt(0) is Post);
		}			
		
		[Test(async)]
		public function testUpdate():void {
			invoke( BulkResource.find(Post, 1), testUpdateStep2);
		}
		
		public function testUpdateStep2(event:AbstractEvent, token:Object=null):void {
			var post:Post = Object(event).result.posts.getItemAt(0) as Post;
			post.body = "Black Rain";
			invoke( BulkResource.update(Post, {posts:new ArrayCollection([post])}), assertTestUpdate );			
		}
		
		private function assertTestUpdate(event:AbstractEvent, token:Object=null):void
		{
			assertTrue(event is ResultEvent);
			var data:Object = (event as ResultEvent).result;
			assertTrue("Expected data.posts to be an ArrayCollection", data.posts is ArrayCollection);
			assertEquals(1, data.posts.length);  
			assertTrue("Expected Post instance in result", data.posts.getItemAt(0) is Post);
			var post:Post = data.posts.getItemAt(0) as Post;
			assertEquals("Black Rain", post.body);
		}			
		
		
		[Test(async)]
		public function testDelete():void {
			invoke( BulkResource.findAll(Post), testDeleteStep2);
		}
		
		private var beforeDeleteCount:Number;
		public function testDeleteStep2(event:AbstractEvent, token:Object=null):void {
			var posts:ArrayCollection = Object(event).result.posts as ArrayCollection;
			beforeDeleteCount = posts.length;
			invoke( BulkResource.destroy(Post, {posts:new ArrayCollection([posts.getItemAt(0)])}), assertTestDelete );			
		}
		
		private function assertTestDelete(event:AbstractEvent, token:Object=null):void
		{
			assertTrue(event is ResultEvent);
			var data:Object = (event as ResultEvent).result;
			assertTrue("Expected data.posts to be an ArrayCollection", data.posts is ArrayCollection);
			assertEquals(1, data.posts.length);  
			assertTrue("Expected Post instance in result", data.posts.getItemAt(0) is Post);
			var post:Post = data.posts.getItemAt(0) as Post;
			assertEquals("Black Rain", post.body);
		}		
		
		protected function invoke(call:AsyncToken, responder:Function, timeout:Number=2000):void {
			call.addResponder(
				Async.asyncResponder(this, new AsyncResponder(responder, responder), timeout));			
		}
	}
}