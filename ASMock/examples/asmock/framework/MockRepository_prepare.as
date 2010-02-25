import asmock.framework.MockRepository;

import flash.events.Event;
import flash.events.IEventDispatcher;

import mx.messaging.messages.IMessage;

var mockRepository : MockRepository = new MockRepository();
var prepareAsync : IEventDispatcher = mockRepository.prepare([IMessage]);

prepareAsync.addEventListener(Event.COMPLETE, prepareComplete);

function prepareComplete() : void
{
	var mockMessage : IMessage = IMessage(mockRepository.create(IMessage));
	
	// setup expectations
	mockRepository.replay(mockMessage);
	
	// run test code
	mockRepository.verify(mockMessage);
}