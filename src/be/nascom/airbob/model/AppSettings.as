package be.nascom.airbob.model
{		
	[Bindable]
	public class AppSettings
	{				
		public var interval:Number = 5000;
		
		public function AppSettings(data:Object=null){
			if (data!=null) {
				interval = data.config.interval;			   	
			 }
		}
	}
}