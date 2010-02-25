package asmock.integration.flexunit.tests
{
	import flash.events.IEventDispatcher;
	
	public interface IReferenceInterface extends IEventDispatcher
	{
		function get stringProperty() : String;
		function set stringProperty(value : String) : void;
		
		function get readOnlyStringProperty() : String;
		
		function methodVoid() : void;
		
		function methodStar() : *;
		
		function methodInt(param1 : int) : int;
		
		function methodCircular() : IReferenceInterface;
		
		function methodRest(first : String, ... rest) : int;
	}
}