package org.interactive.assets
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class MouseEventPlus extends MouseEvent
    {
        private var _DrawPoints:Vector.<Point>;
        private var _UseFrameNum:int;
        private var _target:Object;
        private var _point:Point;
        private var _lastPoint:Point;
        public static const PLUS_MOUSE_WHEEL:String = "plus_mouseWheel";
        public static const PLUS_MOUSE_DOWN:String = "plus_mouseDown";
        public static const PLUS_MOUSE_UP:String = "plus_mouseUp";
        public static const PLUS_MOUSE_OVER:String = "plus_mouseOver";
        public static const PLUS_MOUSE_OUT:String = "plus_mouseOut;";
        public static const PLUS_MOUSE_KEEP:String = "plus_mouseKeep";
        public static const PLUS_MOUSE_CLICK:String = "plus_mouseClick";
        public static const PLUS_MOUSE_DOUBLECLICK:String = "plus_mosueDoubleClick";
        public static const PLUS_MOUSE_SWINGING:String = "plus_mouseSwinging";
        public static const PLUS_MOUSE_ROLLOVER:String = "plus_mouseRollOver";
        public static const PLUS_MOUSE_ROLLMOVE:String = "plus_mouseRollMove";
        public static const PLUS_MOUSE_ROLLOUT:String = "plus_mouseRollOut";

        public function MouseEventPlus(param1:String, param2:Object = null, param3:Point = null, param4:Point = null, param5:Vector.<Point> = null, param6:int = 1, param7:Boolean = true, param8:Boolean = false, param9:Number = NaN, param10:Number = NaN, param11:InteractiveObject = null, param12:Boolean = false, param13:Boolean = false, param14:Boolean = false, param15:Boolean = false, param16:int = 0)
        {
            this._target = param2;
            this._point = param3;
            this._lastPoint = param4;
            this._DrawPoints = param5;
            this._UseFrameNum = param6;
            super(param1, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16);
            return;
        }// end function

        override public function get target() : Object
        {
            return this._target;
        }// end function

        public function get point() : Point
        {
            return this._point;
        }// end function

        public function get lastPoint() : Point
        {
            return this._lastPoint;
        }// end function

        public function get DrawPoints() : Vector.<Point>
        {
            return this._DrawPoints;
        }// end function

        public function get UseFrameNum() : int
        {
            return this._UseFrameNum;
        }// end function

        override public function clone() : Event
        {
            return new MouseEventPlus(type, this.target, this.point, this.lastPoint, this.DrawPoints, this.UseFrameNum, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
        }// end function

        override public function toString() : String
        {
            return formatToString("MouseEventPlus", "type", "target", "point", "lastPoint", "DrawPoints", "UseFrameNum", "bubbles", "cancelable", "localX", "localY", "relatedObject", "ctrlKey", "altKey", "shiftKey", "buttonDown", "delta");
        }// end function

    }
}
