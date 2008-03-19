package be.nascom.airbob.control
{
	import be.nascom.air.logging.FileTarget;
	import be.nascom.airbob.commands.ForceBuildCommand;
	import be.nascom.airbob.commands.LoadConfigCommand;
	import be.nascom.airbob.commands.LoadProjectsCommand;
	import be.nascom.airbob.commands.SaveConfigCommand;
	import be.nascom.airbob.events.LoadProjectsEvent;
	import be.nascom.airbob.model.AppModelLocator;
	import be.nascom.airbob.vo.ServerConfig;
	
	import com.adobe.cairngorm.control.FrontController;
	
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;

	public class AppController extends FrontController {
		private var logger:ILogger = Log.getLogger("AppController");
		
		public static const FORCE_BUILD_EVENT:String = "be.nascom.airbob.events.ForceBuildEvent";
		public static const LOAD_PROJECTS_EVENT:String = "be.nascom.airbob.events.LoadProjectsEvent";				
		public static const LOAD_CONFIG_EVENT:String = "be.nascom.airbob.events.LoadConfigEvent";
		public static const SAVE_CONFIG_EVENT:String = "be.nascom.airbob.events.SaveConfigEvent";
		
		public function AppController() {
			initLogging();
			initPolling();
				
			addCommand(FORCE_BUILD_EVENT, ForceBuildCommand);
			addCommand(LOAD_PROJECTS_EVENT, LoadProjectsCommand);
			addCommand(LOAD_CONFIG_EVENT, LoadConfigCommand);
			addCommand(SAVE_CONFIG_EVENT, SaveConfigCommand);
		}
		
		private function initLogging():void {
			// Add file logger
			var fileTarget:FileTarget = new FileTarget();
			fileTarget.includeDate = true;
			fileTarget.includeTime = true;
			fileTarget.includeLevel = true;
			fileTarget.includeCategory = true;
			fileTarget.level = LogEventLevel.ALL;
			
			// Add the target
			Log.addTarget(fileTarget);
			logger.info("File Logging Active:" + new File(fileTarget.logURI).nativePath);	
		}
		
		private function initPolling():void {
			var timer:Timer = new Timer(AppModelLocator.getInstance().settings.interval);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onTimer(event:TimerEvent=null):void {
	 		for each (var config:ServerConfig in AppModelLocator.getInstance().configs) {
	    		new LoadProjectsEvent(config).dispatch();
	  		}	
	  	}
		
	}
}