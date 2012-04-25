package com.darkdukey.ui 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class GButtonState 
	{
		private var stateName:String;
		
		public function GButtonState(name:String) 
		{
			stateName = name;
		}
		
		public function startTransition(gButton:GButton):void 
		{
			if (gButton.skin is MovieClip)
			{
				(gButton.skin as MovieClip).gotoAndStop(stateName);
			}
		}
		
	}

}