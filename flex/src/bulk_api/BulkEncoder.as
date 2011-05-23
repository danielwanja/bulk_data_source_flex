package bulk_api
{
	import com.adobe.serialization.json.JSONEncoder;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;

	public class BulkEncoder
	{
		/**
		 * This method generates the json to be sent to the Rails app bulk_api.
		 * Outputs {"authors":[{attr1:value, attr2:value}]"}
		 * @arg resourceName - the name of the resource
		 * @data - an objet with one attribute per changed resource, i.e. {todos:[], projects:[]}
		 * @return the json string backed for the bulk_api.
		 */
		static public function to_json(data:Object):String {
			var resources:Array = BulkUtility.getAttributeNames(data);
			var json:Object = {}
			for each (var resource:String in resources) {
				json[resource] = encodeArray(BulkUtility.toArrayCollection(data[resource]));
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
				var attributes:Array = BulkUtility.getAttributeNames(record);
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
	}
}