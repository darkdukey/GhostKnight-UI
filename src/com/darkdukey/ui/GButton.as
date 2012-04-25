package com.darkdukey.ui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Nite Luo
	 */
	public class GButton extends GBase 
	{
		public static const LABEL_UP:String = "up";
		public static const LABEL_OVER:String = "over";
		public static const LABEL_DOWN:String = "down";
		public static const LABEL_DISABLED:String = "disabled";
		
		public static const LABELS:Array = [LABEL_UP, LABEL_OVER, LABEL_DOWN, LABEL_DISABLED];
		
		private const UP:int = 0;
		private const OVER:int = 1;
		private const DOWN:int = 2;
		private const DISABLED:int = 3;
		
		private const upState:GButtonState = new GButtonState("up");
		private const overState:GButtonState = new GButtonState("over");
		private const downState:GButtonState = new GButtonState("down");
		private const disabledState:GButtonState = new GButtonState("disabled");
		
		private var _clip:MovieClip;
		private var _enabled:Boolean = true;
		
		public function GButton(skin:* = null, getPropertiesFromSkin:Boolean = true) 
		{
			super(skin, getPropertiesFromSkin);
		}
		
		override protected function init():void 
		{
			super.init();
			
			addEvents();
			
			switchTo(upState);
		}
		
		override public function destroy():void 
		{
			removeEvents();
			
			super.destroy();
		}
		
		protected function addEvents():void
		{
			//
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			}
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onClick)
		}
		
		protected function removeEvents():void
		{
			//
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function switchTo(state:GButtonState):void
		{
			//
			if (!enabled)
			{
				state = disabledState;
			}
			
			if (state)
			{
				state.startTransition(this);
			}
		}
		
		protected function onClick(e:MouseEvent):void
		{
			trace("Click");
		}
		
		protected function onMouseOut(e:MouseEvent):void 
		{
			//
			switchTo(upState);
		}
		
		protected function onMouseOver(e:MouseEvent):void 
		{
			//
			switchTo(overState);
		}
		
		protected function onMouseUp(e:MouseEvent):void 
		{
			//
			switchTo(upState);
		}
		
		protected function onMouseDown(e:MouseEvent):void 
		{
			//
			switchTo(downState);
		}
		
//---------Getter & Setter------------
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			mouseEnabled = _enabled;
			
			if (_enabled)
			{
				switchTo(upState);
			}
			else
			{
				//
				switchTo(disabledState);
			}
		}
		
	}

}