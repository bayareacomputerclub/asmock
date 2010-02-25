package asmock.tests.framework
{
	import __AS3__.vec.Vector;
	
	import asmock.framework.SetupResult;
	
	/**
	 * Tests support of the flash 10 vector type 
	 * @author Richard
	 * 
	 */	
	public class VectorFixture extends MockTestCase
	{
		public function VectorFixture()
		{
			super([IVectorReference]);
		}
		
		public function testVector() : void
		{
			var ref : IVectorReference = IVectorReference(mockRepository.create(IVectorReference));
			
			var expectedInts : Vector.<int> = new Vector.<int>();
			
			SetupResult.forCall(ref.ints).returnValue(expectedInts);
			
			mockRepository.replay(ref);
			
			var actualInts : Vector.<int> = ref.ints;
			
			assertStrictlyEquals(expectedInts, actualInts);
		}

	}
}