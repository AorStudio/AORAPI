//org.basic::Aorfuns
package org.basic {
	import com.console.AorConsole;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.basic.assets.ApplicationDomainTAG;

	/**
	 * ...
	 * @author Aorition
	 */
	public class Aorfuns {
		
		public function Aorfuns() {
			throw new Error("This class can not be instantiated !");
		}
		
		private static var _version:String = '3.031';
		/**
		 * 获取版本号
		 */
		public static function get version ():String {
			return Aorfuns._version;
		}
		
		private static var _logNum:Number = 0;
		/**
		 * 返回当前记录Log的条数
		 */
		public static function get logNum() : Number {
			return _logNum;
		}// end function
		
		/**
		 * 获取当前系统时间的字符串
		 */
		public static function getTimeToString() : String {
			var $currentTime:Date = new Date();
			return ($currentTime.hours.toString() + ":" + $currentTime.minutes.toString() + ":" + $currentTime.seconds.toString() + " " + $currentTime.milliseconds.toString());
		}// end function
		
		/**
		 * log输出，匹配trace，AorConsole，AorExLog(JS) 3种输出方式。
		 */
		public static function log($logStr:String, $showTimeStr:Boolean = false) : Number {
			var $log:String = ($showTimeStr ? ("<# " + Aorfuns.getTimeToString() + " #> ") : ("")) + $logStr;
			
			trace($log);
			
			if(AorConsole.hasInstance()){
				AorConsole.getInstance().echo('<LOG> ' + $log);
			}
			
			try {
				ExternalInterface.call("AorExLog", $log);
			} catch (e:Error) {
			} finally {
				Aorfuns._logNum ++;
				return Aorfuns.logNum;
			}
		}// end function
		
		/**
		 * swf应用的基础设置，快速设置左上对齐，无缩放，以及系统菜单简化（加标），或者无系统菜单 (AIR无效) 
		 */
		public static function setDefault($ins:DisplayObjectContainer, $StageQuality:String = "high", $menuSign:String = null, $hideRightKeyMenu:Boolean = false):void {
			$ins.stage.quality = $StageQuality;
			if($menuSign || $hideRightKeyMenu){
				$ins.stage.align = StageAlign.TOP_LEFT;
				$ins.stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			if ($menuSign) {
				$ins.stage.showDefaultContextMenu = false;
				var $m:ContextMenu = new ContextMenu();
				var $mi:ContextMenuItem = new ContextMenuItem($menuSign);
				$mi.enabled = false;
				$m.customItems.push($mi);
				$m.hideBuiltInItems();
				$ins.contextMenu = $m;
				return;
			}
			if ($hideRightKeyMenu) {
				$ins.stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void { } );
			}
		}
		
		/**
		 *Uincode字符串转译为 字符串
		 */
		public static function UnicodeToString($unicode:String) : String {
			return unescape($unicode.replace(/\\u/g, "%u"));
		}// end function
		
		/**
		 * 字符串转译为Uincode字符串
		 */
		public static function StringToUnicode($string:String) : String {
			return escape($string.replace(/\%u/g, "u"));
		}// end function
		
		/**
		 * 快速创建一个LoaderContext对象
		 */
		public static function setApplicationDomain($ApplicationDomainTag:String) : LoaderContext {
			var $LoaderContext:LoaderContext = new LoaderContext();
			switch($ApplicationDomainTag) {
				case ApplicationDomainTAG.SELF:
				
					$LoaderContext.applicationDomain = ApplicationDomain.currentDomain;
					return $LoaderContext;
				
				case ApplicationDomainTAG.CHILD:
				
					$LoaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					return $LoaderContext;
				
				case ApplicationDomainTAG.NEW:
				
					$LoaderContext.applicationDomain = new ApplicationDomain();
					return $LoaderContext;
				
				default:
				
					trace("$ApplicationDomainTag无相关指令");
					return null;
					
			}
		}
		
		/**
		 * 在本应用域f内根据字符串获取Class
		 */
		public static function getClass ($class:String): Class {
			return Class(ApplicationDomain.currentDomain.getDefinition($class));
		}
		
		/**
		 * 在指定的swf内根据字符串获取Class
		 */
		public static function getClassInOjbect ($object:Object, $class:String) : Class {
			return Class($object.loaderInfo.applicationDomain.getDefinition($class));
		}
		
		/**
		 * 获取swf文件的所在域的名称 (AIR 无效)
		 */
		public static function getServerDomainName($loaderInfo:LoaderInfo) : String {
			var $tempArray:Array;
			var $url:String = $loaderInfo.url;
			if ($url.charAt(0) == "h") {
				if ($url.charAt(4) == ":") {
					$url = $url.slice(7);
				} else if ($url.charAt(4) == "s") {
					$url = $url.slice(8);
				}
				$tempArray = $url.split("/");
				$url = $tempArray[0];
				if ($url.search(":") != -1) {
					$tempArray = $url.split(":");
					$url = $tempArray[0];
				}
			} else if ($url.charAt(0) == "f") {
				$url = "localhost";
			} else {
				$url = "UNKNOWN";
			}
			return $url;
		}
		
		/**
		 * 针对rotation不为0的对象，获取DisplayObject的理论高度和宽度；
		 */
		public static function getRealSizeForDisplayObject($ins:DisplayObject) : Rectangle {
			var $realWidth:Number,$realHeight:Number;
			if ($ins.rotation != 0) {
				var $tempRotation:Number = $ins.rotation;
				$ins.rotation = 0;
				$realWidth = $ins.width;
				$realHeight = $ins.height;
				$ins.rotation = $tempRotation;
			} else {
				$realWidth = $ins.width;
				$realHeight = $ins.height;
			}
			return new Rectangle($ins.x, $ins.y, $realWidth, $realHeight);
		}
		
		/**
		 * 针对rotation不为0的对象，设置DisplayObject的理论高度和宽度；
		 */
		public static function setRealSizeForDisplayObject($ins:DisplayObject, $realWidth:Number, $realHeihgt:Number) : void {
			
			var $flipWidth:Boolean = ($ins.scaleX < 0 ? true : false);
			var $flipHeight:Boolean = ($ins.scaleY < 0 ? true : false);
			
			if ($ins.rotation != 0) {
				var $tempRotation:Number = $ins.rotation;
				$ins.rotation = 0;
				$ins.width = $realWidth;
				$ins.height = $realHeihgt;
				$ins.rotation = $tempRotation;
			} else {
				$ins.width = $realWidth;
				$ins.height = $realHeihgt;
			}
			
			if ($flipWidth) {
				$ins.scaleX = -($ins.scaleX);
			}
			if ($flipHeight) {
				$ins.scaleY = -($ins.scaleY);
			}
		}
		
		/**
		 * 设置可视对象的交互属性
		 */
		public static function setDOCInteractvie ($ins:DisplayObjectContainer, $mouse:Boolean = false, $tab:Boolean = false, $mouseChildren:Boolean = false, $tabChildren:Boolean = false): void {
			$ins.mouseEnabled = $mouse;
			$ins.tabEnabled = $tab;
			$ins.mouseChildren = $mouseChildren;
			$ins.tabChildren = $tabChildren;
		}
		
		/**
		 * 解析从XML数据内读出的字符串，解决XML数据内\r\n\t不能正常起作用的问题
		 */
		public static function XMLStr2String ($ins:String):String {
			$ins = $ins.replace(/\\r/g,'\r');
			$ins = $ins.replace(/\\n/g,'\n');
			$ins = $ins.replace(/\\t/g,'\t');
			return $ins;
		}
		
		/**
		 * 延迟时间执行一个方法
		 */
		public static function delayCall ($delayTime:int, $funcion:Function, $funcParms:Array = null):uint {
			
			var $DT:Timer = new Timer($delayTime);
			var $DFUNC:Function = function (e:TimerEvent):void {
				var $T:Timer = e.currentTarget as Timer;
				var $O:Object = Aorfuns.removeDCinDCA($T);
				var $doFunc:Function = $O.func;
				var $doFuncParms:Array = $O.funcParms;
				$O.func = null;
				$O.funcParms = null;
				$O = null;
				if($doFunc != null){
					try{
						$doFunc.apply(null,$doFuncParms);
					}catch(e:Error){
						Aorfuns.log("Aorfuns.delayCall Error :: " + e);
					}
				}else{
					Aorfuns.log("Aorfuns.delayCall Error :: no Timer target in delayCallList");
				}
			}
			$DT.addEventListener(TimerEvent.TIMER,$DFUNC);
			var $id:uint = getTimer() * (Math.random() * 1024);
			Aorfuns.addDCinDCA($id,$DT,$DFUNC,$funcion,$funcParms);
			$DT.start();
			return $id;
		}
		/**
		 * 取消延迟执行的方法
		 */
		public static function clearDelayCall ($id:uint):void {
			if(Aorfuns.delayCallList){
				var i:int,length:int = Aorfuns.delayCallList.length;
				for(i = 0; i < length; i++ ){
					if($id == Aorfuns.delayCallList[i].id){
						Aorfuns.delayCallList[i].timer.reset();
						Aorfuns.delayCallList[i].timer.removeEventListener(TimerEvent.TIMER, Aorfuns.delayCallList[i].timerFunc);
						Aorfuns.delayCallList[i].timer = null;
						Aorfuns.delayCallList[i].timerFunc = null;
						Aorfuns.delayCallList[i].func = null;
						Aorfuns.delayCallList[i].funcParms = null;
						Aorfuns.delayCallList.splice(i,1);
						return;
					}
				}
			}
		}
			private static var delayCallList:Array;
			private static function addDCinDCA ($id:uint,$timer:Timer,$timerFunc:Function,$funcion:Function, $funcParms:Array = null):void {
				if(Aorfuns.delayCallList == null) delayCallList = [];
				var i:int;
				var length:int = Aorfuns.delayCallList.length;
				for(i = 0; i < length; i++){
					if($timer == Aorfuns.delayCallList[i].timer){
						return;
					}
				}
				delayCallList.push({id:$id,timer:$timer,timerFunc:$timerFunc,func:$funcion,funcParms:$funcParms});
			}
			private static function removeDCinDCA ($timer:Timer):Object {
				if(Aorfuns.delayCallList == null) return null;
				var i:int;
				var length:int = Aorfuns.delayCallList.length;
				for(i = 0; i < length; i++){
					if($timer == Aorfuns.delayCallList[i].timer ){
						//
						Aorfuns.delayCallList[i].timer.reset();
						Aorfuns.delayCallList[i].timer.removeEventListener(TimerEvent.TIMER, Aorfuns.delayCallList[i].timerFunc);
						Aorfuns.delayCallList[i].timer = null;
						Aorfuns.delayCallList[i].timerFunc = null;
						//
						return Aorfuns.delayCallList.splice(i,1)[0] as Object;
					}
				}
				return null;
			}
			
		/**
		 * 通过ARGB四个值获取一个颜色值
		 */
		public static function ARGB2Color (R:uint,G:uint,B:uint,A:uint = 0xFF):uint{
			return ((A << 24) | (R << 16) | (G << 8) | B) as uint;
		}
		
		/**
		 * 通过RGB三个值获取一个颜色值
		 */
		public static function RGB2Color (R:uint,G:uint,B:uint):uint{
			return ((R << 16) | (G << 8) | B) as uint;
		}
		
		/**
		 * Color转ARGB对象
		 */
		public static function Color2ARGB (color:uint):Object {
			return {a:(color >> 24) & 0xFF,r:(color >> 16) & 0xFF,g:(color >> 8) & 0xFF,b:color & 0xFF};
		}
		
		/**
		 * Color转RGB对象
		 */
		public static function Color2RGB (color:uint):Object {
			return {r:(color >> 16) & 0xFF,g:(color >> 8) & 0xFF,b:color & 0xFF};
		}
		
		/**
		 * 文字去除空格(包括文字的全部空格(也包括\t));
		 */
		public static function trim(str:String):String {
			return str.replace(/([ 　\t]{1})/g,"");
		}
		
		/**
		 * 文字去除首尾空格(不包括文字中间的空格);
		 */
		public static function trimPro (str:String):String {
			var startC:int, endC:int;
			startC = str.search(/[^  \s]/);
			if(startC != -1 ){
				str = str.substring(startC);
			}else{
				return "";
			}
			endC = str.search(/[^  \s][  \s]*$/);
			if(endC != -1 ){
				str = str.substring(0,endC + 1);
			}
			return str;
		}
		
	}
}