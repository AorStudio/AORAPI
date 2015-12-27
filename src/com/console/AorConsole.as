package com.console {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.utils.Timer;
	
	import org.keyborad.KeyCodeHelper;
	import org.math.ValueFormatConver;
	import org.resize.IReszieChild;
	import org.template.SpriteTemplate;
	
	public class AorConsole extends SpriteTemplate implements IReszieChild {
		
		private var _version:String = '\tAorConsole version : 1.0 Author : Aorition';
		
		private static var Instance:AorConsole;
		
		private var _enableShortcut:Boolean;
		/**
		 * 是否启用快捷键来激活console
		 */
		public function get EnableShortcut():Boolean {
			return _enableShortcut;
		}
		public function set EnableShortcut(value:Boolean):void {
			if(value != _enableShortcut){
				_enableShortcut = value;
				if(_enableShortcut){
					enableShortcut();
				}else{
					disableShortcut();
				}
			}
		}
		
		private var _enableGesture:Boolean;
		/**
		 * 是否启用隐藏按钮来激活console
		 */
		public function get EnableGesture():Boolean {
			return _enableGesture;
		}
		public function set EnableGesture(value:Boolean):void {
			if(value != _enableGesture){
				_enableGesture = value;
				if(_enableGesture){
					enableGesture();
				}else{
					disableGesture();
				}
			}
		}
		
		private var _shortcutKeyNeedShift:Boolean = true;
		private var _shortcutKey:uint = 186 // [;键]
		/**
		 * 设置激活快捷键，默认为;键
		 */
		public function get ShortcutKey ():String {
			return KeyCodeHelper.KeyCodeToString(_shortcutKey,_shortcutKeyNeedShift);
		}
		public function set ShortcutKey (ins:String):void {
			var $obj:Object = KeyCodeHelper.StringToKeyCode(ins);
			_shortcutKey = $obj.keyCode;
			_shortcutKeyNeedShift = $obj.shift;
		}
		/**
		 * AorConsole 构造函数
		 * 注意，请不要尝试使用new关键字来实例化此类，请使用getInstance方法来获取单例示例
		 */
		public function AorConsole($Shortcut:Boolean,$GestureBtn:Boolean,$null:ACSNullClass = null) {
			name = 'AorConsole_mc';
			if ($null == null) {
				throw new Error("You cannot instantiate this class directly, please use the static getInstance method.");
				return;
			}//end fun
			_DefaultEchoStyle = new ACEchoStyle();
			_comListCache = [];
			_enableShortcut = $Shortcut;
			_enableGesture = $GestureBtn;
		}
		
		/**
		 * 单件实例化
		 * @param $Shortcut:Boolean 是否启用快捷键来激活console
		 * @param $GestureBtn:Boolean 是否启用隐藏按钮来激活console
		 */
		public static function getInstance ( $Shortcut:Boolean = false,$GestureBtn:Boolean = false):AorConsole {
			if (AorConsole.Instance == null) {
				AorConsole.Instance = new AorConsole($Shortcut,$GestureBtn, new ACSNullClass());
			}//end if
			return AorConsole.Instance;
		}//end fun
		
		public static function hasInstance ():Boolean {
			if(AorConsole.Instance){
				return true;
			}else{
				return false;
			}
		}
		
		private var _AC_width:Number = 320;
		private var _AC_height:Number = 240;
		
		public function resizeHandleMothed($w:Number=1, $h:Number=1, $type:String='default'):void {
				
				_AC_width = $w;
				_AC_height = $h;
			
				_inputBackround.y =  _AC_height - 50;
				_inputBackround.width = _AC_width;
				_inputBackround.height = 50;
			
				_echo.width = _AC_width;
				_echo.height = _inputBackround.y;
			
				_input.width = _AC_width;
				_input.height = _inputBackround.height * 0.6;
				_input.y = (_inputBackround.height - _input.height) * 0.5 + _inputBackround.y;
			
				_info.width = _AC_width * 0.2;
				_info.height = 32;
				_info.x = _AC_width - _info.width - 10;
				_info.y = 20;
				
				
				setGestureBtnPos();
		}
		/**
		 * 自定义隐藏激活按钮的位置的扩展方法
		 * 此方法要求设置3个形参：（$gb:displayObject,$consoleWidth,$consoleHeight）作为AorConsole的传值接口
		 * 如果此扩展方法为设置，则使用默认行为，即隐藏按钮将放置在console的右边中部
		 */
		public var setGestureBtnPosFunc:Function;
		private function setGestureBtnPos ():void {
			
			if(_gestureBtn){
				if(setGestureBtnPosFunc != null){
					setGestureBtnPosFunc(_gestureBtn,_AC_width,_AC_width);
				}else{
					_gestureBtn.x = _AC_width - _gestureBtn.width;
					_gestureBtn.y = (_AC_width - _gestureBtn.height) * 0.5;
				}
			}
		}
		
		private var _info:TextField;
		
		private var _echo:TextField;
		private var _inputBackround:Sprite;
		private var _input:TextField;
		private var _gestureBtn:Sprite; 
		
		private var _DefaultEchoStyle:ACEchoStyle;
		/**
		 * 定义console的显示Style
		 */
		public function get DefaultEchoStyle():ACEchoStyle {
			return _DefaultEchoStyle;
		}
		
		override protected function init ():void {
			//
			this.mouseEnabled = false;
			this.tabEnabled = false;
			
			_commandHistoryList = new Array();
			
			_inputBackround = new Sprite();
			_inputBackround.name = 'AorConsole_input_bg_mc';
			drawInputBg();
			addChild(_inputBackround);
			
			_echo = new TextField();
			_echo.name = 'AorConsole_echo_mc';
			_echo.wordWrap = true;
			_echo.multiline = true;
			_echo.selectable = false;
			_echo.mouseEnabled = false;
			addChild(_echo);
			
			_input = new TextField();
			_input.name = 'AorConsole_input_mc';
			_input.type = TextFieldType.INPUT;
			addChild(_input);
			
			_info = new TextField();
			_info.name = 'AorConsole_info_mc';
			_info.wordWrap = true;
			_info.multiline = true;
			_info.selectable = false;
			addChild(_info);
			
			//
			
			_input.addEventListener(FocusEvent.FOCUS_IN, inputFocusIn);
			_input.addEventListener(FocusEvent.FOCUS_OUT, inputFocusOut);
			
			var $textFormat:TextFormat = new TextFormat(
				DefaultEchoStyle.fontName,
				DefaultEchoStyle.size,
				DefaultEchoStyle.color,
				DefaultEchoStyle.bold,
				DefaultEchoStyle.italic,
				DefaultEchoStyle.underLine,
				null,null,
				DefaultEchoStyle.align,
				DefaultEchoStyle.leftMargin,
				DefaultEchoStyle.rightMargin
			);
			_echo.defaultTextFormat = $textFormat;
			
			var $inputTextFormat:TextFormat = new TextFormat(
				DefaultEchoStyle.fontName,
				DefaultEchoStyle.input_size,
				DefaultEchoStyle.input_color,
				DefaultEchoStyle.bold,
				DefaultEchoStyle.italic,
				DefaultEchoStyle.underLine,
				null,null,
				DefaultEchoStyle.align,
				DefaultEchoStyle.leftMargin,
				DefaultEchoStyle.rightMargin
			);
			_input.defaultTextFormat = $inputTextFormat; 
			
			var $infoTextFormat:TextFormat = new TextFormat(null,DefaultEchoStyle.info_size,DefaultEchoStyle.info_color,null,null,null,null,null,TextFormatAlign.RIGHT,10,10);
			_info.defaultTextFormat = $infoTextFormat;
			
			_echoCache = ECHO_TITLE + 'start \>\n';
			_echo.text = _echoCache;
			
			_info.text = '1 / 1';
			
			_echo.addEventListener(Event.SCROLL,EchoChangeFun);
			
			if(_enableShortcut || _enableGesture){
				hide();
			}
			
			
			
		}
		private function drawInputBg ():void {
			_inputBackround.graphics.clear();
			_inputBackround.graphics.beginFill(DefaultEchoStyle.input_bgColor,DefaultEchoStyle.input_bgAlpha);
			_inputBackround.graphics.drawRect(0,0,100,100);
			_inputBackround.graphics.endFill();
		}
		override protected function destructor ():void {
			disableGesture();
			disableShortcut();
			
			stage.removeEventListener(KeyboardEvent.KEY_UP, checkEnterFun);
			_input.removeEventListener(FocusEvent.FOCUS_IN, inputFocusIn);
			_input.removeEventListener(FocusEvent.FOCUS_OUT, inputFocusOut);
			_echo.removeEventListener(Event.SCROLL, EchoChangeFun);
			
			_commandHistoryList = null;
			
			removeChildren();
			
			_DefaultEchoStyle = null;
			_echo = null;
			_inputBackround = null;
			_input = null;
			
		}
		
		//=============== 方法 =================
		/**
		 * 清除console日志
		 */
		public function cleanEcho ():void {
			_echoCache = '';
			_echo.text = '';
		}
		/**
		 * 发布个日志内容
		 * @param ins:String	需要发布的内容
		 * @param isDispatchCommand:boolean	是否将此发布成命令事件
		 */
		public function echo (ins:String, isDispatchCommand:Boolean = false):void {
			writeEcho(ins);
			_echo.scrollV = _echo.maxScrollV;
			if(isDispatchCommand){
				dispatchCommand(ins);
			}
		}
		
		private var _comListCache:Array;
		
		/**
		 * 执行下一条指令，(此指令需要在指令实现的系列方法中自行调用以确保命令列表的运行)
		 */
		public function nextCommand ():void {
			if(_comListCache.length == 0) return;
			//
			var $currentCom:String = _comListCache.shift();
			dispatchCommand($currentCom);
		}
		
		/**
		 * 发布多条指令，并让多条指令顺序执行（需要在指令实现方法中自行调用nextCommand方法来保证下条指令的运行）
		 */
		public function dispatchCommandList ($commandData:String):void {
			if($commandData.search(/\|/g) == -1){
				dispatchCommand($commandData);
			}else{
				var $newComList:Array = $commandData.split('|');
				var i:int, length:int = $newComList.length;
				for (i = 0; i < length; i++){
					if($newComList[i] != null && $newComList[i] != ""){
						var $str:String = $newComList[i];
						_comListCache.push($str);
					}
				}
				nextCommand();
			}
		}
		
		/**
		 * 发布指令
		 */
		public function dispatchCommand ($commandData:String):void {
			
			
			//内置命令检查
			if($commandData.substr(0,2) == '::'){
				command($commandData.split(/ /g));
			}else{
				dispatchEvent(new AorConsoleEvent(AorConsoleEvent.INPUTCOMMAND,$commandData));
			}
			
		}
		/**
		 * 显示console界面
		 */
		public function show ():void {
			_input.addEventListener(FocusEvent.FOCUS_IN, inputFocusIn);
			_input.addEventListener(FocusEvent.FOCUS_OUT, inputFocusOut);
			//visible = true;
			
			_inputBackround.visible = true;
			_echo.visible = true;
			_input.visible = true;
			_info.visible = true;
			
			
			stage.focus = (_input);
			disableShortcut();
			disableGesture();
			nextCommand();
		}
		/**
		 * 隐藏console界面
		 */
		public function hide ():void {
			_input.removeEventListener(FocusEvent.FOCUS_IN, inputFocusIn);
			_input.removeEventListener(FocusEvent.FOCUS_OUT, inputFocusOut);
			stage.removeEventListener(KeyboardEvent.KEY_UP, checkEnterFun);
			//visible = false;
			
			_inputBackround.visible = false;
			_echo.visible = false;
			_input.visible = false;
			_info.visible = false;
			
			if(_enableShortcut){
				enableShortcut();
			}
			if (_enableGesture){
				enableGesture();
			}
			nextCommand();
		}
		
		//=============== 方法 ============= end
		
		private function inputFocusIn (e:FocusEvent):void {
			stage.addEventListener(KeyboardEvent.KEY_UP, checkEnterFun);
		}
		
		private function inputFocusOut (e:FocusEvent):void {
			stage.removeEventListener(KeyboardEvent.KEY_UP, checkEnterFun);
		}
		
		
		private var _echoCacheLimt:int = 10000;
		/**
		 * 缓存日志的字符数上限，默认为10000
		 */
		public function get echoCacheLimt():int {
			return _echoCacheLimt;
		}
		public function set echoCacheLimt(value:int):void {
			_echoCacheLimt = value;
		}
		
		private var _echoCache:String;
		private function writeEcho($echoText:String):void {
			_echoCache += ($echoText + '\n');
			_echoCache = limtEchoCache(_echoCache);
			_echo.text = _echoCache;
		}
		private function limtEchoCache ($ins:String):String {
			if ($ins.length > _echoCacheLimt){
				var cutLine:int = $ins.search(/\n/im);
				if(cutLine >= 0){
					$ins = $ins.substring(cutLine + 2,$ins.length);
					return limtEchoCache($ins);
				}
			}
			return $ins;
		}
		
		private var _commandHistoryList:Array;
		private var _commandHistoryListMaxNum:int = 50;
		/**
		 * 输入指令缓存条数最大值，默认为50条
		 */
		public function get commandHistoryListMaxNum():int {
			return _commandHistoryListMaxNum;
		}
		public function set commandHistoryListMaxNum(value:int):void {
			_commandHistoryListMaxNum = value;
		}
		private var _commandHistoryPoint:int = 0;
		
		private function addCHistory (ins:String):void {
			_commandHistoryList.push(ins);
			limtChistory();
		}
		private function limtChistory ():void {
			if(_commandHistoryList.length > _commandHistoryListMaxNum){
				_commandHistoryList.shift();
				limtChistory();
			}
		}
		
		private function setInputEnd ():void {
			_input.setSelection(_input.text.length,_input.text.length);
		}
		
		private function checkEnterFun (e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.UP){
				if(_commandHistoryPoint <= 0){
					return;
				}
				_commandHistoryPoint --;
				_input.text = _commandHistoryList[_commandHistoryPoint];
				setInputEnd();
				return;
			}
			if(e.keyCode == Keyboard.DOWN){
				if(_commandHistoryPoint >= (_commandHistoryList.length - 1)){
					return;
				}
				_commandHistoryPoint ++;
				_input.text = _commandHistoryList[_commandHistoryPoint];
				setInputEnd();
				return;
			}
			
			if(e.keyCode == Keyboard.ENTER){
				if(_input.text != ''){
					var $str:String = _input.text;
					//对input的清理工作
					addCHistory($str);
					_commandHistoryPoint = _commandHistoryList.length;
					_input.text = '';
					
					dispatchCommandList($str);
				}
			}
		}
		
		private function enableGesture ():void {
			_gestureBtn = new Sprite();
			_gestureBtn.name = 'AorConsole_gestureBtn_mc';
			_gestureBtn.graphics.beginFill(0x000000,0);
			_gestureBtn.graphics.drawRect(0,0,_AC_height * 0.1, _AC_height * 0.1);
			_gestureBtn.graphics.endFill();
			addChild(_gestureBtn);
			_gestureBtn.addEventListener(MouseEvent.MOUSE_DOWN,gestureDown);
			setGestureBtnPos();
		}
		
		private function disableGesture ():void {
			if(_gestureBtn){
				stage.removeEventListener(MouseEvent.MOUSE_UP,gestureUp);
				removeEventListener(Event.ENTER_FRAME, gestureLoop);
				_gestureBtn.removeEventListener(MouseEvent.MOUSE_DOWN,gestureDown);
				_gestureBtn.graphics.clear();
				removeChild(_gestureBtn);
				_gestureBtn = null;
			}
		}
		
		private var _gestureInt:int;
		private var _gestureMax:int = 100;
		
		private function gestureDown (e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP,gestureUp);
			addEventListener(Event.ENTER_FRAME, gestureLoop);
			_gestureInt = 0;
		}
		
		private function gestureUp (e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP,gestureUp);
			removeEventListener(Event.ENTER_FRAME, gestureLoop);
			_gestureInt = 0;
		}
		
		private function gestureLoop (e:Event):void {
			_gestureInt ++ ;
			if(_gestureInt >= _gestureMax){
				removeEventListener(Event.ENTER_FRAME, gestureLoop);
				//
				show();
			}
		}
		
		private function enableShortcut ():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, shortcutListen);
		}
		
		private function disableShortcut():void {
			delShorkcurKeyTimer();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, shortcutListen);
		}
		
		private var _shorkcutKeyTimer:Timer;
		private function delShorkcurKeyTimer():void {
			if(_shorkcutKeyTimer){
				_shorkcutKeyTimer.reset();
				_shorkcutKeyTimer.removeEventListener(TimerEvent.TIMER, SKTimerDo);
			}
		}
		private function createShorkcutKeyTimer (delay:int):void {
			_shorkcutKeyTimer = new Timer(delay);
			_shorkcutKeyTimer.addEventListener(TimerEvent.TIMER, SKTimerDo);
			_shorkcutKeyTimer.start();
		}
		private function SKTimerDo (e:TimerEvent):void {
			_shorkcutKeyCount = 0;
			delShorkcurKeyTimer();
		}
		private var _shorkcutKeyCount:int = 0;
		private var _shorkcutKeyActiveTime:int = 1000;
		/**
		 * 快捷键键入判定时间,(多少时间内按快捷键多少次视为快捷键触发)，默认为1秒内（1000毫秒）
		 */
		public function get ShorkcutKeyActiveTime():int {
			return _shorkcutKeyActiveTime;
		}
		public function set ShorkcutKeyActiveTime(value:int):void {
			_shorkcutKeyActiveTime = value;
		}

		private var _shorkcutKeyActiveNum:int = 3;
		/**
		 * 快捷键键入判定次数,(多少时间内按快捷键多少次视为快捷键触发)，默认为3次
		 */
		public function get ShorkcutKeyActiveNum():int {
			return _shorkcutKeyActiveNum;
		}
		public function set ShorkcutKeyActiveNum(value:int):void {
			_shorkcutKeyActiveNum = value;
		}
		
		private function shortcutListen (e:KeyboardEvent):void {
			if(e.keyCode == _shortcutKey){
				if(_shortcutKeyNeedShift == true && e.shiftKey == false ){
					return;
				}
				if(_shorkcutKeyCount > 0){
					_shorkcutKeyCount ++ ;
					if(_shorkcutKeyCount >= _shorkcutKeyActiveNum){
						_shorkcutKeyCount = 0;
						show();
					}
				}else{
					_shorkcutKeyCount ++ ;
					createShorkcutKeyTimer(_shorkcutKeyActiveTime);
				}
				
			}
		}
		
		//内置命令
		private const ECHO_TITLE:String = 'AorConsole > ';
		
		private function command (ins:Array):void {
			/*//test
			var testEcho:String;
			//'获得指令: '
			for(var i:int = 0; i < ins.length; i++){
				if(i == 0){
					testEcho = '获取指令 ：' + ins[0] + ' , 参数 [';
					
				}else{
					if(i > 1){
						testEcho += ' , ';
					}
					testEcho += ins[i];
				}
			}
			testEcho += '\n';
			echo(testEcho);
			//*/
			
			var $com:String = String(ins.shift()).slice(2);
			
			switch($com){
				case 'help':
					com_help(ins);
				break;
				case 'efg':
					com_echoCFG(ins);
				break;	
				case 'echo':
					echo(ins.join(' '));
					break;	
				case 'q':
					hide();
				break;
				case 'info':
					com_info(ins);
				break;
				case 'clear':
					cleanEcho();
				break;
				case 'shortcut':
					com_shortcut(ins);
				break;
				case 'check':
					com_check(ins);
				break;
				case 'author':
					echo("AUTHOR : AORITION , Email : aorition@qq.com , QQ: 53160231\n");
					nextCommand();
				break;
				default:
					echo(ECHO_TITLE + $com + ' ' + ins.join(' ') + ': command not found');
			}
		}
		
		private function com_help (args:Array):void {
			echo(ECHO_TITLE + 'help \\>');
			echo('no more Message ... ');
			nextCommand();
		}
		
		private function com_info_show_echoCFG ():void {
			echo('\tEchoSelectble = ' + _echo.selectable);
			echo('\tEchoMouseEnabled = ' + _echo.mouseEnabled);
			echo('\tEchoMouseWheelEnabled = ' + _echo.mouseWheelEnabled);
			echo('\tEchoMaxLineNum = ' + _echo.numLines);
			echo('\tEchoMaxChars = ' + _echo.maxChars);
			nextCommand();
		}
		
		private function com_echoCFG (args:Array):void {
			if(args.length == 0){
				echo(ECHO_TITLE +  'echoCFG \\>');
				com_info_show_echoCFG();
				echo('\\>');
				nextCommand();
				return;
			}
			var $ntf:TextFormat;
			switch(args[0]){
				case 'd':
				case 'default':
					
					_echo.border = false;
					_echo.background = false;
					
					$ntf = new TextFormat(
						DefaultEchoStyle.fontName,
						DefaultEchoStyle.size,
						DefaultEchoStyle.color,
						DefaultEchoStyle.bold,
						DefaultEchoStyle.italic,
						DefaultEchoStyle.underLine,
						null,null,
						DefaultEchoStyle.align,
						DefaultEchoStyle.leftMargin,
						DefaultEchoStyle.rightMargin
					);
					_echo.defaultTextFormat = $ntf;
					_echo.setTextFormat($ntf);
					
					_echo.selectable = false;
					_echo.mouseWheelEnabled = true;
					_echo.mouseEnabled = false;
					
					drawInputBg();
					
					echo(ECHO_TITLE +  'echoCFG \\> set echo Default');
					
					break;
				case 'f':
				case 'font':
					var $fc:uint = DefaultEchoStyle.color;
					var $fs:int = DefaultEchoStyle.size;
					var $fb:Boolean = DefaultEchoStyle.bold;
					if(args.length >= 2){
						$fc = uint(args[1]);
					}
					if(args.length >= 3){
						$fs = int(args[2]);
					}
					if(args.length >= 4){
						$fb = (String(args[3]).toLocaleLowerCase() == 'true' ? true : false);
					}
					$ntf = (new TextFormat(DefaultEchoStyle.fontName,$fs,$fc,$fb));
					_echo.defaultTextFormat = $ntf;
					_echo.setTextFormat($ntf);
					
					echo(ECHO_TITLE +  'echoCFG \\> echo.FontColor == ' + $fc + ' , FontSize == ' + $fs + ' , Bold = ' + $fb);
					break;
				case 's+':
				case 'selectable+':
					_echo.selectable = true;
					echo(ECHO_TITLE +  'echoCFG \\> echo.selectable == true');
					break;
				case 's-':
				case 'selectable-':
					_echo.selectable = false;
					echo(ECHO_TITLE +  'echoCFG \\> echo.selectable == false');
					break;
				case 'w+':
				case 'mouseWheelEnabled+':
					_echo.mouseWheelEnabled = true;
					echo(ECHO_TITLE +  'echoCFG \\> echo.mouseWheelEnabled == true');
					break;
				case 'w-':
				case 'mouseWheelEnabled-':
					_echo.mouseWheelEnabled = false;
					echo(ECHO_TITLE +  'echoCFG \\> echo.mouseWheelEnabled == false');
					break;
				case 'm+':
				case 'mouseEnabled+':
					_echo.mouseEnabled = true;
					echo(ECHO_TITLE +  'echoCFG \\> echo.mouseEnabled == true');
					break;
				case 'm-':
				case 'mouseEnabled-':
					_echo.mouseEnabled = false;
					echo(ECHO_TITLE +  'echoCFG \\> echo.mouseEnabled == false');
					break;
				case 'b+':
				case 'border+':
					_echo.border = true;
					if(args.length >= 2){
						_echo.borderColor = uint(args[1]);
					}
					echo(ECHO_TITLE +  'echoCFG \\> echo.border == true');
					break;
				case 'b-':
				case 'border-':
					_echo.border = false;
					if(args.length >= 2){
						_echo.borderColor = uint(args[1]);
					}
					echo(ECHO_TITLE +  'echoCFG \\> echo.border == false');
					break;
				case 'bg+':
				case 'background+':
					_echo.background = true;
					if(args.length >= 2){
						_echo.backgroundColor = uint(args[1]);
					}
					echo(ECHO_TITLE +  'echoCFG \\> echobackgroundr == true');
					break;
				case 'bg-':
				case 'background-':
					_echo.background = false;
					echo(ECHO_TITLE +  'echoCFG \\> echobackgroundr == false');
					break;
				default:
					//illegal option -- 0
					echo(ECHO_TITLE +  'echoCFG : illegal option ' + args[0]);
			}
			nextCommand();
		}
		
		private function com_info (args:Array):void {
			if(args.length == 0){
				echo(ECHO_TITLE + 'info \\> Base Info');
				echo(_version);
				com_info_show_player();
				echo('\\>');
				nextCommand();
				return;
			}
			switch (args[0]){
				case 'b':
				case 'base':
				case 'baseInfo':
					echo(ECHO_TITLE + 'info \\> Base Info');
					echo(_version);
					com_info_show_player();
					echo('\\>');
				break;
				case 'p':
				case 'pr':
				case 'player':
					echo(ECHO_TITLE + 'info \\> Player Info');
					com_info_show_player();
					echo('\\>');
				break;
				case 'c':
				case 'cpu':
					echo(ECHO_TITLE + 'info \\> CPU Info');
					com_info_show_cpu();
					echo('\\>');
				break;
				case 'm':
				case 'mem':
				case 'memory':
					echo(ECHO_TITLE + 'info \\> Memory Info');
					com_info_show_memory();
					echo('\\>');
				break;
				case 'd':
				case 'md':
				case 'media':
					echo(ECHO_TITLE + 'info \\> Media Info');
					com_info_show_media();
					echo('\\>');
				break;
				case 'o':
				case 'or':
				case 'other':
					echo(ECHO_TITLE + 'info \\> Other Info');
					com_info_show_other();
					echo('\\>');
				break;
				case 'a':
				case 'all':
					echo(ECHO_TITLE + 'info \\> All Info');
					echo(_version);
					com_info_show_player();
					com_info_show_cpu();
					com_info_show_memory();
					com_info_show_media();
					com_info_show_shortcut();
					com_info_show_other();
					echo('\\>');
					break;
				default:
					echo(ECHO_TITLE +  'info : illegal option ' + args[0]);
			}
			nextCommand();
		}
			private function com_info_show_player ():void{
				echo('\tPlayer Info :');
				echo('\t\tPlayerVersion = ' + Capabilities.version);
				echo('\t\tVMVerision = ' + System.vmVersion);
				echo('\t\tOS = ' + Capabilities.os);
				echo('\t\tCPUArchitecture = ' + Capabilities.cpuArchitecture);
				echo('\t\tManufacturer = ' + Capabilities.manufacturer);
				echo('\t\tPlayerType = ' + Capabilities.playerType);
				echo('\t\tIsDebugger = ' + Capabilities.isDebugger);
			}
			private function com_info_show_cpu ():void {
				echo('\tCPU Info :');
				echo('\tSupports64BitProcesses = ' + Capabilities.supports64BitProcesses);
				echo('\tSupports32BitProcesses = ' + Capabilities.supports32BitProcesses);
				echo('\tProcessCPUUsage = ' + System.processCPUUsage);
			}
			private function com_info_show_memory ():void{
				echo('\tMemory Info :');
				echo('\t\tPrivateMemory = ' + formatMemoryString(System.privateMemory));
				echo('\t\tRunTimeMemory = ' + formatMemoryString(System.freeMemory) + ' / ' + formatMemoryString(System.totalMemoryNumber));
				
			}
			private function formatMemoryString(ins:Number):String {
				var out:String;
				out = ValueFormatConver.thousandSeparator(ins / 1024) + 'KB';
				return out;
			}
			private function com_info_show_media ():void {
				echo('\tMedia Info :');
				echo('\t\tMicrophoneSupported = ' + Microphone.isSupported);
				echo('\t\tCameraSupported = ' + Camera.isSupported);
				echo('\t\tVirtualKeyboardSupported = ' + Keyboard.hasVirtualKeyboard);
				echo('\t\tTouchSupported = ' + Multitouch.supportsTouchEvents);
				echo('\t\tMP3Supported = ' + Capabilities.hasMP3);
				echo('\t\tEmbeddedVideoSupported = ' + Capabilities.hasEmbeddedVideo);
			}
			private function com_info_show_other ():void {
				echo('\tOther Info :');
				echo('\t\tIMESupported = ' + Capabilities.hasIME);
				echo('\t\tLanguage = ' + Capabilities.language);
				echo('\t\tPrintingSupported = ' + Capabilities.hasPrinting);
				echo('\t\tLocalFileReadSupported = ' + Capabilities.localFileReadDisable);
				echo('\t\tScreenDPI = ' + Capabilities.screenDPI);
				echo('\t\tIsEmbeddedInAcrobat = ' + Capabilities.isEmbeddedInAcrobat);
			}
			
		private function com_info_show_shortcut ():void {
			echo('\tEnableShortcut = ' + EnableShortcut);
			echo('\tShortcutKey = ' + ShortcutKey);
			echo('\t\tShortcutKeyActiveTime = ' + _shorkcutKeyActiveTime);
			echo('\t\tShortcutKeyActiveNum = ' + _shorkcutKeyActiveNum);
		}
		private function com_shortcut (args:Array):void {
			echo(ECHO_TITLE + 'shorkcutKey \\>');
			if(args.length == 0){
				com_info_show_shortcut();
				echo('\\>');
				nextCommand();
				return;
			}
			
			var $changeStr:String = args[0];
			if($changeStr.length != 1){
				echo('\tChange ShortcutKe Fail ! new key does not meet the requirements! :: ' + $changeStr);
				nextCommand();
				return;
			}
			
			ShortcutKey = $changeStr;
			echo('\tShortcutKey change success ! :: ' + ShortcutKey);
			nextCommand();
		}
		
		private function EchoChangeFun (e:Event):void {
			_info.text = _echo.scrollV + ' / ' + _echo.maxScrollV;
		}
		
		private function com_check (args:Array):void {
			echo(ECHO_TITLE + 'check \\>');
			if(args == null || args.length == 0){
				echo('illegal option ' );
				nextCommand();
				return;
			}
			var $checkComList:Array = String(args[0]).split(/\./g);
			var $checkTarget:Object = getCheckTarget($checkComList);
			
			if($checkTarget == null){
				
				echo('can not find check Obejct : ' + args[0]);
				
			}else{
				if(String(args[0]).search(/gt/g) != -1){
					echo(String(args[0]).replace(/gt/g,'getChildAt') + ':');
				}else{
					echo(args[0] + ':');
				}
				args.shift();
				echo(setValueToTarget($checkTarget,args));
				echo('\\>');
			}
			nextCommand();
		}
		
		private function setValueToTarget(ins:Object, parmsNameList:Array, outStr:String = ''):String {
			if(parmsNameList == null || parmsNameList.length == 0){
				if(outStr == ''){
					return ('* : ' + String(ins) + '\n');
				}
				return outStr;
			}
			var parmsName:String;
			var parmsValue:*;
			var parmRAW:String = parmsNameList.shift();
			if(parmRAW == ''){
				//指令参数为空时跳过此条指令
				return setValueToTarget(ins,parmsNameList,outStr);
			}
			if(parmRAW.search(/=/g) == -1){
				parmsName = parmRAW;
			}else{
				//var currentList:Array = parmRAW.split('=');
				//parmsName = currentList[0];
				//parmsValue = currentList[1];
				var $idx:int = parmRAW.indexOf('=');
				parmsName = parmRAW.substring(0,$idx);
				parmsValue = parmRAW.substring($idx + 1);
			}
			/*
			//屏蔽了不完整的方法执行实现，因为简单方法的调用没有实用性
			var $ckIsFun:int = parmsName.search(/\(/g);
			if($ckIsFun != -1){
				var funcAgrStr:String = parmsName.substring($ckIsFun + 1, parmsName.indexOf(')'));
				trace('funcAgrStr = ' + funcAgrStr);
				parmsName = parmsName.substring(0,$ckIsFun);
			}
			*/
			if(parmsName in ins){
				if(parmsValue){
					ins[parmsName] = parmsValueStr2Value(parmsValue, ins);
				}
				/*
				//屏蔽了不完整的方法执行实现，因为简单方法的调用没有实用性
				if($ckIsFun != -1){
					var func:Function = ins[parmsName];
					outStr += 'call > ' + parmsName + ' : ' + callFunction(func,funcAgrStr) + '\n';
				}else{*/
					if(parmsName == 'parent'){
						if(ins['parent'] == null){
							outStr += parmsName + ' = null\n'; 
						}else{
							outStr += parmsName + ' = ' + ins['parent'].name + ins['parent'] + '\n';
						}
					}else{
						outStr += parmsName + ' = ' + ((ins[parmsName] == null || ins[parmsName] == undefined) ? 'null' : ins[parmsName]) + '\n';
					}
				/*
				//屏蔽了不完整的方法执行实现，因为简单方法的调用没有实用性	
				}
				*/
			}else{
				if(parmsName == '*'){
					outStr += '* : ' + String(ins) + '\n';
				}else{
					outStr += parmsName + ' not be finded by '+ ins + '\n';
				}
			}
			return setValueToTarget(ins,parmsNameList,outStr);
		}
		/*
		//屏蔽了不完整的方法执行实现，因为简单方法的调用没有实用性	
		private function callFunction(ins:Function, argsStr:*):* {
			if(argsStr.search(/,/g) == -1){
				if(argsStr == null || argsStr == ''){
					return ins();
				}else{
					return ins(argsStr);
				}
			}else{
				var args:Array = argsStr.split(/,/g);
				switch(args.length){
					case 2:
						return ins(args[0],args[1]);
					case 3:
						return ins(args[0],args[1],args[2]);
					case 4:
						return ins(args[0],args[1],args[2],args[3]);
					case 5:
						return ins(args[0],args[1],args[2],args[3],args[4]);
					case 6:
						return ins(args[0],args[1],args[2],args[3],args[4],args[5]);
					case 7:
						return ins(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
					case 8:
						return ins(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
					case 9:
						return ins(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]);
					case 10:
						return ins(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]);
					default:
						throw new Error('call Function Error : can not support num of args : ' + args.length );
						return '';
				}
			}
		}
		*/
		private function parseValueStr($fh:Array,$num:Array,str:String, obj:Object):* {
			var cut:int, nc:int;
			cut = str.indexOf('+');
			nc = str.indexOf('-');
			if(nc > -1 && nc < cut){
				cut = nc;
			}
			nc = str.indexOf('*');
			if(nc > -1 && nc < cut){
				cut = nc;
			}
			nc = str.indexOf('/');
			if(nc > -1 && nc < cut){
				cut = nc;
			}
			nc = str.indexOf('%');
			if(nc > -1 && nc < cut){
				cut = nc;
			}
			if(cut > -1){
				//cut过程
				var $newValue:* = str.substring(0,cut);
				$num.push($newValue);
				var $newfh:* = str.substr(cut,1);
				$fh.push($newfh);
				str = str.substring(cut + 1);
				return parseValueStr($fh,$num,str,obj);
			}else{
				//计算过程
				$num.push(str);
				var $a:Number,$b:Number,$out:Number;
				for (var i:int = 0; i < $num.length; i ++){
					if(i > 0){
						if($num[i] in obj){
							$out = parmsVS2Vcore($out,obj[$num[i]],$fh[i - 1]);
						}else{
							$out = parmsVS2Vcore($out,Number($num[i]),$fh[i - 1]);
						}
					}else{
						if($num[i] in obj){
							$out = obj[$num[i]];
						}else{
							$out = Number($num[i]);
						}
					}
				}
				$fh = null;
				$num = null;
				obj = null;
				return $out;
			}
		}
		
		private function parmsVS2Vcore($a:Number,$b:Number,$fh:String):Number {
			switch ($fh){
				case '+': return $a + $b;
				case '-': return $a - $b;
				case '*': return $a * $b;
				case '/': return $a / $b;
				case '%': return $a % $b;
				default:
					return 0;
			}
		}
		
		private function parmsValueStr2Value(ins:*, obj:Object):*{
			var $strRAW:String = String(ins);
			var $strRAWLowerCase:String = $strRAW.toLocaleLowerCase();
			if($strRAW.search(/\+/g) != -1 || $strRAW.search(/\-/g) != -1 || $strRAW.search(/\*/g) != -1 || $strRAW.search(/\//g) != -1 || $strRAW.search(/\%/g) != -1){
				var $fhList:Array = [];
				var $numList:Array = [];
				return parseValueStr($fhList,$numList,ins,obj);
			}else if($strRAWLowerCase == 'true' || $strRAWLowerCase == 'false'){
				return ($strRAWLowerCase == 'true' ? true : false);
			}else{
				return ins;
			}
		}
		
		private function getCheckTarget(NameList:Array,ins:Object = null):Object {
			
			if(NameList.length == 0){
				if(ins){
					return ins;
				}
				return null;
			}
			var $currentObj:Object = ins;
			var $newObj:Object;
			var $newVal:String;
			if($currentObj == null){
				$currentObj = stage.getChildAt(0);
			}
			var $currentName:String = NameList.shift();
			if($currentName == '' || $currentName == 'this'){
				return getCheckTarget(NameList,$currentObj);
			}else if($currentName.substr(0,2) == 'gt' ){
				var $currentArgsCk:int = $currentName.search(/\(/g);
				if($currentArgsCk != -1){
					$newVal = $currentName.substring($currentName.search(/\(/g) + 1,$currentName.search(/\)/g));
				}else{
					$newVal = $currentName.substring(2);
				}
				
				try{
					$newObj = $currentObj.getChildAt(int($newVal)) as Object;
					return getCheckTarget(NameList,$newObj);
				}catch(err:Error){
					//
				}
				return null;
				
			}else if($currentName.substr(0,10) == 'getChildAt'){
				$newVal = $currentName.substring($currentName.search(/\(/g) + 1,$currentName.search(/\)/g));
				try{
					$newObj = $currentObj.getChildAt(int($newVal)) as Object;
					return getCheckTarget(NameList,$newObj);
				}catch(err:Error){
					//
				}
				return null;
			}else{
				if($currentName in $currentObj){
					$newObj = $currentObj[$currentName];
				}else{
					$newObj = $currentObj.getChildByName($currentName) as Object;
				}
				if($newObj){
					return getCheckTarget(NameList,$newObj);
				}
			}
			return null;
		}
		
	}
}class ACSNullClass {}