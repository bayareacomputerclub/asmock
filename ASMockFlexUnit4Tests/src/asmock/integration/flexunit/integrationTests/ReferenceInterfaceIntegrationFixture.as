package asmock.integration.flexunit.integrationTests
{
	//import asmock.flexunit.ASMock1ClassRunner; ASMock1ClassRunner;
	import asmock.framework.MockRepository;
	import asmock.integration.flexunit.tests.IReferenceInterface;
	
	import flash.display.Loader;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	
	
	
	[Mock("asmock.integration.flexunit.tests.IReferenceInterface")]
	[RunWith("asmock.integration.flexunit.ASMockClassRunner")]
	public class ReferenceInterfaceIntegrationFixture
	{
		[Test]
		[Mock("flash.display.Loader")]
		public function simpleMock() : void
		{
			
			var mockRepository : MockRepository = new MockRepository();
			
			var loader : Loader = mockRepository.createStub(Loader) as Loader;
			
			var mock : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStub(IReferenceInterface, StubOptions.ALL));
				
			mock.stringProperty = "test";
			
			assertThat(mock.stringProperty, equalTo("test"));
		}
	}
}