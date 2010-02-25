package asmock.tests
{
	import asmock.tests.framework.*;
	import asmock.tests.framework.constraints.*;
	import asmock.tests.framework.impl.*;
	import asmock.tests.framework.impl.dynamicMock.*;
	import asmock.tests.framework.impl.strict.*;
	import asmock.tests.framework.impl.stub.*;
	import asmock.tests.framework.methodRecorders.UnorderedMethodRecorderFixture;
	import asmock.tests.framework.util.*;
	import asmock.tests.reflection.MethodInfoFixture;
	import asmock.tests.reflection.TypeFixture;
	
	import flexunit.framework.TestSuite;
	
	public class TestProvider
	{
		public function TestProvider()
		{
		}
		
		public function addTests(suite : TestSuite) : void
		{

			// asmock.tests.framework
			//suite.addTestSuite(ArrayCollectionFixture);
			suite.addTestSuite(MockRepositoryInterfaceIntegrationFixture);
			suite.addTestSuite(MockRepositoryClassIntegrationFixture);
			//suite.addTestSuite(MockRepositoryNestedClassIntegrationFixture);
			suite.addTestSuite(LargeObjectMockFixture);
			// suite.addTestSuite(VectorFixture); // Uncomment when targetting flash 10
			suite.addTestSuite(StubOptionsFixture);
			suite.addTestSuite(NoPackageIntegrationFixture);
			suite.addTestSuite(OptionalArgumentsFixture);
			
			// asmock.tests.framework.impl.strict
			suite.addTestSuite(StrictRecordMockStateFixture);
			suite.addTestSuite(StrictReplayMockStateFixture);
			suite.addTestSuite(StrictVerifiedMockStateFixture);
			
			// asmock.tests.framework.impl.dynamicMock
			suite.addTestSuite(DynamicRecordMockStateFixture);
			suite.addTestSuite(DynamicReplayMockStateFixture);
			suite.addTestSuite(DynamicVerifiedMockStateFixture);
			
			// asmock.tests.framework.impl.stub
			suite.addTestSuite(StubRecordMockStateFixture);
			suite.addTestSuite(StubReplayMockStateFixture);
			suite.addTestSuite(StubVerifiedMockStateFixture);
			
			// asmock.tests.framework.constraints
			suite.addTestSuite(AndFixture);
			suite.addTestSuite(AnythingFixture);
			suite.addTestSuite(ArrayEqualsFixture);
			suite.addTestSuite(ArrayLengthFixture);
			suite.addTestSuite(ComparingConstraintFixture);
			suite.addTestSuite(ContainsFixture);
			suite.addTestSuite(EndsWithFixture);
			suite.addTestSuite(EqualFixture);
			suite.addTestSuite(IsFixture);
			suite.addTestSuite(LikeFixture);
			suite.addTestSuite(ListEqualsFixture);
			suite.addTestSuite(ListLengthFixture);
			suite.addTestSuite(NotFixture);
			suite.addTestSuite(OneOfFixture);
			suite.addTestSuite(OrFixture);
			suite.addTestSuite(PredicateConstraintFixture);
			suite.addTestSuite(PropertyFixture);
			suite.addTestSuite(PropertyConstraintFixture);
			suite.addTestSuite(PropertyIsFixture);
			suite.addTestSuite(SameFixture);
			suite.addTestSuite(StartsWithFixture);
			suite.addTestSuite(TextFixture);
			suite.addTestSuite(TypeOfFixture);
			
			// asmock.tests.framework.methodRecorders
			suite.addTestSuite(UnorderedMethodRecorderFixture);
			
			// asmock.tests.framework.util
			suite.addTestSuite(MethodUtilFixture);
			suite.addTestSuite(ClassUtilityFixture);
			
			// asmock.tests.reflection
			suite.addTestSuite(MethodInfoFixture);
			suite.addTestSuite(TypeFixture);
		}

	}
}