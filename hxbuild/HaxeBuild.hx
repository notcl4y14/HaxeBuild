package hxbuild;

import sys.io.Process;
import haxe.Json;
import sys.io.File;
import hxbuild.util.DynamicTools;

class HaxeBuild {
	
	static function usage(): Void {
		var usage = [
			"HaxeBuild",
			"",
			"build --project [name] --target [target] - builds, yup",
			"create [name] - creates a new hxbuild.json file"
		];
		
		Sys.println(usage.join("\n"));
	}

	static function create(name: String = "Project"): Void {
		var json = {
			"name": name,
			"outDir": "build",
			"main": "Main"
		};

		var content = Json.stringify(json, null, "\t");

		File.saveContent("./hxbuild.json", content);
	}

	static function build(json: Dynamic, target: String = null) {
		var name = json.name;
		var outDir = json.outDir;
		var outFile = json.outFile;
		var main = json.main;
		var target = target ?? json.target;

		switch (target) {
			case "cpp":
				build_cpp(outDir, main);
			
			case "hl":
				build_hl(outDir, outFile, main);
			
			default:
				if (target == null) {
					Sys.println("No target specified");
				} else {
					Sys.println("No such target \"" + target + "\"");
				}
		}
	}

	static function build_cpp(outDir: String, main: String) {
		var command = "haxe -cpp " + outDir + " -main " + main;

		Sys.println(command);

		var process = new Process(command);

		if (process.exitCode() != 0) {
			Sys.println("Error running the process");
		}

		process.close();
	}

	static function build_hl(outDir:String, outFile: String, main:String) {
		var command = "haxe -hl " + outDir + "/" + (outFile ?? main) + " -main " + main;

		Sys.println(command);

		var process = new Process(command);

		if (process.exitCode() != 0) {
			Sys.println("Error running the process");
		}

		process.close();
	}

	static function main(): Void {
		var args = Sys.args();

		if (args.length == 0) {
			usage();
			return;
		}

		switch (args[0]) {
			case "create":
				create(args[1]);
			
			case "build":
				var content = File.getContent("./hxbuild.json");

				var json: Dynamic = Json.parse(content);
				var buildTarget = args[1] ?? json.defaultTarget;
				var jsonTarget: Dynamic = Reflect.getProperty(json.targets, buildTarget);

				var defaultTarget: Dynamic = Reflect.getProperty(json, "default");
				DynamicTools.combine(jsonTarget, defaultTarget);

				build(jsonTarget, jsonTarget.target);
		}
	}

}