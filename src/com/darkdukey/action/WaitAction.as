package com.darkdukey.action 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class WaitAction extends GAction 
	{
		
		private var timer:Timer;
		
		public function WaitAction(delay:Number)
		{
			timer = new Timer(delay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, finish);
		}
		
		override public function start():void 
		{
			super.start();
			
			timer.start();
		}
		
		override public function finish(event:* = null):void 
		{
			super.finish(event);
			
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, finish);
		}
	}

}