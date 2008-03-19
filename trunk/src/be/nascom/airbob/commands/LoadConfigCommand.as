package be.nascom.airbob.commands
{
	import be.nascom.airbob.vo.ServerConfig;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class LoadConfigCommand extends AbstractConfigCommand implements ICommand {
		private var logger:ILogger = Log.getLogger("LoadConfigCommand");
		
		public function execute(event:CairngormEvent):void {
			prepare();
			logger.debug("load config");						
			try {		
				model.configs = entityManager.findAll(ServerConfig);		
			} catch (error:Error) {
				logger.error(error.message);				
			}
		}
		
	}
}