package com.console {
	import flash.events.Event;
	
	public class AorConsoleEvent extends Event {
		
		/**
		 * 枚举：发布指令
		 */
		public static const INPUTCOMMAND:String = 'AorConsoleEvent_InputCommand';
		
		private var _InputData:String;
		public function get InputData():String {
			return _InputData;
		}
		
		
		public function AorConsoleEvent(type:String, inputdata:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			_InputData = inputdata;
			super(type, bubbles, cancelable);
		}
	}
}