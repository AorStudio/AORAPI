//org.assets::ImgBatchLoader
package org.assets {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.basic.Aorfuns;

	public class ImgBatchLoader extends EventDispatcher {
		
		private var _basePath:String;
		private var _URLList:Array;
		public function ImgBatchLoader($urlList:Array,$basePath:String = ""){
			_URLList = $urlList;
			_basePath = $basePath;
			_datas = [];
		}
		
		public function destructor ():void {
			clearLoader();
			_datas = null;
			_URLList = null;
		}
		
		private var _datas:Array;
		public function get datas():Array {
			return _datas;
		}
		
		public function startLoading ():void {
			loadingStart();
		}
		
		private var _imgLoder:Loader;
		
		private function loadingStart ():void {
			if(_URLList.length == 0){
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			_imgLoder = new Loader();
			_imgLoder.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorLoad);
			_imgLoder.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoad);
			_imgLoder.load(new URLRequest(_basePath + _URLList.shift()));
		}
		
		private function clearLoader ():void {
			if(_imgLoder){
				/*
				try{
					_imgLoder.close();
				}catch(e:Error){
					Aorfuns.log(e.toString());
				}*/
				_imgLoder.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorLoad);
				_imgLoder.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeLoad);
				_imgLoder = null;
			}
		}
		
		private function ioErrorLoad (e:IOErrorEvent):void {
			clearLoader();
			this.dispatchEvent(e);
			loadingStart();
		}
		
		private function completeLoad (e:Event):void {
			
			var $bitmap:Bitmap = _imgLoder.content as Bitmap;
			if($bitmap){
				_datas.push($bitmap);
				clearLoader();
				loadingStart();
			}else{
				clearLoader();
				this.dispatchEvent(new Event(Event.CANCEL));
				loadingStart();
			}
			
		}
		
	}
}