package hxbuild;

class BuildProperties {
	
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

	public var currentConfig: String;
	public var currentTarget: String;

	public function new() {}

	public static function getCurrentConfig(buildProp: BuildProperties): BuildProperties {
		return buildProp.configs
			.get(buildProp.currentConfig);
	}

	public static function getCurrentTarget(buildProp: BuildProperties): BuildProperties {
		return buildProp.targets
			.get(buildProp.currentTarget);
	}

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
			var value = Reflect.getProperty(json, filter);
			
			var filterKey = getLeftPart(filter);
			var filterValue = getRightPart(filter);

			// When got anything else but filter
			if (filterValue == "") {
				continue;
			}

			// If the given filter does not match the filter
			// that's being searched
			if (filterKey != filterName) {
				continue;
			}

			map.set(filterValue, BuildProperties.fromJson(value, false));
		}

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