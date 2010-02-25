package asmock.integration.fluint.tests.integrationTests
{
	import net.digitalprimates.fluint.tests.TestSuite;
	
	public class IntegrationTestSuite extends TestSuite
	{
		public function IntegrationTestSuite()
		{
			addTestCase(new ReferenceInterfaceIntegrationFixture());
		}

	}
}