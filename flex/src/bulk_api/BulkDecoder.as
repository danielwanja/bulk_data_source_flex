package bulk_api
{
	import com.adobe.serialization.json.JSONDecoder;
	
	import mx.collections.ArrayCollection;

	public class BulkDecoder
	{
		/**
		 * This method takes the raw json received from the Rails app an turns every resources collection
		 * into an array collection of the appropriate BulkResource instances.
		 */
		static public function from_json(json:String):Object {
			var actionScript:Object = new JSONDecoder(json, /*strict*/true).getValue();
			var result:Object = {};

			// Pass errors straight onto result
			var errors:Object = actionScript.errors;
			if (errors) {
				delete actionScript.errors;
				result.errors = errors;
			}

			var resources:Array = BulkUtility.getAttributeNames(actionScript);
			for each (var resource:String in resources) {
				result[resource] = decodeArray(resource, actionScript[resource] as Array);
			}
			return result;
		}
		
		static public function decodeArray(resourceName:String, records:Array):ArrayCollection {
			var result:Array = [];
			for each (var record:Object in records) {
				result.push(cast(resourceName, record));	   
			}
			return new ArrayCollection(result);
		}
		
		static public function cast(resourceName:String, record:Object):Object {
			var clazz:Class = BulkResource.classForResource(resourceName); 
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
		

	}
}