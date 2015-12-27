package org.interactive
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;
    import org.interactive.assets.*;

    public class TouchHandle extends EventDispatcher implements InteractiveBase
    {
        private var _stageInstance:Stage;
        private var _touchDotCounts:int = 0;
        private var _touchDotCache:Object;
        private static var Instance:TouchHandle;

        public function TouchHandle(param1:Stage, param2:TSITCNullClass = null)
        {
            if (param2 == null)
            {
                throw new Error("You cannot instantiate this class directly, please use the static getInstance method.");
            }
            this._stageInstance = param1;
            this._touchDotCache = new Object();
            return;
        }// end function

        public function startListen(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
        {
            this.stopListen();
            this._stageInstance.addEventListener(TouchEvent.TOUCH_BEGIN, this.tcDown);
            this._stageInstance.addEventListener(TouchEvent.TOUCH_MOVE, this.tcMove);
            this._stageInstance.addEventListener(TouchEvent.TOUCH_END, this.tcEnd);
            return;
        }// end function

        public function stopListen(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
        {
            this._stageInstance.removeEventListener(TouchEvent.TOUCH_BEGIN, this.tcDown);
            this._stageInstance.removeEventListener(TouchEvent.TOUCH_MOVE, this.tcMove);
            this._stageInstance.removeEventListener(TouchEvent.TOUCH_END, this.tcEnd);
            return;
        }// end function

        public function destructor() : void
        {
            this.stopListen();
            this._stageInstance = null;
            this._touchDotCache = null;
            return;
        }// end function

        private function tcDown(event:TouchEvent) : void
        {
            if (this._touchDotCounts == Multitouch.maxTouchPoints)
            {
                return;
            }
            var _loc_3:* = this;
            var _loc_4:* = this._touchDotCounts + 1;
            _loc_3._touchDotCounts = _loc_4;
            this._touchDotCache[event.touchPointID] = new Vector.<Point>;
            var _loc_2:* = new Point(event.stageX, event.stageY);
            this._touchDotCache[event.touchPointID].push(_loc_2);
            this._stageInstance.dispatchEvent(new TouchEventPlus(TouchEventPlus.PLUS_TOUCHBEGIN, event.target, _loc_2, null, event.bubbles, event.cancelable, event.touchPointID, event.isPrimaryTouchPoint, event.localX, event.localY, event.sizeX, event.sizeY, event.pressure, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey));
            return;
        }// end function

        private function tcMove(event:TouchEvent) : void
        {
            var _loc_2:* = new Point(event.stageX, event.stageY);
            this._touchDotCache[event.touchPointID].push(_loc_2);
            this._stageInstance.dispatchEvent(new TouchEventPlus(TouchEventPlus.PLUS_TOUCHMOVE, event.target, _loc_2, null, event.bubbles, event.cancelable, event.touchPointID, event.isPrimaryTouchPoint, event.localX, event.localY, event.sizeX, event.sizeY, event.pressure, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey));
            return;
        }// end function

        private function tcEnd(event:TouchEvent) : void
        {
            var _loc_2:* = new Point(event.stageX, event.stageY);
            this._touchDotCache[event.touchPointID].push(_loc_2);
            this._stageInstance.dispatchEvent(new TouchEventPlus(TouchEventPlus.PLUS_TOUCHEND, event.target, _loc_2, this._touchDotCache[event.touchPointID], event.bubbles, event.cancelable, event.touchPointID, event.isPrimaryTouchPoint, event.localX, event.localY, event.sizeX, event.sizeY, event.pressure, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey));
            var _loc_3:* = this;
            var _loc_4:* = this._touchDotCounts - 1;
            _loc_3._touchDotCounts = _loc_4;
            delete this._touchDotCache[event.touchPointID];
            return;
        }// end function

        public static function getInstance(param1:Stage) : TouchHandle
        {
            if (TouchHandle.Instance == null)
            {
                TouchHandle.Instance = new TouchHandle(param1, new TSITCNullClass());
            }
            return TouchHandle.Instance;
        }// end function

    }
}

import flash.display.*;

import flash.events.*;

import flash.geom.*;

import flash.ui.*;

import org.interactive.assets.*;

class TSITCNullClass extends Object
{

    function TSITCNullClass()
    {
        return;
    }// end function

}

