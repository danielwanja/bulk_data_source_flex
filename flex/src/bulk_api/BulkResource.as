package bulk_api
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	
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
		
		//-----------------------------------------------
		// DECODER
		//-----------------------------------------------
		
		/**
		 * This method takes the raw json received from the Rails app an turns it into an
		 * array collection of instances of BulkResources.
		 * Currently this code assume that only one root level association is coming back
		 * which may not be true.
		 */
		static public function from_json(json:String):ArrayCollection {
			var actionScript:Object = new JSONDecoder(json, /*strict*/true).getValue();
			var attributes:Array = getAttributeNames(actionScript);
			// FIXME: convert all attributes...The Result of from_json is an object i.e. {todos:[], projects:[]}
			var firstAttribute:String = attributes.length > 0 ? attributes[0] : null; 
			if (firstAttribute) { // Assuming it's always an array based on Katz's comment during his RailsConf talk.
				return decodeArray(firstAttribute, actionScript[firstAttribute] as Array);
			} else {
				return null;
			}
		}
		
		static public function decodeArray(resourceName:String, records:Array):ArrayCollection {
		   var result:Array = [];
		   for each (var record:Object in records) {
			 result.push(cast(resourceName, record));	   
		   }
		   return new ArrayCollection(result);
		}
		
		static public function cast(resourceName:String, record:Object):Object {
			var clazz:Class = classForResource(resourceName); 
			var instance:Object = new clazz();
			for (var attr:String in record) {
				if (record[attr] is Array) {
					instance[attr] = decodeArray(attr, record[attr] as Array);
				} else {
					instance[attr] = record[attr];
				}
				// TODO: add test to check if instance is dynamic (use describeType+type+.isDynamic)
				// TODO: transform date fields based on metadata.json or other mechanism
			}
			return instance;
		}
		
		public static function classForResource(resourceName:String):Class {
			var clazz:Class = resourceMap[resourceName];
			return clazz ? clazz : Object;
		}
		
		static protected var resourceMap:Object = {};
		static protected function resource(resourceName:String, clazz:Class):void {
			resourceMap[resourceName] = clazz;
		}
		
		//-----------------------------------------------
		// ENCODER
		//-----------------------------------------------
		
		/**
		 * This method generates the json to be sent to the Rails app bulk_api.
		 * Outputs {"authors":[{attr1:value, attr2:value}]"}
		 * @arg resourceName - the name of the resource
		 * @data - an objet with one attribute per changed resource, i.e. {todos:[], projects:[]}
		 * @return the json string backed for the bulk_api.
		 */
		static public function to_json(data:Object):String {
			var resources:Array = getAttributeNames(data);
			var json:Object = {}
			for each (var resource:String in resources) {
				json[resource] = encodeArray(toArrayCollection(data[resource]));
			}
			return new JSONEncoder(json).getString();	
		}
		
		static public function encodeArray(records:ArrayCollection):Array {
			// _local_id
			var result:Array = [];
			for each (var record:Object/*BulkResource instance*/ in records) {
				result.push(encodeObject(record));
			}
			return result;
		}		
		
		static public function encodeObject(record:Object):Object {
			if (record is ObjectProxy) {
				var result:Object = {};
				var attributes:Array = getAttributeNames(record);
				for each (var attr:String in attributes) {
					if (record[attr] is ArrayCollection) {
						result[attr] = encodeArray(record[attr]);
					} else {
						result[attr] = record[attr]
					}
				}				
				return result;
			} 
			else {
				return record;
			}
		}
		//-----------------------------------------------
		// COMMON UTILITIES
		//-----------------------------------------------
		
		public static function getAttributeNames(record:Object):Array {
			var result:Array = [];
			for (var attr:String in record) {
				result.push(attr);
			}
			return result;
		}
		
		public static function toArrayCollection(array:*):ArrayCollection {
			if (array==null) return null;
			if (array is ArrayCollection) return array;
			if (array is Array) return new ArrayCollection(array);
			return new ArrayCollection(ArrayUtil.toArray(array));
		}
		
	}
}