package hxbuild.targets;

class Swf extends Target {
	
	public static var name: String = "swf";

	public static function build(json: Dynamic) {
		var out = json.outDir + "/" + (json.outFile ?? json.main + ".swf");
		var main = json.main;
		var defines = json.defines != null ? Target.joinDefines(json.defines) : "";
		var libs = json.libs ? " " + Target.joinLibs(json.libs) : "";
		var command = "haxe -swf " + out + " -main " + main + defines + libs;
		Target.runProcess(command);
	}

}