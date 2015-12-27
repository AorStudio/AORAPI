package com.console {
	
	import flash.text.TextFormatAlign;
	
	public class ACEchoStyle {
		public function ACEchoStyle() {
		}
		
		private var _fontName:String = '_sans';
		/**
		 * console应用的字体名，默认为“_sans”
		 */
		public function get fontName():String {
			return _fontName;
		}
		public function set fontName(value:String):void {
			_fontName = value;
		}
	
		private var _align:String = TextFormatAlign.LEFT;
		/**
		 * console日志的对齐方式，默认为左对齐
		 */
		public function get align():String {
			return _align;
		}
		public function set align(value:String):void {
			_align = value;
		}
		
		private var _input_color:uint = 0xFFFFFF;
		/**
		 * 输入文字的颜色，默认为白色
		 */
		public function get input_color():uint {
			return _input_color;
		}
		public function set input_color(value:uint):void {
			_input_color = value;
		}
		
		private var _input_size:int = 12;
		/**
		 * 输入文字的大小，默认为12
		 */
		public function get input_size():int {
			return _input_size;
		}
		public function set input_size(value:int):void {
			_input_size = value;
		}
		
		
		private var _info_color:uint = 0x999999;
		/**
		 * info文字颜色，默认为浅灰色
		 */
		public function get info_color():uint {
			return _info_color;
		}
		public function set info_color(value:uint):void {
			_info_color = value;
		}
		
		private var _info_size:int = 10;
		/**
		 * info文字的大小，默认为10
		 */
		public function get info_size():int {
			return _info_size;
		}
		public function set info_size(value:int):void {
			_info_size = value;
		}
		
		private var _input_bgColor:uint = 0x000000;
		/**
		 * 输入框的背景颜色，默认为黑色
		 */
		public function get input_bgColor():uint {
			return _input_bgColor;
		}
		public function set input_bgColor(value:uint):void {
			_input_bgColor = value;
		}
		
		private var _input_bgAlpha:Number = 0.2;
		/**
		 * 输入框的背景的透明度，默认为20%；
		 */
		public function get input_bgAlpha():Number {
			return _input_bgAlpha;
		}
		public function set input_bgAlpha(value:Number):void {
			_input_bgAlpha = value;
		}
		
		private var _color:uint = 0xFFFFFF;
		/**
		 * 日志文字的颜色，默认为白色
		 */
		public function get color():uint {
			return _color;
		}
		public function set color(value:uint):void {
			_color = value;
		}
		
		private var _mouseEnabled:Boolean = false;
		/**
		 * 日志区域是否接受鼠标事件，默认为否
		 */
		public function get mouseEnabled():Boolean {
			return _mouseEnabled;
		}
		public function set mouseEnabled(value:Boolean):void {
			_mouseEnabled = value;
		}

		private var _mouseWheelEnabled:Boolean = true;
		/**
		 * 日志区域是否可以使用滚轮，默认为是（注意如果mouseEnabled为否，则该项无效）
		 */
		public function get mouseWheelEnabled():Boolean {
			return _mouseWheelEnabled;
		}
		public function set mouseWheelEnabled(value:Boolean):void {
			_mouseWheelEnabled = value;
		}
		
		private var _border:Boolean = false;
		/**
		 * 日志区域是否显示边框
		 */
		public function get border():Boolean {
			return _border;
		}
		public function set border(value:Boolean):void {
			_border = value;
		}
		
		private var _borderColor:uint = 0xFF0000;
		/**
		 * 日志区域边框颜色，默认为红色
		 */
		public function get borderColor():uint {
			return _borderColor;
		}
		public function set borderColor(value:uint):void {
			_borderColor = value;
		}
		
		private var _background:Boolean = false;
		/**
		 * 日志区域是否显示背景，默认为否
		 */
		public function get background():Boolean{
			return _background;
		}
		public function set background(value:Boolean):void {
			_background = value;
		}
		
		private var _backgroundColor:uint;
		/**
		 * 日志区域背景的颜色，默认为黑色
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
		}
		
		private var _selectable:Boolean = false;
		/**
		 * 日志区域是否可以被选中，默认为否（注意如果mouseEnabled为否，则该项无效）
		 */
		public function get selectable():Boolean {
			return _selectable;
		}
		public function set selectable(value:Boolean):void {
			_selectable = value;
		}
		
		private var _size:int = 16;
		/**
		 * 日志文字的显示大小，默认为16
		 */
		public function get size():int {
			return _size;
		}
		public function set size(value:int):void {
			_size = value;
		}
		
		private var _bold:Boolean = false;
		/**
		 * 日志文字是否是粗体，默认为否
		 */
		public function get bold():Boolean {
			return _bold;
		}
		public function set bold(value:Boolean):void {
			_bold = value;
		}
		
		private var _underLine:Boolean = false;
		/**
		 * 日志文件是否有下划线，默认为否
		 */
		public function get underLine():Boolean {
			return _underLine;
		}
		public function set underLine(value:Boolean):void {
			_underLine = value;
		}
		/**
		 * 日志文件是否是斜体，默认为否
		 */
		private var _italic:Boolean = false;
		
		public function get italic():Boolean {
			return _italic;
		}
		public function set italic(value:Boolean):void {
			_italic = value;
		}
		
		private var _leftMargin:int = 20;
		/**
		 * 日志文件左缩进，默认20
		 */
		public function get leftMargin():int {
			return _leftMargin;
		}
		public function set leftMargin(value:int):void {
			_leftMargin = value;
		}
		
		private var _rightMargin:int = 20;
		/**
		 * 日志文件右缩进，默认20
		 */
		public function get rightMargin():int {
			return _rightMargin;
		}
		public function set rightMargin(value:int):void {
			_rightMargin = value;
		}
		/**
		 * 输出本类文字信息
		 */
		public function toString ():String {
			var out:String = "fontName:" + _fontName + ",";
			out += "size:" + _size + ",";
			out += "color:" + _color.toString(16) + ",";
			out += "align:" + _align + ",";
			out += "input_color:" + _info_color.toString(16) + ',';
			out += "input_size:" + _input_size + ',';
			out += "input_bgColor:" + _input_bgColor + ',';
			out += "input_bgAlpha:" + _input_bgAlpha + ',';
			out += "info_color:" + _info_color.toString(16) + ',';
			out += "info_size:" + _info_size + ",";
			return "ACEchoStyle[" + out + "]";
		}
		
	}
}