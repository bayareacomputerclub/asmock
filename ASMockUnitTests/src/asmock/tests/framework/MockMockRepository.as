package asmock.tests.framework
{
	import asmock.framework.MockRepository;
	import asmock.framework.impl.IMethodRecorder;
	import asmock.tests.SimpleMock;
	
	import asmock.framework.asmock_internal;
	
	use namespace asmock_internal;
	
	public class MockMockRepository extends MockRepository
	{
		public function MockMockRepository()
		{
		}
		
		public override function get lastMockedObject() : Object
		{
			return _mock.exec("set_lastMockedObject") as Object;
		}
		
		public override function set lastMockedObject(value : Object) : void
		{
			_mock.exec("set_lastMockedObject", [value]);
		}
		
		asmock_internal override function get recorder():IMethodRecorder
		{
			return _mock.exec("recorder") as IMethodRecorder;
		}
		
		asmock_internal override function get replayer() : IMethodRecorder
		{
			return _mock.exec("replayer") as IMethodRecorder;
		}

		private var _mock : SimpleMock = new SimpleMock(this);
		public function get mock() : SimpleMock
		{
			return _mock;
		}
	}
}