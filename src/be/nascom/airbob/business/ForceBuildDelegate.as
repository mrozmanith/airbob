package be.nascom.airbob.business
{
	import be.nascom.airbob.commands.ForceBuildCommand;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class ForceBuildDelegate
	{
		private var command:IResponder;
		private var service:HTTPService;

		public function ForceBuildDelegate( command:IResponder ) 
		{
			this.service = ServiceLocator.getInstance().getHTTPService("forceBuildService");
			this.service.request["operation"] = "build";
			this.service.request["objectname"] = "CruiseControl+Project%3Aname%3D" + ForceBuildCommand(command).project.name;
			this.command = command;
		}

		public function send():void 
		{		
			var token:AsyncToken = service.send();
			token.addResponder(command);
		}

	}
}	