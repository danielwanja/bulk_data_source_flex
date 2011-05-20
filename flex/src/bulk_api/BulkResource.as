package bulk_api
{
	import com.adobe.serialization.json.JSONDecoder;
	
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectProxy;
	
	import org.hamcrest.core.describedAs;
	
	import test.models.Author;
	import test.models.Comment;
	import test.models.Post;

	/**
	 * This first version doesn't support remote calls and only transforms to and frmo json.
	 * This class will be split up and the BulkEncoder and BulkDecoder functionality will be extracted.
	 */
	public class BulkResource extends ObjectProxy
	{
		
		public function BulkResource() {
			super();
		}
		
		public static function from_json(json:String):ArrayCollection {
			var actionScript:Object = new JSONDecoder(json, /*strict*/true).getValue();
			var attributes:Array = getAttributeNames(actionScript);
			var firstAttribute:String = attributes.length > 0 ? attributes[0] : null; //TODO: check if more than one attribute at root level?
			if (firstAttribute) { // Assuming it's always array based on Katz's comment.
				return decodeArray(firstAttribute, actionScript[firstAttribute] as Array);
			} else {
				return null;
			}
		}
		
		public static function decodeArray(resourceName:String, records:Array):ArrayCollection {
		   var result:Array = [];
		   for each (var record:Object in records) {
			 result.push(cast(resourceName, record));	   
		   }
		   return new ArrayCollection(result);
		}
		
		public static function cast(resourceName:String, record:Object):Object {
			var clazz:Class = classForResource(resourceName); 
			var instance:Object = new clazz();
			for (var attr:String in record) {
				if (record[attr] is Array) {
					instance[attr] = decodeArray(attr, record[attr] as Array);
				} else {
					instance[attr] = record[attr];
				}
				// TODO: add test to check if instance is dynamic (use describeType+type+.isDynamic)
				// TODO: transform date fields based on metadata.json
			}
			return instance;
		}
		
//		private static var classMap:Object = {
//			'authors' : Author,
//			'posts'   : Post,
//			'comments': Comment
//		}
		public static function classForResource(resourceName:String):Class {
			// TODO: implement find associated class based on RemoteClass or other non hardcoded mechanism?
			switch(resourceName)
			{
				case 'authors'	: return Author;
				case 'posts'	: return Post;
				case 'comments'	: return Comment;
				default 		: return Object;
			}
			//return classMap[resourceName]; 
		}
		
		public static function getAttributeNames(record:Object):Array {
			var result:Array = [];
			for (var attr:String in record) {
				result.push(attr);
			}
			return result;
		}
		
		
		public function as_json():String {
			return null;	
		}
	}
}