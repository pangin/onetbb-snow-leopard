#!/bin/bash
# Build oneTBB 2021.5.0 static for i386/10.6.
. "$(dirname "$0")/common.sh"
VER=2021.5.0
URL="https://github.com/oneapi-src/oneTBB/archive/refs/tags/v${VER}.zip"
SRCDIR="$DEPS_BUILD/oneTBB-${VER}"
cd "$DEPS_BUILD"
[ -f "oneTBB-${VER}.zip" ] || curl -fL -o "oneTBB-${VER}.zip" "$URL"
[ -d "$SRCDIR" ] || unzip -q "oneTBB-${VER}.zip"
# oneTBB 2021.5 dropped 32-bit macOS: no mac32-*.def symbol-export files. For a
# STATIC build the export list is unused, so copy mac64 -> mac32 to satisfy the
# LINK_DEPENDS prerequisite.
cp "$SRCDIR/src/tbb/def/mac64-tbb.def" "$SRCDIR/src/tbb/def/mac32-tbb.def" 2>/dev/null || true
cp "$SRCDIR/src/tbbmalloc/def/mac64-tbbmalloc.def" "$SRCDIR/src/tbbmalloc/def/mac32-tbbmalloc.def" 2>/dev/null || true
cmake -S "$SRCDIR" -B "$DEPS_BUILD/oneTBB-build" \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$DEPS_PREFIX" -DCMAKE_PREFIX_PATH="$DEPS_PREFIX;$MP" \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DBUILD_SHARED_LIBS=OFF \
  -DTBB_TEST=OFF -DTBB_STRICT=OFF
cmake --build "$DEPS_BUILD/oneTBB-build" -j2 && cmake --install "$DEPS_BUILD/oneTBB-build"
rc=$?; echo "TBB-DONE rc=$rc"
[ $rc -eq 0 ] && ls "$DEPS_PREFIX"/lib/libtbb*.a 2>/dev/null
