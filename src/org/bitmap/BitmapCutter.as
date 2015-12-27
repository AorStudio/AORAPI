package org.bitmap {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Aorition
	 */
	public class BitmapCutter {
		
		public function BitmapCutter() {
			throw new Error("This class can not be instantiated !");
		}
		
		public static function SimpleCutting (bitmap:Bitmap, countMax:int, unitWidth:int, unitHeight:int, ivalWidth:int = 0, ivalHeight:int = 0):Array {
			var columns:int = (bitmap.bitmapData.width + ivalWidth * 1.2) / (unitWidth + ivalWidth);
			var rows:int = (bitmap.bitmapData.height + ivalHeight * 1.2) / (unitHeight + ivalHeight);
			
			var out:Array = [];
			if ((columns <= 1 && rows <= 1) || columns == 0) {
				throw new Error('BitmapCutter.SimpleCutting Error > columns = ' + columns + ',rows = ' + rows);
				return out;
			}
			
			var v:int, u:int, count:int = 0;
			for (v = 0; v < rows; v++ ) {
				for (u = 0; u < columns; u++ ) {
					count ++;
					var s:BitmapData = new BitmapData(unitWidth, unitHeight, true);
					s.copyPixels(bitmap.bitmapData, new Rectangle(u * (unitWidth + ivalWidth), v * (unitHeight + ivalHeight), unitWidth, unitHeight), new Point(0, 0));
					var ss:Bitmap = new Bitmap(s, "auto", true);
					out.push(ss);
					if (count == countMax) {
						return out;
					}
				}
			}
			return out;
		}
	}

}