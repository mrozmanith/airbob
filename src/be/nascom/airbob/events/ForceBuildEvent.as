package be.nascom.airbob.events
{
	import be.nascom.airbob.control.AppController;
	import be.nascom.airbob.vo.DashboardProject;
	
	import com.adobe.cairngorm.control.CairngormEvent;

	public class ForceBuildEvent extends CairngormEvent 
	{
		private var _project:DashboardProject;
		
		public function ForceBuildEvent(project:DashboardProject) 
		{
			super(AppController.FORCE_BUILD_EVENT);
			_project = project;
		}
		
		public function get project():DashboardProject 
		{
			return _project;
		}
		
	}
}