/*
Copyright (c) 2008 Airbob Contributors.  See:
    http://code.google.com/p/airbob/wiki/ProjectContributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package be.nascom.airbob.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	import com.adobe.utils.StringUtil;
	
	import flash.events.EventDispatcher;
		
	[Bindable]
	[Table(name="serverconfig")]
	public class CruiseControlConfig extends EventDispatcher implements ValueObject 
	{	
		private static const CCTRAY_URL:String = "dashboard/cctray.xml";
		[Id]
		public var id:int = 0;
		public var url:String;	
		public var enabled:Boolean = true;
		
		[Ignore]
		public function get ccTrayUrl():String 
		{	
			return cleanUrl + CCTRAY_URL;
		}
		
		[Ignore]
		public function get forceBuildUrl():String 
		{
			if (cleanUrl.indexOf("8080") > 0)
			{
				return cleanUrl.replace("8080", "8000") + "invoke";
			} 
			else
			{
				return cleanUrl + ":8000";
			}
		}
		
		public function CruiseControlConfig(url:String=null) 
		{						
			this.url = url;			
		}
		
		private function get cleanUrl():String
		{
			if (StringUtil.endsWith(url, "/")) return url;	
			else return url + "/";
		}
	}
}