package test {
	
	import org.basic.Aorfuns;
	import org.template.SpriteTemplate;
	
	//import flash.display.Sprite;
	
	import com.licensing.LicensingBuilder;
	import com.licensing.LicensingManager;
	
	public class AORAPITest extends SpriteTemplate {
		
		
		public function AORAPITest() {
			// constructor code
			super();
		}
		
		override protected function init():void {
			//
			//Aorfuns.setDefault(this, "high", '这个是个测试!!!',true);
			//LicensingBuilder.buildLincenFile("test.ttt","cy14","2015-07-01","2015-07-12");
			
			LicensingManager.init("test.ttt","cy14",function():void {trace("success !!")},function():void {trace("eeeeee")});
			
			trace(LicensingManager.getLessTime());
			
		}
		override protected function destructor():void {
			//
		}
		
	}
	
}
