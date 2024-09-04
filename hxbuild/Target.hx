package hxbuild;

import sys.io.Process;

class Target {
	
	public static var name: String;

	public static function build(json: Dynamic) {
		return;
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