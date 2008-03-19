package be.nascom.airbob.events
{
	import be.nascom.airbob.control.AppController;
	
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SaveConfigEvent extends CairngormEvent {
		public function SaveConfigEvent() {
			super(AppController.SAVE_CONFIG_EVENT);
		}
	}
}