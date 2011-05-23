package bulk_api
{
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.utils.ObjectProxy;

	/**
	 * A dynamic class that maps to a Resource. Can be used for CRUD operations.
	 */
	public class BulkResource extends ObjectProxy
	{
		
		public function BulkResource() {
			super();
		}

		static public function find(...args):AsyncToken {
			return null;	
		}
		
		static public function findAll(...args):AsyncToken {
			return null;
		}
		
		static public function save(...args):AsyncToken {
			return null;
		}
		
		static public function get autoCommit():Boolean {
			return false;	
		}
		
		static public function set autoCommit(value:Boolean):void {
			
		}
		
		static public function get pendingChanges():ArrayCollection {
			return null;
		}
		
		public static function classForResource(resourceName:String):Class {
			var clazz:Class = resourceMap[resourceName];
			return clazz ? clazz : Object;
		}
		
		static protected var resourceMap:Object = {};
		static protected function resource(resourceName:String, clazz:Class):void {
			resourceMap[resourceName] = clazz;
		}		
	}
}