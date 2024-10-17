package hxbuild;

class PropertyJoiner {
	
	// Rules for joining:
	// 1. If the value is an array - add new elements from it
	// 2. If the value is null - skip
	// 3. Otherwise - override
	// -  1. If it also contains variables like ${outDir} - take from dest and replace the value with it,
	//       like: "${outDir}/hl" + outDir:"build" -> "build/hl"
	public static function join(dest: BuildProperties, source: BuildProperties): Void {

		for (field in Reflect.fields(source)) {
			var prop = Reflect.getProperty(source, field);

			if (prop is Array) {
				var sourceArray: Array<String> = prop;
				var destArray: Array<String> = Reflect.getProperty(dest, field);
				var newArray = destArray == null ? sourceArray : sourceArray.concat(destArray);

				Reflect.setProperty(dest, field, newArray);
			} else if (prop == null) {
				continue;
			} else {
				var newProp: String = cast (prop, String);
				newProp = replaceStrings(newProp, dest);
				Reflect.setProperty(dest, field, newProp);
			}
		}

	}

	static function replaceStrings(str: String, buildProp: BuildProperties): String {
		var newStr: String = str;

		// TODO: make this automatically get any property
		newStr = StringTools.replace(newStr, "${outDir}", buildProp.outDir);

		// if (ignoreColons) {
		// 	return newStr;
		// }

		// newStr = StringTools.replace(newStr, "${outDir:config}",
		// 	replaceStrings(newStr, BuildProperties.getCurrentConfig(buildProp), true));
		// newStr = StringTools.replace(newStr, "${outDir:target}",
		// 	replaceStrings(newStr, BuildProperties.getCurrentTarget(buildProp), true));
		
		return newStr;
	}
}