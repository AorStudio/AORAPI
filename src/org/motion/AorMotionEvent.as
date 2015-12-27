//org.motion::AorMotionEvent
package org.motion {
	import flash.events.Event;
	
	public class AorMotionEvent extends Event {
		
		public static const AORMOTION_START:String = "AorMotionEvent_start";
		public static const AORMOTION_END:String = "AorMotionEvent_end";
		
		public function AorMotionEvent(type:String, $stats:String, $target:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			_stats = $stats;
			_target = $target;
			super(type, bubbles, cancelable);
		}
		
		private var _stats:String;
		public function get stats():String {
			return _stats;
		}
		
		private var _target:Object;
		override public function get target():Object {
			return _target;
		}
		
		
	}
}