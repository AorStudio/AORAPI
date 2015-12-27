//org.units::ByteArrayParser
package org.units {
	import flash.utils.ByteArray;
	
	import org.units.EncodeTypeEnu;
	
	/**
	 * ByteArray 解析器
	 */
	public class ByteArrayParser {
		public function ByteArrayParser() {
			throw new Error("This class can not be instantiated !");
		}
		
		/**
		 * 尝试将BytesArray转换成字符串
		 */
		public static function ByteArrayToString ($bytes:ByteArray, encodeType:String = "uft-8"):String {
			
			$bytes.position = 0;
			
			var str:String;
			var $bytesAvailable:int = $bytes.bytesAvailable;
			switch (encodeType){
				case EncodeTypeEnu.UNICODE:
					//trace("(((((((((( " + $bytesAvailable);
					str = $bytes.readMultiByte($bytesAvailable ,"unicode");
					break;
				case EncodeTypeEnu.GBK:
					str = $bytes.readMultiByte($bytesAvailable,"GBK");
					break;
				case EncodeTypeEnu.BIG5:
					str = $bytes.readMultiByte($bytesAvailable,"big5");
					break;
				case EncodeTypeEnu.GB18030:
					str = $bytes.readMultiByte($bytesAvailable,"gb18030");
					break;
				default:
					str =  $bytes.readUTFBytes($bytesAvailable);
			}
			return str;
		}
		
		/**
		 * 尝试将字符串转换成BytesArray
		 */
		public static function StringToByteArray (str:String,encodeType:String = "uft-8"):ByteArray {
			var out:ByteArray = new ByteArray();
			switch (encodeType){
				case EncodeTypeEnu.UNICODE:
					out.writeMultiByte(str,"unicode");
					break;
				case EncodeTypeEnu.GBK:
					out.writeMultiByte(str,"GBK");
					break;
				case EncodeTypeEnu.BIG5:
					out.writeMultiByte(str,"big5");
					break;
				case EncodeTypeEnu.GB18030:
					out.writeMultiByte(str,"gb18030");
					break;
				default:
					out.writeUTFBytes(str);
			}
			return out;
		}
		
	}
}