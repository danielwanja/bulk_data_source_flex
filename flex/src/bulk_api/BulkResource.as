package bulk_api
{
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectProxy;

	/**
	 * A dynamic class that maps to a Resource. Can be used for CRUD operations.
	 * 
	 *  api_bulk GET    /api/bulk(.:format) {:controller=>"bulk/api", :action=>"get"}
     *			 POST   /api/bulk(.:format) {:controller=>"bulk/api", :action=>"create"}
     * 			 PUT    /api/bulk(.:format) {:controller=>"bulk/api", :action=>"update"}
     *			 DELETE /api/bulk(.:format) {:controller=>"bulk/api", :action=>"delete"}
	 */
	public class BulkResource extends ObjectProxy
	{
		static public var baseUrl:String = "http://localhost:3000";
		public function BulkResource() {
			super();
		}

		static public function find(clazz:Class, id:Number):AsyncToken {
			var http:HTTPService = new HTTPService();
			http.url = baseUrl+"/api/bulk?"+resourceForClass(clazz)+"="+id;
			return call(http)
		}
		
		static public function findAll(clazz:Class):AsyncToken {
			var http:HTTPService = new HTTPService();
			http.url = baseUrl+"/api/bulk?"+resourceForClass(clazz)+"=all";
			return call(http);
		}
		
		static protected function call(service:HTTPService, params:Object=null):AsyncToken {
			var call:AsyncToken = service.send();
			call.addResponder(new AsyncResponder(handleResult, handleFault));
			return call;			
		}
		
		static protected function handleResult(event:ResultEvent, token:Object=null):void {
			event.mx_internal::setResult(BulkDecoder.from_json(event.result as String));
		}
		
		static protected function handleFault(fault:FaultEvent, token:Object=null):void {
			
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
				
		public static function resourceForClass(clazz:Class):String {
			return reverseMap[clazz];
		}
		
		static protected var resourceMap:Object = {};
		static protected var reverseMap:Object = {};
		static protected function resource(resourceName:String, clazz:Class):void {
			resourceMap[resourceName] = clazz;
			reverseMap[clazz] = resourceName;
		}		
	}
}