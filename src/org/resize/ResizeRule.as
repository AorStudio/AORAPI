package org.resize {
	/**
	 * ...
	 * @author Aorition
	 */
	public class ResizeRule {
		private var _ruleName:String;
		public function get ruleName():String {
			return _ruleName;
		}
		public function set ruleName(value:String):void {
			_ruleName = value;
		}
		
		private var _minWidth:Number;
		public function get minWidth():Number {
			return _minWidth;
		}
		public function set minWidth(value:Number):void {
			_minWidth = value;
		}
		
		private var _minHeight:Number;
		public function get minHeight():Number {
			return _minHeight;
		}
		public function set minHeight(value:Number):void {
			_minHeight = value;
		}
		
		private var _maxWidth:Number;
		public function get maxWidth():Number {
			return _maxWidth;
		}
		public function set maxWidth(value:Number):void {
			_maxWidth = value;
		}
		
		private var _maxHeight:Number;
		public function get maxHeight():Number {
			return _maxHeight;
		}
		public function set maxHeight(value:Number):void {
			_maxHeight = value;
		}
		
		public function ResizeRule($ruleName:String, $minWidth:Number, $minHeight:Number, $maxWidth:Number = 0, $maxHeight:Number = 0){
			_ruleName = $ruleName;
			_minWidth = $minWidth;
			_minHeight = $minHeight;
			_maxWidth = $maxWidth;
			_maxHeight = $maxHeight;
		}
		
	}

}