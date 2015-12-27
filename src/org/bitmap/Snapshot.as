package org.bitmap {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;

    public class Snapshot {

        public function Snapshot() {
			throw new Error("This class can not be instantiated !");
        }// end function

        public static function getSnapshot($ins:DisplayObject, $smothing:Boolean = false, $isAutoRemoveOriginal:Boolean = false) : Bitmap {
            var $parent:DisplayObjectContainer = DisplayObjectContainer($ins.parent);
            var $insIndex:int = $parent.getChildIndex($ins);
            var $btimapData:BitmapData = new BitmapData($ins.width, $ins.height, true, 0);
			$btimapData.draw($ins, null, null, null, null, $smothing);
            var $bitmap:Bitmap = new Bitmap($btimapData, "auto", $smothing);
			$bitmap.name = "Snapshot_" + $ins.name;
			$bitmap.transform.matrix = $ins.transform.matrix;
            if ($isAutoRemoveOriginal) {
				$parent.removeChild($ins);
				$parent.addChildAt($bitmap, $insIndex);
            }
            return $bitmap;
        }// end function

        public static function getStageSnapShot($stage:Stage, $smothing:Boolean = false, $isAutoRemoveOriginal:Boolean = false) : Bitmap {
            var $bitmapData:BitmapData;
            var $main:DisplayObjectContainer = DisplayObjectContainer($stage.getChildAt(0));
           
			$bitmapData = new BitmapData($stage.stageWidth, $stage.stageHeight, true, 0);
			$bitmapData.draw($main, null, null, null, null, $smothing);
			
			var $bitmap:Bitmap= new Bitmap($bitmapData, "auto", $smothing);
			
            if ($isAutoRemoveOriginal) {
				$main.removeChildren();
			}
			
			$main.addChild($bitmap);
            return $bitmap;
        }// end function

    }
}
