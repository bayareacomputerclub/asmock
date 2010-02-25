var mck : IMessage = IMessage(mockRepository.create(IMessage));
var fakeBody : Object = new Object();

Expect.call(mck.body).returnValue(fakeBody).repeat.times(1, 3);
mockRepository.replay(mck);

trace(mck.body);
trace(mck.body);
trace(mck.body);
// trace(mck.body); // would throw ExpectationViolationError if called a 4th time

mockRepository.verify(mck);