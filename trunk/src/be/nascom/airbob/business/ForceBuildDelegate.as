package be.nascom.airbob.business
{
	import be.nascom.airbob.commands.ForceBuildCommand;
	import be.nascom.airbob.vo.DashboardProject;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class ForceBuildDelegate 
	{
		private var command:IResponder;
		private var service:HTTPService;
		
		private var project:DashboardProject;

		public function ForceBuildDelegate( command:IResponder ) 
		{
			project = ForceBuildCommand(command).project
			this.service = ServiceLocator.getInstance().getHTTPService("forceBuildService");
			this.command = command;
		}

		public function send():void 
		{		
			this.service.url = project.config.forceBuildUrl + "?operation=build&objectname=CruiseControl+Project%3Aname%3D" + project.name;
			var token:AsyncToken = service.send();
			token.addResponder(command);
		}

	}
}	