package hxbuild;

class ArgParser {
	
	public static function parse(args: Array<String>): Map<String, String> {
		var result: Map<String, String> = new Map();
		
		var i = 0;

		while (args[++i] != null) {
			var arg: String = args[i];
			var next = args[i + 1];

			if (arg.charAt(0) == "-" && next.charAt(0) == "-") {
				result.set(arg, "");
			} else if (arg.charAt(0) == "-" && next.charAt(0) != "-") {
				i++;
				result.set(arg, next);
			}
		}

		return result;
	}

}