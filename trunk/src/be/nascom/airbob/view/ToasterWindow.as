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

package be.nascom.airbob.view
{
	import be.nascom.airbob.vo.Project;
	
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.Window;
	import mx.effects.Fade;
	import mx.effects.Move;
	import mx.events.EffectEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class ToasterWindow extends Window
	{
		private var logger:ILogger = Log.getLogger("ToasterWindow");
		
		private var windowWidth:Number = 200;
		private var windowHeight:Number = 46;
		
		private var popUpEffect:Move;
		private var fadeOutEffect:Fade;
		
		public function ToasterWindow(project:Project)
		{
			super();					
			
			initEffects();
			
			// Set window properties
			this.type = NativeWindowType.LIGHTWEIGHT;
			this.showStatusBar = false;
			this.showTitleBar = false;
			this.showGripper = false;
			this.systemChrome = "none";
			this.transparent = true;
			this.height = windowHeight;
			this.width = windowWidth;
			this.resizable = false;
			this.maximizable = false;
			this.minimizable = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";				
			this.alwaysInFront = true;							
			
			// Add the content
			var content:ToasterWindowView = new ToasterWindowView();
			content.project = project;
			content.addEventListener(MouseEvent.CLICK, handleClick);			
			addChild(content);			
			
		}
		
		public function popup(xFrom:Number, xTo:Number, yFrom:Number, yTo:Number):void
		{
			popUpEffect.xFrom = xFrom; 
			popUpEffect.xTo = xTo;
			popUpEffect.yTo = yTo;
			popUpEffect.yFrom = yFrom;
			popUpEffect.play();
		}
		
		private function initEffects():void
		{
			popUpEffect = new Move(this);
			popUpEffect.duration = 1000;
			
			fadeOutEffect = new Fade(this);
			fadeOutEffect.duration = 1000;
			fadeOutEffect.alphaFrom = 1;
			fadeOutEffect.alphaTo = 0;
			fadeOutEffect.addEventListener(EffectEvent.EFFECT_END, closeWindow);
			
			var timer:Timer = new Timer(5000);			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onTimer(event:TimerEvent):void 
		{
			fadeOutEffect.play();			
		}	
		
		private function handleClick(event:MouseEvent):void 
		{
			fadeOutEffect.play();		
		}	
		
		private function closeWindow(event:Event):void 
		{
			this.close();
		}	
		
	}
}