package asmock.integration.flexunit
{
	import asmock.framework.MockRepository;
	import asmock.framework.proxy.IProxyRepository;
	
	import flash.utils.getDefinitionByName;
	
	import flex.lang.reflect.Klass;
	
	import org.flexunit.internals.runners.statements.Fail;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.internals.runners.statements.StatementSequencer;
	import org.flexunit.runner.notification.IRunNotifier;
	import org.flexunit.runners.BlockFlexUnit4ClassRunner;
	import org.flexunit.runners.model.FrameworkMethod;
	
	public class ASMockClassRunner extends BlockFlexUnit4ClassRunner
	{
		private var _testClass : Class;
		private var _proxyRepository : IProxyRepository;
		
		public function ASMockClassRunner(testClass : Class)
		{
			super(testClass);
			
			_testClass = testClass;
			_proxyRepository = MockRepository.defaultProxyRepository;
		}
		
		protected override function withBefores(method:FrameworkMethod, target:Object):IAsyncStatement
		{
			var sequencer:StatementSequencer = new StatementSequencer();
			
			sequencer.addStep( withMocks(method.metadata, target) );
			sequencer.addStep( super.withBefores(method, target) );
			
			return sequencer;
		}
		
		protected override function withBeforeClasses():IAsyncStatement
		{
			var sequencer:StatementSequencer = new StatementSequencer();
			
			sequencer.addStep( withMocks(testClass.metadata, testClass) );
			sequencer.addStep( super.withBeforeClasses() );
			
			return sequencer;
		}
		
		protected function withMocks(metadata : XMLList, target : Object) : IAsyncStatement
		{
			return new PrepareMocks(_proxyRepository, metadata, target); 
		}
	}
}