# HaxeBuild

HaxeBuild (or HxBuild) is a build tool for Haxe inspired by C++ build tools like premake.
Currently, it has a few features:
- Different combinations with Configs and Releases
- Automatic copying the included files/directories with `include`
- Installing libraries the hxbuild.json file contains (the ones in configs/targets should be specified with `--config` and/or `--target`)
- Exporting to .hxml file
- Getting the initial `outDir` value from config/target via `${outDir}`
	+ Example: `"outDir": "build"`, `"${outDir}" = "build"`, `"${outDir}/hl" -> "build/hl"`

## Configuring
1. Create `hxbuild.json` file in the source directory of the project
2. Add the properties. Example:
```json
{
	"main": "MainClass",

	"outDir": "build",
	"outFile": "Project",

	"configs:Release": {
		"defines": "Release"
	},

	"targets:HashLink": {
		"target": "hl",
		"outDir": "${outDir}/build"
	}
}
```
3. Type in `haxelib run hxbuild build --config Release --target HashLink` to run the project

## Tags
- `main` - Main class
- `classpath` - Class path (directory that contains all the classes)
- `include` (array) - Files/Directories to be copied to build directory
- `defines` (array) - An array of defines (-D)
- `libraries` (array) - An array of libraries (-L)
	+ Can be used to install the libraries with `hxbuild install`
- `configs:(config_name)` (object) - Specified configuration, example names: Release, Debug; Selected with `--config`
- `targets:(target_name)` (object) - Specified target, example names: HashLink, C++; Selected with `--target`
- `target` - Target for Haxe to compile, like: -hl, -cpp, -js, etc.