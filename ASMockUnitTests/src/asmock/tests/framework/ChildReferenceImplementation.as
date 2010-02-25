package asmock.tests.framework
{
	public class ChildReferenceImplementation extends ReferenceImplementation
	{
		public function ChildReferenceImplementation(requiredArg : int, optionalArg : String = null)
		{
			super(requiredArg, optionalArg);
		}
		
		public function anotherMethodVoid() : void
		{
		}
	}
}