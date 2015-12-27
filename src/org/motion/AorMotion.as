//org.motion::AorMotion
package org.motion {
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.basic.Aorfuns;
	import org.resize.ResizeHandle;
	
	/**
	 * AorMotion
	 * 提示：easting:Function = function (t:Number,b:Number,c:Number,d:Number):Number
	 *  t:Number — 指定当前时间，介于 0 和持续时间之间（包括二者）。
	 *	b:Number — 指定动画属性的初始值。 
     *	c:Number — 指定动画属性的更改总计。(c != 0)；
     *	d:Number — 指定运动的持续时间。
	 */
	public class AorMotion extends EventDispatcher {
		
		private static var _Instance:AorMotion;
		public static function get Instance():AorMotion {
			return _Instance;
		}
		
		private var _isRunning:Boolean = false;
		public function get isRunning():Boolean {
			return _isRunning;
		}
		
		private var _isDebug:Boolean = false;
		public function get isDebug():Boolean {
			return _isDebug;
		}
		public function set isDebug(value:Boolean):void {
			_isDebug = value;
		}
		
		/**
		 * @private
		 */
		public function AorMotion (target:IEventDispatcher=null,$null:AMNullClass = null) {
			// constructor code
			super(target);
			if ($null == null) {
				throw new Error("You cannot instantiate this class, please use the static get_Instance method.");
				return;
			}
		}//end constructor
		
		/**
		 * 单件实例化[静态]
		 */
		public static function getInstance (target:IEventDispatcher=null):AorMotion {
			if (AorMotion._Instance == null) {
				AorMotion._Instance = new AorMotion(target, new AMNullClass());
			}//end if
			return AorMotion._Instance;
		}
		/**
		 * 析构方法
		 */
		public function destructor ():void {
			//
			AorMotion._Instance = null;
		}
		
		
		public function translateFormRight ($parent:DisplayObjectContainer,$old:DisplayObject, $new:DisplayObject, $duration:Number, easting:Function, isIresizeChild:Boolean = false, IresizeParentborder:DisplayObjectContainer = null):void {
			if(!$new){
				if(_isDebug){
					Aorfuns.log('AorMotion.translateFormRight Error > $new == null' );
				}
				return;
			}
			
			dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_START,AorMotionStatsEmu.AORMOTION_STATS_TRANSLATEFORMRIGHT,$new));
			_isRunning = true;
			
			var $hasOld:Boolean = false;
			if($old){
				if(isIresizeChild && ('resizeHandleMothed' in $old) && ResizeHandle.Instance){
					ResizeHandle.Instance.removeResizeChild($old);
				}
				$hasOld = true;
			}
			
			$parent.addChild($new);
			
			if(isIresizeChild && ('resizeHandleMothed' in $new) && ResizeHandle.Instance){
				ResizeHandle.Instance.addResizeChild($new,IresizeParentborder);
			}
			
			$new.x = $new.width;
			
			TweenLite.killTweensOf($new);
			TweenLite.to($new,$duration,{x:0,ease:easting,onComplete:function():void{
				TweenLite.killTweensOf($new);
				dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_END,AorMotionStatsEmu.AORMOTION_STATS_TRANSLATEFORMRIGHT,$new));
				_isRunning = false;
			}});
			
			if($hasOld){
				var $oldTargetX:Number = -($new.width);
				TweenLite.killTweensOf($old);
				TweenLite.to($old,$duration,{x:$oldTargetX,ease:easting,onComplete:function():void{
					TweenLite.killTweensOf($old);
					DisplayObjectContainer($old).parent.removeChild($old);
					$old = null;
				}});
			}
		}		
		
		public function translateFormLeft ($parent:DisplayObjectContainer,$old:DisplayObject, $new:DisplayObject, $duration:int, easting:Function, isIresizeChild:Boolean = false, IresizeParentborder:DisplayObjectContainer = null):void {
			if(!$new){
				if(_isDebug){
					Aorfuns.log('AorMotion.translateFormLeft Error > $new == null' );
				}
				return;
			}
			
			dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_START,AorMotionStatsEmu.AORMOTION_STATS_TRANSLATEFORMLEFT,$new));
			_isRunning = true;
			
			var $hasOld:Boolean = false;
			if($old){
				if(isIresizeChild && ('resizeHandleMothed' in $old) && ResizeHandle.Instance){
					ResizeHandle.Instance.removeResizeChild($old);
				}
				$hasOld = true;
			}
			
			$parent.addChild($new);
			
			if(isIresizeChild && ('resizeHandleMothed' in $new) && ResizeHandle.Instance){
				ResizeHandle.Instance.addResizeChild($new,IresizeParentborder);
			}
			
			$new.x = -($new.width);
			
			TweenLite.killTweensOf($new);
			TweenLite.to($new,$duration,{x:0,ease:easting,onComplete:function():void{
				TweenLite.killTweensOf($new);
				dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_END,AorMotionStatsEmu.AORMOTION_STATS_TRANSLATEFORMLEFT,$new));
				_isRunning = false;
			}});
			
			if($hasOld){
				var $oldTargetX:Number = $new.width;
				TweenLite.killTweensOf($old);
				TweenLite.to($old,$duration,{x:$oldTargetX,ease:easting,onComplete:function():void{
					TweenLite.killTweensOf($old);
					DisplayObjectContainer($old).parent.removeChild($old);
					$old = null;
				}});
			}
		}
		
		public function translateFormTop ($parent:DisplayObjectContainer,$old:DisplayObject, $new:DisplayObject, $duration:int, easting:Function, isIresizeChild:Boolean = false, IresizeParentborder:DisplayObjectContainer = null):void {
			if(!$new){
				if(_isDebug){
					Aorfuns.log('AorMotion.translateFormTop Error > $new == null' );
				}
				return;
			}
			
			dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_START,AorMotionStatsEmu.AORMOTION_STATS_TRANSLATEFORMTOP,$new));
			_isRunning = true;
			
			var $hasOld:Boolean = false;
			if($old){
				if(isIresizeChild && ('resizeHandleMothed' in $old) && ResizeHandle.Instance){
					ResizeHandle.Instance.removeResizeChild($old);
				}
				$hasOld = true;
			}
			
			$parent.addChild($new);
			
			if(isIresizeChild && ('resizeHandleMothed' in $new) && ResizeHandle.Instance){
				ResizeHandle.Instance.addResizeChild($new,IresizeParentborder);
			}
			
			$new.y = -$new.height;
			
			TweenLite.killTweensOf($new);
			TweenLite.to($new,$duration,{y:0,ease:easting,onComplete:function():void{
				TweenLite.killTweensOf($new);
				dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_END,AorMotionStatsEmu.AORMOTION_STATS_TRANSLATEFORMTOP,$new));
				_isRunning = false;
			}});
			
			if($hasOld){
				var $oldTargetY:Number = $new.height;
				TweenLite.killTweensOf($old);
				TweenLite.to($old,$duration,{y:$oldTargetY,ease:easting,onComplete:function():void{
					TweenLite.killTweensOf($old);
					DisplayObjectContainer($old).parent.removeChild($old);
					$old = null;
				}});
			}
			
		}
		
		public function translateFormBottom ($parent:DisplayObjectContainer,$old:DisplayObject, $new:DisplayObject, $duration:int, easting:Function, isIresizeChild:Boolean = false, IresizeParentborder:DisplayObjectContainer = null):void {
			if(!$new){
				if(_isDebug){
					Aorfuns.log('AorMotion.translateFormTop Error > $new == null' );
				}
				return;
			}
			
			dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_START,AorMotionStatsEmu.AORMOTION_STATS_TRANSLATEFORMBOTTOM,$new));
			_isRunning = true;
			
			var $hasOld:Boolean = false;
			if($old){
				if(isIresizeChild && ('resizeHandleMothed' in $old) && ResizeHandle.Instance){
					ResizeHandle.Instance.removeResizeChild($old);
				}
				$hasOld = true;
			}
			
			$parent.addChild($new);
			
			if(isIresizeChild && ('resizeHandleMothed' in $new) && ResizeHandle.Instance){
				ResizeHandle.Instance.addResizeChild($new,IresizeParentborder);
			}
			
			$new.y = $new.height;
			
			TweenLite.killTweensOf($new);
			TweenLite.to($new,$duration,{y:0,ease:easting,onComplete:function():void{
				TweenLite.killTweensOf($new);
				dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_END,AorMotionStatsEmu.AORMOTION_STATS_TRANSLATEFORMBOTTOM,$new));
				_isRunning = false;
			}});
			
			if($hasOld){
				var $oldTargetY:Number = -$new.height;
				TweenLite.killTweensOf($old);
				TweenLite.to($old,$duration,{y:$oldTargetY,ease:easting,onComplete:function():void{
					TweenLite.killTweensOf($old);
					DisplayObjectContainer($old).parent.removeChild($old);
					$old = null;
				}});
			}
		}
		
		public function fadeIN ($parent:DisplayObjectContainer,$old:DisplayObject, $new:DisplayObject, $duration:int, easting:Function, isIresizeChild:Boolean = false, IresizeParentborder:DisplayObjectContainer = null):void {
			
			if(!$new){
				if(_isDebug){
					Aorfuns.log('AorMotion.fadeIN Error > $new == null' );
				}
				return;
			}
			
			dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_START,AorMotionStatsEmu.AORMOTION_STATS_FADEIN,$new));
			_isRunning = true;
			
			var $hasOld:Boolean = false;
			if($old){
				if(isIresizeChild && ('resizeHandleMothed' in $old) && ResizeHandle.Instance){
					ResizeHandle.Instance.removeResizeChild($old);
				}
				$hasOld = true;
			}
			
			$parent.addChild($new);
			
			if(isIresizeChild && ('resizeHandleMothed' in $new) && ResizeHandle.Instance){
				ResizeHandle.Instance.addResizeChild($new,IresizeParentborder);
			}
			
			$new.alpha = 0;
			TweenLite.killTweensOf($new);
			TweenLite.to($new,$duration,{alpha:1,ease:easting,onComplete:function():void{
				TweenLite.killTweensOf($new);
				dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_END,AorMotionStatsEmu.AORMOTION_STATS_FADEIN,$new));
				_isRunning = false;
			}});
			
			if($hasOld){
				TweenLite.killTweensOf($old);
				TweenLite.to($old,$duration,{alpha:0,ease:easting,onComplete:function():void{
					TweenLite.killTweensOf($old);
					DisplayObjectContainer($old).parent.removeChild($old);
					$old = null;
				}});
			}
			
		}
		
		public function fadeBlackIN ($parent:DisplayObjectContainer,$old:DisplayObject, $new:DisplayObject, $duration:int, easting:Function, isIresizeChild:Boolean = false, IresizeParentborder:DisplayObjectContainer = null):void {
			
			if(!$new){
				if(_isDebug){
					Aorfuns.log('AorMotion.fadeBlackIN Error > $new == null' );
				}
				return;
			}
			
			dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_START,AorMotionStatsEmu.AORMOTION_STATS_FADEBLACKIN,$new));
			_isRunning = true;
			var $hasOld:Boolean = false;
			
			if($old){
				if(isIresizeChild && ('resizeHandleMothed' in $old) && ResizeHandle.Instance){
					ResizeHandle.Instance.removeResizeChild($old);
				}
				$hasOld = true;
			}
			
			var $black:Sprite = new Sprite();
			$black.graphics.beginFill(0x000000,1);
			$black.graphics.drawRect(0,0,$old.width,$old.height);
			$black.graphics.endFill();
			$black.alpha = 0;
			
			$parent.addChild($black);
			
			var $d:Number = $duration * 0.4;
			var $dd:Number = $duration * 0.2;
			TweenLite.to($black,$d,{alpha:1,ease:easting,onComplete:function():void{
				TweenLite.killTweensOf($black);
				
				if($hasOld){
					DisplayObjectContainer($old).parent.removeChild($old);
					$old = null;
				}
				
				$parent.addChild($new);
				if(isIresizeChild && ('resizeHandleMothed' in $new) && ResizeHandle.Instance){
					ResizeHandle.Instance.addResizeChild($new,IresizeParentborder);
				}
				
				$new.alpha = 0;
				
				TweenLite.to($new,$d,{alpha:1,delay:$dd,onComplete:function():void{
					TweenLite.killTweensOf($new);
					
					$parent.removeChild($black);
					$black = null;
					
					dispatchEvent(new AorMotionEvent(AorMotionEvent.AORMOTION_END,AorMotionStatsEmu.AORMOTION_STATS_FADEBLACKIN,$new));
					_isRunning = false;
				}});
			}});
		}
	}
}class AMNullClass {}