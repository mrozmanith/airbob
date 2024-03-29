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

package be.nascom.airbob.business
{
	import be.nascom.airbob.vo.Project;
	import be.nascom.airbob.vo.CruiseControlConfig;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class CruiseControlDelegate 
	{
		private var logger:ILogger = Log.getLogger("CruiseControlDelegate");
		
		private var command:IResponder;
		private var service:HTTPService;
		
		private var project:Project;

		public function CruiseControlDelegate( command:IResponder ) 
		{			
			this.service = ServiceLocator.getInstance().getHTTPService("cruisecontrolService");
			this.command = command;
		}

		public function forceBuild(project:Project):void 
		{		
			// Create the force build request
			this.service.url = project.config.forceBuildUrl + "?operation=build&objectname=CruiseControl+Project%3Aname%3D" + project.name;
			logger.debug("calling " + this.service.url);
			var token:AsyncToken = service.send();
			token.addResponder(command);
		}
		
		public function loadCCTrayXml(config:CruiseControlConfig):void 
		{	
			// Create the cctray.xml request				
			this.service.url = config.ccTrayUrl;
			logger.debug("calling " + this.service.url);
			var token:AsyncToken = service.send();
			token.addResponder(command);
		}

	}
}	