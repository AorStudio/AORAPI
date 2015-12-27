package org.interactive{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.interactive.assets.MouseEventPlus;
    

    public class MouseHandle extends EventDispatcher implements InteractiveBase {
		
        private var _ClickCheckTimeNum:int = 35;
        private var _ClickCheckDisNum:int = 10;
        private var _swingPerc:Number = 0.6;
        private var _stageInstance:Stage;
        private var msPointCache:Point;
        private var frameTimeCache:int = 0;
        private var LastPointCache:Point;
        private var cEvent:MouseEvent;
        private var drawPointsCache:Vector.<Point>;
        private var doubleClickCNCache:int;
        private var isCheckDClick:Boolean = false;
        private var _isMSDown:Boolean = false;
        private static var Instance:MouseHandle;

        public function MouseHandle($stage:Stage, $null:MSITCNullClass = null) {
            if ($null == null){
                throw new Error("You cannot instantiate this class directly, please use the static getInstance method.");
            }
            _stageInstance = $stage;
           
        }// end function

        public function get ClickCheckTimeLimt() : int
        {
            return _ClickCheckTimeNum;
        }// end function

        public function set ClickCheckTimeLimt(param1:int) : void
        {
            _ClickCheckTimeNum = param1;
           
        }// end function

        public function get ClickCheckDisNum() : int
        {
            return _ClickCheckDisNum;
        }// end function

        public function set ClickCheckDisNum(param1:int) : void
        {
            _ClickCheckDisNum = param1;
           
        }// end function

        public function get SwingPerc() : Number
        {
            return _swingPerc;
        }// end function

        public function set SwingPerc(param1:Number) : void
        {
            _swingPerc = param1;
           
        }// end function

        public function startListen($left:Boolean = true, $mddle:Boolean = false, $right:Boolean = false, $wheel:Boolean = false) : void
        {
            stopListen($left, $mddle, $right, $wheel);
            if ($left) {
                _stageInstance.addEventListener(MouseEvent.MOUSE_OVER, msOver);
                _stageInstance.addEventListener(MouseEvent.MOUSE_OUT, msOut);
                _stageInstance.addEventListener(MouseEvent.MOUSE_DOWN, msDown);
                _stageInstance.addEventListener(MouseEvent.MOUSE_UP, msUp);
            }
            if ($mddle) {
                _stageInstance.addEventListener(MouseEvent.MIDDLE_CLICK, mddleClick);
            }
            if ($right) {
                _stageInstance.addEventListener(MouseEvent.RIGHT_CLICK, rightClick);
            }
            if ($wheel) {
                _stageInstance.addEventListener(MouseEvent.MOUSE_WHEEL, msWheel);
            }
           
        }// end function

        public function stopListen($left:Boolean = true, $mddle:Boolean = false, $right:Boolean = false, $wheel:Boolean = false) : void {
            _stageInstance.removeEventListener(Event.ENTER_FRAME, msCoreLoop);
            _stageInstance.removeEventListener(Event.ENTER_FRAME, CheckDobleClick);
            _stageInstance.removeEventListener(MouseEvent.MOUSE_MOVE, msMove);
            if ($wheel){
                _stageInstance.removeEventListener(MouseEvent.MOUSE_WHEEL, msWheel);
            }
            if ($left){
                _stageInstance.removeEventListener(MouseEvent.MOUSE_OVER, msOver);
                _stageInstance.removeEventListener(MouseEvent.MOUSE_OUT, msOut);
                _stageInstance.removeEventListener(MouseEvent.MOUSE_DOWN, msDown);
                _stageInstance.removeEventListener(MouseEvent.MOUSE_UP, msUp);
            }
            if ($mddle){
                _stageInstance.removeEventListener(MouseEvent.MIDDLE_CLICK, mddleClick);
            }
            if ($right){
                _stageInstance.removeEventListener(MouseEvent.RIGHT_CLICK, rightClick);
            }
           
        }// end function

        public function destructor() : void{
            stopListen(true, true, true, true);
            _stageInstance = null;
           
        }// end function

        private function msOver(event:MouseEvent) : void{
            if (_isMSDown){
                dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_ROLLOVER, event.target, new Point(event.stageX, event.stageY), null, null, 1, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
            }
            dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_OVER, event.target, new Point(event.stageX, event.stageY), null, null, 1, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
           
        }// end function

        private function msOut(event:MouseEvent) : void{
            if (_isMSDown){
                dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_ROLLOUT, event.target, new Point(event.stageX, event.stageY), null, null, 1, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
            }
            dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_OUT, event.target, new Point(event.stageX, event.stageY), null, null, 1, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
           
        }// end function

        private function msDown(event:MouseEvent) : void {
            _isMSDown = true;
            msPointCache = new Point(event.stageX, event.stageY);
            dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_DOWN, event.target, new Point(event.stageX, event.stageY), null, null, 1, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
            drawPointsCache = new Vector.<Point>;
            LastPointCache = msPointCache.clone();
            cEvent = event;
            _stageInstance.addEventListener(MouseEvent.MOUSE_MOVE, msMove);
            _stageInstance.addEventListener(Event.ENTER_FRAME, msCoreLoop);
           
        }// end function

        private function msCoreLoop(event:Event) : void {
            var _loc_3:* = this;
            var _loc_4:* = frameTimeCache + 1;
            _loc_3.frameTimeCache = _loc_4;
            var _loc_2:* = new Point(_stageInstance.mouseX, _stageInstance.mouseY);
            drawPointsCache.push(_loc_2);
            dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_KEEP, cEvent.target, _loc_2, LastPointCache, null, 1, cEvent.bubbles, cEvent.cancelable, cEvent.localX, cEvent.localY, cEvent.relatedObject, cEvent.ctrlKey, cEvent.altKey, cEvent.shiftKey, cEvent.buttonDown, cEvent.delta));
            LastPointCache = _loc_2.clone();
           
        }// end function

        private function msMove(event:MouseEvent) : void {
            cEvent = event;
            dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_ROLLMOVE, event.target, new Point(event.stageX, event.stageY), LastPointCache, null, 1, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
           
        }// end function

        private function msUp(event:MouseEvent) : void {
            _isMSDown = false;
            _stageInstance.removeEventListener(MouseEvent.MOUSE_MOVE, msMove);
            _stageInstance.removeEventListener(Event.ENTER_FRAME, msCoreLoop);
            var _loc_2:* = new Point(event.stageX, event.stageY);
            dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_UP, event.target, _loc_2, LastPointCache, drawPointsCache, frameTimeCache, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
            if (frameTimeCache < _ClickCheckTimeNum){
				
            }
            if (checkDistance(msPointCache, _loc_2, _ClickCheckDisNum)){
                checkDistance(msPointCache, _loc_2, _ClickCheckDisNum);
            }
            if (checkDistance(_loc_2, LastPointCache, _ClickCheckDisNum)){
                dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_CLICK, event.target, _loc_2, LastPointCache, drawPointsCache, frameTimeCache, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
                if (!isCheckDClick){
                    doubleClickCNCache = 0;
                    _stageInstance.addEventListener(Event.ENTER_FRAME, CheckDobleClick);
                    isCheckDClick = true;
                }else{
                    dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_DOUBLECLICK, event.target, _loc_2, LastPointCache, drawPointsCache, frameTimeCache, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
                }
            } else {
                if (frameTimeCache < _ClickCheckTimeNum * _swingPerc) {
                }
                if (checkDistance(msPointCache, _loc_2, _ClickCheckDisNum) == false) {
                    dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_SWINGING, event.target, _loc_2, LastPointCache, drawPointsCache, frameTimeCache, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
                }
            }
            frameTimeCache = 0;
           
        }// end function

        private function msWheel(event:MouseEvent) : void {
            dispatchEvent(new MouseEventPlus(MouseEventPlus.PLUS_MOUSE_SWINGING, event.target, new Point(event.stageX, event.stageY), null, null, 1, event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
           
        }// end function

        private function CheckDobleClick(event:Event) : void {
            var _loc_2:* = this;
            var _loc_3:* = doubleClickCNCache + 1;
            _loc_2.doubleClickCNCache = _loc_3;
            if (doubleClickCNCache >= _ClickCheckTimeNum){
                _stageInstance.removeEventListener(Event.ENTER_FRAME, CheckDobleClick);
                isCheckDClick = false;
            }
        }// end function

        private function mddleClick(event:MouseEvent) : void {
            dispatchEvent(event);
        }// end function

        private function rightClick(event:MouseEvent) : void {
            dispatchEvent(event);
           
        }// end function

        private function checkDistance(param1:Point, param2:Point, param3:Number) : Boolean {
            var _loc_4:* = Point.distance(param1, param2);
            var _loc_5:* = _loc_4 < param3 ? (true) : (false);
            return _loc_5;
        }// end function

        public static function getInstance(param1:Stage) : MouseHandle {
            if (MouseHandle.Instance == null)
            {
                MouseHandle.Instance = new MouseHandle(param1, new MSITCNullClass());
            }
            return MouseHandle.Instance;
        }// end function

    }
}class MSITCNullClass {}

