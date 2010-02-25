package asmock.integration.flexunit
{
	import asmock.framework.proxy.IProxyRepository;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexunit.internals.runners.statements.AsyncStatementBase;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.token.AsyncTestToken;
	
	public class PrepareMocks extends AsyncStatementBase implements IAsyncStatement
	{
		private static const TIMEOUT_PER_CLASS : int = 5000;
		
		private var _proxyRepository : IProxyRepository;
		private var _metadata : XMLList;
		private var _target : Object;
		
		public function PrepareMocks(proxyRepository : IProxyRepository, metadata : XMLList, target : Object)
		{
			this._target = _target;
			this._metadata = metadata;			
			this._proxyRepository = proxyRepository;
		}
		
		public function evaluate( parentToken:AsyncTestToken ):void
		{
			var classesToMock : Array = null;
			
			try
			{
				classesToMock = ASMockMetadataTools.getMockClasses(_metadata);
			}
			catch(error : Error)
			{
				parentToken.sendResult(error);
				return;
			}
			
			var timeoutTimer : Timer = new Timer(TIMEOUT_PER_CLASS * classesToMock.length, 1);
			timeoutTimer.addEventListener(TimerEvent.TIMER, function(event : Event = null) : void
			{
				// TODO: List the class names? Might help with debugging
				parentToken.sendComplete(new Error("Timeout waiting for mocks to prepare"));	
				
				timeoutTimer.stop();
			});
			
			var eventDispatcher : IEventDispatcher = _proxyRepository.prepare(classesToMock);
			eventDispatcher.addEventListener(Event.COMPLETE, repositoryPreparedHandler);
			eventDispatcher.addEventListener(ErrorEvent.ERROR, repositoryErrorHandler);
			
			function repositoryPreparedHandler(event : Event) : void 
			{
				parentToken.sendResult(null);
			}
			
			function repositoryErrorHandler(event : ErrorEvent) : void
			{
				parentToken.sendResult(new Error(event.text));				
			}
		}

	}
}