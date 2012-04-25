package com.darkdukey.ui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import ghostcat.util.core.ClassFactory;
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class GBase extends Sprite
	{
		private var _skin:DisplayObject;
		protected var initComplete:Boolean = false;
		
		public function GBase(skin:* = null, getPropertiesFromSkin:Boolean = true) 
		{
			super();
			
			setSkin(skin, getPropertiesFromSkin);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			init();
		}
		
		protected function init():void 
		{
			
		}
		
		private function removedFromStageHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
		}
		
		public function setSkin(skin:*, getPropertiesFromSkin:Boolean = true):void
		{
			if (skin is String)
			{
				skin = getDefinitionByName(skin as String);
			}
			
			if (skin is Class)
			{
				skin = new ClassFactory(skin);
			}
			
			if (skin is ClassFactory)
			{
				skin = (skin as ClassFactory).newInstance();
			}
			
			//ignore skin of it's already set
			if (_skin == skin)
			{
				return;
			}
			
			if (skin is BitmapData)
			{
				skin = new Bitmap(skin as BitmapData);
			}
			
			//Clean up old content
			if (_skin && _skin.parent == this)
			{
				if (_skin is IGBase)
				{
					(_skin as IGBase).destroy();
				}
				
				if (_skin.parent)
				{
					removeChild(_skin);
				}
			}
			
			//Attach to skin
			if (getPropertiesFromSkin)
			{
				copyPropertiesFromSkin(skin);
			}
			
			_skin = skin;
			
			//Disable mouse
			if (_skin is InteractiveObject)
			{
				(_skin as InteractiveObject).mouseEnabled = false;
			}
			
			initComplete = true;
		}
		
		private function copyPropertiesFromSkin(skin:*):void 
		{
			var oldIndex:int;
			var oldParent:DisplayObjectContainer;
			
			if(skin == null)
			{
				return;
			}
			
			this.x = skin.x;
			this.y = skin.y;
			
			skin.x = skin.y = 0;
			
			if (_skin == null)
			{
				if (skin.parent)
				{
					oldParent = skin.parent;
					oldIndex = skin.parent.getChildIndex(skin);
				}
			}
			
			addChild(skin);
			
			this.visible = skin.visible;
			skin.visible = true;
			this.name = skin.name;
			
			if (oldParent && !(oldParent is Loader) && oldParent != this)
			{
				oldParent.addChildAt(this, oldIndex);
			}
		}
		
		public function destroy():void
		{
			//
		}
		
//-------------Getter & Setter------------------------
		
		public function get skin():DisplayObject 
		{
			return _skin;
		}
		
		public function set skin(value:DisplayObject):void 
		{
			_skin = value;
		}
	}

}





















