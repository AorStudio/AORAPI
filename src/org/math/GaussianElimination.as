package org.math {

    public class GaussianElimination {
		
		public function GaussianElimination() {
			throw new Error("This class can not be instantiated !");
		}
		/**
		 * 高斯消元法（或译：高斯消去法）（英语：Gaussian Elimination），是线性代数中的一个算法，可用来为线性方程组求解，求出矩阵的秩，以及求出可逆方阵的逆矩阵。当用于一个矩阵时，高斯消元法会产生出一个“行梯阵式”。
		 * Ax = b
		 * $xNum :  未知数个数
		 * $matrixCoefficients ： 一个二维数组，表示高斯消元矩阵A
		 * $rightHandSideVector ： 一个一维数组，表示高斯消元得数b
		 */
		public static function getGEData ($xNum:int,$matrixCoefficients:Array,$rightHandSideVector:Array):Array {
			var a:Array;
			var b:Array;
			var xx:Number, sum:Number;
			var n:int = $xNum;
			
			a = $matrixCoefficients;
			b = $rightHandSideVector;
			
			// convert to upper triangular form
			var i:int, j:int;
			for (var k:int = 0 ; k < n-1 ;k++ ){
				if ( a[k][k] > 0){
					for (i = k+1; i<n; i++){
						xx = a[i][k]/a[k][k];
						for (j = k + 1; j < n; j++) {
							a[i][j] = a[i][j] -a[k][j] * xx;
						}
						b[i] = b[i] - b[k] * xx;
					}
				}else{
					throw new Error("zero pivot found in line: " + k );
					return null;
				}
			}
			
			// back substituti n
			b[n-1]=b[n-1]/a[n-1][n-1];
			for ( i = n-2; i >= 0; i--){
				sum = b[i];
				for (j = i+1; j < n; j++)
					sum = sum - a[i][j]*b[j];
				b[i] = sum/a[i][i];
			}
			
			return b;
		}
		
    }
}
