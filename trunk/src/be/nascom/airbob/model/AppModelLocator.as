package be.nascom.airbob.model
{
	import be.nascom.airbob.vo.ApplicationConfig;
	import be.nascom.airbob.vo.DashboardProject;
	import be.nascom.airbob.vo.ServerConfig;
	
	import com.adobe.cairngorm.model.IModelLocator;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	[Bindable]
	public class AppModelLocator extends EventDispatcher implements IModelLocator 
	{
		private static var logger:ILogger = Log.getLogger("AppModelLocator");		
		private static var model:AppModelLocator;						
        
        [Embed(source="../../../../../assets/icons/systray_success.png")]
        private var IconSuccess:Class;
        private var iconSuccess:BitmapData;
        
        [Embed(source="../../../../../assets/icons/systray_building.png")]
        private var IconBuilding:Class;
        private var iconBuilding:BitmapData;
        
        [Embed(source="../../../../../assets/icons/systray_failure.png")]
        private var IconFailure:Class;
        private var iconFailure:BitmapData;
        
        [Embed(source="../../../../../assets/icons/systray_disconnected.png")]
        private var IconDisconnected:Class;
        private var iconDisconnected:BitmapData;
        
        public var projects:ArrayCollection = new ArrayCollection();		
        public var configs:ArrayCollection = new ArrayCollection();
        
		public var settings:ApplicationConfig;	
        
        public var connectedState:String = STATE_DISCONNECTED;
        public var state:String = "Connecting...";        
        public var selectedView:int = VIEW_DASHBOARD;
        
        public static const VIEW_DASHBOARD:int = 0;
        public static const VIEW_PREFERENCES:int = 1;
        
        public static const STATE_CONNECTED:String = "connected";
        public static const STATE_DISCONNECTED:String = "disconnected";
        
        public static const EVENT_MODEL_UPDATED:String = "EVENT_MODEL_UPDATED";
		
		/**
	     * singleton: constructor only allows one model locator
	     */
		public function AppModelLocator():void 
		{
			if ( AppModelLocator.model != null ) 
			{
				throw new Error( "Only one ModelLocator instance should be instantiated" );
			}
			iconSuccess = new IconSuccess().bitmapData;
        	iconBuilding = new IconBuilding().bitmapData;
        	iconFailure = new IconFailure().bitmapData;
        	iconDisconnected = new IconDisconnected().bitmapData;
        	
        	settings = new ApplicationConfig();        	   	
		}

		/**
	     * singleton: always returns the one existing static instance to itself
	     */
		public static function getInstance():AppModelLocator 
		{
			if ( model == null ) 
			{
				logger.info("init model");
				model = new AppModelLocator();								
			}
			return model;
		}
		
		public function get trayIcon():BitmapData
		{			
			switch(state) 
			{
	  			case DashboardProject.STATUS_SUCCESS:
	  				return iconSuccess;
	  			case DashboardProject.STATUS_BUILDING:
	  				return iconBuilding;
	  			case DashboardProject.STATUS_FAILURE:
	  				return iconFailure;	  					  	
	  		}
	  		return iconDisconnected;		
		}
		
		
		public function update(data:Object, config:ServerConfig):void 
		{			
			if (projects.length!=data.length)
			{	 
	 			initModel(data, config);
		   	} 
		   	else 
		   	{
		   		updateModel(data, config);
		   	}	
		   	model.connectedState = STATE_CONNECTED;		   		
		}
		
		private function initModel(data:Object, config:ServerConfig):void 
		{	
			for(var i:uint=0; i < data.length; i++) 
			{
				var project:DashboardProject = new DashboardProject(data[i]);
				project.config = config;
	   			projects.addItem(project);
	   		}
	   		changeState();	
		}
		
		private function updateModel(data:Object, config:ServerConfig):void 
		{
			for(var i:uint=0; i < data.length; i++) 
			{
	   			var project:DashboardProject = new DashboardProject(data[i]);
	   			for(var j:uint=0; j < projects.length; j++) 
	   			{
	   				if (projects[j].name==project.name) 
	   				{
		   				if (projects[j].hasChanged(project)) 
		   				{
		   					project.config = config;
		   					projects[j].activity = project.activity;		   		
		   					projects[j].lastBuildLabel = project.lastBuildLabel;
		   					projects[j].lastBuildStatus = project.lastBuildStatus;
		   					projects[j].lastBuildTime = project.lastBuildTime;
		   					changeState();					   					
		   				}
	   				}
	   			}
	   		}
		}	
		
		private function changeState():void 
		{
			var stateSuccess:int = 0;
			var stateFailure:int = 0;
			var stateBuilding:int = 0;
			var stateOther:int = 0;
			
			for(var i:uint=0; i < projects.length; i++) 
			{
				if (DashboardProject(projects[i]).state == DashboardProject.STATUS_FAILURE) 
				{
					stateFailure++;	
				} 
				else if (DashboardProject(projects[i]).state == DashboardProject.STATUS_BUILDING) 
				{
					stateBuilding++;	
				} 
				else if (DashboardProject(projects[i]).state == DashboardProject.STATUS_SUCCESS) 
				{
					stateSuccess++;
				} 
				else 
				{
					stateOther++;
				}
			}	
			
			if (stateOther>0) state = DashboardProject.STATUS_INACTIVE;
			if (stateSuccess>0) state = DashboardProject.STATUS_SUCCESS;
			if (stateFailure>0) state = DashboardProject.STATUS_FAILURE;
			if (stateBuilding>0) state = DashboardProject.STATUS_BUILDING;
			
			dispatchEvent(new Event(EVENT_MODEL_UPDATED));
		}				

	}
}