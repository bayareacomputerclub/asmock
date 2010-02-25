package asmock.integration.flexunit
{
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.Method;
	
	import org.flexunit.runner.IRunner;
	import org.flexunit.runners.model.RunnerBuilderBase;
	
	public class ASMockBuilder extends RunnerBuilderBase
	{
		public function ASMockBuilder()
		{
		}

		override public function runnerForClass( testClass:Class ):IRunner {
			if (ASMockMetadataTools.hasMockClasses(testClass)) {
				return new ASMockClassRunner(testClass);
			}
			
			return null;
		}
	}
}