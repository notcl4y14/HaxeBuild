package hxbuild.util;

import haxe.Json;

class DynamicTools {
	
	public static function combine(obj1: Dynamic, obj2: Dynamic) {
		for (n in Reflect.fields(obj2)) {

			if (!Reflect.hasField(obj1, n)) {
				Reflect.setProperty(obj1, n, Reflect.getProperty(obj2, n));
				continue;
			}

			if (n == "defines" || n == "include") {
				var arrayJson = Reflect.getProperty(obj2, n);
				var newArrayJson = Reflect.getProperty(obj1, n);

				var defines: Array<String> = Json.parse( Json.stringify(arrayJson) );
				var newDefines: Array<String> = Json.parse( Json.stringify(newArrayJson) );

				for (define in defines) {
					newDefines.push(define);
				}

				newArrayJson = Json.parse( Json.stringify(newDefines) );

				Reflect.setProperty(obj1, n, newArrayJson);
			}

		}
	}
	
}