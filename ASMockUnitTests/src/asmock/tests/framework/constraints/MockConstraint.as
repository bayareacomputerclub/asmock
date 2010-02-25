package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.AbstractConstraint;
	import asmock.tests.SimpleMock;
	
	public class MockConstraint extends AbstractConstraint
	{
		public function MockConstraint()
		{
		}
		
		public override function eval(obj:Object):Boolean
		{
			return _mock.exec("eval", [obj]);
		}
		
		public override function get message():String
		{
			return _mock.exec("message") as String;
		}
		
		private var _mock : SimpleMock = new SimpleMock(this);
		public function get mock() : SimpleMock
		{
			return _mock;
		}

	}
}