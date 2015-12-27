package org.resize {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	//import flash.geom.PerspectiveProjection;
	//import flash.geom.Point;
	
	public class ResizeHandle {
	
		private static var _Instance:ResizeHandle;
		public static function get Instance():ResizeHandle {
			return _Instance;
		}

		private var _resizeStage:Stage;
		public function get resizeStage():Stage {
			return _resizeStage;
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
		
		/**
		 * @private
		 */
		public function ResizeHandle ($resizeStage:Stage, $minWidth:Number, $minHeight:Number, $maxWidth:Number, $maxHeight:Number,$null:RSNullClass = null) {
			// constructor code
			if ($null == null) {
				throw new Error("You cannot instantiate this class, please use the static get_Instance method.");
				return;
			}
			_resizeStage = $resizeStage;
			_minWidth = $minWidth;
			_minHeight = $minHeight;
			_maxWidth = $maxWidth;
			_maxHeight = $maxHeight;
			_resizeList = [];
			_ruleList = [];
			updateWH();
		}//end constructor
	
		/**
		 * 单件实例化[静态]
		 */
		public static function getInstance ($resizeStage:Stage, $minWidth:Number, $minHeight:Number, $maxWidth:Number = 0, $maxHeight:Number = 0 ):ResizeHandle {
			if (ResizeHandle._Instance == null) {
				ResizeHandle._Instance = new ResizeHandle($resizeStage, $minWidth, $minHeight, $maxWidth, $maxHeight, new RSNullClass());
			}//end if
			return ResizeHandle._Instance;
		}
		/**
		 * 析构方法
		 */
		public function destructor ():void {
			//
			stop();
			_ruleList = null;
			_resizeList = null;
			_resizeStage = null;
			ResizeHandle._Instance = null;
		}
		
		public function start ():void {
			_resizeStage.align = StageAlign.TOP_LEFT;
			_resizeStage.scaleMode = StageScaleMode.NO_SCALE;
			
			_resizeStage.addEventListener(Event.RESIZE, resizeHandleCore);
		}
		
		public function stop ():void {
			_resizeStage.removeEventListener(Event.RESIZE, resizeHandleCore);
		}
		
		private var _resizeList:Array;
		
		public function addResizeChild (ins:DisplayObject, parentborder:DisplayObjectContainer = null):void {
			if ('resizeHandleMothed' in ins) {
				var $type:String;
				if(parentborder == null){
					updateWH();
					$type = getRuleTypeName();
					//trace('w: ' + _w + ' ,h: ' + _h);
					Object(ins).resizeHandleMothed(_w, _h, $type);
				}else{
					$type = getRuleTypeName();
					Object(ins).resizeHandleMothed(parentborder.width, parentborder.height, $type);
				}
				_resizeList.push({tar:ins,parent:parentborder});
			}else {
				throw new Error('ResizeHandle.addResizeChild Error > Child has no "resizeHandleMothed" function can be used.');
			}
		}
		
		public function removeResizeChild (ins:DisplayObject):DisplayObject {
			var i:int;
			for (i = 0; i < _resizeList.length; i++ ) {
				if (ins === _resizeList[i].tar) {
					return _resizeList.splice(i, 1)[0].tar as DisplayObject;
				}
			}
			return null;
		}
		
		private var _ruleList:Array;
		public function addRule (ins:ResizeRule):void {
			_ruleList.push(ins);
		}
		
		public function removeRuleByName ($ruleTypeName:String):void {
			for (var i:int = 0; i < _ruleList.length; i++ ) {
				if (_ruleList[i].ruleName == $ruleTypeName) {
					_ruleList.splice(i, 1);
					return;
				}
			}
		}
		
		private var _w:Number;
		private var _h:Number;
		
		private function updateWH ():void {
			_w = (_resizeStage.stageWidth < _minWidth ? _minWidth : _resizeStage.stageWidth);
			_h = (_resizeStage.stageHeight < _minHeight ? _minHeight : _resizeStage.stageHeight);
			if (_maxWidth > 0) {
				_w = (_w > _maxWidth ? _maxWidth : _w);
			}
			if (_maxHeight > 0) {
				_h = (_h > _maxHeight ? _maxHeight : _h);
			}
			/*
			var $newPP:PerspectiveProjection = new PerspectiveProjection();
			$newPP.projectionCenter = new Point(_w * 0.5, _h * 0.5);
			_resizeStage.transform.perspectiveProjection = $newPP;
			*/
		}
		
		public function DoResize ():void {
			resizeHandleCore();
		}
		
		private function resizeHandleCore(e:Event = null):void {
			updateWH();
			
			var $type:String = getRuleTypeName();
			
			for (var i:int = 0; i < _resizeList.length; i++ ) {
				if(_resizeList[i].parent == null){
					_resizeList[i].tar.resizeHandleMothed(_w, _h, $type);
				}else{
					_resizeList[i].tar.resizeHandleMothed(_resizeList[i].parent.width, _resizeList[i].parent.height, $type);
				}
			}
		}
		
		private function getRuleTypeName ():String {
			
			for (var i:int = 0; i < _ruleList.length; i++ ) {
				if (_w <= _ruleList[i].maxWidth && _w >= _ruleList[i].minWidth && _h <= _ruleList[i].maxHeight && _h >= _ruleList[i].minHeight) {
					return _ruleList[i].ruleName;
				}
			}
			return 'default';
		}
		
	}
}class RSNullClass {}