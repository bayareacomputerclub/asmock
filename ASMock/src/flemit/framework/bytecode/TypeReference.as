package flemit.framework.bytecode
{
	import asmock.reflection.Type;
	
	[ExcludeClass]
	public class TypeReference
	{
		private _type : Type;
		
		public function TypeReference(type : Type)
		{
			_type =type;
		}
		
		public function addToContext(context : IByteCodeContext) : void
		{
			context.registerType(this._type);
		}
	}
}