package ghostcat.util
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	//import ghostcat.debug.Debug;

	/**
	 * Reflection Util class
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class ReflectUtil
	{
		public var xml:XML;
		public var methods:Array;
		public var propertys:Array;
		public var propertysAccess:Object;
		public var propertysType:Object;
		public var metaDatas:Object;
		
		private static var describeTypeCache:Dictionary = new Dictionary(true);
		
		
		/**
		 * Cache Describe Type results
		 * @param classes
		 * 
		 */
		public static function cacheDescribeTypes(classes:Array):void
		{
			for each (var cls:* in classes)
				getDescribeTypeCache(cls);
		}
		
		public function ReflectUtil(obj:*):void
		{
			obj = getClass(obj);
			describeTypeCache[obj] = this;
			
			//get class detail in xml format
			this.xml = describeType(obj);
			this.metaDatas = {};
			
			var meta:Object;
			meta = parseMetaData(xml.factory[0].metadata);
			if (meta)
				this.metaDatas["this"] = meta;
				
			//list of class methods
			this.methods = [];
			
			for each(var child:XML in xml..method)
			{
				var name:String = child.@name.toString();
				methods.push(name);
			}
			
			//list of properties
			this.propertys = [];
			this.propertysAccess = {};
			this.propertysType = {};
			
			
			for each(child in xml..accessor)
			{
				name = child.@name.toString();
				
				propertys.push(name);
				propertysAccess[name] = child.@access.toString();
				propertysType[name] = getDefinitionByName(child.@type);
				
				meta = parseMetaData(child.metadata);
				if (meta)
					metaDatas[name] = meta;
			}
			
			for each(child in xml..variable)
			{
				name = child.@name.toString();
				
				propertys.push(name);
				propertysType[name] = getDefinitionByName(child.@type);
				
				meta = parseMetaData(child.metadata);
				if (meta)
					metaDatas[name] = meta;
			}
		}
		
		private function parseMetaData(xmlList:XMLList):Object
		{
			var result:Object;
			for each (var m:XML in xmlList)
			{
				if (!result)
					result = {};
				
				var o:Object = {}; 
				for each (var child:XML in m.*)
				{
					o[child.@key.toString()] = child.@value.toString();
				}
				result[m.@name.toString()] = o;
			}
			return result;
		}
		
		/**
		 * Get Reflection data from cache
		 *  
		 * @param obj	class name or target class or instance
		 * @return 
		 * 
		 */
		public static function getDescribeTypeCache(obj:*):ReflectUtil
		{
			obj = getClass(obj);
			
			var ins:ReflectUtil = describeTypeCache[obj];
			if (!ins)
				ins = new ReflectUtil(obj);
			
			return ins;
		}
		
		/**
		 * Get XML Reflection data for a object
		 * 
		 * @param obj	class name or target class or instance
		 * @return 
		 * 
		 */		
		public static function getDescribeType(obj:*):XML
		{
			return getDescribeTypeCache(obj).xml;
		}
		
		/**
		 * Clear Reflection cache, It will clear the whole cache by default, unless pass in the specific type to clear.
		 * 
		 * @param obj Clean this specific object
		 */		
		public static function clearDescribeTypeCache(obj:*=null):void
		{
			if (obj)
				delete describeTypeCache[obj];
			else
				describeTypeCache = new Dictionary(true);
		}
		
		/**
		 * Get Method list for an object
		 * 
		 * @param obj	class name or target class or instance
		 * @return 
		 * 
		 */		
		public static function getMethodList(obj:*):Object
		{
			var ins:ReflectUtil = getDescribeTypeCache(obj);
			var result:Object = {};
			for each (var s:String in ins.methods)
				result[s] = obj[s];
		
			return result;
		}
		
		/**
		 * Get property list for an object
		 * 
		 * @param obj	class name or target class or instance
		 * @param writeable	wether only returns the writeable properties(ignore the readonly properties)
		 * @return 
		 * 
		 */
		public static function getPropertyList(obj:*,onlyWriteable:Boolean=false):Object
		{
			var ins:ReflectUtil = getDescribeTypeCache(obj);
			var result:Object = {};
			for each (var k:String in ins.propertys)
			{
				if (obj.hasOwnProperty(k))
				{
					if (!onlyWriteable || ins.propertysAccess[k] != "readonly")
						result[k] = obj[k];		
				}
			}
			return result;
		}
		
		/**
		 * Get the class for specific property
		 * 
		 * @param obj	class name or target class or instance
		 * @param property	name of the property
		 * @return 
		 * 
		 */
		public static function getTypeByProperty(obj:*,property:String):Class
		{
			return getDescribeTypeCache(obj).propertysType[property] as Class;
		}
		
		/**
		 * Get the class for all the properties
		 * 
		 * @param obj	class name or target class or instance
		 * @param writeable	ignore the "readonly" properties
		 * @return 
		 * 
		 */
		public static function getPropertyTypeList(obj:*,onlyWriteable:Boolean=false,onlyReadable:Boolean=false):Object
		{
			var ins:ReflectUtil = getDescribeTypeCache(obj);
			if (onlyWriteable)
			{
				var result:Object = {};
				for (var k:* in ins.propertysType)
				{
					if (ins.propertysAccess[k] != "readonly")
						result[k] = ins.propertysType[k];		
				}
				return result;
			}
			else if (onlyReadable)
			{
				result = {};
				for (k in ins.propertysType)
				{
					if (ins.propertysAccess[k] != "writeonly")
						result[k] = ins.propertysType[k];		
				}
				return result;
			}
			else
			{
				return ins.propertys;
			}
		}
		
		/**
		 * Evaluates a script
		 * 
		 * get value for a property
		 * Example 1: eval("items[0].panel.buttonBar[2].text",root)
		 * 
		 * evaluates a function
		 * Example 2：eval("ghostcat.util::Queue.defaultQueue.commit")();
		 * 
		 * @param path	
		 * @param root	root object
		 * 
		 * 
		 * @return 
		 * 
		 */		
		public static function eval(value:String,root:Object=null):*
		{	
			//get the packge name
			var si:int = value.indexOf("::");
			var li:int;
			if (si != -1)
			{
				li = value.indexOf(".",si);
				if (li == -1)
					li = value.length;
				root = getDefinitionByName(value.substr(0,li));
				value = value.substr(li);
			}
			
			var paths:Array = value.split(/\[|\]|\./);
			try
			{
				if (value.charAt(0) > "A" && value.charAt(0) < "Z")
				{
					//find definition if package name is not specified
					root = getDefinitionByName(paths.shift());
				}
					
				for each (var path:String in paths)
				{
					if (!root)
						return null;
					
					if (path == "")
						continue;
					
					var num:Number = Number(path);
					if(isNaN(num))
						root = root[path];
					else
						root = (root is DisplayObjectContainer)?root.getChildAt(int(num)):root[num];
				}
			}
			catch (e:Error)
			{
				trace("Fail to reflect eval:" + value);
				//Debug.trace("REF","反射失败！ReflectManager.eval() "+e.message);
				return null;
			}
			return root;
		}
		
		/**
		 * Get Definition by name
		 * 
		 * @param name	The name of the class
		 * @return 
		 * 
		 */		
		public static function getDefinitionByName(name:String):Class
		{
			if (name == "*")
				name = "Object";
				
			try{
				return flash.utils.getDefinitionByName(name) as Class;
			}catch (e:ReferenceError) {
				trace("Fail to reflect class:" + name);
				//Debug.trace("REF","反射类"+name+"失败！");
			}
			return null;
		}
		
		/**
		 * Get MetaData info for a property
		 * 
		 * Usually MetaData will be deleted after code been compiled.
		 * if you want to keep MetaData, you should add -keep-as3-metadata+=xxx as compiler parameter
		 * 
		 * @param obj	class name or target class or instance
		 * @param property	name of the property, return the class itself by default
		 * @param metaName	name of the metaData, return all the metaData by default
		 * @return 
		 * 
		 */
		public static function getMetaData(obj:*,property:String=null,metaName:String=null):XML
		{
			var xml:XML = getDescribeType(obj);	
			var prop:XML;
			if (property == null)
				prop = xml.factory[0];
			else
				prop = xml..*.(hasOwnProperty("@name") && @name == property)[0];
			
			if (prop)
			{
				if (metaName)
					return prop.metadata.(@name == metaName)[0];
				else
					return prop.metadata[0];
			}
			return null;	
		}
		
		/**
		 * Get MetaData info for a property
		 * 
		 * Usually MetaData will be deleted after code been compiled.
		 * if you want to keep MetaData, you should add -keep-as3-metadata+=xxx as compiler parameter
		 * 
		 * @param obj	class name or target class or instance
		 * @param property	name of the property, return the class itself by default
		 * @param metaName	name of the metaData, return all the metaData by default
		 * @return 
		 * 
		 */
		public static function getMetaDataObject(obj:*,property:String=null,metaName:String=null):Object
		{
			var ins:ReflectUtil = getDescribeTypeCache(obj);
			var metas:Object;
			metas = ins.metaDatas[property ? property : "this"];
			if (!metaName)
				return metas;
			else
				return metas ? metas[metaName] : null;
		}
		
		/**
		 * Get class for object
		 * 
		 * @param obj
		 * @return 
		 */
		public static function getClass(obj:*):Class
		{	
			if (obj == null)
			{
				return null;
			}
			else if (obj is String)
			{
				return getDefinitionByName(obj) as Class
			}
			else if (obj is Class)
			{
				return obj;
			}
			else	
			{
				return obj["constructor"] as Class;
			}
		}
		
		/**
		 * Get the QName
		 * 
		 * @param obj	class name or target class or instance
		 * 
		 */
		public static function getQName(obj:*):QName
		{
			var names:Array = getQualifiedClassName(obj).split("::");
			
			if (names.length == 2)
			{
				return new QName(names[0],names[1]);
			}
			else
			{
				return new QName(null,names[0]);
			}
			
			return null;
		}
	}
}