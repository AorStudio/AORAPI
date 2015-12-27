//org.air::AORFileWorker
package org.air {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.air.enu.RWLOCEnu;
	
	public class AORFileWorker {
		
		public function AORFileWorker() {
			throw new Error("This class can not be instantiated !");
		}
		
		private static function getLOCPath (workLoc:int):File {
			switch (workLoc){
				case RWLOCEnu.APPLICATION: return File.applicationDirectory;
				case RWLOCEnu.STORAGE: return File.applicationStorageDirectory;
				case RWLOCEnu.DESKTOP: return File.desktopDirectory;
				case RWLOCEnu.DOCUMENTS: return File.documentsDirectory;
				default: return File.applicationDirectory;
			}
		}
		
		/**
		 * 从指派的工作路径中的指定位置读取XML内容
		 */
		public static function readXMLFile (fileURL:String, workLoc:int = 0,$errorFunc:Function = null):XML {
			
			var $path:String = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).nativePath;
			if($path == null || $path == ""){
				$path = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).url;
			}
			
			var file:File =  new File($path);
			var fileStream:FileStream = new FileStream();
			if(file.exists){
				fileStream.open(file,FileMode.READ);
				try{
					var outXML:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
					fileStream.close();
					return outXML;
				}catch(e:Error){
					if($errorFunc != null){
						$errorFunc(e);
					}
					throw e;
				}
			}
			return null;
		}
		
		/**
		 * 从指派的工作路径中的指定位置将XML内容写入XML文件
		 * 注意，IOS平台下workLoc必须为1,Android平台不确定.
		 */
		public static function writeXMLFile (fileURL:String,xml:XML,workLoc:int = 0,$errorFunc:Function = null):void {
			
			var $path:String = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).nativePath;
			if($path == null || $path == ""){
				$path = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).url;
			}
			
			var file:File =  new File($path);
			var fileStream:FileStream = new FileStream();
			try{
				fileStream.open(file,FileMode.WRITE);
				
				var $xmlStr:String = xml.toXMLString();
				$xmlStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n" + $xmlStr.replace(/\n/,"\r\n");
				
				fileStream.writeUTFBytes($xmlStr);
				fileStream.close();
			}catch(e:Error){
				if($errorFunc != null){
					$errorFunc(e);
				}
				throw e;
			}
		}
		
		/**
		 *  从指派的工作路径中的指定位置删除文件
		 */
		public static function deleteFile  (fileURL:String,workLoc:int = 0):void {
			
			var $path:String = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).nativePath;
			if($path == null || $path == ""){
				$path = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).url;
			}
			
			var file:File =  new File($path);
			if(file.exists){
				file.deleteFile();
			}
		}
		
		/**
		 * 从指派的工作路径中的指定位置读取Binary内容
		 */
		public static function readBinaryFile (fileURL:String, workLoc:int = 0,$errorFunc:Function = null):ByteArray {
			var $path:String = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).nativePath;
			if($path == null || $path == ""){
				$path = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).url;
			}
			
			var file:File =  new File($path);
			
			var fileStream:FileStream = new FileStream();
			if(file.exists){
				fileStream.open(file,FileMode.READ);
				try{
					var out:ByteArray = new ByteArray();
					fileStream.readBytes(out,0,fileStream.bytesAvailable);
					fileStream.close();
					return out;
				}catch(e:Error){
					if($errorFunc != null){
						$errorFunc(e);
					}
					throw e;
				}
			}
			return null;
		}
		
		/**
		 * 从指派的工作路径中的指定位置将Binary内容写入Binary文件
		 * 注意，IOS平台下workLoc必须为1,Android平台不确定.
		 */
		public static function writeBinaryFile (fileURL:String,bytes:ByteArray,workLoc:int = 0,$errorFunc:Function = null):void {
			var $path:String = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).nativePath;
			if($path == null || $path == ""){
				$path = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).url;
			}
			
			var file:File =  new File($path);
			
			var fileStream:FileStream = new FileStream();
			try{
				fileStream.open(file,FileMode.WRITE);
				fileStream.writeBytes(bytes);
				fileStream.close();
			}catch(e:Error){
				if($errorFunc != null){
					$errorFunc(e);
				}
				throw e;
			}
		}
		
		/**
		 * 检查工作路径中的指定位置的文件是否存在。
		 */
		public static function exists (fileURL:String,workLoc:int = 0):Boolean {
			var $path:String = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).nativePath;
			if($path == null || $path == ""){
				$path = AORFileWorker.getLOCPath(workLoc).resolvePath(fileURL).url;
			}
			
			var file:File =  new File($path);
			
			if(file.exists){
				return true;
			}else{
				return false;
			}
		}
		
	}
}