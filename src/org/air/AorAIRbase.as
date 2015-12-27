package org.air {
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.ui.Multitouch;
	
	public class AorAIRbase extends EventDispatcher {
		
		private static var Instance:AorAIRbase;
		
		private var _main:DisplayObjectContainer;
		public function get $ ():Object {
			return _main;
		}
		
		public function AorAIRbase($main:DisplayObjectContainer,$null:AABNullClass = null,target:IEventDispatcher=null) {
			_main = $main;
			super(target);
		}
		
		/**
		 * 单件实例化
		 */
		public static function getInstance ($main:DisplayObjectContainer, target:IEventDispatcher=null):AorAIRbase {
			if (AorAIRbase.Instance == null) {
				AorAIRbase.Instance = new AorAIRbase($main, new AABNullClass(), target);
			}//end if
			return AorAIRbase.Instance;
		}//end fun
		
		public function destructor ():void {
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE,DeactivateDo);
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, ActivateDo);
			if($.stage){
				$.stage.nativeWindow.removeEventListener(Event.CLOSING, ClosingMainWindowDo); //监听关闭窗体事件  
				$.stage.nativeWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, nwMinimized);//监听最小化窗体事
			}
			DeactivateFunc = null;
			ActivateFunc = null;
			
			_main = null;
			AorAIRbase.Instance = null;
		}
		
		public function start ():void {
			NativeApplication.nativeApplication.autoExit = false;
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,DeactivateDo);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, ActivateDo);
			$.stage.nativeWindow.addEventListener(Event.CLOSING, ClosingMainWindowDo); //监听关闭窗体事件  
			$.stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, nwMinimized);//监听最小化窗体事
		}
		
		public var DeactivateFunc:Function;
		private function DeactivateDo (e:Event):void {
			if(null != DeactivateFunc){
				DeactivateFunc();
			}
		}
		
		public var ActivateFunc:Function;
		private function ActivateDo (e:Event):void {
			if(null != ActivateFunc){
				ActivateFunc();
			}
		}
		
		public var ClosingMainWindowFunc:Function;
		private function ClosingMainWindowDo (e:Event):void {
			if(null != ClosingMainWindowFunc){
				ClosingMainWindowFunc();
			}else{
				trace('AorAIRBase.ClosingMainWindowDo > Application exit !! ** ');
				NativeApplication.nativeApplication.exit();
			}
		}
		
		public var MinimizedFunc:Function;
		private function nwMinimized (e:NativeWindowDisplayStateEvent):void {
			if(e.afterDisplayState ==  "minimized")  {
				if(null != MinimizedFunc){
					MinimizedFunc();
				}
			}
		}
		
		public function checkNativeApplicationSupports():String {
			var $echo:String = 'NativeApplication Supports : \r\n';
			$echo += '\t DockIcon			 	: ' + NativeApplication.supportsDockIcon + ';\r\n';
			$echo += '\t Menu				 	: ' + NativeApplication.supportsMenu + ';\r\n';
			$echo += '\t StartAtLogin			: ' + NativeApplication.supportsStartAtLogin + ';\r\n';
			$echo += '\t SystemTrayIcon 		: ' + NativeApplication.supportsSystemTrayIcon + ';\r\n';
			$echo += '\t SupportsTouchEvents	: ' + Multitouch.supportsTouchEvents + ';\r\n';
			$echo += '\t SupportedGestures		: ' + Multitouch.supportedGestures + ';\r\n';
			$echo += '\r\n';
			return $echo;
		}
		
	}
}class AABNullClass {}