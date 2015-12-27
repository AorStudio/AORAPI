//com.command::AorCommander
package com.command {
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	
	import org.basic.Aorfuns;
	
	public class AorCommander extends EventDispatcher {
		
		
		//--------------------------------------------------------------------------------------------------
		
		// 提供一组静态方法，解决如果指令参数中包含"空格",可能造成的指令解析错误
		
		/**
		 * 将数组中的每条String中的"空格"转义符号,转换回"空格"
		 */
		public static function decodingCMDSymbolINCOMList ($com:Array):Array {
			var i:int,length:int = $com.length;
			for (i = 0; i < length; i++){
				$com[i] = decodingCMDSymbol($com[i]);
			}
			return $com;
		}
		
		/**
		 * 将String中的"*__*"(转义符号)转换回" ",将"*_*"(转义符号)转换回","
		 */
		public static function decodingCMDSymbol ($str:String):String {
			$str = $str.replace(/\*__\*/g," ");
			$str = $str.replace(/\*_\*/g,",");
			return $str;
		}
		/**
		 * 将String中的" "转换成"*__*"(转义符号),将","转换成"*_*"
		 */
		public static function encodingCMDSymbol ($str:String):String {
			$str = $str.replace(/ /g,"*__*");
			$str = $str.replace(/,/g,"*_*");
			return $str;
		}
		
		//--------------------------------------------------------------------------------------------------
		
		private static var Instance:AorCommander;
		
		public function AorCommander($null:ACHNullClass = null,target:IEventDispatcher=null) {
			super(target);
			_comList = new Vector.<CmdUnit>();
			_comList.push(new CmdUnit('help',commandHelp,this,_helpDoc));
			_comList.push(new CmdUnit('man',commandMan,this,_manDoc));
		}
		
		/**
		 * 单件实例化
		 */
		public static function getInstance (target:IEventDispatcher=null):AorCommander {
			if (AorCommander.Instance == null) {
				AorCommander.Instance = new AorCommander(new ACHNullClass(), target);
			}//end if
			return AorCommander.Instance;
		}//end fun
		
		public function destructor ():void {
			_comList = null;
			AorCommander.Instance = null;
		}
		
		private var _comList:Vector.<CmdUnit>;
		
		/**
		 * 添加一条命令
		 */
		public function addCommand ($alias:String,$comFun:Function, $comTarget:Object = null,$doc:String = "_no_more_info_"):Boolean {
			var i:int, length:int = _comList.length;
			for (i = 0; i < length; i++){
				if($alias == _comList[i].alias){
					return false;
				}
			}
			//
			_comList.push(new CmdUnit($alias,$comFun,$comTarget,$doc));
			return true;
		}
		/**
		 * 删除一条命令
		 */
		public function removeCommand ($alias:String):Boolean {
			var i:int, length:int = _comList.length;
			for (i = 0; i < length; i++){
				if($alias == _comList[i].alias){
					_comList.splice(i,1);
					return true;
				}
			}
			return false;
		}
		/**
		 * 执行命令
		 */
		public function ExecuteCommand ($alias:String,$params:Array = null):Boolean {
			var i:int, length:int = _comList.length;
			for (i = 0; i < length; i++){
				if($alias == _comList[i].alias){
					try{
						if($params){
							_comList[i].com.apply(_comList[i].comTarget,$params);
						}else{
							_comList[i].com.call(_comList[i].comTarget);
						}
					}catch(e:Error){
						throw e;
					}
					return true;
				}
				
			}
			return false;
		}
		
		/**
		 * 通过对象反射添加命令
		 */
		public function addCommandsByReflection ($Object:Object):void {
			
			var xml:XML = describeType($Object);
			
			var i:int,length:int = xml.method.length();
			var $alias:String,$doc:String = "_no_more_info";
			for (i = 0; i < length; i++){
				
				$alias = String(xml.method[i].@name);
				var u:int,ulength:int = xml.variable.length();
				for(u = 0; u < ulength; u++){
					if(("info_"+$alias) == xml.variable[u].@name){
						$doc = $Object["info_"+$alias];
						break;
					}
				}
				addCommand($alias,$Object[$alias],$Object,$doc);

			}
		}
		
		
		/**
		 * 通过对象反射删除命令
		 */
		public function removeCommandsByReflection ($Object:Object):void {
			var $alias:String;
			
			var xml:XML = describeType($Object);
			var i:int,length:int = xml.method.length();
			
			for (i = 0; i < length; i++){
				$alias = String(xml.method[i].@name);
				removeCommand($alias);
			}
		}
		
		private var _helpDoc:String = "help 命令\n解释:AorCommander的帮助,如需查看命令列表请使用 >help list\n用法:help [list]";
		/**
		 * 内置help命令
		 */
		private function commandHelp (...args):void {
			if(args == null || args.length == 0){
				Aorfuns.log("help >\n" + _helpDoc);
			}else if(args.length > 0){
				var $arg:String = args.join(" ");
				if($arg == "list"){
					var listStr:String = "";
					var i:int,length:int = _comList.length;
					for (i = 0; i < length; i++){
						listStr += (i.toString() + "." + _comList[i].alias + '\n');
					}
					Aorfuns.log("help list >\n" + listStr + ">");
				}
			}
		}
		
		private var _manDoc:String = "man 命令\n解释:查看命令配置文档\n用法:man <commandAlias>";
		/**
		 * 内置man命令
		 */
		private function commandMan (...args):void {
			if(args == null || args.length == 0){
				Aorfuns.log(_manDoc);
			}else{
				var $arg:String;
				if(args.length == 1){
					$arg = args[0];
				}else{
					$arg = args.join(" ");
				}
				var i:int,length:int = _comList.length;
				for (i = 0; i < length; i++){
					if($arg == _comList[i].alias){
						Aorfuns.log("man " + $arg + ">\n" + _comList[i].doc);
						return;
					}
				}
			}
		}
		
	}
}
class ACHNullClass {}