import asmock.framework.MockRepository;

import flexunit.framework.TestCase;
import flexunit.framework.TestResult;

import flash.events.Event;
import flash.events.IEventDispatcher;

public class MockTestCase extends TestCase
{
	private var _mockClasses : Array;
	private var _mockRepository : MockRepository;
	
	public function MockTestCase(mockClasses : Array)
	{
		_mockClasses = mockClasses;
	}
	
	public override function setUp() : void
	{
		_mockRepository.backToRecordAll();
	}
	
	public override function runWithResult(result:TestResult):void
	{
		if (_mockRepository == null)
		{
			_mockRepository = new MockRepository();
			
			var superRunWithResult : Function = super.runWithResult;
			
			var dispatcher : IEventDispatcher = _mockRepository.prepare(_mockClasses);
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
	
	protected function get mockRepository() : MockRepository
	{
		return _mockRepository;
	}
}