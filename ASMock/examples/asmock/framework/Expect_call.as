import asmock.framework.Expect;

import flash.display.MovieClip;

var mck : MovieClip = MovieClip(mockRepository.create(MovieClip));

// Use SetupResult instead of Expect if the returnValue 
// should be permanent (ie. can be called an unlimited number 
// of times)
Expect.call(mck.swapChildren(1, 5));
mockRepository.replay(mck);

// mck.verify(mck); // ExpectationViolationError - expected swapChildren to be called

// mck.swapChildren(1, 6); // ExpectationViolationError - expected arguments do not match

mck.swapChildren(1, 5);
mck.verify(mck);

