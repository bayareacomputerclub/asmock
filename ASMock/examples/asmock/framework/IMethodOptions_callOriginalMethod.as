import asmock.framework.Expect;

import flash.display.MovieClip;
import flash.display.Scene;

var mck : MovieClip = MovieClip(mockRepository.create(MovieClip));

Expect.call(mck.currentScene).callOriginalMethod().repeat.once();
mockRepository.replay(mck);

var scene : Scene = mck.currentScene;
// scene = mck.currentScene; // ExpectationViolationError if called a second time

mck.verify(mck);
