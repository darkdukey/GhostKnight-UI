package com.darkdukey
{
	import com.darkdukey.action.GActionQueue;
	import com.darkdukey.action.TestAction;
	import com.darkdukey.action.WaitAction;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class Main extends Sprite 
	{
		private var test:Sprite;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var testPanel:TestPanel = new TestPanel();
			testPanel.x = stage.stageWidth / 2;
			testPanel.y = stage.stageHeight / 2;
			
			addChild(testPanel);
			
			new GActionQueue([
				new TestAction("Start Waiting  "),
				new WaitAction(3000),
				new TestAction("Finish Waiting  ")
			]).start();
		}
		
	}
	
}