package be.nascom.airbob.events
{
	import be.nascom.airbob.control.AppController;
	import be.nascom.airbob.vo.ServerConfig;
	
	import com.adobe.cairngorm.control.CairngormEvent;

	public class LoadProjectsEvent extends CairngormEvent 
	{
		private var _config:ServerConfig;
		
		public function get config():ServerConfig 
		{
			return _config;
		}
		
		public function LoadProjectsEvent(config:ServerConfig) 
		{
			super(AppController.LOAD_PROJECTS_EVENT);
			_config = config;
		}
		
	}
}