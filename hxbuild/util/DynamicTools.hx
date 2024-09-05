package hxbuild.util;

import haxe.Json;

class DynamicTools {
	
	public static function combine(obj1: Dynamic, obj2: Dynamic) {
		for (n in Reflect.fields(obj2)) {

			if (Reflect.hasField(obj1, n) && n == "defines") {
				var definesJson = Reflect.getProperty(obj2, n);
				var newDefinesJson = Reflect.getProperty(obj1, n);

				var defines: Array<String> = Json.parse( Json.stringify(definesJson) );
				var newDefines: Array<String> = Json.parse( Json.stringify(newDefinesJson) );

				for (define in defines) {
					newDefines.push(define);
				}

				newDefinesJson = Json.parse( Json.stringify(newDefines) );

				Reflect.setProperty(obj1, n, newDefinesJson);
			}

			if (!Reflect.hasField(obj1, n)) {
				Reflect.setProperty(obj1, n, Reflect.getProperty(obj2, n));
			}

		}
	}
	
}