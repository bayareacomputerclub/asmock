package asmock.integration.fluint
{
	import asmock.framework.MockRepository;
	import asmock.framework.proxy.IProxyRepository;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import net.digitalprimates.fluint.tests.TestCase;
	
	public class ASMockTestCase extends TestCase
	{
		private var _mockClasses : Array;
		private var _proxyRepository : IProxyRepository = MockRepository.defaultProxyRepository;
		
		private var _preparationComplete : Boolean;
		private var _setupPending : Boolean;
		
		public function ASMockTestCase(mockClasses : Array)
		{
			super();
			
			_mockClasses = mockClasses;
			_preparationComplete = false;
			_setupPending = false;
		}
		
		protected function get proxyRepository() : IProxyRepository
		{
			return _proxyRepository;
		}
		
		/**
		 * Returns a value indicated whether expectations should be cleared 
		 * between each test case. Default value is true. 
		 * @return 
		 */	
		public function get autoClearExpectations() : Boolean
		{
			return true;
		}
		
		public override function runSetup() : void
		{
			if (_preparationComplete)
			{
				super.runSetup();
			}
			else
			{
				_setupPending = true;
				
				var dispatcher : IEventDispatcher = _proxyRepository.prepare(_mockClasses);
				dispatcher.addEventListener(Event.COMPLETE, repositoryPreparedHandler);
			}
		}
		
		public override function get hasPendingAsync() : Boolean
		{
			if (!_preparationComplete)
			{
				return true;
			}
			
			return super.hasPendingAsync;
		}
		
		private function repositoryPreparedHandler(event : Event) : void
		{
			_preparationComplete = true;
			
			if (_setupPending)
			{
				super.runSetup();
			}
		}
	}
}