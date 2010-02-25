package flemit.framework.bytecode
{
	import asmock.reflection.*;
	
	[ExcludeClass]
	public interface IByteCodeLayoutBuilder
	{
		function registerType(type : Type) : void;
		function registerMethodBody(method : MethodInfo, methodBody : DynamicMethod) : void;
		
		function createLayout() : IByteCodeLayout;
	}
}