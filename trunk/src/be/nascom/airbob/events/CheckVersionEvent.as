package be.nascom.airbob.events
{
	import be.nascom.airbob.control.AppController;
	
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class CheckVersionEvent extends CairngormEvent
	{
		public var autoCheck:Boolean;
		
		public function CheckVersionEvent(autoCheck:Boolean=true) 
		{
			this.autoCheck = autoCheck; 
			super( AppController.CHECK_VERSION_EVENT);
		}
	}
}