package com.crypto
{
	import flash.utils.ByteArray;
	
	/**
	 * Data Encryption Standard
	 *
	 * @author PowerPBK
	 * @E-mail powerpbk@163.com
	 * @version 1.0.0
	 * CreateTime 2013-8-31 下午3:21:48
	 */
	public class DES
	{
		/*create key, replacement, 
		58 digits( original number - 1), 
		lack of 8 and 8 multiples*/
		private const _pc1 :Vector.<int> = new <int>[
			56, 48, 40, 32, 24, 16,  8,
			0, 57, 49, 41, 33, 25, 17,
			9,  1, 58, 50, 42, 34, 26,
			18, 10,  2, 59, 51, 43, 35,
			62, 54, 46, 38, 30, 22, 14,
			6, 61, 53, 45, 37, 29, 21,
			13,  5, 60, 52, 44, 36, 28,
			20, 12,  4, 27, 19, 11,  3];
		
		/*create key, replacement
		48 digits
		lack of 8、17、21、24、34、37、42、55、56、57*/
		private const _pc2 :Vector.<int> = new <int>[
			13, 16, 10, 23,  0,  4,  2, 27,
			14,  5, 20,  9, 22, 18, 11,  3,
			25,  7, 15,  6, 26, 19, 12,  1,
			40, 51, 30, 36, 46, 54, 29, 39,
			50, 44, 32, 47, 43, 48, 38, 55,
			33, 52, 45, 41, 49, 35, 28, 31];
		
		//replacement, 64 digits
		private const _IP :Vector.<int> = new <int>[
			57, 49, 41, 33, 25, 17,  9, 1,
			59, 51, 43, 35, 27, 19, 11, 3,
			61, 53, 45, 37, 29, 21, 13, 5,
			63, 55, 47, 39, 31, 23, 15, 7,
			56, 48, 40, 32, 24, 16,  8, 0,
			58, 50, 42, 34, 26, 18, 10, 2,
			60, 52, 44, 36, 28, 20, 12, 4,
			62, 54, 46, 38, 30, 22, 14, 6];
		
		//replacement, 64 digits, _IP1's Inverse array(-1)
		private const _IP_1 :Vector.<int> = new <int>[
			39, 7, 47, 15, 55, 23, 63, 31,
			38, 6, 46, 14, 54, 22, 62, 30,
			37, 5, 45, 13, 53, 21, 61, 29,
			36, 4, 44, 12, 52, 20, 60, 28,
			35, 3, 43, 11, 51, 19, 59, 27,
			34, 2, 42, 10, 50, 18, 58, 26,
			33, 1, 41,  9, 49, 17, 57, 25,
			32, 0, 40,  8, 48, 16, 56, 24];
		
		//E replacement, 48 digits
		private const _E :Vector.<int> = new <int>[
			31,  0,  1,  2,  3,  4,
			3,  4,  5,  6,  7,  8,
			7,  8,  9, 10, 11, 12,
			11, 12, 13, 14, 15, 16,
			15, 16, 17, 18, 19, 20,
			19, 20, 21, 22, 23, 24,
			23, 24, 25, 26, 27, 28,
			27, 28, 29, 30, 31,  0];
		
		//P replacement, 32 digits
		private const _P :Vector.<int> = new <int>[
			15,  6, 19, 20, 28, 11, 27, 16,
			0, 14, 22, 25,  4, 17, 30,  9,
			1,  7, 23, 13, 31, 26,  2,  8,
			18, 12, 29,  5, 21, 10,  3, 24];
		
		//S box, 8 * 4 * 16
		private const _sBox :Vector.<Vector.<Vector.<int>>> = new <Vector.<Vector.<int>>>[
			new <Vector.<int>>[//s1
				new <int>[14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7],
				new <int>[ 0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8],
				new <int>[ 4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0],
				new <int>[15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13]],
			new <Vector.<int>>[//s2
				new <int>[15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10],
				new <int>[ 3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5],
				new <int>[ 0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15],
				new <int>[13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9]],
			new <Vector.<int>>[//s3
				new <int>[10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8],
				new <int>[13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1],
				new <int>[13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7],
				new <int>[ 1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12]],
			new <Vector.<int>>[//s4
				new <int>[ 7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15],
				new <int>[13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9],
				new <int>[10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4],
				new <int>[ 3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14]],
			new <Vector.<int>>[//s5
				new <int>[ 2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9],
				new <int>[14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6],
				new <int>[ 4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14],
				new <int>[11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3]],
			new <Vector.<int>>[//s6
				new <int>[12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11],
				new <int>[10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8],
				new <int>[ 9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6],
				new <int>[ 4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13]],
			new <Vector.<int>>[//s7
				new <int>[ 4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1],
				new <int>[13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6],
				new <int>[ 1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2],
				new <int>[ 6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12]],
			new <Vector.<int>>[//s8
				new <int>[13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7],
				new <int>[ 1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2],
				new <int>[ 7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8],
				new <int>[ 2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11]]];
		
		//Cyclic displacement table
		private const _rotations :Vector.<int> = new <int>[1,1,2,2,2, 2,2,2,1,2, 2,2,2,2,2, 1];
		
		//After processing key
		private var _key :Vector.<Vector.<int>>;
		
		/**
		 * The constructor
		 *  
		 * @param key original Key, the length must be eight.
		 */		
		public function DES( key :ByteArray )
		{
			if(key.length != 8)
				throw new Error("The length of KEY must be eight!");
			
			setKey(key);
		}
		
		//set key========================================================
		private function setKey( key :ByteArray ):void
		{
			var keyD64_48 :Vector.<int> = new Vector.<int>(64, true),
				index :int,
				d :int,
				i :int;
			
			_key = new Vector.<Vector.<int>>(16, true);
			
			//The 8-bit decimal key into a 64-bit binary array----------------------
			while(i < 8)
			{
				d = key[i++];
				
				index = (i << 3) - 1;
				while( d != 0 )
				{
					//To obtain the corresponding binary number, 64 digits
					keyD64_48[index--] = d & 1; 
					d >>= 1;//Decimal number in half off limits
				}
			}
			
			//To become replacement of key after _pc1 to 56 digits----------------------
			var keyD56 :Vector.<int> = new Vector.<int>(56);
			for(i = 0; i < 56; ++i)
			{
				keyD56[i] = keyD64_48[_pc1[i]];
			}
			
			//In turn through "displacement", "_pc2 replacement" to get the key---------
			for(i = 0; i < 16; ++i)
			{
				/*Using _rotations displacement of key operation, 
				the displacement of split into two sections*/
				if( _rotations[i] == 1 ){//1
					//An array of displacement to the left one
					keyD56.splice(27, 0, keyD56.shift());//The first half
					
					keyD56[56] = keyD56[28];//The second half
					keyD56.splice(28, 1);
				}else{//2
					//Array to the displacement of the two
					keyD56.splice(26, 0, keyD56.shift(), keyD56.shift());//The first half
					
					keyD56[56] = keyD56[28];//The second half
					keyD56[57] = keyD56[29];
					keyD56.splice(28, 2);
				}
				
				//To become replacement of key after _pc2 to 48 digits
				keyD64_48 = new Vector.<int>(48, true);//48 digits
				for(d = 0; d < 48; ++d)
				{
					keyD64_48[d] = keyD56[_pc2[d]];
				}
				
				//The key in order for 16 iteration process
				_key[i] = keyD64_48;
			}
		}
		
		//encrypt========================================================
		/**
		 * encrypt
		 * 
		 * @param source plaintext
		 * @return 
		 */		
		public function encrypt( source :ByteArray ):ByteArray
		{
			var ciphertext :ByteArray = new ByteArray(),
				source64 :ByteArray = new ByteArray(),
				blackA64 :Vector.<int> = new Vector.<int>(64, true),
				blackB64 :Vector.<int> = new Vector.<int>(64, true),
				black8 :Vector.<int> = new Vector.<int>(8, true),
				blackB32 :Vector.<int> = new Vector.<int>(32, true),
				blackA32 :Vector.<int>,
				n :int, len :int, index :int,
				d :int, i :int, j :int;
			
			//Extend to 64 digits----------------------------------------------
			i = source.length;//The original data length
			len = i + (n = 8 - i % 8);//new length of 64 digits
			
			source64.length = len;
			source64.writeBytes(source, 0, i);
			
			while( i++ < len)
			{
				//Insufficient use of n (the original data from 64 length difference) filled in
				source64.writeByte(n);
			}
			
			//begin encrypt----------------------------------------------
			len >>= 3;
			for(i = 0; i < len; ++i)
			{
				//The 8-bit decimal data block into a 64 - bit binary array
				for(j = 0; j < 64; ++j) blackA64[j] = 0;
				
				for(j = 0, n = i<<3; j < 8;)
				{
					d = source64[n + j++];
					
					index = (j << 3) - 1;
					while( d != 0)
					{
						//To obtain the corresponding binary number, 64 digits
						blackA64[index--] = d & 1;
						d >>= 1;//Decimal number in half off limits
					}
				}
				
				//_IP initial replacement
				for(j = 0; j < 64; ++j) 
					blackB64[j] = blackA64[_IP[j]];
				
				//Use the key and the sBox encrypted
				for(j = 0; j < 16; ++j)
				{
					blackA32 = blackB64.slice(32);//Get after the blackA64 32 digits
					for(n = 0; n < 48; ++n)
					{
						//Here blackA64 USES only 48 digits
						blackA64[n] = blackA32[_E[n]] ^ _key[j][n];
					}
					
					for(n = 0; n < 8; ++n)
					{
						d = n * 6;
						//get sbox data:[0-7][0-3][0-15]
						d = _sBox[n][(blackA64[d]<<1) + blackA64[d+5]]
							[(blackA64[d+1]<<3) + (blackA64[d+2]<<2) + (blackA64[d+3]<<1) + blackA64[d+4]];
						
						//The decimal data into a binary array
						for(index = 0; index < 8; ++index) black8[index] = 0;
						
						while(d != 0)
						{
							black8[--index] = d & 1;
							d >>= 1;//Decimal number in half off limits
						}
						
						/*Only take black8 after four in the blackB32, 
						because here d value maximum 15 (1111), so only need to take after four*/
						for(d = 0; d < 4; ++d)
						{
							blackB32[n*4+d] = black8[4+d];
						}
					}
					
					//get new 64 digits array
					for(n = 0; n < 32; ++n)
					{
						if(j == 15){
							blackB64[n] = blackB64[n] ^ blackB32[_P[n]];
							blackB64[n + 32] = blackA32[n];
						}else{
							blackB64[n + 32] = blackB64[n] ^ blackB32[_P[n]];
							blackB64[n] = blackA32[n];
						}
					}
				}
				
				/*_IP_1 inverse replacement
				and Binary to decimal, added to the ciphertext*/
				for(j = 0; j < 64;)
				{
					ciphertext.writeByte(
						(blackB64[_IP_1[j++]] << 7)
						+ (blackB64[_IP_1[j++]] << 6)
						+ (blackB64[_IP_1[j++]] << 5)
						+ (blackB64[_IP_1[j++]] << 4)
						+ (blackB64[_IP_1[j++]] << 3)
						+ (blackB64[_IP_1[j++]] << 2)
						+ (blackB64[_IP_1[j++]] << 1)
						+ blackB64[_IP_1[j++]]);
				}
			}
			
			return ciphertext;
		}
		
		//decrypt========================================================
		/**
		 * decrypt
		 *  
		 * @param source ciphertext
		 * @return 
		 */		
		public function decrypt( source :ByteArray ):ByteArray
		{
			var plaintext :ByteArray = new ByteArray(),
				blackA64 :Vector.<int> = new Vector.<int>(64, true),
				blackB64 :Vector.<int> = new Vector.<int>(64, true),
				black8 :Vector.<int> = new Vector.<int>(8, true),
				blackB32 :Vector.<int> = new Vector.<int>(32, true),
				blackA32 :Vector.<int>,
				len :int = source.length >> 3,
				n :int, index :int,
				d :int, i :int, j :int;
			
			//This is different than encrypt
			
			for(;i < len; ++i)
			{
				//The 8-bit decimal data block into a 64 - bit binary array
				for(j = 0; j < 64; ++j) blackA64[j] = 0;
				
				for(j = 0, n = i<<3; j < 8;)
				{
					d = source[n + j++];
					
					index = (j << 3) - 1;
					while( d != 0)
					{
						//To obtain the corresponding binary number, 64 digits
						blackA64[index--] = d & 1;
						d >>= 1;//Decimal number in half off limits
					}
				}
				
				//_IP initial replacement
				for(j = 0; j < 64; ++j) 
					blackB64[j] = blackA64[_IP[j]];
				
				for(j = 15; j >= 0; --j)//This is different than encrypt
				{
					blackA32 = blackB64.slice(32);//Get after the blackA64 32 digits
					for(n = 0; n < 48; ++n)
					{
						//Here blackA64 USES only 48 digits
						blackA64[n] = blackA32[_E[n]] ^ _key[j][n];
					}
					
					for(n = 0; n < 8; ++n)
					{
						d = n * 6;
						//get sbox data:[0-7][0-3][0-15]
						d = _sBox[n][(blackA64[d]<<1) + blackA64[d+5]]
							[(blackA64[d+1]<<3) + (blackA64[d+2]<<2) + (blackA64[d+3]<<1) + blackA64[d+4]];
						
						//The decimal data into a binary array
						for(index = 0; index < 8; ++index) black8[index] = 0;
						
						while(d != 0)
						{
							black8[--index] = d & 1;
							d >>= 1;//Decimal number in half off limits
						}
						
						/*Only take black8 after four in the blackB32, 
						because here d value maximum 15 (1111), so only need to take after four*/
						for(d = 0; d < 4; ++d)
						{
							blackB32[n*4+d] = black8[4+d];
						}
					}
					
					//get new 64 digits array
					for(n = 0; n < 32; ++n)
					{
						if(j == 0){//This is different than encrypt
							blackB64[n] = blackB64[n] ^ blackB32[_P[n]];
							blackB64[n + 32] = blackA32[n];
						}else{
							blackB64[n + 32] = blackB64[n] ^ blackB32[_P[n]];
							blackB64[n] = blackA32[n];
						}
					}
				}
				
				/*_IP_1 inverse replacement
				and Binary to decimal, added to the ciphertext*/
				for(j = 0; j < 64;)
				{
					plaintext.writeByte(
						(blackB64[_IP_1[j++]] << 7)
						+ (blackB64[_IP_1[j++]] << 6)
						+ (blackB64[_IP_1[j++]] << 5)
						+ (blackB64[_IP_1[j++]] << 4)
						+ (blackB64[_IP_1[j++]] << 3)
						+ (blackB64[_IP_1[j++]] << 2)
						+ (blackB64[_IP_1[j++]] << 1)
						+ blackB64[_IP_1[j++]]);
				}
			}
			
			//Reducing the length,This is different than encrypt
			plaintext.length = plaintext.length - plaintext[plaintext.length-1];
			
			return plaintext;
		}
	}
}