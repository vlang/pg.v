# pg.v

V's PostgreSQL driver [`db.pg`](https://github.com/vlang/v/tree/master/vlib/db/pg),
with its ORM support, on top of [libpq](https://www.postgresql.org/docs/current/libpq.html)
18.6 translated from C to V with [c2v](https://github.com/vlang/c2v). It needs
no C library, no C headers and no `pkg-config`: a program that uses it links
only the system C library and V's garbage collector.

libpq has no amalgamation: the library is built from 41 C files of the
PostgreSQL sources (15 in `src/interfaces/libpq`, 17 in `src/common`, 9 in
`src/port`, 40,783 lines). They are translated, unmodified, into the module
`pg.libpq` (43 files, 65,494 lines of V). No part of it was edited by hand.
It passes PostgreSQL's client tests with the same results as the C library
(see [Tests](#tests)).

## Usage

```
git clone https://github.com/vlang/pg.v ~/.vmodules/pg
```

The module `pg` has the API of `db.pg`: replace `import db.pg` with
`import pg`.

```v
import pg

@[table: 'users']
struct User {
	id   int @[primary; sql: serial]
	name string
	age  int
}

fn main() {
	db := pg.connect(host: 'localhost', user: 'postgres', dbname: 'postgres')!
	defer {
		db.close() or {}
	}
	sql db {
		create table User
	}!
	user := User{
		name: 'alice'
		age:  31
	}
	sql db {
		insert user into User
	}!
	users := sql db {
		select from User where age > 30
	}!
	println(users)
}
```

```
$ v -old-compiler -w run examples/orm.v
1 alice 31
3 carol 45
[Option('3'), Option('34.33')]
```

[`examples/libpq.v`](examples/libpq.v) uses libpq's own API, whose functions
have V names: `libpq.pq_connectdb()` is `PQconnectdb()`,
`libpq.pq_exec_params()` is `PQexecParams()`, and so on.

Notes:

- Build with `-old-compiler`. V's new default compiler needs the fixes of
  [vlang/v#29167](https://github.com/vlang/v/pull/29167) (with them, `db.pg`'s
  tests pass with `-new-compiler` too); without them it falls back to the
  established compiler with a lot of output. `-w` hides V's warnings about the
  translated C code.
- C code is translated for one target: the declarations and constants of the
  system headers (struct layouts, socket options, ...) are those of the machine
  that ran c2v. These files were generated on macOS 26 (arm64, Apple Clang 21).
  For another platform, regenerate them there (below).
- libpq is built without optional libraries: no SSL/TLS (`sslmode=prefer`,
  the default, connects without it, and `sslmode=require` fails), no GSSAPI,
  and no OAuth (its dynamically loaded module `libpq-oauth` is not included).
  Password authentication (SCRAM-SHA-256, MD5), Unix sockets, pipelining,
  `COPY`, `LISTEN`/`NOTIFY`, cancellation and connection service files work.

## Files

- `*.v`: module `pg`, V's `vlib/db/pg` (V 0.5.2, commit b583c01) ported by
  [`translate/port_db_pg.py`](translate/port_db_pg.py): its declarations of
  the C functions of libpq are replaced by V functions with the same
  signatures that call module `pg.libpq`.
- `libpq/`: module `pg.libpq`. `name.v` is the translation of `name.c`.
  The declarations of the headers are in the first file that uses them (the
  types of `libpq-fe.h` are in `fe-auth-oauth.v`). `0_globals.v` has the
  initialized global variables, `0_external.c.v` the declarations of the system
  headers. [`COPYRIGHT`](libpq/COPYRIGHT) is PostgreSQL's license.

## Tests

[`test/run_tests.sh`](test/run_tests.sh) runs the tests of `db.pg` against a
server. [`test/libpq_tests.sh`](test/libpq_tests.sh) builds `pg.libpq` as the
shared library `libpq.5.dylib`, puts it in place of the C library in a copy of
a PostgreSQL installation, and runs PostgreSQL's tests of its clients: the
regression suite (`make installcheck-parallel`: `psql` runs 231 test files of
SQL and their output is compared), the tests of `libpq_pipeline` (including
the protocol traces they must produce), the connection URI tests
(`src/interfaces/libpq/t/001_uri.pl`), and pgbench.

Results on macOS 26 (arm64), V 0.5.2 (b583c01), PostgreSQL 18.6 server:

| test                          | translated libpq       | C libpq                |
|-------------------------------|------------------------|------------------------|
| `db.pg` tests                 | 8 of 8 files pass      | 7 of 8 files pass (\*) |
| regression suite              | 231 of 231 tests pass  | 231 of 231 tests pass  |
| `libpq_pipeline` (and traces) | 23 of 23 pass          | 23 of 23 pass          |
| connection URIs               | 63 of 63 pass          | 63 of 63 pass          |
| pgbench, 8 clients, simple / extended / prepared protocol | 0 failed transactions, 13,300 - 16,300 TPS | 0 failed transactions, 13,300 - 14,100 TPS |

(\*) `test_listen_notify` fails with the C library: `db.pg` reads the channel
name of a notification with `vstring()` (no copy) from memory that it frees
with `PQfreemem()`. The port copies the strings.

The translated library was built without optimizations (no `-prod`). pgbench's
throughput is limited by the server on the same machine: it varies more between
runs than between the two libraries.

## Translating

[`translate/translate.sh`](translate/translate.sh) translates libpq from the
PostgreSQL sources with c2v (commit 03df6a9 or later):

```
curl -O https://ftp.postgresql.org/pub/source/v18.6/postgresql-18.6.tar.bz2
tar xf postgresql-18.6.tar.bz2
PG_SRC=postgresql-18.6 C2V=path/to/c2v translate/translate.sh
```

It configures PostgreSQL (for `pg_config.h`), copies the C files listed in
[`translate/sources.txt`](translate/sources.txt) into a c2v project with the
compiler flags of libpq's Makefile, translates it into one V module, and
replaces `libpq/`. `python3 translate/port_db_pg.py <V>/vlib/db/pg .` ports
`db.pg` again.

## License

Module `pg` (from V's `db.pg`): MIT. Module `pg.libpq`: the
[PostgreSQL License](libpq/COPYRIGHT).
