import asmock.framework.Expect;
import asmock.framework.SetupResult;
import asmock.framework.constraints.Is;

import flash.display.MovieClip;
import flash.display.Scene;

var mck : MovieClip = MovieClip(mockRepository.create(MovieClip));

// Using constraints replaces the expectation on the original argument values
Expect.call(mck.swapChildren(0,0)).constraints([
	Is.all(Is.greaterThan(5), Is.lessThan(10)), // argument 1
	Is.anything() // argument 2
	]);

mockRepository.replay(mck);

mck.swapChildren(6, 9); // ok
// mck.swapChildren(4, 5); // ExpectationViolationError (argument 1 is not (5 < x > 10)

mck.verify(mck);
