package com.darkdukey.action 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class ActionEvent extends Event 
	{
		public static const ACTION_START:String = "action_start";
		
		public static const ACTION_COMPLETE:String = "action_complete";
		
		public static const ACTION_ERROR:String = "action_error";
		
		public function ActionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new ActionEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ActionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}