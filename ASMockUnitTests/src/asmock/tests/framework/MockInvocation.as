package asmock.tests.framework
{
	import asmock.framework.proxy.IInvocation;
	import asmock.reflection.MethodInfo;
	import asmock.reflection.PropertyInfo;
	import asmock.reflection.Type;
	import asmock.tests.SimpleMock;

	public class MockInvocation implements IInvocation
	{
		public function MockInvocation()
		{
		}

		public function get arguments():Array
		{
			return _mock.exec("arguments") as Array;
		}
		
		public function get targetType():Type
		{
			return _mock.exec("targetType") as Type;
		}
		
		public function get proxy():Object
		{
			return _mock.exec("proxy") as Object;
		}
		
		public function get property():PropertyInfo
		{
			return null;
		}
		
		public function get method():MethodInfo
		{
			return null;
		}
		
		public function get invocationTarget():Object
		{
			return _mock.exec("invocationTarget") as Object;
		}
		
		public function get methodInvocationTarget():MethodInfo
		{
			return _mock.exec("methodInvocationTarget") as MethodInfo;
		}
		
		public function get returnValue():Object
		{
			return _mock.exec("get_returnValue") as Object;
		}
		
		public function set returnValue(value:Object):void
		{
			_mock.exec("set_returnValue", [value]);
		}
		
		public function get canProceed():Boolean
		{
			return _mock.exec("get_canProceed") as Boolean;
		}
		
		public function proceed():void
		{
			_mock.exec("proceed");
		}
		
		private var _mock : SimpleMock = new SimpleMock(this);
		public function get mock() : SimpleMock
		{
			return _mock;
		}
		
	}
}