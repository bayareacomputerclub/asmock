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
		
		override protected function methodBlock( method:FrameworkMethod ):IAsyncStatement {
			var c:Class;
			
			var test:Object;
			//might need to be reflective at some point
			try {
				test = createTest();
			} catch ( e:Error ) {
				trace( e.getStackTrace() );
				return new Fail(e);
			}
			
			var sequencer:StatementSequencer = new StatementSequencer();
			
			sequencer.addStep( withMocks() );
			sequencer.addStep( withBefores( method, test) );
			sequencer.addStep( withDecoration( method, test ) );
			sequencer.addStep( withAfters( method, test ) );
			
			return sequencer;
		}
		
		protected function withMocks() : IAsyncStatement
		{
			var mockMetaData:Array = [];
			var methods:Array = [];
			
			//get all the methods with a Mock meta data tag
			methods = methods.concat(testClass.getMetaDataMethods( "Mock" ));
			
			//collect all the metadata on the methods in the class
			for each(var method:FrameworkMethod in methods) {
				mockMetaData = mockMetaData.concat(method.metadata)
			}
			//grab all the Mock meta data tags off the class def itself
			mockMetaData = mockMetaData.concat(testClass.metadata)
			
			return new PrepareMocks(_proxyRepository, mockMetaData); 
		}
	}
}