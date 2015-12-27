package org.template {
	/**
	 * ...
	 * @author Aorition
	 */
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class MovieClipTLite extends MovieClip {
		
		public function MovieClipTLite() {
			addEventListener(Event.ADDED, ATSFun);
			addEventListener(Event.REMOVED, RFSFun);
			gotoAndStop(1);
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
			throw new Error ('MovieClipTemplate init Mothed must be override !');
		}
		
		protected function destructor ():void {
			throw new Error ('MovieClipTemplate destructor Mothed must be override !');
		}
		
	}
}
