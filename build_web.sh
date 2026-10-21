#!/bin/sh
# Build the garden for the web into ./docs, which GitHub Pages serves.
# Flow -> C -> WebAssembly through
# Flow's own `flow wasm`, then swap in the page from web_src/.
#
#   ./build_web.sh                 needs FLOW_HOME (default ~/flow) and emcc
#   python3 -m http.server -d docs  then open http://localhost:8000/?seed=4242
set -e
here=$(cd "$(dirname "$0")" && pwd)
flow_home=${FLOW_HOME:-$HOME/flow}
rm -rf "$here/docs"
"$flow_home/flow" wasm "$here/lsystem_garden.flow" --out "$here/docs" \
    "--emcc-flag=-sEXPORTED_RUNTIME_METHODS=callMain,ccall,ENV" \
    "--emcc-flag=-sEXPORTED_FUNCTIONS=_main,_malloc,_free,_garden_set,_garden_get,_garden_atlas_upload,_garden_atlas_mode"
cp "$here/web_src/index.html" "$here/docs/index.html"
ls -l "$here/docs"
