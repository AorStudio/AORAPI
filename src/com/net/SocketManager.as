//com.net::SocketManager
package com.net {
	//import com.net.SocketManagerEvent;

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import org.basic.Aorfuns;
	import org.units.EncodeTypeEnu;
	
	public class SocketManager extends EventDispatcher {		
		
		public function SocketManager ($Host:String, $Port:uint,$encodeType:String):void {
			EncodeType = $encodeType;
			Host = $Host;
			Port = $Port;
		}
		
		public function destructor ():void {
			stop(false);
			//
		}
		/*
		public var Host:String = 'localhost';
		public var Port:uint = 8327;
		*/
		public var Host:String;
		public var Port:uint;
		public var EncodeType:String;// utf-8, gbk, big5
		
		public var session:String;
		
		private var _socket:Socket;
		
		private var _response:String = '';
		
		private var _isConnecting:Boolean = false;
		
		private var _isWorking:Boolean = false;
		/**
		 * 表示SocketManager是否处于工作状态，调用StartConnect方法时该标识为true；只有调用Stop方法的形参$isWorking = false时，该标识会重新置为false。
		 * 该表示可以用于上层组件判定SocketManager是否人为关闭连接还是遇到错误后断开连接。
		 * 通常用于上层组件写自动重连逻辑。
		 */
		public function get isWorking ():Boolean {
			return _isWorking;
		}
		
		/**
		 * 检测socket是否已经连接
		 */
		public function get isConnecting():Boolean {
			return _isConnecting;
		}
		
		public function StartConnect ($showInfo:Boolean = true):void {
			
			if(_socket){
				Aorfuns.log("Socketmanager.StartConnect > _socket is not null");
				return;
			}
			
			_isWorking = true;
			
			_socket = new Socket();
			_socket.addEventListener(Event.CLOSE, closeHandler);
			_socket.addEventListener(Event.CONNECT, connectHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			_socket.connect(Host,Port);
			dispatchEvent(new SocketManagerEvent(SocketManagerEvent.START,0,"SocketManager.StartConnect :: " + Host + ' : ' + Port));
			
			if($showInfo){
				var $startMess:String = "SocketManager.StartConnect :: " + Host + ' : ' + Port;
				Aorfuns.log('SocketManager.StartConnect > ' + $startMess);
			}
		}
		
		public function stop ($showInfo:Boolean = true,$isWorking:Boolean = false):void {
			
			_isConnecting = false;
			_isWorking = $isWorking;
			
			if(_socket){
				_socket.removeEventListener(Event.CLOSE, closeHandler);
				_socket.removeEventListener(Event.CONNECT, connectHandler);
				_socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_socket.removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
				if(_socket.connected){
					_socket.close();
				}
				_socket = null;	
			}
			
			if($showInfo){
				var $closeMess:String = Host + ' : ' + Port;
				Aorfuns.log('SocketManager.stop > ' + $closeMess);
			}
			
		}
		
		public function sendRequest($str:String):void {
			if(!_socket){
				Aorfuns.log('SocketManager.sendRequest Error > _socket = null');
				return;
			}
			//Aorfuns.log("SocketManager.sendRequest");
			_response = "";
			
			//$str += "\n";
			try {
				switch (EncodeType){
					case EncodeTypeEnu.UNICODE:
						_socket.writeMultiByte($str,"unicode");
						break;
					case EncodeTypeEnu.GBK:
						_socket.writeMultiByte($str,"GBK");
						break;
					case EncodeTypeEnu.BIG5:
						_socket.writeMultiByte($str,"big5");
						break;
					case EncodeTypeEnu.GB18030:
						_socket.writeMultiByte($str,"gb18030");
						break;
					default:
						_socket.writeUTFBytes($str);
				}
			}
			catch(e:IOError) {
				Aorfuns.log(e.toString());
			}
			
			_socket.flush();
			
		}
		
		private function closeHandler(event:Event):void {
			stop(false,true);
			dispatchEvent(new SocketManagerEvent(SocketManagerEvent.CLOSE,0,"SocketManager.closeHandler: connect closed :: " + Host + ' : ' + Port));
		}
		
		private function connectHandler(event:Event):void {
			_isConnecting = true;
			dispatchEvent(new SocketManagerEvent(SocketManagerEvent.CONNECT,0,"SocketManager.connectHandler: connect success :: " + Host + ' : ' + Port));
		}
			
		private function ioErrorHandler(event:IOErrorEvent):void {
			stop(false,true);
			dispatchEvent(new SocketManagerEvent(SocketManagerEvent.IO_ERROR,0,"SocketManager.ioErrorHandler: " + event));
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			stop(false,true);
			dispatchEvent(new SocketManagerEvent(SocketManagerEvent.SECURITY_ERROR,0,"SocketManager.securityErrorHandler: " + event));
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			readResponse();
		}
			private function readResponse():void {
				var $bytesAvailable:uint = _socket.bytesAvailable;
				var str:String;
				var $bytes:ByteArray = new ByteArray();
				 _socket.readBytes($bytes,0,$bytesAvailable);
				switch (EncodeType){
					case EncodeTypeEnu.UNICODE:
						str = $bytes.readMultiByte($bytesAvailable,"unicode");
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
						str = $bytes.readUTFBytes($bytesAvailable);
				}
				_response += str;
				dispatchEvent(new SocketManagerEvent(SocketManagerEvent.SOCKET_DATA,$bytesAvailable,_response,$bytes));
				_response = '';
			}
	}
}