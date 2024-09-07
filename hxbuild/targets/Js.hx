package hxbuild.targets;

class Js extends Target {
	
	public static var name: String = "js";

	public static function build(json: Dynamic) {
		var out = json.outDir + "/" + (json.outFile ?? json.main + ".js");
		var main = json.main;
		var defines = json.defines != null ? Target.joinDefines(json.defines) : "";
		var command = "haxe -js " + out + " -main " + main + defines;
		Target.runProcess(command);
	}

}