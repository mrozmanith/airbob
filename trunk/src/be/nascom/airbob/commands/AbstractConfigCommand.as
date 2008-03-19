package be.nascom.airbob.commands
{
	import be.nascom.air.data.EntityManager;
	import be.nascom.airbob.model.AppModelLocator;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	internal class AbstractConfigCommand {
		private static var logger:ILogger = Log.getLogger("AbstractConfigDelegate");
		
		private const DB_PATH:String = "app-storage:/config.db";	
		
		protected var model:AppModelLocator = AppModelLocator.getInstance();			
		
		protected var entityManager:EntityManager;		
		protected var connection:SQLConnection;
		
		public function prepare():void {
			var dbFile:File = new File(DB_PATH);
			logger.info("open config database " +  dbFile.nativePath);
			if (!dbFile.exists){
				logger.warn("create new config database")
			}
			connection = new SQLConnection();
			connection.open(dbFile);	
			entityManager = new EntityManager();
			entityManager.sqlConnection = connection;
		}

	}
}