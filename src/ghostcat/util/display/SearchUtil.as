package ghostcat.util.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;

	/**
	 * Search Util: a collection of functions useful for perform search for the displayObject
	 *
	 * @author flashyiyi
	 *
	 */
	public final class SearchUtil
	{
		/**
		 * Find Child by certain Class
		 * 
		 * @param displayObj objec to perform search on
		 * @param classRef	the class we're looking for
		 * @return
		 *
		 */
		public static function findChildByClass(displayObj:DisplayObject, classRef:Class, depth:int = int.MAX_VALUE):DisplayObject
		{
			if (displayObj is classRef)
				return displayObj;

			if (displayObj is DisplayObjectContainer && !(displayObj is Loader) && depth > 0)
			{
				var child:DisplayObject = findChildByClassIns(displayObj as DisplayObjectContainer, classRef, depth - 1);
				if (child)
					return child;
			}
			return null;
		}

		private static function findChildByClassIns(contain:DisplayObjectContainer, classRef:Class, depth:int = int.MAX_VALUE):DisplayObject
		{
			if (depth > 0)
			{
				var len:int = contain.numChildren;
				var displayObj:DisplayObject
				for (var i:int = 0; i < len; i++)
				{
					displayObj = contain.getChildAt(i);
					if (displayObj is classRef)
						return displayObj;
				}
				for (i = 0; i < len; i++)
				{
					displayObj = contain.getChildAt(i);
					if (displayObj is DisplayObjectContainer && !(displayObj is Loader))
					{
						var child:DisplayObject = findChildByClassIns(displayObj as DisplayObjectContainer, classRef, depth - 1);
						if (child)
							return child;
					}
				}
			}
			return null;
		}

		/**
		 * Find all the children with specific class
		 * 
		 * @param displayObj	objec to perform search on
		 * @param classRef	class we're looking for
		 * @param result	
		 * @return
		 *
		 */
		public static function findChildrenByClass(displayObj:DisplayObject, classRef:Class, depth:int = int.MAX_VALUE, result:Array = null):Array
		{
			if (result == null)
				result = [];

			if (displayObj is classRef)
				result.push(displayObj);

			if (displayObj is DisplayObjectContainer && !(displayObj is Loader) && depth > 0)
				findChildrenByClassIns(displayObj as DisplayObjectContainer, classRef, depth - 1, result);

			return result;
		}

		private static function findChildrenByClassIns(contain:DisplayObjectContainer, classRef:Class, depth:int = int.MAX_VALUE, result:Array = null):void
		{
			if (depth > 0)
			{
				var len:int = contain.numChildren;
				var displayObj:DisplayObject
				for (var i:int = 0; i < len; i++)
				{
					displayObj = contain.getChildAt(i);
					if (displayObj is classRef)
						result.push(displayObj);
				}
				for (i = 0; i < len; i++)
				{
					displayObj = contain.getChildAt(i);
					if (displayObj is DisplayObjectContainer && !(displayObj is Loader))
						findChildrenByClassIns(displayObj as DisplayObjectContainer, classRef, depth - 1, result);
				}
			}
		}

		/**
		 * Find child with specific property
		 * 
		 * Example: You can search for a child with a specific name
		 *
		 * @param displayObject	objec to perform search on
		 * @param property	property we're looking for
		 * @param value	the value of th property, by default we ignore the value
		 * @return
		 *
		 */
		public static function findChildByProperty(displayObj:DisplayObject, property:String, value:* = null, depth:int = int.MAX_VALUE):DisplayObject
		{
			if (displayObj == null)
				return null;

			if (displayObj.hasOwnProperty(property))
			{
				if (value && displayObj[property] == value || value == null)
					return displayObj;
			}

			if (displayObj is DisplayObjectContainer && !(displayObj is Loader) && depth > 0)
			{
				var child:DisplayObject = findChildByPropertyIns(displayObj as DisplayObjectContainer, property, value, depth - 1);
				if (child)
					return child;
			}
			return null;
		}

		private static function findChildByPropertyIns(contain:DisplayObjectContainer, property:String, value:* = null, depth:int = int.MAX_VALUE):DisplayObject
		{
			if (contain == null)
				return null;

			if (depth > 0)
			{
				var len:int = contain.numChildren;
				var displayObj:DisplayObject;

				for (var i:int = 0; i < len; i++)
				{
					displayObj = contain.getChildAt(i);
					if (displayObj && displayObj.hasOwnProperty(property))
					{
						if (value && displayObj[property] == value || value == null)
							return displayObj;
					}
				}
				for (i = 0; i < len; i++)
				{
					displayObj = contain.getChildAt(i);
					if (displayObj && displayObj is DisplayObjectContainer && !(displayObj is Loader))
					{
						var child:DisplayObject = findChildByPropertyIns(displayObj as DisplayObjectContainer, property, value, depth - 1);
						if (child)
							return child;
					}
				}
			}
			return null;
		}

		/**
		 * Find specific objct with specific class from parent
		 * 
		 * @param displayObj	objec to perform search on
		 * @param classRef	class we're looking for
		 * @return
		 *
		 */
		public static function findParentByClass(displayObj:DisplayObject, classRef:Class, depth:int = int.MAX_VALUE):DisplayObject
		{
			if (displayObj is classRef)
				return displayObj;

			if (displayObj.parent && displayObj.parent != displayObj && depth > 0)
				return findParentByClass(displayObj.parent, classRef, depth - 1);

			return null;
		}

		/**
		 * Find all the object of specific class from parent
		 * 
		 * @param displayObj	objec to perform search on
		 * @param classRef	class we're looking for
		 * @param result	the list of objects we find
		 * @return
		 *
		 */
		private static function findParentsByClass(displayObj:DisplayObject, classRef:Class, depth:int = int.MAX_VALUE, result:Array = null):Array
		{
			if (result == null)
				result = [];

			if (displayObj is classRef)
				result.push(displayObj);

			if (displayObj.parent && displayObj.parent != displayObj && depth > 0)
				findParentsByClass(displayObj.parent, classRef, depth - 1, result);

			return result;
		}

		/**
		 * Find a object with specific property from parent
		 *
		 * @param displayObject	objec to perform search on
		 * @param property	property we're looking for
		 * @param value	the value of the property, it will be ignored by default
		 * @return
		 *
		 */
		public static function findParentByProperty(displayObj:DisplayObject, property:String, value:* = null, depth:int = int.MAX_VALUE):DisplayObject
		{
			if (displayObj == null)
				return null;

			if (displayObj.hasOwnProperty(property))
			{
				if (value && displayObj[property] == value || value == null)
					return displayObj;
			}

			if (displayObj.parent && displayObj.parent != displayObj && depth > 0)
				return findParentByProperty(displayObj.parent, property, value, depth - 1);

			return null;
		}

		/**
		 * Set property for all the children
		 * 
		 * Example: you can set mouseEnable = false for all the children
		 *
		 * @param displayObject	objec to perform search on
		 * @param property	the property to set
		 * @param value
		 * @return
		 *
		 */
		public static function setPropertyByChild(displayObj:DisplayObject, property:String, value:*, depth:int = int.MAX_VALUE):void
		{
			if (displayObj == null)
				return;

			if (displayObj.hasOwnProperty(property))
				displayObj[property] = value;

			if (displayObj is DisplayObjectContainer && !(displayObj is Loader) && depth > 0)
			{
				var displayObjectContainer:DisplayObjectContainer = DisplayObjectContainer(displayObj);
				for (var i:int = 0; i < displayObjectContainer.numChildren; i++)
					setPropertyByChild(displayObjectContainer.getChildAt(i), property, value, depth - 1);
			}
		}

		/**
		 * Set property for all the parents
		 *
		 * @param displayObject	objec to perform search on
		 * @param property
		 * @param value	
		 * @return
		 *
		 */
		public static function setPropertyByParent(displayObj:DisplayObject, property:String, value:*, depth:int = int.MAX_VALUE):void
		{
			if (displayObj == null)
				return;

			if (displayObj.hasOwnProperty(property))
				displayObj[property] = value;

			if (displayObj.parent && displayObj.parent != displayObj && depth > 0)
				setPropertyByParent(displayObj.parent, property, value, depth - 1);
		}
	}
}