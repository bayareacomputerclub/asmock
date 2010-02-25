import asmock.framework.Expect;

import flash.display.MovieClip;

var mck : MovieClip = MovieClip(mockRepository.create(MovieClip));

// Use SetupResult instead of Expect if the returnValue 
// should be permanent (ie. can be called an unlimited number 
// of times)
Expect.call(mck.alpha).returnValue(0.5);
Expect.call(mck.alpha).returnValue(0.6);
Expect.call(mck.alpha).returnValue(0.7);

mockRepository.replay(mck);
var alpha : Number = mck.alpha;
trace(alpha); // 0.5

trace(mck.alpha); // 0.6
trace(mck.alpha); // 0.7

mck.verify(mck);

