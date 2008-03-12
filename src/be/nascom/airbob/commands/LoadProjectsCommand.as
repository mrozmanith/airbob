package be.nascom.airbob.commands
{
	import be.nascom.airbob.business.LoadProjectsDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;

	public class LoadProjectsCommand implements ICommand, IResponder
	{
		private var logger:ILogger = Log.getLogger("LoadProjectsCommand");
		
		public function execute(event:CairngormEvent):void
		{
			logger.info("Loading cctray.xml");
			var delegate : LoadProjectsDelegate = new LoadProjectsDelegate(this);
			delegate.send();	
		}
		
		public function result( rpcEvent : Object ) : void 
		{
			logger.debug(ObjectUtil.toString(rpcEvent));							
		}
		
		public function fault( rpcEvent : Object ) : void 
		{
			logger.error(rpcEvent.fault.faultDetail);				
		}
		
	}
}