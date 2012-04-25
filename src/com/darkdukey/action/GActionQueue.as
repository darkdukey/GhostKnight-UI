package com.darkdukey.action 
{
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class GActionQueue extends GAction
	{
		//
		private var elements:Array = [];
		
		public function GActionQueue(pElements:Array = null)
		{
			super();
			
			if (pElements)
			{
				elements = pElements;
			}
		}
		
		public function addAction(action:GAction):void
		{
			elements.push(action);
		}
		
		override public function start():void 
		{
			super.start();
			
			processQueue();
		}
		
		private function processQueue():void 
		{
			if (elements.length > 0)
			{
				//
				var action:GAction = elements[0];
				action.addEventListener(ActionEvent.ACTION_START, childStartHandler);
				action.addEventListener(ActionEvent.ACTION_COMPLETE, nextHandler);
				action.addEventListener(ActionEvent.ACTION_ERROR, nextHandler);
				
				action.start();
			}
			else
			{
				//
				finish();
			}
		}
		
		private function childStartHandler(e:ActionEvent):void 
		{
			//
			var action:GAction = e.currentTarget as GAction;
			
			action.removeEventListener(ActionEvent.ACTION_START, childStartHandler);
		}
		
		private function nextHandler(e:ActionEvent):void 
		{
			//
			var action:GAction = elements[0] as GAction;
			//var action:GAction = e.currentTarget as GAction;
			
			action.removeEventListener(ActionEvent.ACTION_START, childStartHandler);
			action.removeEventListener(ActionEvent.ACTION_COMPLETE, nextHandler);
			action.removeEventListener(ActionEvent.ACTION_ERROR, nextHandler);
			
			elements.shift();
			
			// process next element
			processQueue();
		}
	}

}



