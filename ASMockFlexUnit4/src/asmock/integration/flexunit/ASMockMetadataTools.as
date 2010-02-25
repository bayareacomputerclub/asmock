package asmock.integration.flexunit
{
	import flash.utils.getDefinitionByName;
	
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.Method;
	import flex.lang.reflect.metadata.MetaDataAnnotation;
	import flex.lang.reflect.metadata.MetaDataArgument;
	
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
		
		public static function getMockClasses(metadata : Array) : Array
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
		
		public static function getArgValuesFromMetaDataNode( nodes:Array, metaDataName:String, key:String ):Array {
			
			var values : Array = new Array();

			for each(var node : MetaDataAnnotation in nodes) {
				if(!(node.name == metaDataName)) continue;
				var typeArg : String = "";
				var defaultArg : String = "";  

				if ( node.arguments ) {
					for each(var arg:MetaDataArgument in node.arguments) {
						if(arg.key == key)
							typeArg = arg.value;
						else
							defaultArg = arg.key
					}
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