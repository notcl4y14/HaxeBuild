package hxbuild;

import Xml.XmlType;
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
	
	public static function buildXml(buildProp: BuildProperties): Xml {
		var xml: Xml = Xml.createElement("project");
		var app: Xml = Xml.createElement("app");
		app.set("main", buildProp.main);
		app.set("file", buildProp.outFile);
		app.set("path", buildProp.outDir);

		xml.addChild(app);

		var source: Xml = Xml.createElement("source");
		source.set("path", buildProp.classpath);

		xml.addChild(source);

		xml_Array(xml, "assets", "path", buildProp.include);
		xml_Array(xml, "haxedef", "name", buildProp.defines);
		xml_Array(xml, "haxelib", "name", buildProp.libraries);

		// var assetsArr: Array<Xml> = [];

		// for (include in buildProp.include) {
		// 	var assets: Xml = Xml.createElement("assets");
		// 	assets.set("path", include);
		// }

		// for (asset in assetsArr) {
		// 	xml.addChild(asset);
		// }

		// var definesArr: Array<Xml> = [];

		// for (_define in buildProp.defines) {
		// 	var define: Xml = Xml.createElement("haxedef");
		// 	define.set("name", _define);
		// }

		// for (define in definesArr) {
		// 	xml.addChild(define);
		// }

		// var haxelibArr: Array<Xml> = [];

		// for (lib in buildProp.defines) {
		// 	var haxelib: Xml = Xml.createElement("haxelib");
		// 	haxelib.set("name", lib);
		// }

		// for (lib in haxelibArr) {
		// 	xml.addChild(lib);
		// }

		return xml;
	}

	static function xml_Array(xmlSource: Xml, xmlName: String, xmlAttrib: String, xmlLoop: Array<String>): Void {
		if (xmlLoop == null) {
			return;
		}

		var xmlArr: Array<Xml> = [];

		for (value in xmlLoop) {
			var newXml: Xml = Xml.createElement(xmlName);
			newXml.set(xmlAttrib, value);
			xmlArr.push(newXml);
		}

		for (val in xmlArr) {
			xmlSource.addChild(val);
		}
	}

}