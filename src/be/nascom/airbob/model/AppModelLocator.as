package be.nascom.airbob.model
{
	import be.nascom.airbob.vo.DashboardProject;
	
	import com.adobe.cairngorm.model.IModelLocator;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	[Bindable]
	public class AppModelLocator extends EventDispatcher implements IModelLocator 
	{
		private static var logger:ILogger = Log.getLogger("AppModelLocator");		
		private static var model:AppModelLocator;
		
		public var projects:ArrayCollection = new ArrayCollection();		
		public var settings:AppSettings ;				
        
        [Embed(source="Icons/Success.png")]
        private var IconSuccess:Class;
        private var iconSuccess:BitmapData;
        
        [Embed(source="Icons/Building.png")]
        private var IconBuilding:Class;
        private var iconBuilding:BitmapData;
        
        [Embed(source="Icons/Failure.png")]
        private var IconFailure:Class;
        private var iconFailure:BitmapData;
        
        [Embed(source="Icons/Disconnected.png")]
        private var IconDisconnected:Class;
        private var iconDisconnected:BitmapData;
        
        public var state:String;
        
        public var selectedView:int = VIEW_DASHBOARD;
        
        public const VIEW_DASHBOARD:int = 0;
        public const VIEW_PREFERENCES:int = 1;
		
		/**
	     * singleton: constructor only allows one model locator
	     */
		public function AppModelLocator():void 
		{
			if ( AppModelLocator.model != null ) {
				throw new Error( "Only one ModelLocator instance should be instantiated" );
			}
			iconSuccess = new IconSuccess().bitmapData;
        	iconBuilding = new IconBuilding().bitmapData;
        	iconFailure = new IconFailure().bitmapData;
        	iconDisconnected = new IconDisconnected().bitmapData;
        	
        	settings = new AppSettings();
		}

		/**
	     * singleton: always returns the one existing static instance to itself
	     */
		public static function getInstance():AppModelLocator 
		{
			if ( model == null ) {
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

	}
}