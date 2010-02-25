package asmock.integration.flexunit.tests.integrationTests
{
	//import asmock.flexunit.ASMock1ClassRunner; ASMock1ClassRunner;
	import asmock.framework.MockRepository;
	import asmock.integration.flexunit.ASMockTestCase;
	import asmock.integration.flexunit.tests.IReferenceInterface;
	
	import flash.display.Loader;
	
	public class ReferenceInterfaceIntegrationFixture extends ASMockTestCase
	{
		public function ReferenceInterfaceIntegrationFixture()
		{
			super([IReferenceInterface, Loader]);
		}
		
		public function test_simpleMock() : void
		{
			
			var mockRepository : MockRepository = new MockRepository();
			
			var loader : Loader = mockRepository.createStub(Loader) as Loader;
			
			var mock : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStub(IReferenceInterface, StubOptions.ALL));
				
			mock.stringProperty = "test";
			
			assertEquals("test", mock.stringProperty);
		}
	}
}