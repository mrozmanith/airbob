package be.nascom.airbob.events
{
	import be.nascom.airbob.control.AppController;
	
	import com.adobe.cairngorm.control.CairngormEvent;

	public class LoadConfigEvent extends CairngormEvent 
	{
		public function LoadConfigEvent() 
		{
			super(AppController.LOAD_CONFIG_EVENT);
		}
	}
}