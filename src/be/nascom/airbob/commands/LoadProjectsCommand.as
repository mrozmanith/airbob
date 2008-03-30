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

package be.nascom.airbob.commands
{
	import be.nascom.airbob.business.LoadProjectsDelegate;
	import be.nascom.airbob.events.LoadProjectsEvent;
	import be.nascom.airbob.model.AppModelLocator;
	import be.nascom.airbob.vo.ServerConfig;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;

	public class LoadProjectsCommand extends AbstractConfigCommand implements ICommand, IResponder 
	{
		private var logger:ILogger = Log.getLogger("LoadProjectsCommand");
		
		private var config:ServerConfig;
		
		public function execute(event:CairngormEvent):void 
		{
			logger.info("Loading projects");
			var delegate : LoadProjectsDelegate = new LoadProjectsDelegate(this);
			config = LoadProjectsEvent(event).config;
			delegate.send(config);	
		}
		
		public function result( rpcEvent : Object ) : void  
		{
			logger.debug(ObjectUtil.toString(rpcEvent));
			if (rpcEvent.result.Projects!=null) 
			{
				if (rpcEvent.result.Projects.Project is ArrayCollection) 
				{
					// If the service returns mutiple projects
		 			model.update(rpcEvent.result.Projects.Project, config);
	 			} 
	 			else 
	 			{
	 				// If the service returns only one project
	 				var projects:ArrayCollection = new ArrayCollection();
	 				projects.addItem(rpcEvent.result.Projects.Project);
	 				model.update(projects, config);		 				
	 			}		 
			}										
		}
		
		public function fault( rpcEvent : Object ) : void 
		{
			model.clear();
			logger.error(rpcEvent.fault.faultDetail);				
		}
		
	}
}