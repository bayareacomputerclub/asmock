package asmock.integration.flexunit.tests
{
	import asmock.integration.flexunit.ASMockBuilder;
	import asmock.integration.flexunit.ASMockClassRunner;
	
	import org.flexunit.Assert;
	import org.flexunit.runner.IRunner;
	
	public class ASMockBuilderFixture
	{
		[Test(expected="org.flexunit.internals.runners.InitializationError")]
		public function runnerForClass_classNoTests_throwsError() : void
		{
			var builder : ASMockBuilder = new ASMockBuilder();
			var runner : IRunner = builder.runnerForClass(ClassWithNoTests);
			
			Assert.assertNotNull(runner);
			Assert.assertTrue(runner is ASMockClassRunner);
		}
		
		[Test]
		public function runnerForClass_classHasMockMetadataOnClass_returnsRunner() : void
		{
			var builder : ASMockBuilder = new ASMockBuilder();
			var runner : IRunner = builder.runnerForClass(ClassWithClassMock);
			
			Assert.assertNotNull(runner);
			Assert.assertTrue(runner is ASMockClassRunner);
		}
		
		[Test]
		public function runnerForClass_classHasMockMetadataOnMethod_returnsRunner() : void
		{
			var builder : ASMockBuilder = new ASMockBuilder();
			var runner : IRunner = builder.runnerForClass(ClassWithMethodMock);
		
			Assert.assertNotNull(runner);
			Assert.assertTrue(runner is ASMockClassRunner);
		}
		
		[Test]
		public function runnerForClass_classHasNoMockMetadata_returnsNull() : void
		{
			var builder : ASMockBuilder = new ASMockBuilder();
			var runner : IRunner = builder.runnerForClass(ClassWithNoMock);
			
			Assert.assertNull(runner);
		}

	}
}

[Mock("asmock.flexunit.tests.IReferenceInterface")]
class ClassWithNoTests
{
}

[Mock("asmock.flexunit.tests.IReferenceInterface")]
class ClassWithClassMock
{
	[Test]
	public function test() : void {}
}

class ClassWithMethodMock
{
	[Test]
	[Mock("asmock.flexunit.tests.IReferenceInterface")]
	public function test() : void {}
}

class ClassWithNoMock
{
	[Test]
	public function test() : void {}
}