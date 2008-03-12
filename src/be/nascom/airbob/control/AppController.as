package be.nascom.airbob.control
{
	import be.nascom.airbob.commands.ForceBuildCommand;
	import be.nascom.airbob.commands.LoadProjectsCommand;
	
	import com.adobe.cairngorm.control.FrontController;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class AppController extends FrontController
	{
		private var logger:ILogger = Log.getLogger("AppController");
		
		public static const FORCE_BUILD_EVENT:String = "be.nascom.airbob.events.ForceBuildEvent";
		public static const LOAD_PROJECTS_EVENT:String = "be.nascom.airbob.events.LoadProjectsEvent";
		
		public function AppController()
		{
			addCommand(FORCE_BUILD_EVENT, ForceBuildCommand);
			addCommand(LOAD_PROJECTS_EVENT, LoadProjectsCommand);
		}
		
	}
}