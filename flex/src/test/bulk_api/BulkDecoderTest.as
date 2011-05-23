package test.bulk_api
{
	import bulk_api.BulkDecoder;
	import bulk_api.BulkResource;
	import bulk_api.BulkUtility;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFlexModuleFactory;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.allOf;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.text.containsString;
	
	import test.fixtures.Fixtures;
	import test.models.Author;
	import test.models.Post;

	public class BulkDecoderTest
	{		
		private var fixtures:Fixtures = new Fixtures;
		
		[Test]
		public function testEmtpyArray():void {
			var data:Object = BulkDecoder.from_json('{"authors":[]}');
			assertTrue("Expected ArrayCollection class", data.authors is ArrayCollection);
			assertEquals(0, data.authors.length);
		}
		
		[Test]
		public function testEmptyResponse():void {
			var authors:Object = BulkDecoder.from_json('{}');
			var attributes:Array = BulkUtility.getAttributeNames(authors); // Using internal method to check if result is really empty.
			assertEquals(0, attributes.length);
		}
		
		[Test]
		public function testSimpleResource():void {
			var data:Object = BulkDecoder.from_json(fixtures.authors);
			assertTrue("Expected ArrayCollection class", data.authors is ArrayCollection);
			var author1:Object = data.authors.getItemAt(0);
			var author2:Object = data.authors.getItemAt(1);
			var author3:Object = data.authors.getItemAt(2);
			assertTrue("Expected Author class", author1 is Author);
			assertTrue("Expected Author class", author2 is Author);
			assertTrue("Expected Author class", author3 is Author);
			
		    assertThat(author1, hasProperties({ id: 1, 
												name:"David",
												organization_id: "No Such Agency",
												owned_essay_id : "A Modest Proposal"
											   }));
			
			assertThat(author2, hasProperties({ id: 2, 
												name:"Mary",
												organization_id: null,
												owned_essay_id : null
											}));
			
			assertThat(author3, hasProperties({ id: 3, 
												name:"Bob",
												organization_id: null,
												owned_essay_id : null
											}));
			
		}
				
		[Test]
		public function testNestedResources():void {
			var data:Object = BulkDecoder.from_json(fixtures.authors_with_posts_and_comments);
			var authors:ArrayCollection = data.authors;
			assertEquals(3, authors.length);
			var author:Author = authors.getItemAt(0) as Author;
			assertTrue("Expected posts to be an ArrayCollection", author.posts is ArrayCollection);
			assertEquals(5, author.posts.length);
			var post:Post = author.posts.getItemAt(0) as Post;
			assertEquals("Such a lovely day", post.body);
			assertTrue("Expected comments to be an ArrayCollection", post.comments is ArrayCollection);
			assertEquals(2, post.comments.length);
			assertEquals("Thank you for the welcome", post.comments.getItemAt(0).body);
			assertEquals("Thank you again for the welcome", post.comments.getItemAt(1).body);
		}
		
		[Test]
		public function testMultipleRootAttributes():void {
			var json:String = '{"authors":[{"id":1,"name":"David"}], "posts":[{"id":2, "body":"post1"},{"id":3, "body":"post2"}]}';
			var data:Object = BulkDecoder.from_json(json);
			assertEquals(1, data.authors.length);
			assertEquals(2, data.posts.length);
			assertEquals("Expecting only authors and post as data attributes", 2, BulkUtility.getAttributeNames(data).length); 
		}
		
	}
}