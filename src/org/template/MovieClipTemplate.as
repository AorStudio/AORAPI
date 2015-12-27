package org.template {
	/**
	 * ...
	 * @author Aorition
	 */
	import flash.events.Event;
	import flash.display.MovieClip;
	 
	public class MovieClipTemplate extends MovieClip {
		
		public function MovieClipTemplate() {
			addEventListener(Event.ADDED_TO_STAGE, ATSFun);
			addEventListener(Event.REMOVED_FROM_STAGE, RFSFun);
			gotoAndStop(1);
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
			throw new Error ('MovieClipTemplate init Mothed must be override !');
		}
		
		protected function destructor ():void {
			throw new Error ('MovieClipTemplate destructor Mothed must be override !');
		}
		
	}
}