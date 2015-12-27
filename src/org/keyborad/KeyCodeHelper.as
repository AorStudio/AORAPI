package org.keyborad {
	
	public class KeyCodeHelper {
		
		/**
		 * KeyCodeHelper 
		 * 目前转换内容只包括字母、数字（数字键盘不在此列）以及 部分
		 */
		public function KeyCodeHelper() {
			throw new Error("This class can not be instantiated !");
		}
		
		/**
		 * KeyCode转换成文字
		 */
		public static function KeyCodeToString ($keyCode:uint, $shift:Boolean = false):String{
			var out:String;
			for (var i:int = 0; i < KeyCodeHelper._KeyCodeLib.length; i++){
				if($keyCode == KeyCodeHelper._KeyCodeLib[i].code){
					if($shift){
						out = KeyCodeHelper._KeyCodeLib[i].shift;
					}else{
						out = KeyCodeHelper._KeyCodeLib[i].Str;
					}
					if(out == '') {
						out = KeyCodeHelper._KeyCodeLib[i].Str;
					}
					return out;
				}
			}
			return null;
		}
		/**
		 * 将字符转换成KeyCode
		 * 目前转换内容只包括字母、数字（数字键盘不在此列）以及部分符号
		 */
		public static function StringToKeyCode ($Str:String):Object{
			for (var i:int = 0; i < KeyCodeHelper._KeyCodeLib.length; i++){
				if($Str == KeyCodeHelper._KeyCodeLib[i].Str){
					return {keyCode:KeyCodeHelper._KeyCodeLib[i].code,shift:false};
				}
				if($Str == KeyCodeHelper._KeyCodeLib[i].shift){
					return {keyCode:KeyCodeHelper._KeyCodeLib[i].code,shift:true};
				}
			}
			return null;
		}
		
		//{Str:'',shift:'',code:},
		private static var _KeyCodeLib:Array = [
													//控制键
													{Str:'BackSpace',shift:'',code:8},{Str:'Tab',shift:'',code:9},{Str:'Clear',shift:'',code:12},
													{Str:'Enter',shift:'',code:13},{Str:'Shift',shift:'',code:16},{Str:'Control',shift:'',code:17},
													{Str:'Alt',shift:'',code:18},{Str:'Cape Lock',shift:'',code:20},{Str:'Esc',shift:'',code:27},
													{Str:'Spacebar',shift:'',code:32},{Str:'Page Up',shift:'',code:33},{Str:'Page Down',shift:'',code:34},
													{Str:'End',shift:'',code:35},{Str:'Home',shift:'',code:36},
													{Str:'Left Arrow',shift:'',code:37},{Str:'Up Arrow',shift:'',code:38},{Str:'Right Arrow',shift:'',code:39},{Str:'Down Arrow',shift:'',code:40},
													{Str:'Insert',shift:'',code:45},{Str:'Delete',shift:'',code:46},
													
													//数字
													{Str:'0',shift:')',code:48},{Str:'1',shift:'!',code:49},{Str:'2',shift:'@',code:50},{Str:'3',shift:'#',code:51},
													{Str:'4',shift:'$',code:52},{Str:'5',shift:'%',code:53},{Str:'6',shift:'^',code:54},{Str:'7',shift:'&',code:55},
													{Str:'8',shift:'*',code:56},{Str:'9',shift:'(',code:57},
													//字母
													{Str:'a',shift:'A',code:65},{Str:'b',shift:'B',code:66},{Str:'c',shift:'C',code:67},{Str:'d',shift:'D',code:68},
													{Str:'e',shift:'E',code:69},{Str:'f',shift:'F',code:70},{Str:'g',shift:'G',code:71},{Str:'h',shift:'H',code:72},
													{Str:'i',shift:'I',code:73},{Str:'j',shift:'J',code:74},{Str:'k',shift:'K',code:75},{Str:'l',shift:'L',code:76},
													{Str:'m',shift:'M',code:77},{Str:'n',shift:'N',code:78},{Str:'o',shift:'O',code:79},{Str:'p',shift:'P',code:80},
													{Str:'q',shift:'Q',code:81},{Str:'r',shift:'R',code:82},{Str:'s',shift:'S',code:83},{Str:'t',shift:'T',code:84},
													{Str:'u',shift:'U',code:85},{Str:'v',shift:'V',code:86},{Str:'w',shift:'W',code:87},{Str:'x',shift:'X',code:88},
													{Str:'y',shift:'Y',code:89},{Str:'z',shift:'Z',code:90},
													//数字键盘
													{Str:'0',shift:'',code:96},{Str:'1',shift:'',code:97},{Str:'2',shift:'',code:98},{Str:'3',shift:'',code:99},
													{Str:'4',shift:'',code:100},{Str:'5',shift:'',code:101},{Str:'6',shift:'',code:102},{Str:'7',shift:'',code:103},
													{Str:'8',shift:'',code:104},{Str:'9',shift:'',code:105},{Str:'*',shift:'',code:106},{Str:'+',shift:'',code:107},
													{Str:'Enter',shift:'',code:108},{Str:'-',shift:'',code:109},{Str:'.',shift:'',code:110},{Str:'/',shift:'',code:111},
													//功能键
													{Str:'F1',shift:'',code:112},{Str:'F2',shift:'',code:113},{Str:'F3',shift:'',code:114},{Str:'F4',shift:'',code:115},
													{Str:'F5',shift:'',code:116},{Str:'F6',shift:'',code:117},{Str:'F7',shift:'',code:118},{Str:'F8',shift:'',code:119},
													{Str:'F9',shift:'',code:120},{Str:'F10',shift:'',code:121},{Str:'F11',shift:'',code:122},{Str:'F12',shift:'',code:123},
													//其他
													{Str:'Num Lock',shift:'',code:144},
													//多媒体
													{Str:'Sound Up',shift:'',code:175},{Str:'Sound Down',shift:'',code:174},{Str:'Stop',shift:'',code:179},
													{Str:'Mute',shift:'',code:173},{Str:'Browser',shift:'',code:172},{Str:'Mail',shift:'',code:180},
													{Str:'Search',shift:'',code:170},{Str:'Collect',shift:'',code:171},
													//符号
													{Str:';',shift:':',code:186},{Str:'=',shift:'+',code:187},{Str:',',shift:'<',code:188},
													{Str:'-',shift:'_',code:189},{Str:'.',shift:'>',code:190},{Str:'/',shift:'?',code:191},
													{Str:'`',shift:'~',code:192},{Str:'[',shift:'{',code:219},{Str:"\\",shift:'|',code:220},
													{Str:']',shift:'}',code:221},{Str:"'",shift:'"',code:222}
												];
		
	}
}