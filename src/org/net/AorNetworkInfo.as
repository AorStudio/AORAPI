//org.net::AorNetworkInfo
package org.net {
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	/**
	 * AorNetworkInfo 类
	 * 	获取本机IP地址、Mac地址的封装类
	 */
	public class AorNetworkInfo {
		
		public static function isSupported ():Boolean {
			return NetworkInfo.isSupported;
		}
		
		/**
		 * 获取本机网络的基本信息，包括ip地址（4，6）和mac地址
		 */
		public static function getAorNetworkInfo():AorNetworkInfo {
			if(NetworkInfo.isSupported){
				var netinfo:NetworkInfo=NetworkInfo.networkInfo;
				var interfaces:Vector.<NetworkInterface>=netinfo.findInterfaces();  
				if(interfaces!=null){  
					if(interfaces.length > 0){
						var i:int ,length:int = interfaces.length;
						for(i = 0; i < length; i++){
							if(interfaces[i].active){
								var $ip4:String,$ip6:String;
								var $mac:String = interfaces[i].hardwareAddress;
								var u:int, ul:int = interfaces[i].addresses.length;
								for (u = 0; u < ul; u++){
									if(interfaces[i].addresses[u].ipVersion.toLowerCase() == "ipv6"){
										$ip6 = interfaces[i].addresses[u].address;
									}
									if(interfaces[i].addresses[u].ipVersion.toLowerCase() == "ipv4"){
										$ip4 = interfaces[i].addresses[u].address;
									}
								}
								return getInstance($ip4,$ip6,$mac);
							}
						}
					}
				}
				throw new Error("Aorfuns.getAorNetworkInfo Error :: can not getAorNetworkInfo !");
			}
			return null;
		}
		
		/**
		 * 获取本机网络接口信息
		 */
		public static function getLocalNetworkInterfacesInfo ():String {
			if(NetworkInfo.isSupported){
				var netinfo:NetworkInfo=NetworkInfo.networkInfo  
				var interfaces:Vector.<NetworkInterface> = netinfo.findInterfaces(); 
				var out:String = "NetworkInterfacesInfo:\n";
				if(interfaces!=null){  
					if(interfaces.length > 0){
						var i:int ,length:int = interfaces.length;
						for(i = 0; i < length; i++){
							out += "\t名称: " +  interfaces[i].name + "\n";
							out += "\t显示名称: " +  interfaces[i].displayName + "\n";
							out += "\t状态: " +  (interfaces[i].active == true ? "激活" : "未激活") + "\n";
							out += "\tMAC地址: " + interfaces[i].hardwareAddress + "\n";
							var u:int, ul:int = interfaces[i].addresses.length;
							for (u = 0; u < ul; u++){
								out += "\t" + interfaces[i].addresses[u].ipVersion + ":\n";
								out += "\t\taddress: " + interfaces[i].addresses[u].address + "\n";
								out += "\t\tbroadcast: " + interfaces[i].addresses[u].broadcast + "\n";
								out += "\t\tprefixLength: " + interfaces[i].addresses[u].prefixLength + "\n";
							}
							out += "\n";
						}
						return out;
					}
				} 
				throw new Error("Aorfuns.getLocalNetworkInterfaces Error :: can not find interfaces");
			}
			return null;
		}
		
		private static var _Instance:AorNetworkInfo;
		public static function get Instance():AorNetworkInfo {
			return _Instance;
		}
		
		public function AorNetworkInfo($ip4:String,$ip6:String,$mac:String,$null:ANINullClass = null) {
			if ($null == null) {
				throw new Error("You cannot instantiate this class directly, please use the static getAorNetworkInfo method.");
				return;
			}//end fun
			_ip4 = $ip4;
			_ip6 = $ip6;
			_mac = $mac;
		}
		
		private static function getInstance ($ip4:String,$ip6:String,$mac:String):AorNetworkInfo {
			_Instance = new AorNetworkInfo($ip4,$ip6,$mac,new ANINullClass());
			return _Instance;
		}//end fun
		
		private var _ip4:String;
		public function get ip4():String {
			return _ip4;
		}
		
		private var _ip6:String;
		public function get ip6():String {
			return _ip6;
		}
		
		private var _mac:String;
		public function get mac():String {
			return _mac;
		}

	}
}class ANINullClass {}