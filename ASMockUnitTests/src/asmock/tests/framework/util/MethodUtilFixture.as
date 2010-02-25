package asmock.tests.framework.util
{
	import asmock.framework.util.*;
	import asmock.reflection.*;
	import asmock.tests.framework.IReferenceInterface;
	import asmock.tests.framework.MockTestCase;
	import asmock.tests.framework.ReferenceImplementation;
	
	public class MethodUtilFixture extends MockTestCase
	{
		public function MethodUtilFixture()
		{
			super([IReferenceInterface, ReferenceImplementation]);
		}
		
		public function simpleMethod() : void
		{
		}
		
		public function test_formatMethod_noBaseClass_interfaces_returnsInterfaceType() : void
		{
			var reference : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
				
			var type : Type = Type.getType(reference);
			
			var method : MethodInfo = type.getMethod("methodInt", false);  
			
			var value : String = MethodUtil.formatMethod(method, [1]);
			
			assertEquals("asmock.tests.framework:IReferenceInterface/methodInt(1);", value);
		}
		
		public function test_formatMethod_baseClass_interfaces_returnsBaseType() : void
		{
			var reference : ReferenceImplementation = 
				ReferenceImplementation(mockRepository.createStrict(ReferenceImplementation, [0, null]));
				
			var type : Type = Type.getType(reference);
			
			var method : MethodInfo = type.getMethod("methodInt", false);  
			
			var value : String = MethodUtil.formatMethod(method, [1]);
			
			assertEquals("asmock.tests.framework:ReferenceImplementation/methodInt(1);", value);
		}
		
		public function test_formatMethod_noBaseClass_noInterfaces_returnsOriginalType() : void
		{
			var reference : ReferenceImplementation = new ReferenceImplementation(1, null);
				
			var type : Type = Type.getType(reference);
			
			var method : MethodInfo = type.getMethod("methodInt", false);  
			
			var value : String = MethodUtil.formatMethod(method, [1]);
			
			assertEquals("asmock.tests.framework:ReferenceImplementation/methodInt(1);", value);
		}
		
		public function test_formatMethod_worksWithPropertyGet() : void
		{
			var reference : ReferenceImplementation = 
				ReferenceImplementation(mockRepository.createStrict(ReferenceImplementation, [0, null]));
				
			var type : Type = Type.getType(reference);
			
			var method : MethodInfo = type.getProperty("stringProperty", false).getMethod;  
			
			var value : String = MethodUtil.formatMethod(method, []);
			
			assertEquals("asmock.tests.framework:ReferenceImplementation/stringProperty/get();", value);
		}
		
		public function test_formatMethod_worksWithPropertySet() : void
		{
			var reference : ReferenceImplementation = 
				ReferenceImplementation(mockRepository.createStrict(ReferenceImplementation, [0, null]));
				
			var type : Type = Type.getType(reference);
			
			var method : MethodInfo = type.getProperty("stringProperty", false).setMethod;  
			
			var value : String = MethodUtil.formatMethod(method, ["test"]);
			
			assertEquals("asmock.tests.framework:ReferenceImplementation/stringProperty/set(\"test\");", value);
		}
	}
}