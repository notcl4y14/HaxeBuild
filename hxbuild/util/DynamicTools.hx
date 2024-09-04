package hxbuild.util;

class DynamicTools {
	
	public static function combine(obj1: Dynamic, obj2: Dynamic) {
		for (n in Reflect.fields(obj2)) {
			if (!Reflect.hasField(obj1, n)) {
				Reflect.setProperty(obj1, n, Reflect.getProperty(obj2, n));
			}
		}
	}
	
}