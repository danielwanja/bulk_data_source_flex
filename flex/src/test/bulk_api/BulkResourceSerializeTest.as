package test.bulk_api
{
	import bulk_api.BulkResource;
	
	import com.adobe.serialization.json.JSONDecoder;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	
	import test.fixtures.Fixtures;
	import test.models.Author;
	import test.models.Post;

	public class BulkResourceSerializeTest
	{		
		private var fixtures:Fixtures = new Fixtures;
		
		[Test]
		public function testSimpleResource():void {
			var author:Author = new Author();
			author.name = "Daniel";
			author.owned_essay_id = "A Modest Proposal";
			var json:String = BulkResource.to_json({"authors":[author]});
			// redecode for easier testing			
			var actual:Object = new JSONDecoder(json, true).getValue();
			assertTrue("Expected root attribute object to be an array", actual.authors is Array);
			assertEquals(1, actual.authors.length);
			assertFalse(actual.authors[0] is Author);
			assertEquals("Daniel", actual.authors[0].name);
			assertEquals("A Modest Proposal", actual.authors[0].owned_essay_id);
		}
		
		[Test]
		public function testNestedResource():void {
			var author:Author = new Author();
			author.name = "Daniel";
			author.posts = new ArrayCollection();
			var post:Post = new Post;
			post.body = "Such a lovely day";
			author.posts.addItem(post);
			post = new Post;
			post.body = "This rocks!"
			author.posts.addItem(post);
			
			var json:String = BulkResource.to_json({"authors":[author]});
			// redecode for easier testing			
			var actual:Object = new JSONDecoder(json, true).getValue();
			assertTrue("Expected posts to be an array", actual.authors[0].posts is Array);
			var posts:Array = actual.authors[0].posts;
			assertEquals(2, posts.length);
			assertFalse(posts[0] is Post);
			assertEquals("Such a lovely day", posts[0].body);
			assertEquals("This rocks!", posts[1].body);
		}		
		
	}
}