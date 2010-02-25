package asmock.tests.framework
{
	import asmock.framework.Expect;
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.Is;
	import asmock.framework.constraints.Property;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.*;
	
	import mx.controls.SWFLoader;
	import mx.core.UIComponent;
	
	public class LargeObjectMockFixture extends MockTestCase
	{
		public function LargeObjectMockFixture()
		{
			super([Loader, SWFLoader]);
		}
		
		public function test_createStrict_supportsLargeObjects() : void
		{
			var loader : Loader = Loader(mockRepository.createStrict(Loader));
			
			SetupResult.forCall(loader.dispatchEvent(null)).ignoreArguments().callOriginalMethod();
			
			Expect.call(loader.load(null)).constraints([
				Property.value("url", "test_url"),
				Is.anything()
			]);
			
			var dispObject : DisplayObject = new MovieClip();
			
			SetupResult.forCall(loader.content).returnValue(dispObject);
			
			mockRepository.replay(loader);
			
			// NOTE: The loaderInfo events cannot be faked (cannot call dispatchEvent on loaderInfo)
			// To mock this process, create a wrapper interface
			loader.load(new URLRequest("test_url"));
			
			assertEquals(dispObject, loader.content);
		}
	}
}
