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
	import be.nascom.airbob.events.ProjectStateChangedEvent;
	import be.nascom.airbob.view.NotificationWindow;
	import be.nascom.airbob.vo.Project;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class ProjectStateChangedCommand implements ICommand
	{
		private var logger:ILogger = Log.getLogger("ProjectStateChangedCommand");
		
		public function execute(event:CairngormEvent):void
		{
			var project:Project = ProjectStateChangedEvent(event).project;
			if (project.setting.isFavorite) 
			{
				logger.debug("project " + project.name + " changed");
				
				var toaster:NotificationWindow = new NotificationWindow(project);			
				toaster.open(true);	
				var xFrom:Number = Screen.mainScreen.bounds.width - (toaster.width+10);;
				var yFrom:Number;
				var yTo:Number;
				
				if (NativeApplication.supportsSystemTrayIcon)
				{
					yFrom = Screen.mainScreen.bounds.height;
					yTo = Screen.mainScreen.bounds.height - (toaster.height+40);
				} else {
					yFrom = 0;
					yTo = 0 + (toaster.height);
					
				}
				toaster.popup(xFrom, xFrom, yFrom, yTo);
			}
		}	
						
	}	
		
}