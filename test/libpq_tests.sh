#!/usr/bin/env bash
# Runs PostgreSQL's client tests with the translated libpq (macOS).
#
# The V module libpq is built as the shared library libpq.5.dylib, and put in
# place of the C library under a copy of a PostgreSQL installation. Then:
#   - the regression suite (`make installcheck-parallel`: psql runs 231 SQL
#     test files and compares their output),
#   - libpq_pipeline (the tests of src/test/modules/libpq_pipeline, and the
#     protocol traces they are expected to produce),
#   - the connection URI tests of src/interfaces/libpq/t/001_uri.pl,
#   - pgbench in the simple, extended and prepared query modes.
#
# usage: test/libpq_tests.sh [c]   (c: the same tests with the C library)
#
# Environment:
#   PG_SRC      PostgreSQL 18.6 source tree
#   PG_BUILD    a build of it (configured like translate/translate.sh does, and
#               `make`, `make -C src/test/regress`,
#               `make -C src/test/modules/libpq_pipeline`,
#               `make -C src/interfaces/libpq/test`)
#   PG_INSTALL  its `make install` prefix
#   PGHOST, PGPORT, PGUSER: a running server (trust authentication). The
#               regression suite needs the extensions of `make -C contrib install`.
#   WORK        work directory (default: ./work)
#   V           (default: v)
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
repo=$(cd "$here/.." && pwd)
: "${PG_SRC:?}" "${PG_BUILD:?}" "${PG_INSTALL:?}"
export PGHOST=${PGHOST:-localhost} PGPORT=${PGPORT:-5432} PGUSER=${PGUSER:-postgres}
V=${V:-v}
WORK=${WORK:-$PWD/work}
which=${1:-v}
mkdir -p "$WORK"
WORK=$(cd "$WORK" && pwd)

# relink <binary> <libpq.5.dylib>: makes a binary use the given libpq.
relink() {
	local current
	current=$(otool -L "$1" | awk '/libpq.*dylib/ {print $1}')
	if [ -n "$current" ]; then
		install_name_tool -change "$current" "$2" "$1" 2>/dev/null
		codesign -f -s - "$1" 2>/dev/null
	fi
}

install=$WORK/$which-install
lib=$install/lib/libpq.5.dylib
if [ "$which" = v ]; then
	build=$WORK/vbuild
	mkdir -p "$build"
	# V compiles a shared library with -fvisibility=hidden, and can give the C
	# variadic functions (which keep their C names) static linkage: rerun its C
	# compiler command without the option, with libpq's functions made public.
	"$V" -old-compiler -w -shared -showcc -keepc -o "$build/libpq" "$repo/libpq" >"$build/build.log" 2>&1 ||
		{ tail -20 "$build/build.log"; exit 1; }
	rsp=$(grep -o "@[^ ']*\.rsp" "$build/build.log" | head -1 | tr -d "@'")
	sed 's/ -fvisibility=hidden//' "$rsp" >"$build/cc.rsp"
	csrc=$(grep -o '"[^"]*\.tmp\.so\.c"' "$build/cc.rsp" | tr -d '"')
	for name in $(grep -v '^#' "$PG_SRC/src/interfaces/libpq/exports.txt" | awk '{print $1}'); do
		sed -i '' "s/^VV_LOC \(.*[ *]\)$name(/VV_EXP \1$name(/" "$csrc"
	done
	cc @"$build/cc.rsp" >"$build/cc.log" 2>&1 || { grep error "$build/cc.log" | head; exit 1; }
	rm -rf "$install"
	cp -R "$PG_INSTALL" "$install"
	cp "$build/libpq.dylib" "$lib"
	install_name_tool -id "$lib" "$lib"
	codesign -f -s - "$lib" 2>/dev/null
	for bin in "$install"/bin/*; do
		relink "$bin" "$lib"
	done
else
	install=$PG_INSTALL
	lib=$install/lib/libpq.5.dylib
fi
echo "libpq: $lib"

echo "== regression suite"
relink "$PG_BUILD/src/test/regress/pg_regress" "$lib"
(cd "$PG_BUILD/src/test/regress" && make installcheck-parallel bindir="$install/bin" >"$WORK/regress-$which.log" 2>&1) || true
grep -E "tests (passed|failed)|All [0-9]+ tests|of [0-9]+ tests|Bail out" "$WORK/regress-$which.log" | tail -1 || true

echo "== libpq_pipeline"
bin=$WORK/pipeline-$which/libpq_pipeline
mkdir -p "$WORK/pipeline-$which/traces"
cp "$PG_BUILD/src/test/modules/libpq_pipeline/libpq_pipeline" "$bin"
relink "$bin" "$lib"
# A new database, as the TAP test uses a new cluster.
db=pipeline_$which
"$install/bin/psql" -X -q -d postgres -c "SET client_min_messages = warning" -c "DROP DATABASE IF EXISTS $db" -c "CREATE DATABASE $db"
conn="dbname=$db"
expected=$PG_SRC/src/test/modules/libpq_pipeline/traces
pass=0
fail=0
for t in $("$bin" tests); do
	args=(-r 700)
	trace=
	case $t in
	simple_pipeline | nosync | multi_pipelines | prepared | singlerow | pipeline_abort | pipeline_idle | transaction | disallowed_in_pipeline)
		trace=$WORK/pipeline-$which/traces/$t.trace
		args+=(-t "$trace")
		;;
	esac
	if "$bin" "${args[@]}" "$t" "$conn max_protocol_version=latest" >"$WORK/pipeline-$which/$t.out" 2>&1; then
		pass=$((pass + 1))
	else
		fail=$((fail + 1))
		echo "FAIL: $t"
	fi
	if [ -n "$trace" ] && [ -s "$expected/$t.trace" ]; then
		if diff -q "$expected/$t.trace" "$trace" >/dev/null; then
			pass=$((pass + 1))
		else
			fail=$((fail + 1))
			echo "TRACE MISMATCH: $t"
		fi
	fi
done
if "$bin" cancel "$conn max_protocol_version=3.0" >"$WORK/pipeline-$which/cancel30.out" 2>&1; then
	pass=$((pass + 1))
else
	fail=$((fail + 1))
	echo "FAIL: cancel (protocol 3.0)"
fi
echo "$pass passed, $fail failed"

echo "== connection URIs"
bin=$WORK/uri-$which/libpq_uri_regress
mkdir -p "$WORK/uri-$which"
cp "$PG_BUILD/src/interfaces/libpq/test/libpq_uri_regress" "$bin"
relink "$bin" "$lib"
perl "$here/uri_tests.pl" "$bin" "$PG_SRC/src/interfaces/libpq/t/001_uri.pl"

echo "== pgbench"
"$install/bin/psql" -X -q -d postgres -c "SET client_min_messages = warning" -c "DROP DATABASE IF EXISTS pgbench_$which" -c "CREATE DATABASE pgbench_$which"
"$install/bin/pgbench" -q -i -s 10 "pgbench_$which" >/dev/null 2>&1
for mode in simple extended prepared; do
	"$install/bin/pgbench" -M "$mode" -c 8 -j 4 -T 10 "pgbench_$which" 2>&1 |
		awk -v m="$mode" '/failed transactions/ {f=$0} /^tps/ {t=$3} END {print m ": " t " tps, " f}'
done
