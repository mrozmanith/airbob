package be.nascom.airbob.business
{
	import be.nascom.airbob.vo.ServerConfig;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class LoadProjectsDelegate 
	{
		private var logger:ILogger = Log.getLogger("LoadProjectsDelegate");
		
		private var command:IResponder;
		private var service:HTTPService;

		public function LoadProjectsDelegate( command:IResponder ) 
		{
			this.service = ServiceLocator.getInstance().getHTTPService("loadProjectsService");		
			this.command = command;
		}

		public function send(config:ServerConfig):void 
		{		
			logger.debug("calling " + config.ccTrayUrl);
			this.service.url = config.ccTrayUrl;
			var token:AsyncToken = service.send();
			token.addResponder(command);
		}

	}
}