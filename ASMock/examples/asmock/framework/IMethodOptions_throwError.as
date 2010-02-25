import asmock.framework.Expect;

import flash.display.MovieClip;

import mx.controls.TextArea;

var mck : MovieClip = MovieClip(mockRepository.create(MovieClip));

Expect.call(mck.addChild(null)).ignoreArguments().throwError(new Error("test!");

mockRepository.replay(mck);

// Will throw the error specified above
mck.addChild(new TextArea());

