package com.darkdukey 
{
	import com.darkdukey.ui.GBase;
	import com.darkdukey.ui.GButton;
	import com.darkdukey.ui.GUIBase;
	import flash.events.MouseEvent;
	
	import GK.testPanel;
	
	
	
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class TestPanel extends GUIBase 
	{
		public var btn1:GButton;
		public var btn2:GButton;
		public var bkg:GBase;
		public var btn3:GButton;
		
		public function TestPanel() 
		{
			super(new testPanel());
			btn3 = new GButton(testButton);
			
			addChild(btn3);
			btn1.addEventListener(MouseEvent.CLICK, onBtn1);
			btn2.addEventListener(MouseEvent.CLICK, onBtn2);
			btn3.addEventListener(MouseEvent.CLICK, onBtn3);
		}
		
		private function onBtn3(e:MouseEvent):void 
		{
			trace("Click btn3");
		}
		
		private function onBtn2(e:MouseEvent):void 
		{
			trace("Click btn2");
		}
		
		private function onBtn1(e:MouseEvent):void 
		{
			trace("Click btn1");
		}
		
	}

}