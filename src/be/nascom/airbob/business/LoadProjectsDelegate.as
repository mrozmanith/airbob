package be.nascom.airbob.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class LoadProjectsDelegate
	{
		private var command:IResponder;
		private var service:Object;

		public function LoadProjectsDelegate( command:IResponder ) 
		{
			this.service = ServiceLocator.getInstance().getHTTPService("ccTrayService");
			this.command = command;
		}

		public function send():void 
		{		
			var token:AsyncToken = service.send();
			token.addResponder(command);
		}

	}
}