package org.bitmap {
    import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.display.BlendMode;
    import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.template.SpriteTemplate;
	
    public class Reflection extends SpriteTemplate {
        private var _disTarget:DisplayObject;
        private var _numStartFade:Number;
        private var _numMidLoc:Number;
        private var _numEndFade:Number;
        private var _numSkewX:Number;
        private var _numScale:Number;
        private var _bmpReflect:Bitmap;

        public function Reflection($disTarget:DisplayObject, $numStartFade:Number = 0.3, $numMidLoc:Number = 0.5, $numEndFade:Number = 0, $numSkewX:Number = 0, $numScale:Number = 1) {
            _disTarget = $disTarget;
            _numStartFade = $numStartFade;
            _numMidLoc = $numMidLoc;
            _numEndFade = $numEndFade;
            _numSkewX = $numSkewX;
            _numScale = $numScale;
            super();
        }// end function
		
		override protected function init ():void {
			_bmpReflect = new Bitmap(new BitmapData(1, 1, true, 0));
			addChild(_bmpReflect);
			createReflection();
		}
		
		override protected function destructor ():void {
			removeChildren();
			if(_bmpReflect){
				_bmpReflect.bitmapData.dispose();
				_bmpReflect = null;
			}
			
			_disTarget = null;
			
		}
		
        private function createReflection() : void {
            var $bitmapData:BitmapData = new BitmapData(_disTarget.width, _disTarget.height, true, 0);
            var $matrix:Matrix = new Matrix(1, 0, _numSkewX, -1 * _numScale, 0, _disTarget.height);
            var $rectangle:Rectangle = new Rectangle(0, 0, _disTarget.width, _disTarget.height * (2 - _numScale));
            var $mp:Point = $matrix.transformPoint(new Point(0, _disTarget.height));
			$matrix.tx = $mp.x * -1;
			$matrix.ty = ($mp.y - _disTarget.height) * -1;
			$bitmapData.draw(_disTarget, $matrix, null, null, $rectangle, true);
            var $shape:Shape = new Shape();
            var $matrixB:Matrix = new Matrix();
            var $arrayA:Array = new Array(_numStartFade, (_numStartFade - _numEndFade) / 2, _numEndFade);
            var $arrayB:Array = new Array(0, 255 * _numMidLoc, 255);
			$matrixB.createGradientBox(_disTarget.width, _disTarget.height, 0.5 * Math.PI);
			$shape.graphics.beginGradientFill(GradientType.LINEAR, new Array(0, 0, 0), $arrayA, $arrayB, $matrixB);
			$shape.graphics.drawRect(0, 0, _disTarget.width, _disTarget.height);
			$shape.graphics.endFill();
			$bitmapData.draw($shape, null, null, BlendMode.ALPHA);
            _bmpReflect.bitmapData.dispose();
            _bmpReflect.bitmapData = $bitmapData;
            _bmpReflect.filters = _disTarget.filters;
            x = _disTarget.x;
            y = _disTarget.y + _disTarget.height - 1;
        }// end function

    }
}
