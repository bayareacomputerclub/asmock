package asmock.tests
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.*;
	
	import flexunit.framework.TestCase;
	
	public class ExtendedTestCase extends TestCase
	{
		public function ExtendedTestCase()
		{
		}
		
		public static function assertNotEquals(valueA : Object, valueB : Object, message : String = null) : void
		{
			_assertionsMade++;
			
			if (valueA == valueB)			
			{
				fail(message);
			}
		}
		
		public static function assertNotStrictlyEquals(valueA : Object, valueB : Object, message : String = null) : void
		{
			_assertionsMade++;
			
			if (valueA === valueB)			
			{
				fail(message);
			}
		}
		
		public static function assertArrayEquals(message : String, arrayA : Array, arrayB : Array) : void
		{
			var messagePrefix : String = (message == null) ? "" : message + ": ";
			
			if (arrayA == null && arrayB == null)
			{
				return;
			}
			
			assertNotNull(message, arrayA);
			assertNotNull(message, arrayB);
			
			assertEquals(messagePrefix + "lengths did not match", arrayA.length, arrayB.length);
			
			for (var i:int; i<arrayA.length; i++)
			{
				if (arrayA[i] is Array)
				{
					assertArrayEquals(messagePrefix + "array at "+i, arrayA[i] as Array, arrayB[i] as Array);
				}
				else
				{
					assertEquals(messagePrefix + "Unexpected item at index " + i, arrayA[i], arrayB[i]);
				}
			}
		}
		
		public static function assertError(message : String, func : Function, errorClass : Class = null, errorMessage : String = null, errorCodes : Array = null) : Error 
		{
			if (errorClass == null) errorClass = Error;
			
			try
			{
				func();
			}
			catch(ex : Error)
			{
				if (!(ex is errorClass))
				{
					fail("Expected error of type '" + getQualifiedClassName(errorClass) + "' but was '" + getQualifiedClassName(ex) + "'");
				}
				
				if (errorMessage != null && ex.message != errorMessage)
				{
					fail("Expected error with message '" + errorMessage + "' but was '" + ex.message + "'");
				}
				
				if (errorCodes != null && errorCodes.indexOf(ex.errorID) == -1)
				{
					fail("Expected error with errorID '" + errorCodes.join(" or ") + "' but was '" + ex.errorID + "'");
				}
				
				_assertionsMade++;
				
				return ex;
			}
			
			if (message == null)
			{
				message = "Expected error of type '" + getQualifiedClassName(errorClass) + "' but none was thrown"
			}
			
			fail(message);
			
			return null;
		}
		
		public static function assertEvent(message : String, func : Function, dispatcher : IEventDispatcher, eventName : String, eventClass : Class = null, iterations : int = 1) : Array
		{
			var messagePrefix : String = (message == null) ? "" : message + ": ";
		
			dispatcher.addEventListener(eventName, eventHandler);
			
			var eventCount : int = 0;
			
			var events : Array = new Array();
			
			try
			{
				func();
			}
			finally
			{
				dispatcher.removeEventListener(eventName, eventHandler);
			}
			
			assertEquals(messagePrefix + "Event was raised an unexpected number of times", iterations, eventCount);
			
			return events; 
			
			function eventHandler(event : Event) : void
			{
				if (eventClass != null)
				{
					assertTrue(messagePrefix + "Expected instance of '" + getQualifiedClassName(eventClass) + "' but was '" + getQualifiedClassName(event) + "'", 
						event is eventClass);
				}
				
				events.push(event);
				
				eventCount++;				
			}
		}
	}
}