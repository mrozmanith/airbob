package be.nascom.airbob.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	[Bindable]
	public class DashboardProject extends EventDispatcher implements ValueObject {
		public static const ACTIVITY_SLEEPING:String = "Sleeping";
		public static const ACTIVITY_BUILDING:String = "Building";
		
		public static const STATUS_SUCCESS:String = "Success";
		public static const STATUS_BUILDING:String = "Building";
		public static const STATUS_FAILURE:String = "Failure";		
		public static const STATUS_INACTIVE:String = "Inactive";
		
		public var name:String; 		 
		public var lastBuildStatus:String; 
		public var lastBuildLabel:String; 
		public var lastBuildTime:String; 
		public var webUrl:String;
				
		public var config:ServerConfig;
		
		private var _state:String;
		private var _activity:String;
		
		private static var logger:ILogger = Log.getLogger("DashboardProject");
		
		public function DashboardProject(data:Object=null):void { 
			if (data==null) return;
			
			this.name = data.name;
			this.activity = data.activity;
			this.lastBuildStatus = data.lastBuildStatus;
			this.lastBuildLabel = data.lastBuildLabel;
			this.lastBuildTime = data.lastBuildTime;
			this.webUrl = data.webUrl;
		}
		
		public function hasChanged(project:DashboardProject):Boolean {
			return (activity!=project.activity) || (lastBuildTime!=project.lastBuildTime);
		}
		
		public function get activity() : String {
			return _activity;
		}
		
		public function set activity(value : String) : void{
			_activity = value;
		}
		
		public function get state() : String {			
			if (activity==ACTIVITY_BUILDING) {
				return STATUS_BUILDING;
			} else if (activity==ACTIVITY_SLEEPING) {
				if (lastBuildStatus==STATUS_SUCCESS) {
					return STATUS_SUCCESS;
				} else if (lastBuildStatus==STATUS_FAILURE) {
					return STATUS_FAILURE;
				}
			} 
			return STATUS_INACTIVE;
		}
		
		public function set state(value : String) : void {
			_state = value;
		}
		
	}
}