import asmock.framework.Expect;

import mx.messaging.messages.IMessage;

var mockInterface : IInterface = IInterface(mockRepository.create(IInterface));
	
mockRepository.ordered(function():void
{
	Expect.call(mockInterface.first());
	Expect.call(mockInterface.second());
	
	mockRepository.unordered(function():void
	{
		Expect.call(mockInterface.fourth());
		Expect.call(mockInterface.fifth());
	});
	
	Expect.call(mockInterface.sixth());
});

mockRepository.replay(mockInterface);

mockInterface.first();
mockInterface.second();
// fourth and fifth can be called  in reverse order
// but sixth cannot be called until both are called 
// (unless they are made optional via IMethodOptions.repeat)
mockInterface.fifth();
mockInterface.fourth(); 

mockInterface.sixth();

mockRepository.verify(mockInterface);