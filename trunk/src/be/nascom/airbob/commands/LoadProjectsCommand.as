package be.nascom.airbob.commands
{
	import be.nascom.airbob.business.LoadProjectsDelegate;
	import be.nascom.airbob.events.LoadProjectsEvent;
	import be.nascom.airbob.model.AppModelLocator;
	import be.nascom.airbob.vo.CCTrayConfig;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;

	public class LoadProjectsCommand implements ICommand, IResponder
	{
		private var logger:ILogger = Log.getLogger("LoadProjectsCommand");
		
		private var model:AppModelLocator = AppModelLocator.getInstance();
		private var config:CCTrayConfig;
		
		public function execute(event:CairngormEvent):void
		{
			logger.info("Loading projects");
			var delegate : LoadProjectsDelegate = new LoadProjectsDelegate(this);
			config = LoadProjectsEvent(event).config;
			delegate.send(config);	
		}
		
		public function result( rpcEvent : Object ) : void 
		{
			logger.debug(ObjectUtil.toString(rpcEvent));
			if (rpcEvent.result.Projects!=null) {
				if (rpcEvent.result.Projects.Project is ArrayCollection) {
		 			model.update(rpcEvent.result.Projects.Project, config);
	 			} else {
	 				var projects:ArrayCollection = new ArrayCollection();
	 				projects.addItem(rpcEvent.result.Projects.Project);
	 				model.update(projects, config);		 				
	 			}		 
			}										
		}
		
		public function fault( rpcEvent : Object ) : void 
		{
			logger.error(rpcEvent.fault.faultDetail);				
		}
		
	}
}