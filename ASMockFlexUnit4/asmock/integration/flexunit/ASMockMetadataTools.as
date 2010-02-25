package asmock.integration.flexunit
{
	import flash.utils.getDefinitionByName;
	
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.Method;
	
	public class ASMockMetadataTools
	{
		private static const MOCK_METADATA : String = "Mock";
		private static const MOCK_METADATA_TYPE_KEY : String = "type";
		
		public static function hasMockClasses(testClass : Class) : Boolean
		{
			var klass : Klass = new Klass(testClass);
			
			if (klass.hasMetaData(MOCK_METADATA)) {
				return true;
			}
			
			for each(var method : Method in klass.methods) {
				if (method.hasMetaData(MOCK_METADATA)) {
					return true;
				}
			}
			
			return false;
		}
		
		public static function getMockClasses(metadata : XMLList) : Array
		{
			var classNames : Array = getArgValuesFromMetaDataNode(metadata, 
			 	MOCK_METADATA, MOCK_METADATA_TYPE_KEY);
			 	
			return classNames.map(mapClass);
		}
		
		private static function mapClass(className : String, index : int, source : Array) : Class
		{
			var klass : Class = null;
			
			try
			{
				klass = getDefinitionByName(className) as Class;
			}
			catch(error : Error)
			{
				throw new ASMockMetadataError("[Mock] metadata specified invalid class: " + className);
			}
			
			return klass;
		}
		
		public static function getArgValuesFromMetaDataNode( nodes:XMLList, metaDataName:String, key:String ):Array {
			var value:String;
			var metaNodes:XMLList;
			
			var values : Array = new Array();

			for each(var node : XML in nodes.(@name == metaDataName)) {
			
				var typeArg : String = null;
				var defaultArg : String = null;  

				if ( node.arg ) {
					typeArg = String( node.arg.(@key==key).@value );
					defaultArg = String( node.arg.(@key=="").@value );
				}
				
				var hasType : Boolean = (typeArg.length > 0);
				var hasDefault : Boolean = (defaultArg.length > 0);
				
				if (hasType)
				{
					if (values.indexOf(typeArg) == -1)
					{
						values.push(typeArg);
					}
				}
				else if (hasDefault)
				{
					if (values.indexOf(defaultArg) == -1)
					{
						values.push(defaultArg);
					}
				}
			}
			
			return values;
		}
	}
}