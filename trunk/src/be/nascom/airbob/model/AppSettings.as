package be.nascom.airbob.model
{		
	[Bindable]
	public class AppSettings
	{		
		public var rootUrl:String = "http://wombat.int.nascom.be:8080";	
		public var ccTrayUrl:String = rootUrl + "/dashboard/cctray.xml";
		public var forceBuildUrl:String = rootUrl + "/invoke";
		public var interval:Number = 5000;
		
		public function AppSettings(data:Object=null){
			if (data!=null) {
				interval = data.config.interval;
			   	ccTrayUrl = data.config.ccTrayUrl;
			   	forceBuildUrl = data.config.forceBuildUrl;
			 }
		}
	}
}