package com.darkdukey.action 
{
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class GActionGroup extends GAction
	{
		//
		private var elements:Array = [];
		
		private var finishCount:int = 0;
		
		public function GActionGroup(pElements:Array = null)
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
			
			finishCount = 0;
			
			for each(var action:GAction in elements)
			{
				action.addEventListener(ActionEvent.ACTION_START, childStartHandler);
				action.addEventListener(ActionEvent.ACTION_COMPLETE, childCompleteHandler);
				action.addEventListener(ActionEvent.ACTION_ERROR, childErrorHandler);
				action.start();
			}
		}
		
		private function childStartHandler(e:ActionEvent):void 
		{
			var action:GAction = e.currentTarget as GAction;
			
			action.removeEventListener(ActionEvent.ACTION_START, childStartHandler);
		}
		
		private function childCompleteHandler(e:ActionEvent):void 
		{
			var action:GAction = e.currentTarget as GAction;
			
			completeChildAction(action);
		}
		
		private function childErrorHandler(e:ActionEvent):void 
		{
			var action:GAction = e.currentTarget as GAction;
			
			completeChildAction(action);
		}
		
		private function completeChildAction(action:GAction):void 
		{
			action.removeEventListener(ActionEvent.ACTION_START, childStartHandler);
			action.removeEventListener(ActionEvent.ACTION_COMPLETE, childCompleteHandler);
			action.removeEventListener(ActionEvent.ACTION_ERROR, childErrorHandler);
			
			finishCount ++;
			
			if (elements.length == finishCount)
			{
				finish();
			}
		}
	}

}