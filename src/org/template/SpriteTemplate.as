package org.template {
	/**
	 * ...
	 * @author Aorition
	 */
	import flash.events.Event;
	import flash.display.Sprite;
	 
	public class SpriteTemplate extends Sprite {
		
		public function SpriteTemplate() {
			addEventListener(Event.ADDED_TO_STAGE, ATSFun);
			addEventListener(Event.REMOVED_FROM_STAGE, RFSFun);
		}
		
		private function ATSFun(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, ATSFun);
			//
			init();
		}
		
		private function RFSFun(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, ATSFun);
			removeEventListener(Event.REMOVED_FROM_STAGE, RFSFun);
			//
			destructor();
		}
		
		protected function init ():void {
			throw new Error ('SpriteTemplate init Mothed must be override !');
		}
		
		protected function destructor ():void {
			throw new Error ('SpriteTemplate destructor Mothed must be override !');
		}
		
	}
}