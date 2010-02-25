package asmock.framework.impl
{
	import asmock.reflection.PropertyInfo;
	import asmock.reflection.MethodInfo;
	import asmock.framework.IMockedObject;

	[ExcludeClass]
	public class MockedObject implements IMockedObject
	{
		public function MockedObject()
		{
		}

		public function shouldCallOriginal(method:MethodInfo):Boolean
		{
			return false;
		}
		
		public function handleProperty(property:PropertyInfo, method:MethodInfo, args:Array):Object
		{
			return null;
		}
		
		public function isRegisteredProperty(property:PropertyInfo):Boolean
		{
			return false;
		}
		
	}
}