package com.command {
	public class CmdUnit {
		
		
		public function CmdUnit($alias:String,$comFun:Function,$comTarget:Object = null,$doc:String = "_no_more_info_") {
			_alias = $alias
			_com = $comFun;
			_doc = $doc;
		}
		
		private var _alias:String;
		public function get alias():String {
			return _alias;
		}
		
		private var _comTarget:Object;
		public function get comTarget ():Object {
			return _comTarget;
		}
		
		private var _doc:String;
		public function get doc():String {
			return _doc;
		}
		
		private var _com:Function;
		public function get com():Function {
			return _com;
		}
		
		
	}
}