package com.debug {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import org.basic.Aorfuns;
	import org.math.ValueFormatConver;
	import org.resize.IReszieChild;
	import org.template.SpriteTemplate;
	import org.template.TemplateTool;
	
	public class TracePanel extends SpriteTemplate implements IReszieChild {
		
		
		public function TracePanel($traceData:Array = null) {
			if($traceData){
				setTraceData($traceData);
			}
			super();
		}
		
		public var resizeHandleFunc:Function;
		public function resizeHandleMothed($w:Number=1, $h:Number=1, $type:String='default'):void {
			if(resizeHandleFunc != null){
				resizeHandleFunc($w,$h,$type);
			}
		}
		
		override protected function destructor():void {
			stopTracing();
			
			removeChildren();
			
			_traceList = null;
			_closeBtn = null;
			_bg = null;
		}
		
		private var _traceList:Array;
		
		private var _bg:Sprite;
		private var _closeBtn:CloseBtn;
		override protected function init():void {
			
			_bg = TemplateTool.createRoundRectBG(100,100,10,10,0x000000,0.65);
			addChild(_bg);
			
			start();
		}
		
		private var _isTraceDataDone:Boolean = false;
		
		public function setTraceData ($data:Array):void {
			_traceList = [];
			var i:int, length:int = $data.length;
			for(i = 0; i < length; i++){
				var dataObj:Object = {};
				if($data[i] is Array){
					if($data[i].length < 3) continue;
					dataObj.label = $data[i][0]
					dataObj.obj = $data[i][1];
					dataObj.param = $data[i][2];
					_traceList.push(dataObj);
				}else if($data[i] is Object){
					dataObj.label = $data[i].label;
					dataObj.obj = $data[i].obj;
					dataObj.param = $data[i].param;
					_traceList.push(dataObj);
				}else{
					continue;
				}
				
			}
			_isTraceDataDone = true;
			
		}
		public var marginLeft:Number = 10;
		public var marginTop:Number = 10;
		public var marginRight:Number = 10;
		public var marginBottom:Number = 10;
		
		public var valueTextWidth:Number = 200;
		
		public var labeTextFormat:TextFormat;
		public var valueTextFormat:TextFormat;
		
		public function start ():void {
			if(!_isTraceDataDone) {
				Aorfuns.log("TracePanel.start Error > _isTraceDataDone = " + _isTraceDataDone);
				return;
			}
			
			var $tracerHeight:int;
			var $tracerWidth:int = 0;
			
			var i:int, length:int = _traceList.length;
			for (i = 0; i < length; i++){
				//label
				var $label:TextField = new TextField();
				$label.mouseEnabled = false;
				
				if(labeTextFormat){
					$label.defaultTextFormat = labeTextFormat;
				}else{
					$label.defaultTextFormat = new TextFormat(null,12,0xFFFFFF,true);
				}
				
				$label.text = _traceList[i].label;
				$label.width = $label.textWidth + 10;
				$label.height = $label.textHeight + 5;
				
				if(i == 0){
					$tracerHeight = $label.height;
				}
				
				$label.x = marginLeft;
				$label.y = i * ($tracerHeight + 5) + marginTop;
				
				addChild($label);
				
				//value
				var $value:TextField = new TextField();
				$value.mouseEnabled = false;
				
				if(valueTextFormat){
					$value.defaultTextFormat = valueTextFormat;
				}else{
					$value.defaultTextFormat = new TextFormat(null,12,0xFFFFFF);
				}
				
				if(_traceList[i].param == "PrivateMemory" ||
					_traceList[i].param == "RunTimeMemory" ||
					_traceList[i].param == "FPS"
				){
					_traceList[i].obj = this as Object;
				}
				
				$value.text = String(_traceList[i].obj[_traceList[i].param]);
				$value.width = valueTextWidth;
				$value.height = $label.textHeight + 5;
				
				if(i == 0 && ($value.height > $tracerHeight)){
					$tracerHeight = $value.height;
				}
				
				$value.x = $label.x + $label.width + 10;
				$value.y = i * ($tracerHeight + 5) + marginTop;
				
				addChild($value);
				
				_traceList[i].text = $value;
				
				if(($value.x + $value.width - marginLeft) > $tracerWidth){
					$tracerWidth = ($value.x + $value.width - marginLeft);
				}
				
			}
			
			//创建关闭按钮
			_closeBtn = new CloseBtn();
			_closeBtn.addEventListener(MouseEvent.CLICK,closeFunc);
			addChild(_closeBtn);
			
			//创建移动
			addEventListener(MouseEvent.MOUSE_DOWN, ms_down);
			
			
			resetPanelSize ($tracerWidth, (i * ($tracerHeight + 5)));
			
			if(!_isTracing){
				startTracing();
			}
			
		}
		
		private function ms_down (e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, ms_up);
			startDrag();
		}
		
		private function ms_up (e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, ms_up);
			stopDrag();
		}
		
		private function closeFunc (e:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_DOWN, ms_down);
			stage.removeEventListener(MouseEvent.MOUSE_UP, ms_up);
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeFunc);
			//
			parent.removeChild(this);
		}
		
		private function resetPanelSize ($w:Number,$h:Number):void {
			_bg.width = $w + marginLeft + marginRight;
			_bg.height = $h + marginTop + marginBottom;
			
			_closeBtn.scaleX = _closeBtn.scaleY = 0.3;
			_closeBtn.x = _bg.width - _closeBtn.width * 0.5;
			_closeBtn.y = _closeBtn.height * 0.5;
		}
		
		private var _isTracing:Boolean = false;
		
		public function startTracing():void {
			if(_isTracing) return;
			
			_frames = 0;
			_tfTimer = getTimer();
			
			addEventListener(Event.ENTER_FRAME, tarcingLoop);
			_isTracing = true;
		}
		
		
		public function stopTracing ():void {
			removeEventListener(Event.ENTER_FRAME, tarcingLoop);
			
			_isTracing = false;
		}
		
		
		private var _frames:int, _tfTimer:int, _diagramTimer:int, _fn:int = 10;
		public function get fn():int {
			return _fn;
		}
		public function set fn(value:int):void {
			_fn = value;
		}
		
		private function tarcingLoop(e:Event):void {
			
			//FPS get
			_frames ++;
			if(_frames >= _fn){
				_frames = 0;
				_fps = 1000 * _fn / (getTimer() - _tfTimer);
				_tfTimer = getTimer();
			}

			var i:int, length:int = _traceList.length;
			for (i = 0; i < length; i++){
				_traceList[i].text.text = String(_traceList[i].obj[_traceList[i].param]);
			}
			
		}
		
		private var _fps:Number;
		private function get FPS ():String {
			return _fps.toFixed(1) + " / " + stage.frameRate;
		}
		
		private function get PrivateMemory ():String {
			return ValueFormatConver.thousandSeparator(System.privateMemory / 1024) + 'KB'
		}
		
		private function get RunTimeMemory ():String {
			return ValueFormatConver.thousandSeparator(System.freeMemory / 1024) + 'KB' + " / " + ValueFormatConver.thousandSeparator(System.totalMemoryNumber / 1024) + 'KB';
		}
		
	}
}

import flash.display.Sprite;
import flash.events.MouseEvent;

import org.basic.Aorfuns;
import org.template.SpriteTemplate;

class CloseBtn extends SpriteTemplate {
	
	private var _n:Sprite;
	private var _o:Sprite;
	private var _c:Sprite;
	
	public function CloseBtn () {
		super();
	}
	
	override protected function destructor():void {
		
		removeEventListener(MouseEvent.MOUSE_DOWN, downFunc);
		removeEventListener(MouseEvent.MOUSE_UP, upFunc);
		removeEventListener(MouseEvent.MOUSE_OVER, overFunc);
		removeEventListener(MouseEvent.MOUSE_OUT, outFunc);
		removeEventListener(MouseEvent.ROLL_OUT, outFunc);
		
		removeChildren();
		
		_n = null;
		_o = null;
		_c = null;
	}
	
	override protected function init():void {
		
		buttonMode = true;
		Aorfuns.setDOCInteractvie(this,true,true);
		
		_n = new Sprite();
		_n.graphics.lineStyle(2,0xFFFFFF,0);
		_n.graphics.beginFill(0xFFFFFF,0);
		_n.graphics.drawCircle(0,0,25);
		_n.graphics.endFill();
		_n.graphics.lineStyle(3,0xFFFFFF,1);
		_n.graphics.moveTo(-16,-16);
		_n.graphics.lineTo(16,16);
		_n.graphics.moveTo(-16,16);
		_n.graphics.lineTo(16,-16);
		addChild(_n);
		
		_o = new Sprite();
		_o.graphics.lineStyle(2,0xFFFFFF,0);
		_o.graphics.beginFill(0xFFFFFF,0);
		_o.graphics.drawCircle(0,0,27);
		_o.graphics.endFill();
		_o.graphics.lineStyle(3,0xFFFFFF,1);
		_o.graphics.moveTo(-17,-17);
		_o.graphics.lineTo(17,17);
		_o.graphics.moveTo(-17,17);
		_o.graphics.lineTo(17,-17);
		addChild(_o);
		_o.visible = false;
		
		_c = new Sprite();
		_c.graphics.lineStyle(2,0xFFFFFF,0);
		_c.graphics.beginFill(0xFFFFFF,0);
		_c.graphics.drawCircle(0,0,23);
		_c.graphics.endFill();
		_c.graphics.lineStyle(3,0xFFFFFF,1);
		_c.graphics.moveTo(-14,-14);
		_c.graphics.lineTo(14,14);
		_c.graphics.moveTo(-14,14);
		_c.graphics.lineTo(14,-14);
		addChild(_c);
		_c.visible = false;
		
		addEventListener(MouseEvent.MOUSE_DOWN, downFunc);
		addEventListener(MouseEvent.MOUSE_UP, upFunc);
		addEventListener(MouseEvent.MOUSE_OVER, overFunc);
		addEventListener(MouseEvent.MOUSE_OUT, outFunc);
		addEventListener(MouseEvent.ROLL_OUT, outFunc);
	}
	
	private function downFunc (e:MouseEvent):void {
		_n.visible = false;
		_o.visible = false;
		_c.visible = true;
	}
	
	private function upFunc (e:MouseEvent):void {
		_n.visible = true;
		_o.visible = false;
		_c.visible = false;
	}
	
	private function overFunc (e:MouseEvent):void {
		_n.visible = false;
		_o.visible = true;
		_c.visible = false;
	}
	
	private function outFunc (e:MouseEvent):void {
		_n.visible = true;
		_o.visible = false;
		_c.visible = false;
	}
	
}
