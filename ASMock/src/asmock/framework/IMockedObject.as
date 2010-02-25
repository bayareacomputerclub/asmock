package asmock.framework
{
	import asmock.framework.constraints.Property;
	import asmock.reflection.*;
	
	[ExcludeClass]
	public interface IMockedObject
	{
		function shouldCallOriginal(method : MethodInfo) : Boolean;
		
		function handleProperty(property : PropertyInfo, method : MethodInfo, args : Array) : Object;
		function isRegisteredProperty(property : PropertyInfo) : Boolean;		
	}
}