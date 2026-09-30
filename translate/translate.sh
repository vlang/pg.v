#!/usr/bin/env bash
# Translates PostgreSQL's client library (libpq) to the V module `libpq` with c2v.
#
# usage: translate/translate.sh
#
# Environment:
#   PG_SRC  PostgreSQL source tree, e.g. postgresql-18.6 (required)
#   C2V     c2v executable (default: c2v)
#   WORK    work directory (default: ./work)
#   OUT     directory for the V module (default: the libpq directory of this repository)
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
: "${PG_SRC:?set PG_SRC to the PostgreSQL source tree (postgresql-18.6)}"
PG_SRC=$(cd "$PG_SRC" && pwd)
C2V=${C2V:-c2v}
WORK=${WORK:-$PWD/work}
OUT=${OUT:-$here/../libpq}
mkdir -p "$WORK"
WORK=$(cd "$WORK" && pwd)

# 1. Configure PostgreSQL, for pg_config.h and the other generated headers.
#    - No optional libraries: the translation uses none (so no TLS).
#    - pgac_cv__builtin_op_overflow=no: common/int.h uses its portable overflow
#      checks instead of the compiler's type-generic builtins.
config=$WORK/config
if [ ! -f "$config/src/include/pg_config.h" ]; then
	mkdir -p "$config"
	(
		cd "$config"
		pgac_cv__builtin_op_overflow=no "$PG_SRC/configure" --without-icu --without-readline \
			--without-openssl --without-zlib --without-zstd --without-lz4 --without-libcurl >configure.log
		make -C src/port pg_config_paths.h >/dev/null
	)
fi

# 2. The C project: the files libpq.so is linked from (and pg_bitutils.c, for
#    the static inline functions of port/pg_bitutils.h), unmodified.
project=$WORK/libpq # the directory name prefixes the names of C statics
rm -rf "$project"
mkdir -p "$project"
while read -r path; do
	cp "$PG_SRC/$path" "$project/"
	basename "$path" >>"$project/sources.txt"
done <"$here/sources.txt"

# The flags of `make -C src/interfaces/libpq`. -U__ARM_NEON selects the portable
# code of port/simd.h instead of Arm vector intrinsics.
cat >"$project/c2v.toml" <<EOF
[project]
output_dirname = "out"
additional_flags = "-I$PG_SRC/src/interfaces/libpq -I$config/src/include -I$PG_SRC/src/include -I$PG_SRC/src/common -I$PG_SRC/src/port -I$config/src/port -DFRONTEND -D_REENTRANT -D_THREAD_SAFE -DSO_MAJOR_VERSION=5 -U__ARM_NEON"
single_module = true
generate_stubs = false
require_no_stubs = true
source_manifest = "sources.txt"
skip_comments = true
module_name = "libpq"

['fe-auth-oauth.c']
additional_flags = "-DUSE_DYNAMIC_OAUTH"

['jsonapi.c']
additional_flags = "-DJSONAPI_USE_PQEXPBUFFER"
EOF

# 3. Translate.
(cd "$project" && "$C2V" "$project")
mkdir -p "$OUT"
rm -f "$OUT"/*.v
cp "$project"/out/*.v "$OUT/"
echo "libpq translated to $OUT"
