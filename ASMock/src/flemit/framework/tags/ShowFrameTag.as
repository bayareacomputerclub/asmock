package flemit.framework.tags
{
	import flemit.framework.ISWFOutput;
	import flemit.framework.Tag;
	
	[ExcludeClass]
	public class ShowFrameTag extends Tag
	{
		public static const TAG_ID : int = 0x1;
		
		private var _name : String;
		
		public function ShowFrameTag()
		{
			super(TAG_ID);
		}
		
		public override function writeData(output : ISWFOutput) : void
		{
		}
	}
}