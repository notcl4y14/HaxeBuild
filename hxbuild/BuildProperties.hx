package hxbuild;

class BuildProperties {

	// Removes the "x:" part leaving only "y" part in "x:y"
	// Example: "config:Release" -> "Release"
	static var rightRegex: EReg = ~/(?!.+:)((?!:).+)/;
	static var leftRegex: EReg = ~/(.+(?=:))/;
	// static var rightRegex: EReg = ~/(?!(.+):)((?!:).*)/;
	// static var leftRegex: EReg = ~/((.+):)(?!:(.*))/;
	
	public var main: String;
	public var target: String;
	
	public var classpath: String;
	public var include: Array<String>;

	public var outFile: String;
	public var outDir: String;

	public var libraries: Array<String>;

	public var defines: Array<String>;

	public var configs: Map<String, BuildProperties>;
	public var targets: Map<String, BuildProperties>;

	public function new() {}

	public static function asString(buildProp: BuildProperties): String {
		return 'main: ${buildProp.main}
target: ${buildProp.target}
classpath: ${buildProp.classpath}
include: ${buildProp.include}
outFile: ${buildProp.outFile}
outDir: ${buildProp.outDir}
libraries: ${buildProp.libraries}
defines: ${buildProp.defines}
configs: ${buildProp.configs} items
targets: ${buildProp.targets} items';
// configs: ${Reflect.fields(buildProp.configs).length} items
// targets: ${Reflect.fields(buildProp.targets).length} items';
	}

	// public static function hasFilter(filter: String, value: String): Bool {}

	public static function fromJson(json: Dynamic, subBuildProp: Bool = true): BuildProperties {
		var buildProp: BuildProperties
			= new BuildProperties();
		
		buildProp.main = json.main;
		buildProp.classpath = json.classpath;
		buildProp.target = json.target;
		buildProp.include = json.include;
		buildProp.outFile = json.outFile;
		buildProp.outDir = json.outDir;
		buildProp.libraries = json.libraries;
		buildProp.defines = json.defines;

		if (!subBuildProp) {
			return buildProp;
		}

		buildProp.configs = BuildProperties.mapBuildProperties(json, "configs");
		buildProp.targets = BuildProperties.mapBuildProperties(json, "targets");

		return buildProp;
	}

	static function mapBuildProperties(json: Dynamic, filterName: String): Map<String, BuildProperties> {
		var map: Map<String, BuildProperties>
			 = new Map();
			 
		for (filter in Reflect.fields(json)) {
			// var key = Reflect.field(json, filter);
			var value = Reflect.getProperty(json, filter);

			// trace("----" + filter + "----");

			// var filterKey = leftRegex.split(filter)[0]; // key without the left part with the colon
			// var filterValue = rightRegex.split(filter)[0];

			var filterKey = getLeftPart(filter);
			var filterValue = getRightPart(filter);

			// var filterName = filters.filter((a) -> keyName == a)[0];

			// When got anything else but filter
			if (filterValue == "") {
				continue;
			}

			// trace(filterKey);
			// trace(filterValue);

			// trace(filterKey == filterName);

			// If the given filter does not match the filter
			// that's being searched
			if (filterKey != filterName) {
				continue;
			}

			// trace(filterValue);
			// trace(value);

			map.set(filterValue, BuildProperties.fromJson(value, false));
		}

		// if (map.get("C++") != null)
		// 	trace(BuildProperties.asString(map.get("C++")));

		return map;
	}

	static function getLeftPart(value: String): String {
		var result: String = "";
		var i: Int = -1;

		while (value.charAt(++i) != "" && value.charAt(i) != ":") {
			result += value.charAt(i);
		}

		return result;
	}

	static function getRightPart(value: String): String {
		var colon: Bool = false;
		var result: String = "";
		var i: Int = -1;

		while (value.charAt(++i) != "") {
			if (colon) result += value.charAt(i);
			if (value.charAt(i) == ":") {
				colon = true;
			}
		}

		return result;
	}

}