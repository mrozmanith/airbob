/*
Copyright (c) 2008 Airbob Contributors.  See:
    http://code.google.com/p/airbob/wiki/ProjectContributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package be.nascom.airbob.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	import com.adobe.utils.DateUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	[Bindable]
	[Table(name="projects")]
	public class DashboardProject extends EventDispatcher implements ValueObject 
	{
		
		public static const ACTIVITY_SLEEPING:String = "Sleeping";
		public static const ACTIVITY_BUILDING:String = "Building";
		
		public static const STATUS_SUCCESS:String = "Success";
		public static const STATUS_BUILDING:String = "Building";
		public static const STATUS_FAILURE:String = "Failure";		
		public static const STATUS_INACTIVE:String = "Inactive";
		
		public var name:String; 		 
		 
		public var lastBuildLabel:String; 		 
		public var webUrl:String;
		public var isFavorite:Boolean = true;
		public var lastBuildTime:String;		
		public var config:ServerConfig;
		
		private var _state:String;
		private var _activity:String;
		private var _lastBuildStatus:String;		
		
		private static var logger:ILogger = Log.getLogger("DashboardProject");
		
		public static const EVENT_ACTIVITY_CHANGE:String = "EVENT_ACTIVITY_CHANGE";		
		public static const EVENT_STATUS_CHANGE:String = "EVENT_STATUS_CHANGE";
		
		public function DashboardProject(data:Object=null):void 
		{ 
			if (data==null) return;
			
			this.name = data.name;						
			this.lastBuildLabel = data.lastBuildLabel;
			this.lastBuildTime = data.lastBuildTime;
			this.webUrl = data.webUrl;
			
			this._lastBuildStatus = data.lastBuildStatus;
			this._activity = data.activity;
		}
		
		public function hasChanged(project:DashboardProject):Boolean 
		{
			return (activity!=project.activity) || (lastBuildTime!=project.lastBuildTime);
		}
		
		public function get activity() : String 
		{
			return _activity;
		}
		
		public function set activity(value : String) : void 
		{
			if (_activity!=value) 
			{	
				logger.debug("dispatch event:" + EVENT_ACTIVITY_CHANGE + " old:" + _activity + " new:" + value);			
				_activity = value;				
				dispatchEvent(new Event(EVENT_ACTIVITY_CHANGE));
			}
		}
		
		public function get lastBuildStatus() : String 
		{
			return _lastBuildStatus;
		}
		
		public function set lastBuildStatus(value : String) : void 
		{
			if (_lastBuildStatus!=value) 
			{				
				logger.debug("dispatch event:" + EVENT_STATUS_CHANGE + " old:" + _activity + " new:" + value);
				_lastBuildStatus = value;
				dispatchEvent(new Event(EVENT_STATUS_CHANGE));
			}
		}
		
		public function get state() : String 
		{			
			if (activity==ACTIVITY_BUILDING) 
			{
				return STATUS_BUILDING;
			} 
			else if (activity==ACTIVITY_SLEEPING) 
			{
				if (lastBuildStatus==STATUS_SUCCESS) 
				{
					return STATUS_SUCCESS;
				} 
				else if (lastBuildStatus==STATUS_FAILURE) 
				{
					return STATUS_FAILURE;
				}
			} 
			return STATUS_INACTIVE;
		}
		
		public function set state(value : String) : void 
		{
			_state = value;
		}			
		
	}
}