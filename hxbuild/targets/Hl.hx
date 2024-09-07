package hxbuild.targets;

class Hl extends Target {
	
	public static var name: String = "hl";

	public static function build(json: Dynamic) {
		var out = json.outDir + "/" + (json.outFile ?? json.main);
		var main = json.main;
		var defines = json.defines != null ? Target.joinDefines(json.defines) : "";
		var libs = json.libs ? " " + Target.joinLibs(json.libs) : "";
		var command = "haxe -hl " + out + " -main " + main + defines + libs;
		Target.runProcess(command);
	}

}