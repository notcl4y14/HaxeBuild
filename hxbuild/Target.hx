package hxbuild;

import sys.io.Process;

class Target {
	
	public static var name: String;
	public static var flag: String;

	public static function build(json: Dynamic, flag: String) {
		var out     = json.outDir + "/" + (json.outFile ?? json.main);
		var main    = json.main;
		var defines = json.defines != null ? " " + Target.joinDefines(json.defines) : "";
		var libs    = json.libs != null    ? " " + Target.joinLibs(json.libs)       : "";

		var command = "haxe " + flag + " " + out + " -main " + main + defines + libs;
		Target.runProcess(command);
	}

	public static function joinValues(values: Array<String>, prefix: String) {
		var output = "";

		for (value in values) {
			output += " " + prefix + " " + value;
		}

		return output;
	}

	public static function joinDefines(values: Array<String>) {
		return joinValues(values, "-D");
	}

	public static function joinLibs(values: Array<String>) {
		return joinValues(values, "-lib");
	}
	
	public static function runProcess(string:String) {
		Sys.println(string);
		
		var process = new Process(string);

		if (process.exitCode() != 0) {
			Sys.println("Error running the process");
		}

		process.close();
	}
	
}