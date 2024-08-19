# The odin_assimp language binding for the odin language
This repository contains simple language bindings for the [asset importer library (assimp)](https://github.com/assimp/assimp) library to use with the odin language.
Currently, the library supports assimp v5.4.2 down to and including v5.2.2 some older versions may be supported but may not fully work.

## Usage:
Install the assimp library (e.g. `apt install libassimp-dev` on Debian based Systems) or build the
library locally and add the location of the `libassimp.??` library file to the `$PATH` variable.


## Defines
The language binding exposes multiple defines that can be changed using e.g. 
`-define:ASSIMP_API_VERSION="5.2.2"` in the odin build command. The exposed defines are:

| define             | Default Value  | Description | 
| ------------------ | -------------- | ----------- |
| ASSIMP_API_VERSION | "5.2.2"        | Changes the contents of certain structures that were changed in a non-backwards compatible way. |
| ASIMP_DOUBLE_PERCISION | false      | `*` |
| ASSIMP_MAX_FACES_INCIDES | 0x7fff   | `*` |
| ASSIMP_MAX_BONE_WEIGHTS | 0x7fffffff| `*` |
| ASSIMP_MAX_VERTICES | 0x7fffffff    | `*` |
| ASSIMP_MAX_FACES | 0x7fffffff       | `*` |
| ASSIMP_MAX_NUMBER_OF_COLOR_SEATS | 0x8 | `*` |
| ASSIMP_MAX_NUMBER_OF_TEXTURECOORDS | 0x8 | `*` |

`*` == Has the exact same meaning as the corresponding values used for building ASSIMP the defaults are the same as the current ASSIMP defaults

## Note
* These bindings are not fully tested.
* Most structures can be used as intendet and bindings for all functions given in the C-API are provided.
* If you find any issues, abnormalities or have any improvement requests submit a pull request or ask me.
