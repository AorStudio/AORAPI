package com.net {
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class SocketManagerEvent extends Event {
		
		public static const CONNECT:String = "Socket_Connected";
		
		public static const IO_ERROR:String = "Socket_IO_Error";
		
		public static const SECURITY_ERROR:String = "Socket_Security_Error";
		
		public static const SOCKET_DATA:String = "Socket_Socket_DATA";
		
		public static const CLOSE:String = "Socket_closed";
		
		public static const START:String = "Socket_start";
		
		private var _bytesAvailable:uint;
		public function get bytesAvailable():uint	{
			return _bytesAvailable;
		}
		
		private var _StringData:String;
		public function get StringData():String {
			return _StringData;
		}

		private var _Data:ByteArray;
		public function get Data():ByteArray {
			return _Data;
		}
		
		public function SocketManagerEvent(type:String,bytesAvailable:uint,stringData:String,data:ByteArray = null,bubbles:Boolean=false, cancelable:Boolean=false) {
			_bytesAvailable = bytesAvailable;
			_StringData = stringData;
			_Data = data;
			super(type, bubbles, cancelable);
		}
	}
}