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
	import be.nascom.air.UpdateManager;
	import be.nascom.airbob.events.CheckVersionEvent;
	import be.nascom.airbob.model.AppModelLocator;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class CheckVersionCommand implements ICommand
	{		
		private var logger:ILogger = Log.getLogger("CheckVersionCommand");
				
		public function execute( event:CairngormEvent ) : void 
		{				
			var model:AppModelLocator = AppModelLocator.getInstance();
			var updateManager:UpdateManager = new UpdateManager(model.settings.updateUrl, CheckVersionEvent(event).autoCheck);
			updateManager.alertTitle = "Airbob"
			
			logger.debug("check for version: " + model.settings.updateUrl);
			if (!CheckVersionEvent(event).autoCheck) {
				updateManager.checkForUpdate();
			}
		}
	}
}