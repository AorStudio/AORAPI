package org.graphics {
    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class AorDraw {
		
		public function AorDraw() {
			throw new Error("This class can not be instantiated !");
		}
		
		/**
		 * 画虚线
		 */
        public static function drawDottedLine($ins:Graphics, $moveTo:Point, $lineTo:Point, $lineLength:Number = 5, $interval:Number = 5, $thickness:Number = 1, $color:uint = 0, $alpha:Number = 1, $pixelHinting:Boolean = false, $scaleMode:String = "normal") : void {
            var $tA:Point;
            var $tB:Point;
			$ins.lineStyle($thickness, $color, $alpha, $pixelHinting, $scaleMode);
            var $distance:Number = Point.distance($moveTo, $lineTo);
            var $tmpNum:Number = 0;
            while ($tmpNum < $distance)
            {
                
				$tA = Point.interpolate($lineTo, $moveTo, $tmpNum / $distance);
				$tmpNum = $tmpNum + $lineLength;
                if ($tmpNum > $distance)
                {
					$tmpNum = $distance;
                }
				$tB = Point.interpolate($lineTo, $moveTo, $tmpNum / $distance);
				$ins.moveTo($tA.x, $tA.y);
				$ins.lineTo($tB.x, $tB.y);
				$tmpNum = $tmpNum + $interval;
            }
            return;
        }// end function
		
		/**
		 * 画 圆弧
		 */
        public static function drawArc($ins:Graphics, $x:Number, $y:Number, $distance:Number, $startAngle:Number, $endAngle:Number, $thickness:Number = 1, $color:uint = 0, $alpha:Number = 1, $pixelHinting:Boolean = false, $scaleMode:String = "normal") : void {
            
			var $dx:Number,$dy:Number;
			$ins.lineStyle($thickness, $color, $alpha, $pixelHinting, $scaleMode);
            var $zz:Number = $startAngle;
            while ($zz <= $endAngle) {
                
				$dx = $distance * Math.cos((-$zz) * Math.PI / 180) + $x;
				$dy = $distance * Math.sin((-$zz) * Math.PI / 180) + $y;
                if ($zz == $startAngle) {
					$ins.moveTo($dx, $dy);
                }
				$ins.lineTo($dx, $dy);
				$zz = $zz + 1;
            }
        }// end function
		
		/**
		 * 绘制 不规则线条的弧线
		 */
        public static function drawUndirectArc($ins:Graphics, $x:Number, $y:Number, $distance:Number, $startAngle:Number, $endAngle:Number, $swingLength:Number = 2, $swingWidth:Number = 2, $thickness:Number = 1, $color:uint = 0, $alpha:Number = 1, $pixelHinting:Boolean = false, $scaleMode:String = "normal") : void {
            
			var $txA:Number,$yA:Number,$txB:Number,$tyB:Number,$txC:Number,$tyC:Number,$xD:Number,$yD:Number;
			$ins.lineStyle($thickness, $color, $alpha, $pixelHinting, $scaleMode);
            var $zz_sub:Number = 0;
            var $zz:Number = $startAngle;
            while ($zz <= $endAngle) {
                
				$txA = $distance * Math.cos((-$zz) * Math.PI / 180) + $x;
				$yA = $distance * Math.sin((-$zz) * Math.PI / 180) + $y;
                if ($zz == $startAngle) {
					$ins.moveTo($txA, $yA);
                }
				$zz_sub = $zz_sub + 1;
                if ($zz_sub >= $swingLength) {
					$txB = Math.random() > 0.5 ? (Math.random() * $swingWidth) : (-Math.random() * $swingWidth);
					$tyB = Math.random() > 0.5 ? (Math.random() * $swingWidth) : (-Math.random() * $swingWidth);
					$txC = $txA + $txB;
					$tyC = $yA + $tyB;
					$ins.lineTo($txC, $tyC);
					$zz_sub = 0;
                }
				$zz = $zz + 1;
            }
			$xD = $distance * Math.cos((-$endAngle) * Math.PI / 180) + $x;
			$yD = $distance * Math.sin((-$endAngle) * Math.PI / 180) + $y;
			$ins.lineTo($xD, $yD);
            
        }// end function
		
		
		/**
		 * 绘制 不规则线条的圆形
		 */
        public static function drawUndirectCircle($ins:Graphics, $x:Number, $y:Number, $distance:Number, $swingLength:Number = 2, $swingWidth:Number = 2, $thickness:Number = 1, $color:uint = 0, $alpha:Number = 1, $pixelHinting:Boolean = false, $scaleMode:String = "normal") : void {
            AorDraw.drawUndirectArc($ins, $x, $y, $distance, 0, 360, $swingLength, $swingWidth, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
        }// end function
		
		/**
		 * 绘制 虚线圆形
		 */
        public static function drawDottedCircle($ins:Graphics, $x:Number, $y:Number, $distance:Number, $lineLength:Number = 5, $interval:Number = 5, $thickness:Number = 1, $color:uint = 0, $alpha:Number = 1, $pixelHinting:Boolean = false, $scaleMode:String = "normal") : void {
            var $cA:Number;
            var $cB:Number;
            
            var $tA:Number = 0;
            var $tB:Number = 0;
			
			var $zz:Number = 0;
            while ($zz < 360) {
                
                if ( $tA == 0 && $tB == 0) {
					$cA = $zz;
					$tA = $tA + 1;
                }else {
					$tA = $tA + 1;
                }
                
                if ($tA > $lineLength && $tB == 0) {
					$cB = $zz;
                    AorDraw.drawArc($ins, $x, $y, $distance, $cA, $cB, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
					$tB = $tB + 1;
                } else if ($tA > $lineLength) {
                    if ($tB >= $interval) {
						$tA = 0;
						$tB = 0;
                    } else {
						$tB = $tB + 1;
                    }
                }
				$zz = $zz + 1;
            }
           
        }// end function

		/**
		 * 绘制 虚线矩形
		 */
        public static function drawDottedRect($ins:Graphics,$rectangle:Rectangle, $lineLength:Number = 5, $interval:Number = 5, $thickness:Number = 1, $color:uint = 0, $alpha:Number = 1, $pixelHinting:Boolean = false, $scaleMode:String = "normal") : void {
            AorDraw.drawDottedLine($ins, $rectangle.topLeft, new Point($rectangle.right,$rectangle.y), $lineLength, $interval, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
            AorDraw.drawDottedLine($ins, new Point($rectangle.right,$rectangle.y), $rectangle.bottomRight, $lineLength, $interval, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
            AorDraw.drawDottedLine($ins, $rectangle.bottomRight, new Point($rectangle.x,$rectangle.bottom), $lineLength, $interval, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
            AorDraw.drawDottedLine($ins, new Point($rectangle.x,$rectangle.bottom), $rectangle.topLeft, $lineLength, $interval, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
        }// end function
		
		/**
		 * 绘制 不规则线条
		 */
        public static function drawUndirectLine($ins:Graphics, $moveTo:Point, $lineTo:Point, $swingLength:Number = 2, $swingWidth:Number = 2, $thickness:Number = 1, $color:uint = 0, $alpha:Number = 1, $pixelHinting:Boolean = false, $scaleMode:String = "normal") : void {
            var $tp:Point;
			$ins.lineStyle($thickness, $color, $alpha, $pixelHinting, $scaleMode);
            var $distance:Number = Point.distance($moveTo, $lineTo);
            var $zz:Number = 0;
            while ($zz < $distance) {
                
				$tp = Point.interpolate($lineTo, $moveTo, $zz / $distance);
                if ($zz == 0) {
					$ins.moveTo($tp.x, $tp.y);
                }else{
					$tp.x = $tp.x + (Math.random() > 0.5 ? (Math.random() * $swingWidth) : (-Math.random() * $swingWidth));
					$tp.y = $tp.y + (Math.random() > 0.5 ? (Math.random() * $swingWidth) : (-Math.random() * $swingWidth));
					$ins.lineTo($tp.x, $tp.y);
                }
				$zz = $zz + $swingLength;
            }
			$ins.lineTo($lineTo.x, $lineTo.y);
            return;
        }// end function
		
		/**
		 * 绘制 不规则线条 矩形
		 */
		public static function drawUndirectRect($ins:Graphics,$rectangle:Rectangle, $swingLength:Number = 2, $swingWidth:Number = 2, $thickness:Number = 1, $color:uint = 0, $alpha:Number = 1, $pixelHinting:Boolean = false, $scaleMode:String = "normal") : void {
			AorDraw.drawUndirectLine($ins, $rectangle.topLeft, new Point($rectangle.right,$rectangle.y), $swingLength, $swingWidth, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
			AorDraw.drawUndirectLine($ins, new Point($rectangle.right,$rectangle.y), $rectangle.bottomRight, $swingLength, $swingWidth, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
			AorDraw.drawUndirectLine($ins, $rectangle.bottomRight, new Point($rectangle.x,$rectangle.bottom), $swingLength, $swingWidth, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
			AorDraw.drawUndirectLine($ins, new Point($rectangle.x,$rectangle.bottom), $rectangle.topLeft, $swingLength, $swingWidth, $thickness, $color, $alpha, $pixelHinting, $scaleMode);
		}// end function
		
    }
}
