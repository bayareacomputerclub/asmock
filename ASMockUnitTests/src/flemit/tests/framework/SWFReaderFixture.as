package flemit.tests.framework
{
	import asmock.tests.ExtendedTestCase;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import flemit.framework.SWF;
	import flemit.framework.SWFReader;
	
	public class SWFReaderFixture extends ExtendedTestCase
	{
		public function SWFReaderFixture()
		{
		}
		
		public function testHeader() : void
		{
			var data : Array = [0x46, 0x57, 0x53, 0x09, 0x15, 0x00, 0x00, 
								0x00, 0x78, 0x00, 0x04, 0xE2, 0x00, 0x00, 
								0x0E, 0xA6, 0x00, 0x00, 0x18, 0x02, 0x00];
			
			var buffer : ByteArray = createByteArray(data);
			buffer.endian = Endian.LITTLE_ENDIAN;
			
			var reader : SWFReader = new SWFReader();
			
			var swf : SWF = reader.read(buffer);
			
			assertNotNull(swf.header);
			assertFalse(swf.header.compressed);
			assertEquals(9, swf.header.version);
			assertEquals("666.67", swf.header.width.toFixed(2));
			assertEquals(500, swf.header.height);
			assertEquals(24, swf.header.frameRate);
			assertEquals(2, swf.header.frameCount);
		}
		
		private function createByteArray(hexData : Array) : ByteArray
		{
			var data : ByteArray = new ByteArray();
			
			for each(var value : int in hexData)
			{
				data.writeByte(value);
			}
			
			data.position = 0;
			
			return data;
		}
	}
}