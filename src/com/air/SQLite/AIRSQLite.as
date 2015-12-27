package com.air.SQLite {
	import com.air.SQLite.helper.SqlParameter;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	
	import org.basic.Aorfuns;
	
	public class AIRSQLite {
		
		/** 单件实例 */
		private static var Instance:AIRSQLite;
		
		/**
		 * @private
		 */
		public function AIRSQLite ($null:ASLCNullClass = null) {
			// constructor code
			if ($null == null) {
				throw new Error("You cannot instantiate this class, please use the static getInstance method.");
				return;
			}//end fun
			_localSQLServer = new SQLConnection();
		}//end constructor
		
		/**
		 * 单件实例化[静态]
		 */
		public static function getInstance ():AIRSQLite {
			if (AIRSQLite.Instance == null) {
				AIRSQLite.Instance = new AIRSQLite(new ASLCNullClass());
			}//end if
			return AIRSQLite.Instance;
		}//end fun
		/**
		 * 析构方法
		 */
		public function destructor ():void {
			//
			if(_localSQLServer){
				if(_localSQLServer.connected){
					_localSQLServer.close();
				}
				_localSQLServer = null;
			}
			
			AIRSQLite.Instance = null;
		}//end fun
		
		// 数据库连接字串
		public var _localSQLServer:SQLConnection;
		
		// 连接数据库
		public function setLocalSQLServer(dbURL:String, $RWLOCEnu:int = 0):Boolean {
			try {
				var dbFile:File = File.applicationDirectory.resolvePath(dbURL);
				if(_localSQLServer.connected) {
					return true;
				}
				if(dbFile.exists){
					_localSQLServer.open(dbFile, SQLMode.UPDATE);
				}else{
					_localSQLServer.open(dbFile);
				}
			} catch(error:Error) {
				return false;
			}
			return true;
		}
		
		//-----------------------
		
		
		/**
		 * 执行SQL语句，返回影响的记录数
		 */
		public function executeSql(sqlString:String, cmdParams:SqlParameter):int {
			var result:SQLResult = querySQL(sqlString, cmdParams);
			return result.rowsAffected;
		}
		
		/**
		 * 执行SQL语句，返回结果数组
		 */
		public function query(sqlString:String, cmdParams:SqlParameter):Array {
			var result:SQLResult = querySQL(sqlString, cmdParams);
			return result.data;
		}
		
		/**
		 * 执行SQL语句，返回结果
		 */
		public function querySQL(sqlString:String, cmdParams:SqlParameter):SQLResult {
			var sqlstatement:SQLStatement = new SQLStatement();
			sqlstatement.sqlConnection = _localSQLServer;
			sqlstatement.text = sqlString;
			try{
				if(cmdParams && cmdParams.length > 0){
					cmdParams.transParameters(sqlstatement);
				}
				sqlstatement.execute();
				//cmdParams.clear();
			}catch(error:SQLError){
				Aorfuns.log(error.details);
				throw error;
			}
			return sqlstatement.getResult();
		}
		
		/**
		 * 执行一个SQL语句(无参数)
		 */
		public function querySQLWithOutParameter(conn:SQLConnection,sqlString:String):Boolean{
			var sqlstatement:SQLStatement = new SQLStatement();
			sqlstatement.sqlConnection = conn;
			sqlstatement.text = sqlString;
			try{
				sqlstatement.execute();
			}catch(error:SQLError){
				Aorfuns.log(error.details);
				throw error;
				return false;
			}
			return true;
		}
		
		/**
		 * 检测一个记录是否存在
		 */
		public function exists(sqlString:String, cmdParams:SqlParameter):Boolean {
			var result:Array = query(sqlString, cmdParams);
			return result.length > 0;
		}
		
		/**
		 * 获取表某个字段的最大值
		 */
		public function getMaxID(FieldName:String, TableName:String):uint {
			var sql:String = "SELECT MAX(" + FieldName + ") FROM " + TableName;
			var result:Array = query(sql, new SqlParameter());
			if (result[0]["MAX("+FieldName+")"] != null)
				return result[0]["MAX("+FieldName+")"];
			else
				return 0;
		}
		
		/**
		 * 总记录数
		 */
		public function getRecordNum(TableName:String, FieldName:String, cmdParams:SqlParameter, wheresql:String = ""):uint {
			var sql:String = "SELECT COUNT(" + FieldName + ") FROM " + TableName;
			sql += " "+wheresql;
			var result:Array = query(sql, cmdParams);
			return uint(result[0]["COUNT("+FieldName+")"].toString());
		} 
		/**
		 * 分页查询
		 * pageSize 每页数据量
		 * pageIndex 页数
		 */
		public function pageList(sqlString:String, cmdParams:SqlParameter, pageSize:uint, pageIndex:uint):Array {
			sqlString += " LIMIT "+(pageSize*(pageIndex-1)).toString()+", "+pageSize.toString();
			return query(sqlString, cmdParams);
		}
		
		/**
		 * 清除缓存
		 */
		public function clearCache():void {
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = _localSQLServer;
			stmt.text = "DELETE FROM statements";
			stmt.execute();
		}
		
	}
}class ASLCNullClass {}