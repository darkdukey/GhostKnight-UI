package com.darkdukey.action 
{
	import flash.events.EventDispatcher;
	[Event(name = "action_start", type = "com.darkdukey.action.ActionEvent")]
	[Event(name = "action_complete", type = "com.darkdukey.action.ActionEvent")]
	[Event(name = "action_error", type = "com.darkdukey.action.ActionEvent")]
	
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class GAction extends EventDispatcher
	{
		public static const CREATED:int = 0;
		public static const WAIT:int = 1;
		public static const RUN:int = 2;
		public static const FINISH:int = 3;
		
		private var _status:int = 0;
		
		public function GAction() 
		{
			
		}
		
		/**
		 * Make sure super.start() is called otherwise ACTION_START will not trigger
		 */
		public function start():void
		{
			//Send start event
			var e:ActionEvent = new ActionEvent(ActionEvent.ACTION_START);
			dispatchEvent(e);
			
			_status = RUN;
		}
		
		public function update():void
		{
			//
		}
		
		public function finish(event:* = null):void
		{
			//
			var e:ActionEvent = new ActionEvent(ActionEvent.ACTION_COMPLETE);
			dispatchEvent(e);
			
			_status = FINISH;
		}
		
		public function error(event:* = null):void
		{
			var e:ActionEvent = new ActionEvent(ActionEvent.ACTION_ERROR);
			dispatchEvent(e);
			
			_status = FINISH;
		}
		
		public function get status():int 
		{
			return _status;
		}
	}

}

















