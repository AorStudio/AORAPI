package org.template {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.basic.Aorfuns;

	public class TemplateTool {
		public function TemplateTool() {
			throw new Error("This class can not be instantiated !");
		}
		
		/**
		 * 创建一个简单的Sprite用作背景
		 */
		public static function createSimpleBackground ($width:Number = 100, $height:Number = 100, $color:uint = 0x000000, alpha:Number = 0):Sprite {
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill($color,alpha);
			bg.graphics.drawRect(0,0,$width,$height);
			bg.graphics.endFill();
			return bg;
		}
		
		/**
		 * 创建一个单色圆角的Sprite用作背景(scale9)
		 */
		public static function createRoundRectBG ($width:Number = 100, $height:Number = 100, $ellipseWidth:Number = 10, $ellipseHeight:Number = 10, $color:uint = 0x000000, alpha:Number = 0):Sprite {
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill($color,alpha);
			bg.graphics.drawRoundRect(0,0,$width,$height,$ellipseWidth,$ellipseHeight);
			bg.graphics.endFill();
			bg.scale9Grid = new Rectangle($ellipseWidth + 1, $ellipseHeight + 1, $width - ($ellipseWidth + 1) * 2, $height - ($ellipseHeight + 1) * 2 );
			return bg;
		}
		
		/**
		 * 创建一个基础容器,此容器自身不接收鼠标事件
		 */
		public static function createBaseContainer ():Sprite {
			var ct:Sprite = new Sprite();
			Aorfuns.setDOCInteractvie(ct,false,false,true,true);
			return ct;
		}
		
	}
}