package org.math {

    public class ValueFormatConver {

        public function ValueFormatConver() {
            throw new Error("This class can not be instantiated !");
        }
		
		/**
		 * 转换为带有千分号的数值字符串
		 */
        public static function thousandSeparator($number:Number, $toFixedNum:int = -1) : String {
            var $AbsNum:Number = Number($number > 0 ? ($number) : (-$number));
            var $xiaoshu:Number = $AbsNum - Math.floor($AbsNum);
            var $numStr:String = Math.floor($AbsNum).toString();
            var $strLength:int = $numStr.length;
            var $jianGe:int = 3;
			var $tmpArray:Array;
			var $tA:int, $tB:int,$zz:int;
			var $tStr:String;
            if ($strLength > $jianGe) {
				$tA = $strLength % $jianGe;
				$tB = int($strLength / $jianGe);
				$tmpArray = [];
				$tStr = $numStr.substr(0, $tA);
                if ($tStr != "") {
					$tmpArray.push($tStr);
                }
				$zz = 0;
                while ($zz < $tB) {
					$tmpArray.push($numStr.substr($tA + $zz * $jianGe, $jianGe));
					$zz = $zz + 1;
                }
				$numStr = $tmpArray.join(",");
            }
            if ($xiaoshu > 0) {
				if($toFixedNum == -1){
					$numStr = $numStr + String($xiaoshu).substr(1);
				}else{
					$numStr = $numStr + $xiaoshu.toFixed($toFixedNum).substr(1);
				}
            }
            return ($number > 0 ? ($numStr) : ("-" + $numStr));
        }// end function
		
		/**
		 * 使用 T/B/M/K 等字符缩写数值，返回字符串
		 * $toFixedNum : 保留小数点后多少位, 默认为-1表示不控制小数点位数
		 */
        public static function abbreviations($Number:Number, $toFixedNum:int = -1) : String {
			var $outNum:Number;
            var $outStr:String;
            var $absNum:Number = $Number > 0 ? ($Number) : (-$Number);
            
			if ($absNum > 999999999999) {
				$outNum = $absNum / 1000000000000;
				if($toFixedNum == -1){
					$outStr = $outNum.toString() + 'T';
				}else{
					$outStr = $outNum.toFixed($toFixedNum) + 'T';
				}			
				return ($Number > 0 ? ($outStr) : ("-" + $outStr));
			}
			
			if ($absNum > 999999999) {
				$outNum = $absNum / 1000000000;
				if($toFixedNum == -1){
					$outStr = $outNum.toString() + 'B';
				}else{
					$outStr = $outNum.toFixed($toFixedNum) + 'B';
				}			
                return ($Number > 0 ? ($outStr) : ("-" + $outStr));
            }
			
            if ($absNum > 999999) {
				$outNum = $absNum / 1000000;
				if($toFixedNum == -1){
					$outStr = $outNum.toString() + 'M';
				}else{
					$outStr = $outNum.toFixed($toFixedNum) + 'M';
				}
                return $Number > 0 ? ($outStr) : ("-" + $outStr);
            }
			
            if ($absNum > 999) {
				$outNum = $absNum / 1000;
				if($toFixedNum == -1){
					$outStr = $outNum.toString() + 'K';
				}else{
					$outStr = $outNum.toFixed($toFixedNum) + 'K';
				}
				return $Number > 0 ? ($outStr) : ("-" + $outStr);
            }
			
			$outNum = $absNum;
			if($toFixedNum == -1){
				$outStr = $outNum.toString();
			}else{
				$outStr = $outNum.toFixed($toFixedNum);
			}
            return $Number > 0 ? ($outStr) : ("- " + $outStr);
        }// end function
		
		/**
		 * 将数值转换成为特定位数的数值字符串
		 * $ws	:	将数值转换成为多少位的数值字符串(不包括小数点之后的位数)
		 * 注意	：	此函数将保留小数点之后的小数部分，请转换之前自行处理
		 * 例	:	numToStr(12, 4) -> '0012'；
		 * 			numToStr(12.345, 4) -> '0012.345'；
		 */			
        public static function numToStr($Number:Number, $ws:int = 0, $toFixedNum:int = -1) : String {
			
			var $absNum:Number = ($Number >= 0 ? $Number : -$Number);
			var $xiaoshu:Number = $absNum - Math.floor($absNum);
			var $numStr:String = Math.floor($absNum).toString();
			var $absOut:String;
			if($numStr.length < $ws){
				var $loopMax:int = $ws - $numStr.length;
				for (var i:int = 0; i < $loopMax; i++){
					$numStr = '0' + $numStr;
				}
			}
			
			if($xiaoshu > 0){
				if($toFixedNum == -1){
					$absOut = $numStr + String($xiaoshu).substr(1);
				}else{
					$absOut = $numStr + $xiaoshu.toFixed($toFixedNum).substr(1);
				}
			}else{
				$absOut = $numStr;
			}
			return ($Number >= 0 ? $absOut : '-' + $absOut);
		}
		
    }
}
