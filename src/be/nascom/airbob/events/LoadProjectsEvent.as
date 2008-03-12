package be.nascom.airbob.events
{
	import be.nascom.airbob.control.AppController;
	
	import com.adobe.cairngorm.control.CairngormEvent;

	public class LoadProjectsEvent extends CairngormEvent
	{
		public function LoadProjectsEvent()
		{
			super(AppController.LOAD_PROJECTS_EVENT);
		}
		
	}
}