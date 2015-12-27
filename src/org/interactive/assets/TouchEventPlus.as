package org.interactive.assets
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class TouchEventPlus extends TouchEvent
    {
        private var _point:Point;
        private var _target:Object;
        private var _dotList:Vector.<Point>;
        public static const PLUS_TOUCHBEGIN:String = "PLUS_TouchBegin";
        public static const PLUS_TOUCHMOVE:String = "PLUS_TouchMove";
        public static const PLUS_TOUCHEND:String = "PLUS_TouchEnd";

        public function TouchEventPlus(param1:String, param2:Object = null, param3:Point = null, param4:Vector.<Point> = null, param5:Boolean = true, param6:Boolean = false, param7:int = 0, param8:Boolean = false, param9:Number = NaN, param10:Number = NaN, param11:Number = NaN, param12:Number = NaN, param13:Number = NaN, param14:InteractiveObject = null, param15:Boolean = false, param16:Boolean = false, param17:Boolean = false)
        {
            this._target = param2;
            this._point = param3;
            this._dotList = param4;
            super(param1, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17);
            return;
        }// end function

        public function get point() : Point
        {
            return this._point;
        }// end function

        override public function get target() : Object
        {
            return this._target;
        }// end function

        public function get dotList() : Vector.<Point>
        {
            return this._dotList;
        }// end function

        override public function clone() : Event
        {
            return new TouchEventPlus(type, this.target, this.point, this.dotList, bubbles, cancelable, touchPointID, isPrimaryTouchPoint, localX, localY, sizeX, sizeY, pressure, relatedObject, ctrlKey, altKey, shiftKey);
        }// end function

        override public function toString() : String
        {
            return formatToString("TouchEventPlus", "type", "target", "point", "dotList", "bubbles", "cancelable", "touchPointID", "isPrimaryTouchPoint", "localX", "localY", "sizeX", "sizeY", "pressure", "relatedObject", "ctrlKey", "altKey", "shiftKey");
        }// end function

    }
}
