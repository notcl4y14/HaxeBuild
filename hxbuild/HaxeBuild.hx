package hxbuild;

import sys.io.Process;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

class HaxeBuild {

	// ==== Main ==== //

	static function main(): Void {
		var argsArr: Array<String> = Sys.args();

		#if Haxelib
		if (argsArr.length == 1)
		#else
		if (argsArr.length == 0)
		#end
		{
			usage();
			return;
		}

		var argsMap: Map<String, String>
			= ArgParser.parse(argsArr);
		
		var command = argsArr[0];

		switch (command) {
			case "help" | "usage":
				usage();
			
			case "build":
				build(argsMap);
			
			case "init":
				init();
			
			case "install":
				install(argsMap);
		}
	}

	// ==== Commands ==== //
	
	static function usage(): Void {
		var usage = [
			"HaxeBuild v1.0.1",
			"",
			"GitHub Repo: \033[34mhttps://github.com/notcl4y14/HaxeBuild\033[0m",
			"",
			"help|usage - Shows this list",
			"build \033[90m--target [target] --config [config]\033[0m - Builds project with specified target and config",
			"init - Creates a new hxbuild.json file",
			"install - Installs required libraries from the hxbuild.json file",
			"",
			"build \033[90m-G [output]\033[0m - Specifies what to build of the following:",
			"\tdirect - Directly build the project (default option)",
			"\thxml - Generates a new .hxml file with specified target and config",
			"",
			"install \033[90m--target [target] --config [config]\033[0m - Specifies what config's and/or target's libraries",
			"should be installed"
		];
		
		Sys.println(usage.join("\n"));
	}

	static function build(args: Map<String, String>): Void {
		if (!FileSystem.exists("./hxbuild.json")) {
			Sys.println("ERROR: The current directory doesn't have hxbuild.json file");
			return;
		}

		var hxbuildContent: String = File.getContent("./hxbuild.json");
		var hxbuildJson: Dynamic = Json.parse(hxbuildContent);

		var buildProp: BuildProperties
			= BuildProperties.fromJson(hxbuildJson);
		
		// Sys.println(BuildProperties.asString(buildProp));

		// Joining
		var config = args.get("--config");
		var target = args.get("--target");

		if (config == null) {
			Sys.println("ERROR: Config not specified");
			return;
		}

		if (target == null) {
			Sys.println("ERROR: Target not specified");
			return;
		}

		if (!buildProp.configs.exists(config)) {
			Sys.println("ERROR: No such config as \"" + config + "\"");
			return;
		}

		if (!buildProp.targets.exists(target)) {
			Sys.println("ERROR: No such target as \"" + target + "\"");
			return;
		}

		PropertyJoiner.join(buildProp, buildProp.configs.get(config));
		PropertyJoiner.join(buildProp, buildProp.targets.get(target));

		// Sys.println(BuildProperties.asString(buildProp));

		// Building
		if (args.get("-G") == "hxml") {
			var hxml = Builder.buildHxml(buildProp);
			File.saveContent("./hxbuild.hxml", hxml);
			return;
		}

		Builder.build(buildProp);

		// Including
		if (buildProp.include == null) {
			return;
		}

		for (itemName in buildProp.include) {
			// Check if File/Directory exists
			if (!sys.FileSystem.exists("./" + itemName)) {
				Sys.println("ERROR: No file/folder found \"" + itemName + "\"");
				continue;
			}

			// Get source File/Directory
			var item: Any = sys.FileSystem.isDirectory("./" + itemName)
				? hx.files.Dir.of("./" + itemName)
				: hx.files.File.of("./" + itemName);
			
			// Copy to destination File/Directory
			item is hx.files.Dir
				? cast (item, hx.files.Dir).copyTo("./" + buildProp.outDir + "/" + itemName, [MERGE, OVERWRITE])
				: cast (item, hx.files.File).copyTo("./" + buildProp.outDir + "/" + itemName, [OVERWRITE]);
		}
	}

	static function init(): Void {
		// var json = {
		// 	"main": "Main",

		// 	"outFile": "Main",
		// 	"outDir": "build",
		
		// 	"configs:Release": {
		// 		"defines": ["Release"]
		// 	},
		
		// 	"configs:Debug": {
		// 		"defines": ["Debug"]
		// 	}
		// };

		// var jsonStr = Json.stringify(json, null, "\t");
		var jsonStr = '{
	"main": "Main",

	"outFile": "Main",
	"outDir": "build",

	"configs:Release": {
		"defines": ["Release"],
		"optimize": "On"
	},

	"configs:Debug": {
		"defines": ["Debug"],
		"optimize": "Off"
	}
}';
		Sys.println(jsonStr);
		File.saveContent("hxbuild.json", jsonStr);
	}

	static function install(args: Map<String, String>): Void {
		var hxbuildContent: String = File.getContent("./hxbuild.json");
		var hxbuildJson: Dynamic = Json.parse(hxbuildContent);

		var buildProp: BuildProperties
			= BuildProperties.fromJson(hxbuildJson);

		// Joining
		var config = args.get("--config");
		var target = args.get("--target");

		if (config != null && !buildProp.configs.exists(config)) {
			Sys.println("ERROR: No such config as \"" + config + "\"");
			return;
		}

		if (target != null && !buildProp.targets.exists(target)) {
			Sys.println("ERROR: No such target as \"" + target + "\"");
			return;
		}

		config != null ? PropertyJoiner.join(buildProp, buildProp.configs.get(config)) : null;
		target != null ? PropertyJoiner.join(buildProp, buildProp.targets.get(target)) : null;

		// Installing
		for (library in buildProp.libraries) {
			if (StringTools.contains(library, " ")) {
				Sys.println("ERROR: Library \"" + library + "\" contains a space character(s)");
				continue;
			}

			var cmd: String = "haxelib install " + library;
			Sys.println(cmd);
			
			var process: Process = new Process(cmd);
			var stdout = process.stdout;

			// https://community.haxe.org/t/read-process-output-while-it-is-running/2583/6
			while (true) {
				try {
					var b = stdout.readByte();
					Sys.print(String.fromCharCode(b));
				} catch (e) {
					break;
				}
			}

			var exitCode: Int = process.exitCode();
			
			if (exitCode != 0) {
				Sys.println("ERROR: Haxelib returned an error code: " + exitCode);
			}
			// process.close();
		}
	}

}