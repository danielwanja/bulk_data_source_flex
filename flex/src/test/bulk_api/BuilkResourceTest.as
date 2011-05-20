package test.bulk_api
{
	import bulk_api.BulkResource;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFlexModuleFactory;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.hasProperties;
	
	import test.models.Author;

	public class BuilkResourceTest
	{		
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
			var actual:Object = BulkResource.from_json(authorsJson);
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
		
		[Ignore]
		[Test]
		public function testAsJson():void {
			
		}
		
		private static var authorsJson:String = '{"authors":[{"author_address_extra_id":2,"author_address_id":1,"id":1,"name":"David","organization_id":"No Such Agency","owned_essay_id":"A Modest Proposal"},{"author_address_extra_id":null,"author_address_id":null,"id":2,"name":"Mary","organization_id":null,"owned_essay_id":null},{"author_address_extra_id":null,"author_address_id":null,"id":3,"name":"Bob","organization_id":null,"owned_essay_id":null}]}';
		
	}
}