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
			// if (!sys.Filesystem.exists("./" + itemName)) {
				// Sys.println("ERROR: No file/folder found \"" + itemName + "\"");
				// continue;
			// }

			// var item = sys.FileSystem.isDirectory("./" + itemName)
				// ? hx.files.Dir.of("./" + itemName)
				// : hx.files.File.of("./" + itemName);
			
			var item = hx.files.Dir.of("./" + itemName);

			item.copyTo("./" + path + "/" + itemName, [MERGE, OVERWRITE]);
			
			// item is hx.files.Dir
			// 	? item.copyTo("./" + path + "/" + include, [MERGE, OVERWRITE])
			// 	: item.copyTo("./" + path + "/" + include, [OVERWRITE]);
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