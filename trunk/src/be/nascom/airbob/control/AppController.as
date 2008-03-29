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
	import be.nascom.airbob.commands.ForceBuildCommand;
	import be.nascom.airbob.commands.LoadConfigCommand;
	import be.nascom.airbob.commands.LoadProjectsCommand;
	import be.nascom.airbob.commands.SaveConfigCommand;
	import be.nascom.airbob.events.LoadConfigEvent;
	import be.nascom.airbob.events.LoadProjectsEvent;
	import be.nascom.airbob.model.AppModelLocator;
	
	import com.adobe.cairngorm.control.FrontController;
	import com.adobe.cairngorm.model.ModelLocator;
	
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
		
		private var model:AppModelLocator = AppModelLocator.getInstance();
		
		public function AppController() 
		{			
			addCommand(FORCE_BUILD_EVENT, ForceBuildCommand);
			addCommand(LOAD_PROJECTS_EVENT, LoadProjectsCommand);
			addCommand(LOAD_CONFIG_EVENT, LoadConfigCommand);
			addCommand(SAVE_CONFIG_EVENT, SaveConfigCommand);
			
			new LoadConfigEvent().dispatch();
			initLogging();
			initPolling();			
			
		}
		
		private function initLogging():void 
		{
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
		
		private function initPolling():void 
		{
			var timer:Timer = new Timer(model.settings.interval);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onTimer(event:TimerEvent=null):void 
		{
			if (!model.emptyConfig)
    			new LoadProjectsEvent(model.config).dispatch();
	  	}
		
	}
}