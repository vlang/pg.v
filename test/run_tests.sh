#!/usr/bin/env bash
# Runs the tests of module pg (the tests of V's db.pg) against a PostgreSQL
# server on localhost that accepts the user postgres without a password.
#
# usage: test/run_tests.sh [port]  (default 5432)
#
# Environment: V (default: v), VFLAGS (default: -old-compiler -w)
set -euo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)
port=${1:-5432}
V=${V:-v}
VFLAGS=${VFLAGS:--old-compiler -w}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/vmodules/pg"
(cd "$repo" && cp -R ./*.v v.mod libpq "$tmp/vmodules/pg/")
# The tests connect to port 5432.
if [ "$port" != 5432 ]; then
	for f in "$tmp"/vmodules/pg/*_test.v; do
		perl -0pi -e "s/pg\.Config\{ user: 'postgres'/pg.Config{ port: $port, user: 'postgres'/g; s/\n(\s*)user:(\s*)'postgres'\n/\n\1port: $port\n\1user:\2'postgres'\n/g" "$f"
	done
fi
pass=0
fail=0
for f in "$tmp"/vmodules/pg/*_test.v; do
	name=$(basename "$f")
	# shellcheck disable=SC2086
	if out=$(VMODULES="$tmp/vmodules" "$V" $VFLAGS -d network test "$f" 2>&1); then
		pass=$((pass + 1))
		echo "OK   $name"
	else
		fail=$((fail + 1))
		echo "FAIL $name"
		echo "$out" | grep -v notice | grep -iE 'error|assert|fail|panic' | head -10
	fi
done
echo "$pass passed, $fail failed"
[ "$fail" = 0 ]
