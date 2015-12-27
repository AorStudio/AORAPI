package org.font {
    import flash.text.Font;
    import flash.text.FontType;

    public class FontsHandle {
        private var _deviceFontList:Vector.<Font>;
        private var _embedFontList:Vector.<Font>;
        private var _embedCFFFontList:Vector.<Font>;
        private static var Instance:FontsHandle;

        public function FontsHandle($null:FTHLDNullClass = null) {
            if ($null == null) {
                throw new Error("You cannot instantiate this class directly, please use the static getInstance method.");
            }
            updateFontList();
        }// end function

        public function get deviceFontList() : Vector.<Font> {
            return _deviceFontList;
        }// end function

        public function get embedFontList() : Vector.<Font> {
            return _embedFontList;
        }// end function

        public function get embedCFFFontList() : Vector.<Font> {
            return _embedCFFFontList;
        }// end function

        public function registeringFontClass($fontClass:Class, $updateList:Boolean = true) : void {
            Font.registerFont($fontClass);
            if ($updateList) {
                updateFontList();
            }
        }// end function

        public function checkFontInDevice($fontName:String) : Boolean {
            for (var i:int = 0; i < _deviceFontList.length; i++) {
                if (_deviceFontList[i].fontName == $fontName) {
                    return true;
                }
            }
            return false;
        }// end function

        public function checkFontInEmbed($fontName:String) : Boolean {
            for (var i:int = 0; i < _embedFontList.length; i++) {
                if (_embedFontList[i].fontName == $fontName) {
                    return true;
                }
            }
            return false;
        }// end function

        public function checkFontInEmbedCFF($fontName:String) : Boolean {
            for (var i:int = 0; i < _embedCFFFontList.length; i++) {
                if (_embedCFFFontList[i].fontName == $fontName) {
                    return true;
                }
            }
            return false;
        }// end function

        public function FontListToString() : String {
            var $outStr:String = "FontsHandle.FontListMessage >>\n";
			$outStr = $outStr + "Device <";
            var i:int;
            for (i = 0; i < _deviceFontList.length; i++) {
                if (i > 0){
					$outStr = $outStr + ",";
                }
				$outStr = $outStr + ("[" + _deviceFontList[i].fontName + "]");
            }
			$outStr = $outStr + ">\nEmbed <";
            
            for (i = 0; i < _embedFontList.length; i++) {
                
                if (i > 0) {
					$outStr = $outStr + ",";
                }
				$outStr = $outStr + ("[" + _embedFontList[i].fontName + "]");
				
            }
			$outStr = $outStr + ">\nEmbedCFF <";
            
            for (i = 0; i < _embedCFFFontList.length; i++) {
                
                if (i > 0) {
					$outStr = $outStr + ",";
                }
				$outStr = $outStr + ("[" + _embedCFFFontList[i].fontName + "]");
            }
			$outStr = $outStr + ">\n";
            return $outStr;
        }// end function

        public function destructor() : void {
            _deviceFontList = null;
            _embedFontList = null;
            _embedCFFFontList = null;
        }// end function

        private function updateFontList() : void {
            var $tmpFont:Font;
            var $returnList:Array = Font.enumerateFonts(true);
            _deviceFontList = new Vector.<Font>;
            _embedFontList = new Vector.<Font>;
            _embedCFFFontList = new Vector.<Font>;
            while ($returnList.length > 0) {
                
				$tmpFont = $returnList.pop() as Font;
                switch($tmpFont.fontType) {
                    case FontType.DEVICE:
                        this._deviceFontList.push($tmpFont);
                        break;
                    case FontType.EMBEDDED:
                        this._embedFontList.push($tmpFont);
                        break;
                    case FontType.EMBEDDED_CFF:
                        this._embedCFFFontList.push($tmpFont);
                        break;
                    default:
                        throw new Error("FontsHandle.updateFontList Error > FontType Unknown : " + $tmpFont.fontType + " .");
                }
            }
			$returnList = null;
        }// end function

        public static function getInstance() : FontsHandle {
            if (FontsHandle.Instance == null)
            {
                FontsHandle.Instance = new FontsHandle(new FTHLDNullClass());
            }
            return FontsHandle.Instance;
        }// end function

    }
}class FTHLDNullClass {}

