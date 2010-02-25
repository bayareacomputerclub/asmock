package asmock.tests.framework.expectations
{
	import asmock.framework.Range;
	import asmock.framework.expectations.IExpectation;
	import asmock.framework.proxy.IInvocation;
	import asmock.reflection.MethodInfo;
	import asmock.tests.SimpleMock;
	
	import flash.events.Event;

	public class MockExpectation implements IExpectation
	{
		public function MockExpectation()
		{
		}

		public function get expected():Range
		{
			return _mock.exec("get_expected") as Range;
		}
		
		public function set expected(value:Range):void
		{
			_mock.exec("set_expected", [value]);
		}
		
		public function get actualCallsCount():uint
		{
			return _mock.exec("actualCallsCount") as uint;
		}
		
		public function get repeatableOption():uint
		{
			return _mock.exec("get_repeatableOption") as uint;
		}
		
		public function set repeatableOption(value:uint):void
		{
			_mock.exec("set_repeatableOption", [value]);
		}
		
		public function get errorToThrow():Error
		{
			return _mock.exec("get_errorToThrow") as Error;
		}
		
		public function set errorToThrow(value:Error):void
		{
			_mock.exec("set_errorToThrow", [value]);
		}
		
		public function get eventToDispatch():Event
		{
			return _mock.exec("get_eventToDispatch") as Event;
		}
		
		public function set eventToDispatch(value:Event):void
		{
			_mock.exec("set_eventToDispatch", [value]);
		}
		
		public function get message():String
		{
			return _mock.exec("get_message") as String;
		}
		
		public function set message(value:String):void
		{
			_mock.exec("set_message", [value]);
		}
		
		public function get errorMessage():String
		{
			return _mock.exec("get_errorMessage") as String;
		}
		
		public function get actionToExecute():Function
		{
			return _mock.exec("get_actionToExecute") as Function;
		}
		
		public function set actionToExecute(value:Function):void
		{
			_mock.exec("set_actionToExecute", [value]);
		}
		
		public function get expectationSatisfied():Boolean
		{
			return _mock.exec("expectationSatisfied") as Boolean;
		}
		
		public function get canAcceptCalls():Boolean
		{
			return _mock.exec("canAcceptCalls") as Boolean;
		}
		
		public function get returnValue():Object
		{
			return _mock.exec("get_returnValue") as Object;
		}
		
		public function set returnValue(value:Object):void
		{
			_mock.exec("set_returnValue", [value]);
		}
		
		public function get hasReturnValue():Boolean
		{
			return _mock.exec("hasReturnValue") as Boolean;
		}
		
		public function get method():MethodInfo
		{
			return _mock.exec("method") as MethodInfo;
		}
		
		public function get originalInvocation():IInvocation
		{
			return _mock.exec("originalInvocation") as IInvocation;
		}
		
		public function isExpected(args:Array):Boolean
		{
			return _mock.exec("isExpected") as Boolean;
		}
		
		public function addActualCall():void
		{
			_mock.exec("addActualCall");
		}
		
		public function get actionsSatisfied():Boolean
		{
			return _mock.exec("actionsSatisfied") as Boolean;
		}
		
		public function returnOrThrow(invocation:IInvocation, args:Array):Object
		{
			return _mock.exec("returnOrThrow", [invocation, args]) as Object;
		}
		
		public function buildVerificationFailureMessage():String
		{
			return _mock.exec("buildVerificationFailureMessage") as String;
		}
		
		private var _mock : SimpleMock = new SimpleMock(this);
		public function get mock() : SimpleMock
		{
			return _mock;
		}
		
	}
}