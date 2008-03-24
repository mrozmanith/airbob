package be.nascom.airbob.commands
{
	import be.nascom.airbob.business.ForceBuildDelegate;
	import be.nascom.airbob.events.ForceBuildEvent;
	import be.nascom.airbob.vo.DashboardProject;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;

	public class ForceBuildCommand implements ICommand, IResponder 
	{
		private var logger:ILogger = Log.getLogger("ForceBuildCommand");
		public var project:DashboardProject;
		
		public function execute(event:CairngormEvent):void 
		{
			project = ForceBuildEvent(event).project;
			logger.info("Force build for " + project.name);
			var delegate : ForceBuildDelegate = new ForceBuildDelegate(this);
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