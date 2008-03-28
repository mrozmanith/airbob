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
			this.lastBuildStatus = data.lastBuildStatus;
			this.lastBuildLabel = data.lastBuildLabel;
			this.lastBuildTime = data.lastBuildTime;
			this.webUrl = data.webUrl;
			this.activity = data.activity;
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