import asmock.framework.Expect;

import flash.display.DisplayObject;
import flash.display.MovieClip;

import mx.controls.TextArea;

var mck : MovieClip = MovieClip(mockRepository.create(MovieClip));

var specialReturnValue : DisplayObject = new TextArea();

Expect.call(mck.getChildAt(5)).doAction(function(index : int) : DisplayObject
{
	// Some out of the ordinary logic for what happens here
	
	return specialReturnValue; // Value to be returned from method. 
});

mockRepository.replay(mck);

mck.getChildAt(5); // specialReturnValue will be returned 
