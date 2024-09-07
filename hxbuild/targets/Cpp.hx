package hxbuild.targets;

class Cpp extends Target {
	
	public static var name: String = "cpp";

	public static function build(json: Dynamic) {
		var out = json.outDir + "/" + (json.outFile ?? json.main);
		var main = json.main;
		var defines = json.defines ? " " + Target.joinDefines(json.defines) : "";
		var libs = json.libs ? " " + Target.joinLibs(json.libs) : "";
		var command = "haxe -cpp " + out + " -main " + main + defines + libs;
		Target.runProcess(command);
	}

}