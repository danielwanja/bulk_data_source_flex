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

	// FIXME: mock call to server. Currently you need to start the testRailsapp before running the tests.
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
			var call:AsyncToken = BulkResource.findAll(Post);
			call.addResponder(
					Async.asyncResponder(this, new AsyncResponder(testFindAllResult, testFindAllResult), 5000));
		}
		
		private function testFindAllResult(event:AbstractEvent, token:Object=null):void
		{
			assertTrue(event is ResultEvent);
			var data:Object = (event as ResultEvent).result;
			assertTrue("Expected data.posts to be an ArrayCollection", data.posts is ArrayCollection);
			assertEquals(11, data.posts.length);
			assertTrue("Expected Post instance in result", data.posts.getItemAt(0) is Post);
		}
		
		[Test(async)]
		public function testFindOne():void {
			var call:AsyncToken = BulkResource.find(Post, 1);
			call.addResponder(
				Async.asyncResponder(this, new AsyncResponder(testFindOneResult, testFindOneResult), 5000));
		}
		
		private function testFindOneResult(event:AbstractEvent, token:Object=null):void
		{
			assertTrue(event is ResultEvent);
			var data:Object = (event as ResultEvent).result;
			assertTrue("Expected data.posts to be an ArrayCollection", data.posts is ArrayCollection);
			assertEquals(1, data.posts.length);
			assertTrue("Expected Post instance in result", data.posts.getItemAt(0) is Post);
		}		
		
	}
}