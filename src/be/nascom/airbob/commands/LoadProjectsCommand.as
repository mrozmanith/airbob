package be.nascom.airbob.commands
{
	import be.nascom.airbob.business.LoadProjectsDelegate;
	import be.nascom.airbob.events.LoadProjectsEvent;
	import be.nascom.airbob.model.AppModelLocator;
	
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
		
		public function execute(event:CairngormEvent):void
		{
			logger.info("Loading projects");
			var delegate : LoadProjectsDelegate = new LoadProjectsDelegate(this);
			delegate.send(LoadProjectsEvent(event).config);	
		}
		
		public function result( rpcEvent : Object ) : void 
		{
			logger.debug(ObjectUtil.toString(rpcEvent));
			if (rpcEvent.result.Projects!=null) {
				if (rpcEvent.result.Projects.Project is ArrayCollection) {
		 			model.update(rpcEvent.result.Projects.Project);
	 			} else {
	 				var projects:ArrayCollection = new ArrayCollection();
	 				projects.addItem(rpcEvent.result.Projects.Project);
	 				model.update(projects);		 				
	 			}		 
			}
			
//		 		var projectCount:int = model.projects.length;
//		 		if (event.result.Projects!=null){
//		 			if (event.result.Projects.Project is ArrayCollection) {
//		 				model.update(event.result.Projects.Project);
//		 			} else {
//		 				var projects:ArrayCollection = new ArrayCollection();
//		 				projects.addItem(event.result.Projects.Project);
//		 				model.update(projects);		 				
//		 			}		 			
//		 		}	
//		 		if (model.projects.length!=projectCount){
//		 			calculateHeight();
//		 		}	 		
		 				 			
										
		}
		
		public function fault( rpcEvent : Object ) : void 
		{
			logger.error(rpcEvent.fault.faultDetail);				
		}
		
	}
}