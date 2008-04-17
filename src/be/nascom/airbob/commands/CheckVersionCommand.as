package be.nascom.airbob.commands
{
	import be.nascom.air.UpdateManager;
	import be.nascom.airbob.events.CheckVersionEvent;
	import be.nascom.airbob.model.AppModelLocator;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class CheckVersionCommand implements ICommand
	{		
		private var logger:ILogger = Log.getLogger("CheckVersionCommand");
				
		public function execute( event:CairngormEvent ) : void 
		{				
			var model:AppModelLocator = AppModelLocator.getInstance();
			var updateManager:UpdateManager = new UpdateManager(model.settings.updateUrl, CheckVersionEvent(event).autoCheck);
			updateManager.alertTitle = "Airbob"
			
			logger.debug("check for version: " + model.settings.updateUrl);
			if (!CheckVersionEvent(event).autoCheck) {
				updateManager.checkForUpdate();
			}
		}
	}
}