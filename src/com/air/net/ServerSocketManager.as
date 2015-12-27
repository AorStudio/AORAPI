//com.air.net::ServerSocketManager
package com.air.net {
	//import com.air.net.ServerSocketManagerEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.events.TimerEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import org.basic.Aorfuns;
	import org.units.EncodeTypeEnu;
	
	/**
	 * Socket Server 管理类
	 */
	public class ServerSocketManager extends EventDispatcher {
		
		public function ServerSocketManager($Bind_IP:String,$Bind_localPort:uint,$checkClientTime:int,$EncodeType:String) {
			EncodeType = $EncodeType;
			Bind_IP = $Bind_IP;
			Bind_localPort = $Bind_localPort;
			_checkClientTime = $checkClientTime;
			
			_clientList = [];
			
			//设置安全沙箱
			//Security.allowDomain("*"); 
			//Security.allowInsecureDomain("*");
		}
		
		public function destructor ():void {
			//
			stopListenClient();
			
			while (_clientList.length > 0){
				destroySocketClient(_clientList.pop().client as Socket);
			}
			
			_clientList = null;
		}
		
		public var EncodeType:String;
		
		private var _serverSocket:ServerSocket;
		private var _clientList:Array;
		
		private var _checkClientTime:int;
		
		public var Bind_localPort:int;
		public var Bind_IP:String;
		
		/**
		 * 启动Socket Server
		 */
		public function start ():void {
			if(ServerSocket.isSupported == false){
				Aorfuns.log('The System can not supported ServerSocket ! ***',true);
				return;
			}

			if(_serverSocket || _clientList.length > 0) return;
			
			_serverSocket = new ServerSocket();
			_serverSocket.bind(Bind_localPort);
			//
			_serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, ClientConnectedFun);
			//
			_serverSocket.listen();
			listenClient();
			Aorfuns.log('ServerSocketManager.start > serverSocket listen to ' + Bind_IP + ' : ' + Bind_localPort);
			dispatchEvent(new ServerSocketManagerEvent(ServerSocketManagerEvent.MANAGER_START));
		}
		
		
		/**
		 * 停止Socket Server
		 */
		public function stop ():void {
			if(_serverSocket){
				
				while (_clientList.length > 0){
					destroySocketClient(_clientList.pop().client as Socket);
				}
					
				if(_serverSocket.listening){
					var $closeMess:String = Bind_IP + ' : ' + Bind_localPort;
					_serverSocket.close();
					//Aorfuns.log('ServerSocketManager.stop > ' + $closeMess);
				}
				_serverSocket.removeEventListener(ServerSocketConnectEvent.CONNECT, ClientConnectedFun);
				_serverSocket = null;
				
				stopListenClient();
				
				dispatchEvent(new ServerSocketManagerEvent(ServerSocketManagerEvent.MANAGER_CLOSE));
			}
			Aorfuns.log('ServerSocketManager.stop > ');
		}
		
		private function checkSocketConnected ($cs:Socket):Boolean {
			var i:int, length:int = _clientList.length;
			for (i = 0; i < length; i++){
				if($cs == _clientList[i].client){
					return false;
				}
			}
			return true;
		}
		
		private function ClientConnectedFun (e:ServerSocketConnectEvent):void {
			var $cs:Socket = e.socket;
			if(!checkSocketConnected($cs)){
				Aorfuns.log("*** Ignore Repeated connection > " + $cs.toString());
				return;
			}
			$cs.addEventListener( ProgressEvent.SOCKET_DATA, onClientSocketData );
			
			var $address:String = $cs.remoteAddress;
			var $port:uint = $cs.remotePort;
			
			_clientList.push({address:$address,port:$port,client:$cs});
			
			Aorfuns.log( "ServerSocketManager > Connection from " + $cs.remoteAddress + ":" + $cs.remotePort, true );
			dispatchEvent(new ServerSocketManagerEvent(ServerSocketManagerEvent.SOCKET_CONNECT,$cs.remoteAddress,$cs.remotePort));
			
		}
		
		private var _listenTimer:Timer;
		private function listenClient ():void {
			stopListenClient();
			_listenTimer = new Timer(_checkClientTime);
			_listenTimer.addEventListener(TimerEvent.TIMER, checkClientFun);
			_listenTimer.start();
		}
		
		private function stopListenClient ():void {
			if(_listenTimer){
				_listenTimer.reset();
				_listenTimer.removeEventListener(TimerEvent.TIMER, checkClientFun);
				_listenTimer = null;
			}
		}
		public var CustomHeartbeatFunc:Function;
		private function defaultHearbeatFunc ($sc:Object):void {
			if(CustomHeartbeatFunc != null){
				CustomHeartbeatFunc($sc);
				return;
			}
			
			sendStringToSocket('\r\n|',$sc.client,false);
			
		}
		private function checkClientFun (e:TimerEvent):void {
			var i:int, length:int = _clientList.length;
			var $cs:Socket;
			for (i = 0; i < length; i++){
				$cs = _clientList[i].client;
				if($cs && $cs.connected){
					defaultHearbeatFunc(_clientList[i]);
				}else{
					var $a:String = _clientList[i].address;
					var $p:uint = _clientList[i].port;
					Aorfuns.log( "ServerSocketManager > Disconnected :: " + $a + ":" + $p, true );
					dispatchEvent(new ServerSocketManagerEvent(ServerSocketManagerEvent.SOCKET_DISCONNECTED,$a,$p));
					_clientList.splice(i,1);
					destroySocketClient($cs);
				}
			}
			
		}
		
		private function destroySocketClient ($cs:Socket):void {
			if($cs){
				if($cs.connected){
					$cs.close();
				}
				$cs.removeEventListener( ProgressEvent.SOCKET_DATA, onClientSocketData );
				$cs = null;
			}
		}
		
		private function onClientSocketData (e:ProgressEvent):void {
			var $cs:Socket = e.currentTarget as Socket;
			var $bytesAvailable:uint = $cs.bytesAvailable;
			var $buffer:ByteArray = new ByteArray();
			
			$cs.readBytes($buffer);
			
			//Aorfuns.log( "SocketData : < Form: " +$cs.remoteAddress + ":" + $cs.remotePort + ",Received: " + $buffer.toString() ,true);
			dispatchEvent(new ServerSocketManagerEvent(ServerSocketManagerEvent.SOCKET_RECEIVED,$cs.remoteAddress,$cs.remotePort,$bytesAvailable,$buffer));
			
		}
		
		/**
		 * 获取当前连接的Socket客服端列表
		 */
		public function getSocketClientInfo ():String {
			var out:String = "ServerSocketManager.getSocketClientInfo > \r\n";
			var i:int, length:int = _clientList.length;
			for (i = 0; i < length; i++){
				var tar:Object = _clientList[i];
				if(tar.client && Socket(tar.client).connected){
					out += "\t\t" + tar.address + ":" + tar.port + "\r\n"
				}
			}
			out += "\\>\r\n";
			return out;
		}
		
		/**
		 * 获取连接至服务器的Socket对象，根据$Address值或者$port值进行匹配
		 */
		public function getSocket ($Address:String = null, $port:uint = 0):Socket {
			var i:int, length:int = _clientList.length;
			for (i = 0; i < length; i++){
				var tar:Object = _clientList[i];
				if(tar.address == $Address && tar.port == $port){
					tar = null;
					return _clientList[i].client as Socket;
				}else if (tar.address == $Address){
					tar = null;
					return _clientList[i].client as Socket;
				}else if( tar.port == $port){
					tar = null;
					return _clientList[i].client as Socket;
				}
			}
			tar = null;
			return null;
		}
		/**
		 * 获取连接至服务器的SocketClient的包装对象，根据$Address值或者$port值进行匹配
		 * {address:String,port:uint,client:Socket,isVerified:Boolean = false}
		 */
		public function getSocketClient ($Address:String = null, $port:uint = 0, $socket:Socket = null):Object {
			var i:int, length:int = _clientList.length;
			for (i = 0; i < length; i++){
				var tar:Object = _clientList[i];
				if(tar.address == $Address && tar.port == $port){
					tar = null;
					return _clientList[i] as Object;
				}else if (tar.address == $Address){
					tar = null;
					return _clientList[i] as Object;
				}else if( tar.port == $port){
					tar = null;
					return _clientList[i] as Object;
				}else if(tar.client == $socket){
					tar = null;
					return _clientList[i] as Object;
				}
			}
			tar = null;
			return null;
		}
		
		/**
		 * 广播 字符串
		 */
		public function sendStringToALL (ins:String):void {
			var i:int, length:int = _clientList.length;
			var $cs:Socket;
			for (i = 0; i < length; i++){
				$cs = _clientList[i].client as Socket;
				sendStringToSocket(ins,$cs);
			}
			$cs = null;
		}
		
		/**
		 * 对单独SocketClient对象发送字符串
		 */
		public function sendStringToSocket (ins:String, $cs:Socket,$log:Boolean = true):void {
			try {
				if( $cs != null && $cs.connected ) {
					switch (EncodeType){
						case EncodeTypeEnu.UNICODE:
							$cs.writeMultiByte(ins,"unicode");
							break;
						case EncodeTypeEnu.GBK:
							$cs.writeMultiByte(ins,"GBK");
							break;
						case EncodeTypeEnu.BIG5:
							$cs.writeMultiByte(ins,"big5");
							break;
						case EncodeTypeEnu.GB18030:
							$cs.writeMultiByte(ins,"gb18030");
							break;
						default:
							$cs.writeUTFBytes(ins);
					}
					$cs.flush(); 
					if($log){
						Aorfuns.log( "Sent message to " + $cs.remoteAddress + ":" + $cs.remotePort );
					}
				}else{
					Aorfuns.log("No socket connection.");
				}
			}catch ( error:Error ) {
				Aorfuns.log( error.message );
			}
		}
		
		/**
		 * 广播 bytes数据
		 */
		public function sendBytesToALL (ins:ByteArray,$log:Boolean = true):void {
			var i:int, length:int = _clientList.length;
			var $cs:Socket;
			ins.position = 0;
			for (i = 0; i < length; i++){
				$cs = _clientList[i].client as Socket;
				sendBytesToSocket(ins,$cs,$log);
			}
			$cs = null;
		}
		
		/**
		 * 对单独SocketClient对象发送bytes数据
		 */
		public function sendBytesToSocket (ins:ByteArray, $cs:Socket,$log:Boolean = true):void {
			try {
				if( $cs != null && $cs.connected ) {
					ins.position = 0;
					$cs.writeBytes(ins);
					$cs.flush(); 
					if($log){
						Aorfuns.log( "Sent ByteArray to " + $cs.remoteAddress + ":" + $cs.remotePort );
					}
				}else{
					Aorfuns.log("No socket connection.");
				}
			}catch ( error:Error ) {
				Aorfuns.log( error.message );
			}
		}
		
		/**
		 * 关闭某个已经连接的socket对象
		 */
		public function closeSocketClient ($Address:String = null, $port:uint = 0, $socket:Socket = null):void {
			var c:Socket = getSocket($Address,$port);
			if(c){
				var i:int,length:int = _clientList.length;
				for(i = 0; i < length; i++){
					if(_clientList[i].client == c){
						_clientList.splice(i,1);
						destroySocketClient(c);
					}
				}
			}
		}
		
	}
}