//com.media::AORVideo
package com.media {
	import flash.display.Stage;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import org.basic.Aorfuns;
	import org.template.SpriteTemplate;
	
	/**
	 * AOR视频播放组件
	 * 
	 * 提示:
	 * 		请勿直接为此组件的width,height,x,y属性赋值，请调用setVideoRect方法.
	 */
	public class AORVideo extends SpriteTemplate {
		
		private var nc:NetConnection; 
		private var ns:NetStream;
		private var vid:Video;
		
		/**
		 * 表示播放头时间/位置的一个数值
		 */
		public function get playheadTime ():Number {
			if(ns){
				return ns.time;
			}
			return -1;
		}
		private var _duration:Number = -1;
		/**
		 * 表示播放内容的总长度
		 */
		public function get totalTime ():Number {
			return _duration;
		}
		
		public function get volume ():Number {
			if(ns){
				return ns.soundTransform.volume;
			}
			return 0;
		}
		private var _volume:Number = 1;
		public function set volume (value:Number):void {
			_volume = value;
			
			if(ns){
				if(ns.soundTransform.volume == _volume) return;
				ns.soundTransform = new SoundTransform(_volume,0);
			}
		}
		
		private var _preferredWidth:Number = 0;
		/**
		 * 无缩放时，视频的预设宽度
		 */
		public function get preferredWidth():Number {
			return _preferredWidth;
		}

		private var _preferredHeight:Number = 0;
		/**
		 * 无缩放时，视频的预设高度
		 */
		public function get preferredHeight():Number {
			return _preferredHeight;
		}
		
		private var videoURL:String = "null";
		
		private var _stats:String = "stop";
		public function get stats():String {
			return _stats;
		}
		
		private var _smoothing:Boolean;
		public function get smoothing():Boolean {
			return _smoothing;
		}
		public function set smoothing(value:Boolean):void {
			_smoothing = value;
		}
		
		private var _supportStageVideo:Boolean = true;
		public function get supportStageVideo():Boolean {
			return _supportStageVideo;
		}
		public function set supportStageVideo(value:Boolean):void {
			_supportStageVideo = value;
		}
		
		private var _debug:Boolean = false;
		public function get debug():Boolean {
			return _debug;
		}
		public function set debug(value:Boolean):void {
			_debug = value;
		}
		
		public function AORVideo($viewRect:Rectangle,$smoothing:Boolean = true) {
			_viewRect = $viewRect;
			_smoothing = $smoothing;
			super();
		}
		
		override protected function destructor():void {
			
			clearVideo();
			removeChildren();
			
			_stageLink.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,onStageVideoState);
			_stageLink = null;
			
		}
		//private var _bg:Sprite;
		override protected function init():void {
			//
			super.x = _viewRect.x;
			super.y = _viewRect.y;
			
			_stageLink = stage;
			
			if(_debug){
				Aorfuns.log("AORVideo.init \>\n" + "\twidth:" + width + "\n\thiehgt:" + height);
			}
		}
		
		override public function set height(value:Number):void {
			//
		}
		
		override public function set width(value:Number):void {
			//
		}

		override public function set x(value:Number):void {
			//
		}
		
		override public function set y(value:Number):void {
			//
		}
		
		private var _stageLink:Stage;
		
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					//Aorfuns.log("Unable to locate video: " + videoURL);
					_stats = AORVideoStatsEmu.ERROR;
					dispatchEvent(new AORVideoEvent(AORVideoEvent.onStreamNotFound,videoURL,_volume,0,_duration,_stats));
					break;
				case "NetStream.Buffer.Flush":
					//数据流处理完成，处理继续播放还是播放其余文件；
					//Aorfuns.log("AORVideo.NetStream.Buffer.Flush");
					dispatchEvent(new AORVideoEvent(AORVideoEvent.onBufferFlush,videoURL,_volume,ns.time,_duration,_stats));
					break;
				case "NetStream.Play.Stop":
					//Aorfuns.log("AORVideo.NetStream.Play.Stop");
					stop(true);
					break;
				case "NetStream.Seek.Complete":
					//Aorfuns.log("AORVideo.NetStream.Seek.Complete");
					dispatchEvent(new AORVideoEvent(AORVideoEvent.onStatsUpdate,videoURL,_volume,ns.time,_duration,_stats));
					break;
			}
		}
		
		private function connectStream():void {
			ns = new NetStream(nc); 
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			//ns.addEventListener(
			vid=new Video(); 
			vid.smoothing = _smoothing;
			
			if(_supportStageVideo){
				stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,onStageVideoState);
			}else{
				toggleStageVideo(false);
			}
			
		}
		
		private var sv:StageVideo;
		private var stageVideoInUse:Boolean;
		private var classicVideoInUse:Boolean;
		
		private function onStageVideoState(event:StageVideoAvailabilityEvent):void {	
			// Detect if StageVideo is available and decide what to do in toggleStageVideo
			stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,onStageVideoState);
			//
			toggleStageVideo((event.availability == StageVideoAvailability.AVAILABLE));
			
		}
		
		private function toggleStageVideo(on:Boolean):void {	
			if(_debug){
				Aorfuns.log( "StageVideo Running (Direct path) : " + on + "\n");
			}
			if (on) {
				//$.stage3DMode = true;
				stageVideoInUse = true;
				if ( sv == null ) {
					sv = stage.stageVideos[0];
					sv.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);
				}
				sv.attachNetStream(ns);
				if (classicVideoInUse) {
					// If we use StageVideo, we just remove from the display list the Video object to avoid covering the StageVideo object (always in the background)
					removeChild (vid);
					classicVideoInUse = false;
				}
			} else {
				// Otherwise we attach it to a Video object
				//$.stage3DMode = false;
				if (stageVideoInUse){
					stageVideoInUse = false;
				}
				classicVideoInUse = true;
				vid.attachNetStream(ns); 
				addChild(vid);
				
			}
			
			var obj:Object = {};
			obj.onMetaData = onMetaData; 
			obj.onXMPData = onXMPData;
			obj.onCuePoint = onCuePoint;
			
			ns.client = obj; 
			ns.play(videoURL);
			
			_stats = AORVideoStatsEmu.PLAY;
			ns.soundTransform = new SoundTransform(_volume);
			dispatchEvent(new AORVideoEvent(AORVideoEvent.onStatsUpdate,videoURL,_volume,0,_duration,_stats));
			updateProgress();
		} 
		
		private function stageVideoStateChange(event:StageVideoEvent):void {	
			// set the StageVideo size using the viewPort property
			//sv.viewPort = getVideoRect(sv.videoWidth,sv.videoHeight);
			//$.resizeHandle.DoResize();
			sv.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);
			sv.viewPort = _viewRect;
		}
		
		public function setVideoRect($rect:Rectangle):void {
			
			_viewRect = $rect;
			/*
			//动态修改背景大小会影响整个组件的宽高判定
			if(_bg){
				_bg.width = _viewRect.width;
				_bg.height = _viewRect.height;
			}*/
			
			if(_supportStageVideo){
				if(sv){
					sv.viewPort = _viewRect;
				}
			}else{
				setVRect();
			}
		}
		
		private function setVRect ():void {
			if(vid){
				super.width = _viewRect.width;
				super.height = _viewRect.height;
			}
			super.x = _viewRect.x;
			super.y = _viewRect.y;
		}
		
		private var _viewRect:Rectangle;
		
		/* 居中算法
		private function getVideoRect(width:uint, height:uint):Rectangle {
			var videoRect:Rectangle = new Rectangle();
			var videoWidth:uint = width;
			var videoHeight:uint = height;
			var scaling:Number = Math.min ( stage.stageWidth / videoWidth, stage.stageHeight / videoHeight );
			
			videoWidth *= scaling, videoHeight *= scaling;
			
			var posX:uint = stage.stageWidth - videoWidth >> 1;
			var posY:uint = stage.stageHeight - videoHeight >> 1;
			
			videoRect.x = posX;
			videoRect.y = posY;
			videoRect.width = videoWidth;
			videoRect.height = videoHeight;
			
			return videoRect;
		}*/
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			var $message:String = "AORVideo.securityError :: " + event.toString();
			if(_debug){
				Aorfuns.log($message);
			}
			_stats = AORVideoStatsEmu.ERROR;
			dispatchEvent(new AORVideoEvent(AORVideoEvent.onSecurityError,videoURL,_volume,0,0,_stats,null,$message));
			clearUpdateProgress();
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void {
			// ignore AsyncErrorEvent events.
			var $message:String = "AORVideo.asyncError :: " + event.toString();
			if(_debug){
				Aorfuns.log($message);
			}
			_stats = AORVideoStatsEmu.ERROR;
			dispatchEvent(new AORVideoEvent(AORVideoEvent.onAsyncError,videoURL,_volume,0,0,_stats,null,$message));
			clearUpdateProgress();
		}
		
		private function onMetaData(infoObject:Object):void { 
			//_duration=infoObject.duration;//获取总时间 
			//Aorfuns.log("onMetaData ::" + MetaDataToString(infoObject));
			
			_duration = infoObject["duration"];
			_preferredWidth = infoObject["width"];
			_preferredHeight = infoObject["height"];
			//
			vid.width = _preferredWidth;
			vid.height = _preferredHeight;
			
			var $message:String = "onMetaData :: duration:" + _duration + ", preferredWidth:" + _preferredWidth + ", preferredHeight:" + _preferredHeight;
			if(_debug){
				Aorfuns.log($message);
			}
			dispatchEvent(new AORVideoEvent(AORVideoEvent.onMetaData,videoURL,_volume,0,_duration,_stats,infoObject,$message));
			
		} 
		
		private function onXMPData(infoObject:Object):void {
			if(_debug){
				Aorfuns.log("**** onXMPData *****");
			}
			dispatchEvent(new AORVideoEvent(AORVideoEvent.onXMPData,videoURL,_volume,0,_duration,_stats,infoObject,"onXMPData"));
		}
		
		private function onCuePoint(infoObject:Object):void { 
			if(_debug){
				Aorfuns.log("**** onCuePoint *****");
			}
			dispatchEvent(new AORVideoEvent(AORVideoEvent.onCuePoint,videoURL,_volume,0,_duration,_stats,infoObject,"onCuePoint"));
		}
		
		private function clearVideo ($dontClearPlayerMovieCache:Boolean = false):void {
			//$.stage3DMode = false;
			if(stage){
				stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,onStageVideoState);
			}
			if(sv){
				sv.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);
				sv = null;
			}
			
			if(vid){
				vid.clear();
				if(vid.parent){
					removeChild(vid);
				}
				vid = null;
			}
			if(ns){
				ns.close();
				ns.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				ns.dispose();
				ns = null;
				
			}
			if(nc){
				if(nc.connected){
					nc.close()
				}
				nc.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				nc = null;
			}
			if($dontClearPlayerMovieCache){
				videoURL = null;
			}
		}
		
		private var _checkTimer:Timer;
		
		private function clearTimer ():void {
			if(_checkTimer){
				_checkTimer.reset();
				_checkTimer.removeEventListener(TimerEvent.TIMER, TimerDoit);
				_checkTimer = null;
			}
		}
		
		private function createTimer ():void {
			clearTimer();
			//
			_checkTimer = new Timer(1000);
			_checkTimer.addEventListener(TimerEvent.TIMER, TimerDoit);
			_checkTimer.start();
		}
		
		private function TimerDoit (e:TimerEvent):void {
			if(ns){
				dispatchEvent(new AORVideoEvent(AORVideoEvent.onStatsUpdate,videoURL,_volume,ns.time,_duration,_stats));
			}
		}
		
		private function clearUpdateProgress ():void {
			removeEventListener(Event.ENTER_FRAME,updateProgressLoop);
		}
		
		private function updateProgress ():void {
			clearUpdateProgress();
			addEventListener(Event.ENTER_FRAME,updateProgressLoop);
		}
		
		private function updateProgressLoop (e:Event):void {
			if(ns){
				dispatchEvent(new AORVideoEvent(AORVideoEvent.onProgress,videoURL,_volume,ns.time,_duration,_stats));
			}
		}
		
		//-------------------------- 方法 ------------------------
		
		public function seekP (value:Number):void {
			if(ns){
				seek(_duration * value);
			}
		}
		
		public function seek(value:Number):void {
			if(ns){
				if (value == int(_duration)) { 
					ns.seek(0); 
				} else { 
					if (value > Math.floor(int(_duration) * ns.bytesLoaded / ns.bytesTotal)) { 
						ns.seek(Math.floor(int(_duration) * ns.bytesLoaded / ns.bytesTotal)-5); 
					} else { 
						ns.seek(value); 
					} 
					dispatchEvent(new AORVideoEvent(AORVideoEvent.onSeek,videoURL,_volume,0,_duration,_stats));
				} 
			}
			//trace(value,int(duration)); 
			//trace(ns.bytesLoaded+":"+ns.bytesTotal); 
		} 
		
		public function play ($path:String = null):void {
			if($path == null || $path == ""){
				if(videoURL && ns){
					ns.resume();
				}
				updateProgress();
				return;
			}else if(videoURL == $path){
				ns.resume();
				updateProgress();
			}else{
				//
				videoURL = $path;
				nc=new NetConnection(); 
				nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				nc.connect(null);
			}
		}
		
		public function pause ():void {
			if(ns){
				clearTimer();
				clearUpdateProgress();
				ns.pause();
				_stats = AORVideoStatsEmu.PAUSE;
				dispatchEvent(new AORVideoEvent(AORVideoEvent.onStatsUpdate,videoURL,_volume,ns.time,_duration,_stats));
			}
		}
		
		public function stop ($dontClearPlayerMovieCache:Boolean = false):void {
			if(ns){
				clearTimer();
				clearUpdateProgress();
				ns.seek(0);
				ns.pause();
				_stats = AORVideoStatsEmu.STOP;
				dispatchEvent(new AORVideoEvent(AORVideoEvent.onStatsUpdate,videoURL,_volume,0,_duration,_stats));
			}
			clearVideo($dontClearPlayerMovieCache);
		}
		
		
		
	}
}