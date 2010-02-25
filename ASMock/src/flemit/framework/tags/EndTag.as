package flemit.framework.tags
{
	import flemit.framework.ISWFOutput;
	import flemit.framework.Tag;
	
	[ExcludeClass]
	public class EndTag extends Tag
	{
		public static const TAG_ID : int = 0x0; 
		
		public function EndTag()
		{
			super(TAG_ID);
		}
		
		public override function writeData(output:ISWFOutput):void		
		{
		}

	}
}