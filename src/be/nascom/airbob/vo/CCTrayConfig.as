package be.nascom.airbob.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	
	import flash.events.EventDispatcher;
		
	[Bindable]
	public class CCTrayConfig extends EventDispatcher implements ValueObject
	{
		public var url:String;	
		
		public function get ccTrayUrl():String {
			return url + "/dashboard/cctray.xml";
		}
		
		public function get forceBuildUrl():String {
			return url + "/invoke";
		}
		
		public function CCTrayConfig(url:String) {
			this.url = url;			
		}
	}
}