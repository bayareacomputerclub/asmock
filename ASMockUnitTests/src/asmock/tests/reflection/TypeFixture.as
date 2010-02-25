package asmock.tests.reflection
{
	import asmock.reflection.Type;
	import asmock.tests.ExtendedTestCase;
	
	public class TypeFixture extends ExtendedTestCase
	{
		public function TypeFixture()
		{
		}
		
		public function test_getType_XML_supported() : void
		{
			var xml : XML = new XML();
			
			var type : Type = Type.getType(xml);
			
			assertNotNull(type);
		}
		
		public function test_class_support() : void 
		{
			var classType : Type = Type.getType(Class);
			var fixtureType : Type = Type.getType(TypeFixture);
			
			var ret : Boolean = classType.isAssignableFrom(fixtureType);
			
			assertTrue(ret);
		}

	}
}