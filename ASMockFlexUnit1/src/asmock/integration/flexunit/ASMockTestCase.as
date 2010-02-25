package asmock.integration.flexunit
{
	import asmock.framework.MockRepository;
	import asmock.framework.proxy.IProxyRepository;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestResult;
	
	public class ASMockTestCase extends TestCase
	{
		private var _mockClasses : Array;
		
		private var _proxyRepository : IProxyRepository = MockRepository.defaultProxyRepository;
		private var _initialised : Boolean = false;
		
		public function ASMockTestCase(mockClasses : Array)
		{
			_mockClasses = mockClasses || [];
		}
		
		public override function runWithResult(result:TestResult):void
		{
			if (!_initialised)
			{
				var superRunWithResult : Function = super.runWithResult;
				
				var dispatcher : IEventDispatcher = _proxyRepository.prepare(_mockClasses);
				dispatcher.addEventListener(Event.COMPLETE, repositoryPreparedHandler);
				
				function repositoryPreparedHandler(event : Event) : void 
				{
					superRunWithResult(result);
				}
			}
			else
			{
				super.runWithResult(result);
			}
		}
		
		protected function get proxyRepository() : IProxyRepository
		{
			return _proxyRepository;
		}
	}
}