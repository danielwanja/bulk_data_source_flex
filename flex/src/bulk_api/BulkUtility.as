package bulk_api
{
	import mx.collections.ArrayCollection;
	import mx.utils.ArrayUtil;

	public class BulkUtility
	{
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