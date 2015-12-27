package com.air.SQLite.helper {
	import flash.data.SQLStatement;
	public dynamic class SqlParameter extends Object {
		public function SqlParameter()
		{
		}
		//给SQLStatement参数赋值
		public function transParameters(SQLStatementParameters:SQLStatement):void
		{
			for (var i:String in this)
			{
				SQLStatementParameters.parameters[i] = this[i];
			}
		}
		//清除全部属性
		public function clear():void
		{
			for (var i:String in this)
			{
				delete this[i];
			}
		}
		//获取属性数量
		public function get length():uint
		{
			var len:uint = 0;
			for (var i:String in this)
			{
				len ++;
			}
			return len;
		}
	}
}