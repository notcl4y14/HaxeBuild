package hxbuild.targets;

class Hl extends Target {
	
	public static var name: String = "hl";

	public static function build(json: Dynamic) {
		var out = json.outDir + "/" + (json.outFile ?? json.main);
		var main = json.main;
		var command = "haxe -hl " + out + " -main " + main;
		Target.runProcess(command);
	}

}