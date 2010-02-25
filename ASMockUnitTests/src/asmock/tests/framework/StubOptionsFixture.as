package asmock.tests.framework
{
	import flexunit.framework.TestCase;
	
	public class StubOptionsFixture extends TestCase
	{
		public function StubOptionsFixture()
		{
		}
		
		public function test_all_returnsTrueForProperties_returnsTrueForEvents() : void
		{
			var options : StubOptions = StubOptions.ALL;
			
			assertTrue(options.stubProperties);
			assertTrue(options.stubEvents);
		}
		
		public function test_properties_returnsTrueForProperties_returnsFalseForEvents() : void
		{
			var options : StubOptions = StubOptions.PROPERTIES;
			
			assertTrue(options.stubProperties);
			assertFalse(options.stubEvents);
		}
		
		public function test_events_returnsFalseForProperties_returnsTrueForEvents() : void
		{
			var options : StubOptions = StubOptions.EVENTS;
			
			assertFalse(options.stubProperties);
			assertTrue(options.stubEvents);
		}
		
		public function test_none_returnsFalseForProperties_returnsFalseForEvents() : void
		{
			var options : StubOptions = StubOptions.NONE;
			
			assertFalse(options.stubProperties);
			assertFalse(options.stubEvents);
		}

	}
}