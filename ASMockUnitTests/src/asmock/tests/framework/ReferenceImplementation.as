package asmock.tests.framework
{
	import flash.events.EventDispatcher;
	
	public class ReferenceImplementation extends EventDispatcher implements IReferenceInterface
	{
		private var _stringProperty : String;
		
		public function ReferenceImplementation(requiredArg : int, optionalArg : String = "!")
		{
			this.methodVoid();
		}
		
		public function get stringProperty() : String
		{
			return _stringProperty;
		}
		
		public function set stringProperty(value : String) : void
		{
			_stringProperty = value;
		}
		
		public function methodVoid() : void
		{
			methodInt(0);
		}
		
		public function methodStar() : *
		{
		}
		
		public function methodInt(param1 : int) : int
		{
			return param1 + 1;
		}
		
		public final function methodCircular() : IReferenceInterface
		{
			return this;
		}
		
		public function methodRest(first : String, ... rest) : int
		{
			return rest.length;
		}
	}
}