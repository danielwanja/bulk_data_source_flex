package test.bulk_api
{
	import bulk_api.BulkResource;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFlexModuleFactory;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.hasProperties;
	
	import test.fixtures.Fixtures;
	import test.models.Author;
	import test.models.Post;

	public class BulkResourceTest
	{		
		private var fixtures:Fixtures = new Fixtures;
		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[Ignore]
		[Test]
		public function testRemoteClass():void {
			
		}
		
		//------------------------------------------------
		// Author: Simple Resource
		//------------------------------------------------
	
		[Test]
		public function testEmtpyArray():void {
			var authors:Object = BulkResource.from_json('{"authors":[]}');
			assertTrue("Expected ArrayCollection class", authors is ArrayCollection);
			assertEquals(0, authors.length);
		}
		
		[Test]
		public function testEmptyResponse():void {
			var authors:Object = BulkResource.from_json('{}');
			assertNull(authors);
		}
		
		[Test]
		public function testFromJson():void {
			var actual:Object = BulkResource.from_json(fixtures.authors);
			assertTrue("Expected ArrayCollection class", actual is ArrayCollection);
			var author1:Object = actual.getItemAt(0);
			var author2:Object = actual.getItemAt(1);
			var author3:Object = actual.getItemAt(2);
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
		
		//------------------------------------------------
		// Post->Comment: Nested Resource
		//------------------------------------------------
		
		[Test]
		public function testNestedResources():void {
			var authors:ArrayCollection = BulkResource.from_json(fixtures.authors_with_posts_and_comments) as ArrayCollection;
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
		
		[Ignore]
		[Test]
		public function testAsJson():void {
			
		}
		
	}
}