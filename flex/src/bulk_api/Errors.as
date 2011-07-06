package bulk_api
{
	import mx.collections.ArrayCollection;

	/**
	 *  Represents Rails validations errors.
	 *  FIXME: added support for base errors
	 */
	[Bindable]
	public class Errors
	{
		protected var errors:Object;
		
		public function Errors(errors:Object)
		{
			this.errors = errors;
		}
		
		public function hasErrors():Boolean {
			return false;
		}
		
		public function fullMessages():Array {
			return [];	
		}
		
		public function errorFields():Array {
			return [];
		}
		
		public function hasErrorsOn(field:String):Boolean {
			return false;
		}
		
		public function fullMessagesOn(field:String):Array {
			return []
		}
	}
}