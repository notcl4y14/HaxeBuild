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