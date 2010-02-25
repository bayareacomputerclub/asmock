import asmock.framework.Expect;
import asmock.framework.SetupResult;

import flash.display.MovieClip;

var mck : MovieClip = MovieClip(mockRepository.create(MovieClip));

SetupResult.forCall(mck.alpha).returnValue(0.4);
mockRepository.replay(mck);

// mck.verify(mck); // would be ok

var alpha : Number = mck.alpha;
trace(alpha); // 0.5

trace(mck.alpha); // 0.5
trace(mck.alpha); // 0.5
// ...
trace(mck.alpha); // 0.5

mck.verify(mck);

