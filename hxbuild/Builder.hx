package hxbuild;

import sys.io.Process;

class Builder {
	
	public static function build(buildProp: BuildProperties): Void {
		var command = "haxe ";

		command += "--main " + buildProp.main;
		command += " --class-path " + buildProp.classpath;
		command += " --" + buildProp.target + " " + buildProp.outDir + "/" + buildProp.outFile;
		command += buildProp.defines == null ? "" : " -D " + buildProp.defines.join(" -D ");
		command += buildProp.libraries == null ? "" : " -L " + buildProp.libraries.join(" -L ");

		Sys.println(command);

		var process: Process = new Process(command);
		var exitCode: Null<Int> = process.exitCode();

		if (exitCode != 0) {
			Sys.println("Error running the process");
		}

		process.close();
	}
	
	public static function buildHxml(buildProp: BuildProperties): String {
		var hxml = "";

		hxml += buildProp.defines == null ? "" : "-D " + buildProp.defines.join("\n-D ") + "\n";
		hxml += buildProp.libraries == null ? "" : "-L " + buildProp.libraries.join("\n-L ") + "\n";
		hxml += "--class-path " + buildProp.classpath + "\n";
		hxml += "--main " + buildProp.main + "\n";
		hxml += "--" + buildProp.target + " " + buildProp.outDir + "/" + buildProp.outFile + "\n";

		return hxml;
	}

}