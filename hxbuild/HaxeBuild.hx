package hxbuild;

import sys.io.Process;
import sys.io.File;
import haxe.Json;
import hxbuild.util.DynamicTools;

class HaxeBuild {
	
	static function usage(): Void {
		var usage = [
			"HaxeBuild",
			"",
			"build [target] [config] - builds project with specified target and config",
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
		var target = target ?? json.target;

		switch (target) {
			case "cpp":
				Target.build( json, hxbuild.targets.Cpp.flag );
			
			case "hl":
				Target.build( json, hxbuild.targets.Hl.flag );

			case "js":
				Target.build( json, hxbuild.targets.Js.flag );

			case "swf":
				Target.build( json, hxbuild.targets.Swf.flag );
			
			default:
				if (target == null) {
					Sys.println("No target specified");
				} else {
					Sys.println("No such target \"" + target + "\"");
				}

				return;
		}

		var path = json.outDir;
		var include: Array<String> = json.include;

		if (include.length == 0) {
			return;
		}

		if (path == null) {
			Sys.println("Cannot include a file/folder without outDir specified");
			return;
		}

		for (itemName in include) {
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
				? cast (item, hx.files.Dir).copyTo("./" + path + "/" + itemName, [MERGE, OVERWRITE])
				: cast (item, hx.files.File).copyTo("./" + path + "/" + itemName, [OVERWRITE]);
		}
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

				var configName: Dynamic = args[2] ?? Reflect.getProperty(json, "defaultConfig") ?? "Release";

				var defaultTarget: Dynamic = Reflect.getProperty(json, "default");
				var config: Dynamic = Reflect.getProperty(json.configs, configName);

				DynamicTools.combine(jsonTarget, defaultTarget);
				DynamicTools.combine(jsonTarget, config);

				trace(jsonTarget);

				build(jsonTarget, jsonTarget.target);
		}
	}

}