package org.events {
    import flash.events.Event;

    public class AORSimpleEvent extends Event {
        
		public var params:Object;

        public function AORSimpleEvent($type:String, $params:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false)  {
			params = $params;
            super($type, $bubbles, $cancelable);
        }// end function

        override public function clone() : Event {
            return new AORSimpleEvent(type, params, bubbles, cancelable);
        }// end function

        override public function toString() : String {
            return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable");
        }// end function

    }
}
