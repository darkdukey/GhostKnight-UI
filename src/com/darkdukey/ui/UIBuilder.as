package com.darkdukey.ui 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.SearchUtil;
	import ghostcat.util.ReflectUtil;
	
	/**
	 * ...
	 * @author Nite Luo
	 */
	public final class UIBuilder 
	{
		
		public function UIBuilder()
		{
			//TODO throw error
		}
		
		public static function build(target:GBase):void
		{
			//Get children from skin class
			var displayClasses:Array = SearchUtil.findChildrenByClass(target.skin, InteractiveObject);
			
			//Get list of class types from target class, so we can initialize the right class according to the children name in the skin
			var functionClasses:Object = ReflectUtil.getPropertyTypeList(target, true);
			
			//Link display objects in the skin with the code
			for (var i:int = 0; i < displayClasses.length; i++ )
			{
				var child:DisplayObject = displayClasses[i] as DisplayObject;
				var name:String = child.name;
				
				//Get the type of functionClass if definition with the same name is found
				if (functionClasses[name])
				{
					//Get object type for 
					var ref:ClassFactory = new ClassFactory(functionClasses[name] as Class);
					
					if (ref)
					{
						//
						if (!ref.params)
						{
							ref.params = [];
						}
					}
					
					var displayObj:DisplayObject;
					
					try
					{
						//
						ref.params[0] = child;
						displayObj = ref.newInstance();
					}
					catch (e:ArgumentError)
					{
						//
						displayObj = child;
					}
					
					target[name] = displayObj;
					delete functionClasses[name];
				}
			}
		}
		
		static public function destroy(target:GBase, all:Boolean = false):void 
		{
			var skin:DisplayObject = target.skin;
			var children:Array = SearchUtil.findChildrenByClass(skin, IGBase);
			
			for (var i:int = children.length - 1; i >= 0; i--)
			{
				//
				var obj:DisplayObject = children[i] as DisplayObject;
				
				if (obj is IGBase)
				{
					var name:String = obj.name;
					
					if (all || target.hasOwnProperty(name) && target[name] == obj)
					{
						(obj as IGBase).destroy();
					}
				}
			}
		}
		
		
	}

}
















