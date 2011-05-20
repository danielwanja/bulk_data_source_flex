package bulk_api
{
	import com.adobe.serialization.json.JSONDecoder;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectProxy;
	
	import test.models.Author;

	/**
	 * This first version doesn't support remote calls and only transforms to and frmo json.
	 * This class will be split up and the BulkEncoder and BulkDecoder functionality will be extracted.
	 */
	public class BulkResource extends ObjectProxy
	{
		public function BulkResource()
		{
		}
		
		public static function from_json(json:String):ArrayCollection {
			var actionScript:Object = new JSONDecoder(json, /*strict*/true).getValue();
			var attributes:Array = getAttributeNames(actionScript);
			var firstAttribute:String = attributes.length > 0 ? attributes[0] : null; //TODO: check if more than one attribute at root level?
			if (firstAttribute) {
				return new ArrayCollection(decodeArray(firstAttribute, actionScript[firstAttribute] as Array));
			} else {
				return null;
			}
		}
		
		public static function decodeArray(resourceName:String, records:Array):Array {
		   var result:Array = [];
		   for each (var record:Object in records) {
			 result.push(cast(resourceName, record));	   
		   }
		   return result;
		}
		
		public static function cast(resourceName:String, record:Object):Object {
			var clazz:Class = classForResource(resourceName); 
			var instance:Object = new clazz();
			for (var attr:String in record) {
				instance[attr] = record[attr];
				// TODO: add test to check if instance is dynamic
				// TODO: recurse if record[attr] is array
				// TODO: transform date fields
			}
			return instance;
		}
		
		public static function classForResource(resourceName:String):Class {
			return Author;  // TODO: implement
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