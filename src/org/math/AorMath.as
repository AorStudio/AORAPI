//org.math::Aormath
package org.math {
	/**
	 * ...
	 * @author Aorition
	 */
	import flash.geom.Point;
	import flash.geom.Vector3D;
	 
	public class AorMath {
		
		public function AorMath() {
			throw new Error("This class can not be instantiated !");
		}
		
		public static function angle (radians:Number):Number {
			return radians * (180 / Math.PI);
		}
		
		public static function radians (angle:Number):Number {
			return angle * (Math.PI / 180);
		}
		
		public static function random ($min:Number, $max:Number, $isInit:Boolean = false):Number {
			return ($isInit == true ? Math.round(Math.random() * ($max - $min)) + $min : Math.random() * ($max - $min) + $min );
		}
		
		public static function randomDif (tNum:Number, $min:Number, $max:Number, $isInit:Boolean = false):Number {
			var out:Number = AorMath.random($min, $max, $isInit);
			if (out == tNum) {
				return AorMath.randomDif(tNum, $min, $max, $isInit);
			}else {
				return out;
			}
		}
		
		public static function randomString (StringList:String, length:int):String {
			var tNum:Number = -1;
			var out:String = "";
			var i:int;
			for(i = 0; i < length; i++){
				tNum = randomDif(tNum,0,StringList.length - 1,true)
				out += StringList.charAt(tNum);
			}
			return out;
		}
		
		public static function getFlashAngle (rp:Point, tp:Point, is360Angle:Boolean = false) : Number {
			var out:Number = Math.PI * 0.5;
			
			if(rp != tp){
				out	= AorMath.angle(Math.atan2((tp.y - rp.y), (tp.x - rp.x)));
			}
			
			if(is360Angle){
				if(out < 0){
					return (360 - (-out));
				}
			}
			
			return out;
		}
		
		public static function getProjectionPoint (Angle:Number, distance:Number, rp:Point = null) : Point {
			if (!rp) rp = new Point();
			var $radians:Number = AorMath.radians(Angle);
			return new Point(distance * Math.cos($radians) + rp.x, distance * Math.sin($radians) + rp.y);
		}
		/**
		 * 使用XY,ZY两个角度和距离定义3D空间中的一个向量,返回该向量在3D空间中的投射位置
		 * ps:简易算法,便于理解.后期考虑使用矩阵来计算结果
		 */
		public static function getProjectinPoint3D_2Angle(XYAngle:Number,ZYAngle:Number,distance:Number,rp:Vector3D = null):Vector3D {
			if (!rp) rp = new Vector3D();
			var xyP:Point = AorMath.getProjectionPoint(XYAngle,distance);
			var zyP:Point = AorMath.getProjectionPoint(ZYAngle,distance);
			
			return new Vector3D((xyP.x + rp.x), (xyP.y + rp.y),(zyP.x + rp.z));
		}
		
		public static function shuffle (ins:Array,time:int = 1) : Array {
			var t:int, i:int, r:int = 0;
			for (t = 0; t < time; t++ ) {
				for (i = 0; i < ins.length; i++ ) {
					r = AorMath.randomDif(r, 0, ins.length - 1, true);
					var cc:* = ins[r];
					ins[r] = ins[i];
					ins[i] = cc;
				}
			}
			return ins;
		}
		
		public static function getMouse8KV(rp:Point, tp:Point, $distanceThreshold:Number = 5) : int {						
			return AorMath.get8KVByAngle(AorMath.getFlashAngle(rp, tp),Point.distance(rp, tp),$distanceThreshold);
		}
		
		/**
		 * 根据一个角度值,返回一个 8KV方位 标记 
		 * 
		 * 
		 * 位置:				7	4	8
		 * 					3	0	1
		 * 					6	2	5
		 */
		public static function get8KVByAngle ($testAngle:Number,$distance:Number = 1,$distanceThreshold:Number = 0):int {
			var $out:int = -1;
			if ($distance < $distanceThreshold) {
				$out = 0;
			} else {
				if (($testAngle >= -22.25 && $testAngle <= 0) || ($testAngle <= 22.25 && $testAngle >= 0)) {
					$out = 1;
				} else if ($testAngle > 22.25 && $testAngle < 67.25) {
					$out = 5;
				} else if ($testAngle >= 67.25 && $testAngle <= 112.25) {
					$out = 2;
				} else if ($testAngle > 112.25 && $testAngle < 157.25) {
					$out = 6;
				} else if (($testAngle >= 157.25 && $testAngle <= 180) || ($testAngle <= -157.25 && $testAngle >= -180)) {
					$out = 3;
				} else if ($testAngle > -157.25 && $testAngle < -112.25) {
					$out = 7;
				} else if ($testAngle >= -112.25 && $testAngle <= -67.25) {
					$out = 4;
				} else if ($testAngle > -67.25 && $testAngle < -22.25) {
					$out = 8;
				}
			}
			return $out;
		}
		
		/**
		 * 根据 min 和 max 值,返回一个介于min和max之间的值 (包括min,max);
		 */
		public static function Clamp (value:Number,min:Number,max:Number):Number {
			return (value < min ? min : value > max ? max : value);
		}
		
	}
}