package hxbuild;

import sys.io.Process;

class Target {
	
	public static var name: String;

	public static function build(json: Dynamic) {
		return;
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
	
	public static function runProcess(string:String) {
		Sys.println(string);
		
		var process = new Process(string);

		if (process.exitCode() != 0) {
			Sys.println("Error running the process");
		}

		process.close();
	}
	
}