package hxbuild.util;

abstract Object(String) {

	public var map: Map<String, Any>;

	public function new() {
		this.map = new Map();
	}

	public static function fromDynamic(value: Dynamic) {
		var object: Object = new Object();

		for (n in Reflect.fields(value)) {
			object.map[n] = Reflect.getProperty(value, n);
		}

		return object;
	}

	public function asDynamic() {
		var output: Dynamic = {};

		for (key in this.map.keys()) {
			var value = this.map[key];
			Reflect.setProperty(output, key, value);
		}

		return output;
	}

	@:arrayAccess
	public inline function get(key: String) {
		return this.map[key];
	}

	@:arrayAccess
	public inline function arrayWrite(key: String, value: Any) {
		this.map[key] = value;
		return value;
	}

	// public override extern inline function combine(object: Object);
	// public override extern inline function combine(value: Dynamic);

	public overload extern inline function combine(object: Object) {
		for (key in object.map.keys()) {
			var value = object.map[key];

			if (!this.map.exists(key)) {
				this.map[key] = value;
			}
		}
	}

	public overload extern inline function combine(value: Dynamic) {
		this.combine( Object.fromDynamic(value) );
	}

}