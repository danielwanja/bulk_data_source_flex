package test.bulk_api
{
	import bulk_api.BulkResource;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.AbstractEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	
	import test.models.Post;

	// FIXME: mock call to server.
	// First time before starting the Rails server
	//    $ bundle exec rake db:create
	//    $ bundle exec rake db:migrate
	// Start the Rails testrailsapp:
	//   $ rails s
	public class BulkResourceTest
	{		
		[Before(async)]
		public function setUp():void
		{
			var fixtures:HTTPService = new HTTPService();
			fixtures.url = "http://localhost:3000/fixtures/reset";
			invoke( fixtures.send(), proceed);
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		// FIND
		//---------------------------------------------------------------------
		
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
		
		// CREATE
		//---------------------------------------------------------------------
		
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
			assertEquals(2, data.posts.length); 
			assertTrue("Expected Post instance in result", data.posts.getItemAt(0) is Post);
		}			
		
		// UPDATE
		//---------------------------------------------------------------------
		
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
		
		// DELETE
		//---------------------------------------------------------------------
		
		
		[Test(async)]
		public function testDelete():void {
			invoke( BulkResource.findAll(Post), testDeleteStep2, 3000);
		}
		
		private var beforeDeleteCount:Number;
		public function testDeleteStep2(event:AbstractEvent, token:Object=null):void {
			assertTrue(event is ResultEvent);			
			var posts:ArrayCollection = Object(event).result.posts as ArrayCollection;
			beforeDeleteCount = posts.length;
			invoke( BulkResource.destroy(Post, {posts:new ArrayCollection([posts.getItemAt(0).id])}), assertTestDelete );			
		}
		
		private function assertTestDelete(event:AbstractEvent, token:Object=null):void
		{
			assertTrue(event is ResultEvent);
			var data:Object = (event as ResultEvent).result;
			assertTrue("Expected data.posts to be an ArrayCollection", data.posts is ArrayCollection);
			assertEquals(1, data.posts.length);  
			assertTrue("Expected Post instance in result", data.posts.getItemAt(0) is Post);
			var post:Post = data.posts.getItemAt(0) as Post;
			invoke( BulkResource.findAll(Post), assertTestDeleteDifference);
		}		

		public function assertTestDeleteDifference(event:AbstractEvent, token:Object=null):void {
			var posts:ArrayCollection = Object(event).result.posts as ArrayCollection;
			assertEquals(beforeDeleteCount,  posts.length+1);
		}

		protected function invoke(call:AsyncToken, responder:Function, timeout:Number=2000):void {
			call.addResponder(
				Async.asyncResponder(this, new AsyncResponder(responder, responder), timeout));			
		}
		
		// VALIDATIONS
		//---------------------------------------------------------------------
		
		[Test(async)]
		public function testValidations():void {
			var post:Post = new Post({title:"", body:""});
			var post2:Post = new Post({title:"", body:"another description"});
			invoke( BulkResource.create(Post, {posts:new ArrayCollection([post, post2])}),
				assertTestValidations );
		}
		
		/*
		{"errors":{"posts":{"78022718-C553-4E40-1E85-FD1AE349F987":{"type":"invalid","data":{"title":["can't be blank"]}},"C9912FEB-4963-0042-EA8F-FD1AE34A816B":{"type":"invalid","data":{"title":["can't be blank"]}}}}}
		{"errors":{"posts":{"F423EEE3-CB64-6D21-DA7D-FD1CC0D1F16C":{"type":"invalid","data":{"title":["can't be blank"],"body":["can't be blank"]}},"219F1154-7224-AFBD-68BB-FD1CC0D1A3EB":{"type":"invalid","data":{"title":["can't be blank"]}}}}}
		*/
		private function assertTestValidations(event:AbstractEvent, token:Object=null):void
		{
			assertTrue(event is ResultEvent);
			var data:Object = (event as ResultEvent).result;
			assertTrue("Expected data.posts to be an ArrayCollection", data.posts is ArrayCollection);
			assertEquals(2, data.posts.length);
			var post1:Post = data.posts.getItemAt(0) as Post
			assertNotNull(post1.errors);
			assertEquals("can't be blank", post1.errors.title.join(","))
			assertEquals("can't be blank", post1.errors.body.join(","))

			var post2:Post = data.posts.getItemAt(1) as Post
			assertNotNull(post2.errors);
			assertEquals("can't be blank", post2.errors.title.join(","))
			assertNull(post2.errors.body)
		}	
		
		// HELPERS
		//---------------------------------------------------------------------
		
		protected function proceed(event:AbstractEvent, token:Object=null):void {
			// do nothing
		}
		
	}
}