package test {
	
	import org.template.SpriteTemplate;
	import org.resize.IReszieChild;
	
	public class TestResizeHandle extends SpriteTemplate implements IReszieChild {
		
		
		public function TestResizeHandle() {
			// constructor code
		}
		
		override protected function init():void {
			//
		}
		
		override protected function destructor():void {
			
		}
		
		public function resizeHandleMothed ($w:Number = 1, $h:Number = 1, $type:String = 'default'):void {
			
			if ($type == 'sp') {
				width = $w * 0.5;
				height = $h * 0.5;
			}else {
				scaleX = 1;
				scaleY = 1;
			}
			
			x = ($w - width) * 0.5;
			y = ($h - height) * 0.5;
		}
	}
	
}
