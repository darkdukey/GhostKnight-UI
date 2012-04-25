package com.darkdukey.ui 
{
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class GUIBase extends GBase 
	{
		
		public function GUIBase(skin:* = null, getPropertiesFromSkin:Boolean = true )
		{
			super(skin, getPropertiesFromSkin);
		}
		
		override public function setSkin(skin:*, getPropertiesFromSkin:Boolean = true):void 
		{
			if (initComplete)
			{
				UIBuilder.destroy(this);
			}
			
			super.setSkin(skin, getPropertiesFromSkin);
			
			UIBuilder.build(this);
		}
		
		override public function destroy():void 
		{
			UIBuilder.destroy(this);
			
			super.destroy();
		}
	}

}