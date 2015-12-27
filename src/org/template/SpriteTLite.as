package org.template {
	/**
	 * ...
	 * @author Aorition
	 */
	import flash.events.Event;
	import flash.display.Sprite;
	
	public class SpriteTLite extends Sprite {
		
		public function SpriteTLite() {
			addEventListener(Event.ADDED, ATSFun);
			addEventListener(Event.REMOVED, RFSFun);
		}
		
		private function ATSFun(e:Event):void {
			if(e.target != e.currentTarget) return;
			
			removeEventListener(Event.ADDED, ATSFun);
			//
			init();
		}
		
		private function RFSFun(e:Event):void {
			
			if(e.target != e.currentTarget) return;
			
			removeEventListener(Event.ADDED, ATSFun);
			removeEventListener(Event.REMOVED, RFSFun);
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

