package be.nascom.airbob.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	
	import flash.events.EventDispatcher;
		
	[Bindable]
	[Table(name="serverconfig")]
	public class ServerConfig extends EventDispatcher implements ValueObject {
		
		[Id]
		public var id:int = 0;
		public var url:String;	
		public var enabled:Boolean = true;
		
		[Ignore]
		public function get ccTrayUrl():String {
			return url + "/dashboard/cctray.xml";
		}
		
		[Ignore]
		public function get forceBuildUrl():String {
			if (url.indexOf("8080") > 0)
			{
				return url.replace("8080", "8000") + "/invoke";
			} 
			else
			{
				return url + ":8000";
			}
		}
		
		public function ServerConfig(url:String=null) {						
			this.url = url;			
		}
	}
}