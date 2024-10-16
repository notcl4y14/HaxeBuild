class Main {
	static function main() {
		trace("Hello World!");
		#if HashLink
		trace("HashLink");
		#elseif CPP
		trace("C++");
		#end

		#if Debug
		trace("Debug");
		#elseif Release
		trace("Release");
		#end
	}
}