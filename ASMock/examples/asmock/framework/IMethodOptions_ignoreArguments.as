import asmock.framework.Expect;
import asmock.framework.SetupResult;
import asmock.framework.constraints.Is;

import flash.display.MovieClip;
import flash.display.Scene;

var mck : MovieClip = MovieClip(mockRepository.create(MovieClip));

Expect.call(mck.swapChildren(5,5)).ignoreArguments(); // first call ignore arguments
Expect.call(mck.swapChildren(1,1)); // second call default
mockRepository.replay(mck);

mck.swapChildren(6, 9); // ok
// mck.swapChildren(4, 5); // ExpectationViolationError: arguments did not match (1, 1)

mck.verify(mck);
