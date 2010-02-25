package flemit.framework.bytecode
{
	import asmock.reflection.FieldInfo;
	import asmock.reflection.MethodInfo;
	import asmock.reflection.PropertyInfo;
	import asmock.reflection.Type;
	
	import flash.utils.Dictionary;
	
	[ExcludeClass]
	public class DynamicClass extends Type
	{
		//public var instanceInitialiser : DynamicMethod;
		
		public var methodBodies : Dictionary = new Dictionary();
		
		public function DynamicClass(qname : QualifiedName, baseClass : Type, interfaces : Array)
		{
			super(qname);
			
			super._baseClass = baseClass;
			
			_interfaces = interfaces;
		}
		
		public function addMethodBody(method : MethodInfo, methodBody : DynamicMethod) : void
		{
			this.methodBodies[method] = methodBody;
		}
		
		public function addMethod(method : MethodInfo) : void
		{
			_methods.push(method);
		}
		
		public function addProperty(property : PropertyInfo) : void
		{
			_properties.push(property);
		}
		
		public function addSlot(field : FieldInfo) : void
		{
			_fields.push(field);
		}
		
		public function set constructor(value : MethodInfo) : void
		{
			_constructor = value;
		}

	}
}