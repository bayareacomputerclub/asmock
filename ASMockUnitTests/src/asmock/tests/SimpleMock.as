package asmock.tests
{
	/**
	 * Enables extremely simple mocking of objects.  
	 * @author Richard Szalay
	 */	
	public class SimpleMock
	{
		private var _hash : Object = {};
		private var _container : Object;
		
		public function SimpleMock(container : Object)
		{
			this._container = container;
		}
		
		public function setupResult(func : String, returnValue : Object) : void
		{
			if (isSetup(func))
			{
				throw new Error("The function " + func + " has already been configured");				
			}
			
			_hash[func] = returnValue;
		}
		
		public function setupProxy(func : String, proxy : Function) : void
		{
			if (isSetup(func))
			{
				throw new Error("The function " + func + " has already been configured");
			}
			
			_hash[func] = proxy;
		}
		
		public function exec(func : String, argArray : Array = null) : Object
		{
			if (!isSetup(func))
			{
				throw new Error("Unexpected call to function " + func);
			}
			
			if (typeof(_hash[func]) == 'function')
			{
				return (_hash[func] as Function).apply(this._container, argArray);
			}
			else
			{
				return _hash[func];
			}
		}
		
		public function isSetup(func : String) : Boolean
		{
			return (typeof(_hash[func]) != 'undefined');
		}
		
		public function resetMethod(func : String) : void
		{
			delete _hash[func];
		}
		
		public function reset() : void
		{
			_hash = {};
		}
	}
}