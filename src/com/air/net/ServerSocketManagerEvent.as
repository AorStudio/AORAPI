package com.air.net {
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class ServerSocketManagerEvent extends Event {
		
		public static const SOCKET_CONNECT:String = "Socket_Connected";
		
		public static const SOCKET_RECEIVED:String = "Socket_Received_DATA";
		
		public static const SOCKET_DISCONNECTED:String = "Socket_Disconnected";
		
		public static const SOCKET_CLOSE:String = "Socket_Closed";
		
		public static const MANAGER_CLOSE:String = "Manager_Close";
		
		public static const MANAGER_START:String = "Manager_Start";
		
		private var _bytesAvailable:uint;
		public function get bytesAvailable():uint	{
			return _bytesAvailable;
		}
		
		private var _data:ByteArray;
		public function get data():ByteArray {
			return _data;
		}
		
		private var _remoteAddress:String;
		public function get remoteAddress():String {
			return _remoteAddress;
		}

		private var _remotePort:uint;
		public function get remotePort():uint {
			return _remotePort;
		}
		
		public function ServerSocketManagerEvent (type:String, $remoteAddress:String = null, $remotePort:uint = 0, bytesAvailable:uint = 0, data:ByteArray = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			_remoteAddress = $remoteAddress;
			_remotePort = $remotePort;
			_bytesAvailable = bytesAvailable;
			_data = data;
			super(type, bubbles, cancelable);
		}
	}
}
