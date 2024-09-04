package hxbuild.targets;

class Cpp extends Target {
	
	public static var name: String = "cpp";

	public static function build(json: Dynamic) {
		var out = json.outDir + "/" + (json.outFile ?? json.main);
		var main = json.main;
		var command = "haxe -cpp " + out + " -main " + main;
		Target.runProcess(command);
	}

}