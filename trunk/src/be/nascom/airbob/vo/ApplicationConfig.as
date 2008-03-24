package be.nascom.airbob.vo
{
	[Bindable]
	[Table(name="applicationconfig")]
	public class ApplicationConfig {				
		public var interval:Number = 5000;
		
		public function ApplicationConfig()
		{
			
		}
	}
}