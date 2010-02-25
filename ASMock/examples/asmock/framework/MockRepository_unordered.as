import asmock.framework.Expect;

import mx.messaging.messages.IMessage;

var mockMessage : IMessage = IMessage(mockRepository.create(IMessage));
	
mockRepository.ordered(function():void
{
	Expect.call(mockMessage.body).returnValue("testBody");
	Expect.call(mockMessage.destination).returnValue("testDestination");
});

mockRepository.replay(mockMessage);

trace(mockMessage.destination); // Fail, body must be called before destination

mockRepository.verify(mockMessage);