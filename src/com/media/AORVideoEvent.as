package com.media {
	import flash.events.Event;
	
	public class AORVideoEvent extends Event {
		
		public static const onStreamNotFound:String = "AORVE_onStreamNotFound";
		public static const onMetaData:String = "AORVE_onMetaData";
		public static const onXMPData:String = "AORVE_onXMPData";
		public static const onCuePoint:String = "AORVE_onCuePoint";
		public static const onAsyncError:String = "AORVE_onAsyncError";
		public static const onSecurityError:String = "AORVE_onSecurityError";
		public static const onBufferFlush:String = "AORVE_onBufferFlush";
		public static const onSeek:String = "AORVE_onSeek";
		public static const onStatsUpdate:String = "AORVE_onStatsUpdate";
		public static const onProgress:String = "AORVE_onProgress";
		
		public function AORVideoEvent(type:String,$moviePath:String,$volume:Number,$currentPos:Number,$duration:Number,$stats:String = "stoped",$dataObject:Object = null, $message:String = "none", bubbles:Boolean=false, cancelable:Boolean=false) {
			_moviePath = $moviePath;
			_volume = $volume;
			_currentPos = $currentPos;
			_duration = $duration;
			_stats = $stats;
			_message = $message;
			_dataObject = $dataObject;
			super(type, bubbles, cancelable);
		}
		
		private var _moviePath:String;
		public function get moviePath():String {
			return _moviePath;
		}
		
		private var _volume:Number;
		public function get volume():Number {
			return _volume;
		}
		
		private var _currentPos:Number;
		public function get currentPos():Number {
			return _currentPos;
		}
		
		private var _duration:Number;
		public function get duration():Number {
			return _duration;
		}
		
		private var _stats:String;
		public function get stats():String {
			return _stats;
		}
		
		private var _message:String;
		public function get message ():String {
			return _message;
		}
		
		private var _dataObject:Object;
		public function get dataObject():Object {
			return _dataObject;
		}
		
		override public function toString():String {
			var out:String = "AORVideoEvent[";
			out += type + ",<";
			out += "stats:" + _stats + ","
			out += "moviePath:" + _moviePath + ",";
			out += "volume:" + _volume + ",";
			out += "currentPos:" + _currentPos + ",";
			out += "duration:" + _duration + ",";
			out += "message:" + _message + ",";
			out += "dataObject:" + _dataObject + ">";
			return out + "]";
		}
		
		
		
		
	}
}