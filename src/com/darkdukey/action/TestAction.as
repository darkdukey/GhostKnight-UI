package com.darkdukey.action 
{
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class TestAction extends GAction 
	{
		private var message:String;
		
		public function TestAction(pMessage:String) 
		{
			message = pMessage;
		}
		
		override public function start():void 
		{
			super.start();
			
			trace(message + new Date());
			
			finish();
		}
	}

}