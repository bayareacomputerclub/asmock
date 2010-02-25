package asmock.tests.framework.methodRecorders
{
	import asmock.framework.ExpectationViolationError;
	import asmock.framework.Range;
	import asmock.framework.expectations.*;
	import asmock.framework.impl.IMethodRecorder;
	import asmock.framework.methodRecorders.*;
	import asmock.reflection.MethodInfo;
	import asmock.reflection.Type;
	import asmock.tests.ExtendedTestCase;
	import asmock.tests.framework.MockInvocation;
	import asmock.tests.framework.expectations.MockExpectation;

	public class UnorderedMethodRecorderFixture extends ExtendedTestCase
	{
		private var _repeatableMethods : ProxyMethodExpectationsDictionary;
		
		public function UnorderedMethodRecorderFixture()
		{
			super();
		}
		
		public override function setUp():void
		{
			_repeatableMethods = new ProxyMethodExpectationsDictionary();
		}
		
		public function testDefaultProperties() : void
		{
			
		}
		
		public function testHasExpectations_NoExpectations() : void
		{
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			assertFalse("Unexpected value for hasExpectations", recorder.hasExpectations);
		}
		
		public function testHasExpectations_OneCanAcceptCalls() : void
		{
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var expectationA : MockExpectation = new MockExpectation();
			expectationA.mock.setupResult("canAcceptCalls", true);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			recorder.record(proxy, method, expectationA);
			
			assertTrue("Unexpected value for hasExpectations", recorder.hasExpectations);
		}
		
		public function testHasExpectations_MiddleCanAcceptCalls() : void
		{
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var expectationA : MockExpectation = new MockExpectation();
			expectationA.mock.setupResult("canAcceptCalls", false);
			
			var expectationB : MockExpectation = new MockExpectation();
			expectationB.mock.setupResult("canAcceptCalls", true);
			
			var expectationC : MockExpectation = new MockExpectation();
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			recorder.record(proxy, method, expectationA);
			recorder.record(proxy, method, expectationB);
			recorder.record(proxy, method, expectationC);
			
			assertTrue("Unexpected value for hasExpectations", recorder.hasExpectations);
		}
		
		public function testHasExpectations_NoneCanAcceptCalls() : void
		{
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var expectationA : MockExpectation = new MockExpectation();
			expectationA.mock.setupResult("canAcceptCalls", false);
			
			var expectationB : MockExpectation = new MockExpectation();
			expectationB.mock.setupResult("canAcceptCalls", true);
			
			var expectationC : MockExpectation = new MockExpectation();
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			recorder.record(proxy, method, expectationA);
			recorder.record(proxy, method, expectationB);
			recorder.record(proxy, method, expectationC);
			
			assertTrue("Unexpected value for hasExpectations", recorder.hasExpectations);
		}
		
		public function testGetRecordedExpectationOrNull_NoExpectations() : void
		{
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			var actualExpectation : IExpectation = recorder.getRecordedExpectationOrNull(proxy, method, []);
			
			assertNull("Unexpected return result from getRecordedExpectationOrNull", actualExpectation);
		}
		
		public function testGetRecordedExpectationOrNull_NoExpectationsForProxy() : void
		{
			var proxyA : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var proxyB : Object = new Object();
			
			var mockExpectation : MockExpectation = new MockExpectation();
			mockExpectation.mock.setupResult("expectationSatisfied", true);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			recorder.record(proxyA, method, mockExpectation);  
			
			var actualExpectation : IExpectation = recorder.getRecordedExpectationOrNull(proxyB, method, []);
			
			assertNull("Unexpected return result from getRecordedExpectationOrNull", actualExpectation);
		}
		
		public function testGetRecordedExpectationOrNull_NoExpectationsForMethod() : void
		{
			var proxy : Object = new Object();
			var methodA : MethodInfo = MethodInfo.getCallingMethod();
			var methodB : MethodInfo = methodA.clone();
			
			var mockExpectation : MockExpectation = new MockExpectation();
			mockExpectation.mock.setupResult("expectationSatisfied", true);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			recorder.record(proxy, methodA, mockExpectation);  
			
			var expectation : IExpectation = recorder.getRecordedExpectationOrNull(proxy, methodB, []);
			
			assertNull("Unexpected return result from getRecordedExpectationOrNull", expectation);
		}
		
		public function testGetRecordedExpectationOrNull_ExpectationCannotAcceptCalls() : void
		{
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var mockExpectation : MockExpectation = new MockExpectation();
			mockExpectation.mock.setupResult("canAcceptCalls", false);
			mockExpectation.mock.setupResult("expectationSatisfied", true);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			recorder.record(proxy, method, mockExpectation);  
			
			var actualExpectation : IExpectation = recorder.getRecordedExpectationOrNull(proxy, method, []);
			
			assertNull("Unexpected return result from getRecordedExpectationOrNull", actualExpectation);
		}
		
		public function testGetRecordedExpectationOrNull_ExpectationIsNotExpected() : void
		{
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var mockExpectation : MockExpectation = new MockExpectation();
			mockExpectation.mock.setupResult("canAcceptCalls", true);
			mockExpectation.mock.setupResult("isExpected", false);
			mockExpectation.mock.setupResult("expectationSatisfied", true);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			recorder.record(proxy, method, mockExpectation);  
			
			var actualExpectation : IExpectation = recorder.getRecordedExpectationOrNull(proxy, method, []);
			
			assertNull("Unexpected return result from getRecordedExpectationOrNull", actualExpectation);
		}
		
		public function testGetRecordedExpectationOrNull_Expected() : void
		{
			var actualCalls : int = 0;
			
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var mockExpectation : MockExpectation = new MockExpectation();
			mockExpectation.mock.setupResult("canAcceptCalls", true);
			mockExpectation.mock.setupResult("isExpected", true);
			mockExpectation.mock.setupResult("addActualCall", function() : void { actualCalls++; });
			mockExpectation.mock.setupResult("expectationSatisfied", true);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			recorder.record(proxy, method, mockExpectation);  
			
			var actualExpectation : IExpectation = recorder.getRecordedExpectationOrNull(proxy, method, []);
			
			assertStrictlyEquals("Unexpected return result from getRecordedExpectationOrNull", mockExpectation, actualExpectation);
		}
		
		public function testReplaceExpectation() : void
		{
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var mockExpectationA : MockExpectation = new MockExpectation();
			var mockExpectationB : MockExpectation = new MockExpectation();
			
			mockExpectationB.mock.setupResult("canAcceptCalls", true); 
			mockExpectationB.mock.setupResult("isExpected", true);
			mockExpectationB.mock.setupResult("addActualCall", null);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxy, method, mockExpectationA);
			recorder.replaceExpectation(proxy, method, mockExpectationA, mockExpectationB);
			
			var actualExpectation : IExpectation = recorder.getRecordedExpectationOrNull(proxy, method, []);
			
			assertStrictlyEquals("Unexpected return result from getRecordedExpectationOrNull", mockExpectationB, actualExpectation);
		}
		
		public function testReplaceExpectation_NothingToReplace_Proxy() : void
		{
			var proxyA : Object = new Object();
			var proxyB : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var mockExpectationA : MockExpectation = new MockExpectation();
			var mockExpectationB : MockExpectation = new MockExpectation();
			
			mockExpectationA.mock.setupResult("canAcceptCalls", true); 
			mockExpectationA.mock.setupResult("isExpected", true); 
			mockExpectationA.mock.setupResult("addActualCall", null);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxyA, method, mockExpectationA);
			recorder.replaceExpectation(proxyB, method, mockExpectationA, mockExpectationB);
			
			var actualExpectation : IExpectation = recorder.getRecordedExpectationOrNull(proxyA, method, []);
			
			assertStrictlyEquals("Unexpected return result from getRecordedExpectationOrNull", mockExpectationA, actualExpectation);
		}
		
		public function testReplaceExpectation_NothingToReplace_Method() : void
		{
			var proxy : Object = new Object();
			var methodA : MethodInfo = MethodInfo.getCallingMethod();
			var methodB : MethodInfo = methodA.clone();
			
			var mockExpectationA : MockExpectation = new MockExpectation();
			var mockExpectationB : MockExpectation = new MockExpectation();
			
			mockExpectationA.mock.setupResult("canAcceptCalls", true); 
			mockExpectationA.mock.setupResult("isExpected", true);
			mockExpectationA.mock.setupResult("addActualCall", null);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxy, methodA, mockExpectationA);
			recorder.replaceExpectation(proxy, methodB, mockExpectationA, mockExpectationB);
			
			var actualExpectation : IExpectation = recorder.getRecordedExpectationOrNull(proxy, methodA, []);
			
			assertStrictlyEquals("Unexpected return result from getRecordedExpectationOrNull", mockExpectationA, actualExpectation);
		}
		
		public function testReplaceExpectation_NothingToReplace_Expectation() : void
		{
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var mockExpectationA : MockExpectation = new MockExpectation();
			var mockExpectationB : MockExpectation = new MockExpectation();
			var mockExpectationC : MockExpectation = new MockExpectation();
			
			mockExpectationA.mock.setupResult("canAcceptCalls", true); 
			mockExpectationA.mock.setupResult("isExpected", true);
			mockExpectationA.mock.setupResult("addActualCall", null);
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxy, method, mockExpectationA);
			recorder.replaceExpectation(proxy, method, mockExpectationC, mockExpectationB);
			
			var actualExpectation : IExpectation = recorder.getRecordedExpectationOrNull(proxy, method, []);
			
			assertStrictlyEquals("Unexpected return result from getRecordedExpectationOrNull", mockExpectationA, actualExpectation);
		}
		
		public function testGetAllExpectationsForProxy_None() : void
		{
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var proxyA : Object = new Object();
			var proxyB : Object = new Object();
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxyA, method, new MockExpectation());
			
			var result : Array = recorder.getAllExpectationsForProxy(proxyB);
			
			assertArrayEquals("Unexpected result from getAllExpectationsForProxy", [], result);
			
		}
		
		public function testGetAllExpectationsForProxy() : void
		{
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var proxyA : Object = new Object();
			var proxyB : Object = new Object();
			
			var expectationA : IExpectation = new MockExpectation();
			var expectationB : IExpectation = new MockExpectation();
			var expectationC : IExpectation = new MockExpectation();
			var expectationD : IExpectation = new MockExpectation();
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxyA, method, expectationA);
			recorder.record(proxyA, method, expectationC);
			recorder.record(proxyB, method, expectationB);
			recorder.record(proxyB, method, expectationD);
			
			var result : Array = recorder.getAllExpectationsForProxy(proxyB);
			
			assertArrayEquals("Unexpected result from getAllExpectationsForProxy", [expectationB, expectationD], result);
		}
		
		public function testGetAllExpectationsForProxyAndMethod_None() : void
		{
			var methodA : MethodInfo = MethodInfo.getCallingMethod();
			var methodB : MethodInfo = methodA.clone();
			
			var proxyA : Object = new Object();
			var proxyB : Object = new Object();
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			var expectations : Array = [
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation()
			];
			
			recorder.record(proxyA, methodA, expectations[0]);
			recorder.record(proxyA, methodB, expectations[1]);
			recorder.record(proxyA, methodA, expectations[2]);
			recorder.record(proxyA, methodB, expectations[3]);
			recorder.record(proxyB, methodA, expectations[4]);
			recorder.record(proxyB, methodA, expectations[5]);
			
			var result : Array = recorder.getAllExpectationsForProxyAndMethod(proxyB, methodB);
			
			assertArrayEquals("Unexpected result from getAllExpectationsForProxyAndMethod", [], result);
		}
		
		public function testGetAllExpectationsForProxyAndMethod() : void
		{
			var methodA : MethodInfo = MethodInfo.getCallingMethod();
			var methodB : MethodInfo = methodA.clone();
			
			var proxyA : Object = new Object();
			var proxyB : Object = new Object();
			
			var recorder : IMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			var expectations : Array = [
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation(),
				new MockExpectation(),
			];
			
			recorder.record(proxyA, methodA, expectations[0]);
			recorder.record(proxyA, methodB, expectations[1]);
			recorder.record(proxyA, methodA, expectations[2]);
			recorder.record(proxyA, methodB, expectations[3]);
			recorder.record(proxyB, methodA, expectations[4]);
			recorder.record(proxyB, methodB, expectations[5]);
			recorder.record(proxyB, methodA, expectations[6]);
			recorder.record(proxyB, methodB, expectations[7]);
			
			var result : Array = recorder.getAllExpectationsForProxyAndMethod(proxyB, methodB);
			
			assertArrayEquals("Unexpected result from getAllExpectationsForProxyAndMethod", [expectations[5], expectations[7]], result);
		}
		
		public function testUnexpectedMethodCall_NoExpectations() : void
		{
			var recorder : UnorderedMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			
			var invocation : MockInvocation = new MockInvocation();
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [];
			
			var error : ExpectationViolationError = recorder.unexpectedMethodCall(invocation, proxy, method, args);
			
			assertNotNull("Unexpected result from unexpectedMethodCall()", error);
			
			var expectedErrorMessage : String = "asmock.tests.framework.methodRecorders:UnorderedMethodRecorderFixture/testUnexpectedMethodCall_NoExpectations(); Expected #0, Actual #1.";
			
			assertEquals(expectedErrorMessage, error.message);
		}
		
		public function testUnexpectedMethodCall_MinRangeEqualsMaxRange() : void
		{ 
			var invocation : MockInvocation = new MockInvocation();
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [];
			
			var expectationA : MockExpectation = new MockExpectation();
			
			expectationA.mock.setupResult("message", null);
			expectationA.mock.setupResult("actualCallsCount", 1);
			expectationA.mock.setupResult("get_expected", new Range(4, 4));
			expectationA.mock.setupResult("get_message", null);
			expectationA.mock.setupResult("isExpected", true);
			expectationA.mock.setupResult("expectationSatisfied", true);
					
			var recorder : UnorderedMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxy, method, expectationA);
			
			var error : ExpectationViolationError = recorder.unexpectedMethodCall(invocation, proxy, method, args);
			
			assertNotNull("Unexpected result from unexpectedMethodCall()", error);
			
			var expectedErrorMessage : String = "asmock.tests.framework.methodRecorders:UnorderedMethodRecorderFixture/" + method.name + "(); Expected #4, Actual #2.";
			
			assertEquals(expectedErrorMessage, error.message);
		}
		
		public function testUnexpectedMethodCall_MinRangeNotEqualsMaxRange() : void
		{
			var invocation : MockInvocation = new MockInvocation();
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [];
			
			var expectationA : MockExpectation = new MockExpectation();
			
			expectationA.mock.setupResult("message", null);
			expectationA.mock.setupResult("actualCallsCount", 1);
			expectationA.mock.setupResult("get_expected", new Range(4, 5));
			expectationA.mock.setupResult("get_message", null);
			expectationA.mock.setupResult("isExpected", true);
			expectationA.mock.setupResult("expectationSatisfied", true);
					
			var recorder : UnorderedMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxy, method, expectationA);
			
			var error : ExpectationViolationError = recorder.unexpectedMethodCall(invocation, proxy, method, args);
			
			assertNotNull("Unexpected result from unexpectedMethodCall()", error);
			
			var expectedErrorMessage : String = "asmock.tests.framework.methodRecorders:UnorderedMethodRecorderFixture" +
				"/testUnexpectedMethodCall_MinRangeNotEqualsMaxRange(); Expected #4 - 5, Actual #2.";
			
			assertEquals(expectedErrorMessage, error.message);
		}
		
		public function testUnexpectedMethodCall_Multiple() : void
		{
			var invocation : MockInvocation = new MockInvocation();
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [];
			
			var expectationA : MockExpectation = new MockExpectation();
			var expectationB : MockExpectation = new MockExpectation();
			
			expectationA.mock.setupResult("message", null);
			expectationA.mock.setupResult("get_errorMessage", null);
			expectationA.mock.setupResult("actualCallsCount", 1);
			expectationA.mock.setupResult("get_expected", new Range(4, 5));
			expectationA.mock.setupResult("get_message", null);
			expectationA.mock.setupResult("isExpected", true);
			expectationA.mock.setupResult("expectationSatisfied", true);
					
			expectationB.mock.setupResult("message", null);
			expectationB.mock.setupResult("actualCallsCount", 2);
			expectationB.mock.setupResult("get_expected", new Range(5, 6));
			expectationB.mock.setupResult("get_message", null);
			expectationB.mock.setupResult("isExpected", true);
					
			var recorder : UnorderedMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxy, method, expectationA);
			recorder.record(proxy, method, expectationB);
			
			var error : ExpectationViolationError = recorder.unexpectedMethodCall(invocation, proxy, method, args);
			
			assertNotNull("Unexpected result from unexpectedMethodCall()", error);
			
			var expectedErrorMessage : String = "asmock.tests.framework.methodRecorders:UnorderedMethodRecorderFixture" +
				"/" + method.name + "(); Expected #9 - 11, Actual #4.";
			
			assertEquals(expectedErrorMessage, error.message);
		}
		
		public function testUnexpectedMethodCall_NotExpected() : void
		{
			var invocation : MockInvocation = new MockInvocation();
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [];
			
			var expectationA : MockExpectation = new MockExpectation();
			var expectationB : MockExpectation = new MockExpectation();
			
			expectationA.mock.setupResult("message", null);
			expectationA.mock.setupResult("actualCallsCount", 1);
			expectationA.mock.setupResult("get_expected", new Range(4, 5));
			expectationA.mock.setupResult("get_message", null);
			expectationA.mock.setupResult("isExpected", true);
			expectationA.mock.setupResult("expectationSatisfied", true);
					
			expectationB.mock.setupResult("message", null);
			expectationB.mock.setupResult("actualCallsCount", 2);
			expectationB.mock.setupResult("get_expected", new Range(5, 6));
			expectationB.mock.setupResult("get_message", null);
			expectationB.mock.setupResult("isExpected", false);
					
			var recorder : UnorderedMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxy, method, expectationA);
			recorder.record(proxy, method, expectationB);
			
			var error : ExpectationViolationError = recorder.unexpectedMethodCall(invocation, proxy, method, args);
			
			assertNotNull("Unexpected result from unexpectedMethodCall()", error);
			
			var expectedErrorMessage : String = "asmock.tests.framework.methodRecorders:UnorderedMethodRecorderFixture" +
				"/" + method.name + "(); Expected #4 - 5, Actual #2.";
			
			assertEquals(expectedErrorMessage, error.message);
		}
		
		public function testUnexpectedMethodCall_NotExpected_NextExpected() : void
		{
			var invocation : MockInvocation = new MockInvocation();
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [];
			
			var expectationA : MockExpectation = new MockExpectation();
			var expectationB : MockExpectation = new MockExpectation();
			
			expectationA.mock.setupResult("message", null);
			expectationA.mock.setupResult("get_errorMessage", "test message");
			expectationA.mock.setupResult("actualCallsCount", 1);
			expectationA.mock.setupResult("get_expected", new Range(4, 5));
			expectationA.mock.setupResult("get_message", null);
			expectationA.mock.setupResult("isExpected", true);
			expectationA.mock.setupResult("expected", new Range(1, 2));
			expectationA.mock.setupResult("expectationSatisfied", false);
					
			expectationB.mock.setupResult("message", null);
			expectationB.mock.setupResult("actualCallsCount", 2);
			expectationB.mock.setupResult("get_expected", new Range(5, 6));
			expectationB.mock.setupResult("get_message", null);
			expectationB.mock.setupResult("isExpected", false);
					
			var recorder : UnorderedMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxy, method, expectationA);
			recorder.record(proxy, method, expectationB);
			
			var error : ExpectationViolationError = recorder.unexpectedMethodCall(invocation, proxy, method, args);
			
			assertNotNull("Unexpected result from unexpectedMethodCall()", error);
			
			var expectedErrorMessage : String = "asmock.tests.framework.methodRecorders:UnorderedMethodRecorderFixture" +
				"/" + method.name + "(); Expected #4 - 5, Actual #2.\n" +
				"test message Expected #4 - 5, Actual #1.";
			
			assertEquals(expectedErrorMessage, error.message);
		}
		
		public function testUnexpectedMethodCall_Message() : void
		{
			var invocation : MockInvocation = new MockInvocation();
			var proxy : Object = new Object();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [];
			
			var expectationA : MockExpectation = new MockExpectation();
			var expectationB : MockExpectation = new MockExpectation();
			
			expectationA.mock.setupResult("message", null);
			expectationA.mock.setupResult("actualCallsCount", 1);
			expectationA.mock.setupResult("get_expected", new Range(4, 5));
			expectationA.mock.setupResult("get_message", "test message");
			expectationA.mock.setupResult("isExpected", true);
			expectationA.mock.setupResult("expectationSatisfied", true);
					
			expectationB.mock.setupResult("message", null);
			expectationB.mock.setupResult("actualCallsCount", 2);
			expectationB.mock.setupResult("get_expected", new Range(5, 6));
			expectationB.mock.setupResult("get_message", null);
			expectationB.mock.setupResult("isExpected", false);
					
			var recorder : UnorderedMethodRecorder = new UnorderedMethodRecorder(_repeatableMethods);
			recorder.record(proxy, method, expectationA);
			recorder.record(proxy, method, expectationB);
			
			var error : ExpectationViolationError = recorder.unexpectedMethodCall(invocation, proxy, method, args);
			
			assertNotNull("Unexpected result from unexpectedMethodCall()", error);
			
			var expectedErrorMessage : String = "asmock.tests.framework.methodRecorders:UnorderedMethodRecorderFixture" +
				"/" + method.name + "(); Expected #4 - 5, Actual #2.\n" +
				"Message: test message\n";
			
			assertEquals(expectedErrorMessage, error.message);
		}
	}
}