import asmock.framework.Expect;
import asmock.framework.SetupResult;
import asmock.framework.constraints.Is;

import flash.display.MovieClip;
import flash.display.Scene;

var mck : MovieClip = MovieClip(mockRepository.create(MovieClip));

Expect.call(mck.swapChildren(5,5)).message("TextBox swapped with Login control");
mockRepository.replay(mck);

// ExpectationViolationError including the message above 
// and why the expectation failed
mck.verify(mck);
