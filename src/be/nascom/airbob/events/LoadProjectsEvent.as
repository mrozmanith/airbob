package be.nascom.airbob.events
{
	import be.nascom.airbob.control.AppController;
	import be.nascom.airbob.vo.CCTrayConfig;
	
	import com.adobe.cairngorm.control.CairngormEvent;

	public class LoadProjectsEvent extends CairngormEvent
	{
		private var _config:CCTrayConfig;
		
		public function get config():CCTrayConfig {
			return _config;
		}
		
		public function LoadProjectsEvent(config:CCTrayConfig)
		{
			super(AppController.LOAD_PROJECTS_EVENT);
			_config = config;
		}
		
	}
}