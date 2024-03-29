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

package be.nascom.airbob.control
{
	import be.nascom.air.logging.FileTarget;
	import be.nascom.airbob.commands.CheckVersionCommand;
	import be.nascom.airbob.commands.ForceBuildCommand;
	import be.nascom.airbob.commands.LoadCruiseControlConfigCommand;
	import be.nascom.airbob.commands.LoadProjectsCommand;
	import be.nascom.airbob.commands.ProjectStateChangedCommand;
	import be.nascom.airbob.commands.SaveCruiseControlConfigCommand;
	import be.nascom.airbob.commands.SaveProjectSettingsCommand;
	import be.nascom.airbob.events.LoadCruiseControlConfigEvent;
	import be.nascom.airbob.events.LoadProjectsEvent;
	import be.nascom.airbob.model.AppModelLocator;
	
	import com.adobe.cairngorm.control.FrontController;
	
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;

	public class AppController extends FrontController 
	{
		private var logger:ILogger = Log.getLogger("AppController");
		
		public static const FORCE_BUILD_EVENT:String = "be.nascom.airbob.events.ForceBuildEvent";
		public static const LOAD_PROJECTS_EVENT:String = "be.nascom.airbob.events.LoadProjectsEvent";				
		public static const LOAD_CONFIG_EVENT:String = "be.nascom.airbob.events.LoadConfigEvent";
		public static const SAVE_CONFIG_EVENT:String = "be.nascom.airbob.events.SaveConfigEvent";
		public static const SAVE_PROJECT_SETTINGS_EVENT:String = "be.nascom.airbob.events.SaveProjectSettingsEvent";
		public static const PROJECT_STATE_CHANGED_EVENT:String = "be.nascom.airbob.events.ProjectStateChangedEvent";
		public static const CHECK_VERSION_EVENT:String = "be.nascom.airbob.events.CheckVersionEvent";
		
		private var model:AppModelLocator = AppModelLocator.getInstance();
		
		public function AppController() 
		{			
			// Initialize the Cairngorm Events/Commands
			addCommand(FORCE_BUILD_EVENT, ForceBuildCommand);
			addCommand(LOAD_PROJECTS_EVENT, LoadProjectsCommand);
			addCommand(LOAD_CONFIG_EVENT, LoadCruiseControlConfigCommand);
			addCommand(SAVE_CONFIG_EVENT, SaveCruiseControlConfigCommand);
			addCommand(SAVE_PROJECT_SETTINGS_EVENT, SaveProjectSettingsCommand);
			addCommand(PROJECT_STATE_CHANGED_EVENT, ProjectStateChangedCommand);
			addCommand(CHECK_VERSION_EVENT, CheckVersionCommand);
			
			// Load the configuration
			new LoadCruiseControlConfigEvent().dispatch();
			
			// Initialze
			initLogging();
			initPolling();			
			
		}
		
		/**
		 * Initialize the Flex logging framework
		 * */
		private function initLogging():void 
		{
			// Add file logger
			var fileTarget:FileTarget = new FileTarget();
			fileTarget.includeDate = true;
			fileTarget.includeTime = true;
			fileTarget.includeLevel = true;
			fileTarget.includeCategory = true;
			fileTarget.level = LogEventLevel.INFO;
			
			// Add the target
			Log.addTarget(fileTarget);
			logger.info("File Logging Active:" + new File(fileTarget.logURI).nativePath);	
		}
		
		/**
		 * Init the command that will poll the cruise control service
		 * */
		private function initPolling():void 
		{
			var timer:Timer = new Timer(model.applicationSettings.interval);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		/**
		 * Retrieve the project info from the cruise control server
		 * */
		private function onTimer(event:TimerEvent=null):void 
		{
			if (!model.emptyConfig)
    			new LoadProjectsEvent(model.ccConfig).dispatch();
	  	}
		
	}
}