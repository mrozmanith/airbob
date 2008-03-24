package be.nascom.airbob.commands
{
	import be.nascom.airbob.vo.ServerConfig;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class SaveConfigCommand extends AbstractConfigCommand implements ICommand 
	{
		private var logger:ILogger = Log.getLogger("SaveConfigCommand");
		
		public function execute(event:CairngormEvent):void 
		{
			prepare();
			logger.debug("save config");			
			try 
			{		
				entityManager.beginTransaction();
				for each(var config:ServerConfig in model.configs)
				{
					entityManager.save(config);		
				}	
				entityManager.commitTransaction();			
			} 
			catch (error:Error) 
			{
				logger.error(error.message);
				entityManager.rollbackTransaction();
			}
						
		}
		
	}
}