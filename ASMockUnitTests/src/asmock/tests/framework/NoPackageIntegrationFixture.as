package asmock.tests.framework
{
	import INoPackageReferenceInterface;
	import asmock.framework.Expect;
	import asmock.framework.ExpectationViolationError;
	import asmock.framework.OriginalCallOptions;
	import asmock.framework.SetupResult;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.*;
	
	/**
	 * Contains a test for mocking objects with no package
	 * @author Richard Szalay
	 */	
	public class NoPackageIntegrationFixture extends MockTestCase
	{
		public function NoPackageIntegrationFixture()
		{
			super([INoPackageReferenceInterface]);
		}
		
		public function test_canCreateStrict() : void
		{
			var reference : INoPackageReferenceInterface = 
				INoPackageReferenceInterface(mockRepository.createStrict(INoPackageReferenceInterface));
		}
	}
}
