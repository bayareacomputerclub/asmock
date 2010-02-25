package asmock.tests.framework
{
	import asmock.framework.MockRepository;
	import asmock.framework.proxy.IProxyRepository;
	import asmock.framework.proxy.ProxyRepositoryImpl;
	import asmock.tests.ExtendedTestCase;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import flexunit.framework.TestResult;
	
	public class MockTestCase extends ExtendedTestCase
	{
		private var _mockClasses : Array;
		private var _mockRepository : MockRepository;
		
		public function MockTestCase(mockClasses : Array)
		{
			_mockClasses = mockClasses;
		}
		
		public override function runWithResult(result:TestResult):void
		{
			if (_mockRepository == null)
			{
				_mockRepository = new MockRepository();
				
				var superRunWithResult : Function = super.runWithResult;
				
				var dispatcher : IEventDispatcher = _mockRepository.prepare(_mockClasses);
				dispatcher.addEventListener(Event.COMPLETE, repositoryPreparedHandler);
			}
			else
			{
				super.runWithResult(result);
			}
			
			function repositoryPreparedHandler(event : Event) : void 
			{
				superRunWithResult(result);
			}
		}
		
		protected function get mockRepository() : MockRepository
		{
			return _mockRepository;
		}

	}
}