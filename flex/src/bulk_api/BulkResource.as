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
		public function BulkResource(attributes:Object=null) {
			super();
			BulkUtility.copyAttributes(attributes, this);
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
		
		static public function create(clazz:Class, data:Object):AsyncToken {
			var http:HTTPService = new HTTPService();
			http.url = baseUrl+"/api/bulk";
			http.method = "POST";
			http.resultFormat = "text";
			http.contentType = "application/json";			
			return call(http, BulkEncoder.to_json(data))
		}

		static public function update(clazz:Class, data:Object):AsyncToken {
			var http:HTTPService = new HTTPService();
			http.url = baseUrl+"/api/bulk";
			http.method = "POST";
			http.headers={X_HTTP_METHOD_OVERRIDE:'put'}; // tell Rails we really want a put
			http.resultFormat = "text";
			http.contentType = "application/json";
			return call(http, BulkEncoder.to_json(data))
		}
		
		static public function destroy(clazz:Class, data:Object):AsyncToken {
			var http:HTTPService = new HTTPService();
			http.url = baseUrl+"/api/bulk";
			http.method = "POST";
			http.headers={X_HTTP_METHOD_OVERRIDE:'delete'}; // tell Rails we really want a delete
			http.resultFormat = "text";
			http.contentType = "application/json";
			return call(http, BulkEncoder.to_json(data))
		}
		
		//-----------------------------------------------------------
		// DATA CONVERSION METHODS
		//-----------------------------------------------------------
		
		static protected function call(service:HTTPService, params:Object=null):AsyncToken {
			var call:AsyncToken = service.send(params);
			call.addResponder(new AsyncResponder(handleResult, handleFault));
			return call;			
		}
		
		static protected function handleResult(event:ResultEvent, token:Object=null):void {
			event.mx_internal::setResult(BulkDecoder.from_json(event.result as String));
		}
		
		static protected function handleFault(fault:FaultEvent, token:Object=null):void {
			// TODO: see how to deal with error object
		}

		//-----------------------------------------------------------
		// CLASS REGISTRY METHODS
		//-----------------------------------------------------------
		
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