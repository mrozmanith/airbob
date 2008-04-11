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

package be.nascom.airbob.model
{
	import be.nascom.airbob.events.ProjectStateChangedEvent;
	import be.nascom.airbob.vo.ApplicationConfig;
	import be.nascom.airbob.vo.Project;
	import be.nascom.airbob.vo.ProjectConfig;
	import be.nascom.airbob.vo.CruiseControlConfig;
	
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
        public var favoriteProjectLength:int = 0;                		
        public var config:CruiseControlConfig;        
		public var settings:ApplicationConfig;	
        
        public var connectedState:String = STATE_CONNECTING;
        public var state:String = "Disconnected";        
        
        public static const STATE_CONNECTED:String = "connected";
        public static const STATE_DISCONNECTED:String = "disconnected";
        public static const STATE_CONNECTING:String = "connecting";
        public static const STATE_INITIALIZING:String = "initializing";
        
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
			
			// Initialze icons for the system tray icon
			iconSuccess = new IconSuccess().bitmapData;
        	iconBuilding = new IconBuilding().bitmapData;
        	iconFailure = new IconFailure().bitmapData;
        	iconDisconnected = new IconDisconnected().bitmapData;
        	
        	// Init 
        	settings = new ApplicationConfig();      
        	config = new CruiseControlConfig();  	   	
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
		
		/**
		 * Returns true if there is no url configured for the app
		 * */
		public function get emptyConfig():Boolean
		{
			return (model.config==null || model.config.url==null || model.config.url=="");
		}
		
		/**
		 * Returns the current tray icon
		 * */
		public function get trayIcon():BitmapData
		{			
			switch(state) 
			{
	  			case Project.STATUS_SUCCESS:
	  				return iconSuccess;
	  			case Project.STATUS_BUILDING:
	  				return iconBuilding;
	  			case Project.STATUS_FAILURE:
	  				return iconFailure;	  					  	
	  		}
	  		return iconDisconnected;		
		}
		/**
		 * Clears the current model
		 * */
		public function clear():void
		{
			projects.removeAll();
			refreshState();
		}
		
		/**
		 * Updates the model
		 * */
		public function update(projectData:ArrayCollection, projectSettings:ArrayCollection):void 
		{			
			if (projects.length!=projectData.length)
			{	 
	 			initModel(projectData, projectSettings);
		   	} 
		   	else 
		   	{
		   		updateModel(projectData, projectSettings);
		   	}	
		   	model.connectedState = STATE_CONNECTED;		   		
		}				
		
		private function getProjectSetting(project:Project, projectSettings:ArrayCollection) : ProjectConfig
		{
			for each(var setting:ProjectConfig in projectSettings) 
			{
				if (setting.projectName==project.name) return setting;				
			}
			return new ProjectConfig(project);
		} 
		
		/**
		 * Initializes the model
		 * */
		private function initModel(projectData:ArrayCollection, projectSettings:ArrayCollection):void 
		{				
			var projectsTemp:ArrayCollection = new ArrayCollection();
			for(var i:uint=0; i < projectData.length; i++) 
			{
				var project:Project = new Project(projectData[i]);
				project.config = config;
				project.setting = getProjectSetting(project, projectSettings);
	   			projectsTemp.addItem(project);
	   		}
	   		projects = projectsTemp;
	   		refreshState();	
		}
		
		/**
		 * Upate only the changed projects
		 * */
		private function updateModel(projectData:ArrayCollection, projectSettings:ArrayCollection):void 
		{
			for(var i:uint=0; i < projectData.length; i++) 
			{
	   			var project:Project = new Project(projectData[i]);
	   			for(var j:uint=0; j < projects.length; j++) 
	   			{
	   				if (projects[j].name==project.name) 
	   				{
		   				if (projects[j].hasChanged(project)) 
		   				{
		   					project.config = config;
		   					project.setting = getProjectSetting(project, projectSettings);
		   					projects[j].activity = project.activity;		   		
		   					projects[j].lastBuildLabel = project.lastBuildLabel;
		   					projects[j].lastBuildStatus = project.lastBuildStatus;
		   					projects[j].lastBuildTime = project.lastBuildTime;	
		   					new ProjectStateChangedEvent(projects[j]).dispatch();	   									   				
		   				}
	   				}
	   			}
	   		}
	   		refreshState();	
		}	
		
		/**
		 * Changes the current model state
		 * */
		public function refreshState():void 
		{
			var stateSuccess:int = 0;
			var stateFailure:int = 0;
			var stateBuilding:int = 0;
			var stateOther:int = 1;
			favoriteProjectLength = 0;
			
			var prevState:String = state; 
			
			for(var i:uint=0; i < projects.length; i++) 
			{
				var project:Project = Project(projects[i]);
				if (project.setting.isFavorite)
				{
					favoriteProjectLength++;
					if (project.state == Project.STATUS_FAILURE) 
					{
						stateFailure++;	
					} 
					else if (project.state == Project.STATUS_BUILDING) 
					{
						stateBuilding++;	
					} 
					else if (project.state == Project.STATUS_SUCCESS) 
					{
						stateSuccess++;
					}
				} 				
			}	
			
			if (stateOther>0) state = Project.STATUS_INACTIVE;
			if (stateSuccess>0) state = Project.STATUS_SUCCESS;
			if (stateFailure>0) state = Project.STATUS_FAILURE;
			if (stateBuilding>0) state = Project.STATUS_BUILDING;
			
			logger.debug("refresh model state: " + state);
			if (state!=prevState)
				dispatchEvent(new Event(EVENT_MODEL_UPDATED));
		}				

	}
}