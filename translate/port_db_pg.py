#!/usr/bin/env python3
# Ports V's db.pg from the C libpq to the V translation of libpq (module pg.libpq):
#   port_db_pg.py <V's vlib/db/pg> <destination dir: the root of this repository>
# The C declarations of pg.c.v are replaced by V adapters with the same
# signatures, so that the rest of db.pg only changes `C.PQx(` to `pq_x(`.
import os
import re
import shutil
import sys

src, dst = sys.argv[1], sys.argv[2]
names = [n for n in sorted(os.listdir(src)) if n.endswith('.v')]
for name in names:
    shutil.copyfile(os.path.join(src, name), os.path.join(dst, name))

ADAPTERS = '''// libpq is the V translation of PostgreSQL's C client library (see
// https://github.com/vlang/c2v): db.pg needs no C library and no C headers.
// The functions below adapt its API to the signatures db.pg used for C's.

pub enum ConnStatusType {
	ok                = 0
	bad               = 1
	// Non-blocking mode only below here
	// The existence of these should never be relied upon - they should only be used for user feedback or similar purposes.
	started           = 2  // Waiting for connection to be made.
	made              = 3  // Connection OK; waiting to send.
	awaiting_response = 4  // Waiting for a response from the postmaster.
	auth_ok           = 5  // Received authentication; waiting for backend startup.
	setenv            = 6  // Negotiating environment.
	ssl_startup       = 7  // Negotiating SSL.
	needed            = 8  // Internal state: connect() needed.
	check_writable    = 9  // Check if we could make a writable connection.
	consume           = 10 // Wait for any pending message and consume them.
	gss_startup       = 11 // Negotiating GSSAPI.
}

pub enum ExecStatusType {
	empty_query    = 0 // empty query string was executed
	command_ok     = 1 // a query command that doesn't return anything was executed properly by the backend
	tuples_ok      = 2 // a query command that returns tuples was executed properly by the backend, PGresult contains the result tuples
	copy_out       = 3 // Copy Out data transfer in progress
	copy_in        = 4 // Copy In data transfer in progress
	bad_response   = 5 // an unexpected response was recv'd from the backend
	nonfatal_error = 6 // notice or warning message
	fatal_error    = 7 // query failed
	copy_both      = 8 // Copy In/Out data transfer in progress
	single_tuple   = 9 // single tuple from larger resultset
}

fn pq_connectdb(conninfo &char) &libpq.PGconn {
	return libpq.pq_connectdb(unsafe { &i8(conninfo) })
}

fn pq_status(conn &libpq.PGconn) i32 {
	return i32(libpq.pq_status(conn))
}

fn pq_transaction_status(conn &libpq.PGconn) i32 {
	return i32(libpq.pq_transaction_status(conn))
}

fn pq_error_message(conn &libpq.PGconn) &char {
	return unsafe { &char(libpq.pq_error_message(conn)) }
}

fn pq_exec(conn &libpq.PGconn, query &char) &libpq.PGresult {
	return libpq.pq_exec(conn, unsafe { &i8(query) })
}

fn pq_getisnull(res &libpq.PGresult, row i32, col i32) i32 {
	return i32(libpq.pq_getisnull(res, row, col))
}

fn pq_getvalue(res &libpq.PGresult, row i32, col i32) &char {
	return unsafe { &char(libpq.pq_getvalue(res, row, col)) }
}

fn pq_result_status(res &libpq.PGresult) i32 {
	return i32(libpq.pq_result_status(res))
}

fn pq_ntuples(res &libpq.PGresult) i32 {
	return i32(libpq.pq_ntuples(res))
}

fn pq_nfields(res &libpq.PGresult) i32 {
	return i32(libpq.pq_nfields(res))
}

fn pq_fname(res &libpq.PGresult, col i32) &char {
	return unsafe { &char(libpq.pq_fname(res, col)) }
}

fn pq_ftype(res &libpq.PGresult, col i32) u32 {
	return u32(libpq.pq_ftype(res, col))
}

fn pq_fmod(res &libpq.PGresult, col i32) i32 {
	return i32(libpq.pq_fmod(res, col))
}

fn pq_fsize(res &libpq.PGresult, col i32) i32 {
	return i32(libpq.pq_fsize(res, col))
}

fn pq_fformat(res &libpq.PGresult, col i32) i32 {
	return i32(libpq.pq_fformat(res, col))
}

fn pq_ftable(res &libpq.PGresult, col i32) u32 {
	return u32(libpq.pq_ftable(res, col))
}

fn pq_ftablecol(res &libpq.PGresult, col i32) i32 {
	return i32(libpq.pq_ftablecol(res, col))
}

// Params:
// const Oid *paramTypes
// const char *const *paramValues
// const int *paramLengths
// const int *paramFormats
fn pq_exec_params(conn &libpq.PGconn, command &char, n_params i32, param_types voidptr, param_values voidptr,
	param_lengths voidptr, param_formats voidptr, result_format i32) &libpq.PGresult {
	return libpq.pq_exec_params(conn, unsafe { &i8(command) }, n_params, unsafe { &libpq.Oid(param_types) },
		unsafe { &&u8(param_values) }, unsafe { &i32(param_lengths) }, unsafe { &i32(param_formats) },
		result_format)
}

fn pq_put_copy_data(conn &libpq.PGconn, buffer &char, nbytes i32) i32 {
	return i32(libpq.pq_put_copy_data(conn, unsafe { &i8(buffer) }, nbytes))
}

fn pq_put_copy_end(conn &libpq.PGconn, errmsg &char) i32 {
	return i32(libpq.pq_put_copy_end(conn, unsafe { &i8(errmsg) }))
}

fn pq_get_copy_data(conn &libpq.PGconn, buffer &&char, async i32) i32 {
	return i32(libpq.pq_get_copy_data(conn, unsafe { &&u8(buffer) }, async))
}

fn pq_prepare(conn &libpq.PGconn, stmt_name &char, query &char, n_params i32, param_types voidptr) &libpq.PGresult {
	return libpq.pq_prepare(conn, unsafe { &i8(stmt_name) }, unsafe { &i8(query) }, n_params,
		unsafe { &libpq.Oid(voidptr(param_types)) })
}

fn pq_exec_prepared(conn &libpq.PGconn, stmt_name &char, n_params i32, param_values voidptr,
	param_lengths voidptr, param_formats voidptr, result_format i32) &libpq.PGresult {
	return libpq.pq_exec_prepared(conn, unsafe { &i8(stmt_name) }, n_params, unsafe { &&u8(param_values) },
		unsafe { &i32(param_lengths) }, unsafe { &i32(param_formats) }, result_format)
}

// cleanup

fn pq_clear(res &libpq.PGresult) {
	libpq.pq_clear(res)
}

fn pq_freemem(ptr voidptr) {
	libpq.pq_freemem(ptr)
}

fn pq_finish(conn &libpq.PGconn) {
	libpq.pq_finish(conn)
}

// LISTEN/NOTIFY support
fn pq_notifies(conn &libpq.PGconn) &libpq.PGnotify {
	return libpq.pq_notifies(conn)
}

fn pq_consume_input(conn &libpq.PGconn) i32 {
	return i32(libpq.pq_consume_input(conn))
}

fn pq_socket(conn &libpq.PGconn) i32 {
	return i32(libpq.pq_socket(conn))
}

fn pq_escape_literal(conn &libpq.PGconn, str &char, length usize) &char {
	return unsafe { &char(libpq.pq_escape_literal(conn, &i8(str), length)) }
}
'''

C_NAMES = {
    'PQconnectdb': 'pq_connectdb', 'PQstatus': 'pq_status',
    'PQtransactionStatus': 'pq_transaction_status', 'PQerrorMessage': 'pq_error_message',
    'PQexec': 'pq_exec', 'PQgetisnull': 'pq_getisnull', 'PQgetvalue': 'pq_getvalue',
    'PQresultStatus': 'pq_result_status', 'PQntuples': 'pq_ntuples', 'PQnfields': 'pq_nfields',
    'PQfname': 'pq_fname', 'PQftype': 'pq_ftype', 'PQfmod': 'pq_fmod', 'PQfsize': 'pq_fsize',
    'PQfformat': 'pq_fformat', 'PQftable': 'pq_ftable', 'PQftablecol': 'pq_ftablecol',
    'PQexecParams': 'pq_exec_params', 'PQputCopyData': 'pq_put_copy_data',
    'PQputCopyEnd': 'pq_put_copy_end', 'PQgetCopyData': 'pq_get_copy_data',
    'PQprepare': 'pq_prepare', 'PQexecPrepared': 'pq_exec_prepared', 'PQclear': 'pq_clear',
    'PQfreemem': 'pq_freemem', 'PQfinish': 'pq_finish', 'PQnotifies': 'pq_notifies',
    'PQconsumeInput': 'pq_consume_input', 'PQsocket': 'pq_socket',
    'PQescapeLiteral': 'pq_escape_literal',
}

# Pointer parameters that db.pg passes a literal 0 (C's null pointer) to.
POINTER_ARGS = {'pq_exec_params': [3, 4, 5, 6], 'pq_prepare': [4], 'pq_exec_prepared': [3, 4, 5]}


def null_pointer_args(text):
    out = []
    i = 0
    pattern = re.compile(r'\b(' + '|'.join(POINTER_ARGS) + r')\(')
    while True:
        m = pattern.search(text, i)
        if not m:
            out.append(text[i:])
            break
        out.append(text[i:m.end()])
        # split the arguments at top level commas
        depth, j, args, start = 0, m.end(), [], m.end()
        while True:
            ch = text[j]
            if ch in '([{':
                depth += 1
            elif ch in ')]}':
                if depth == 0:
                    args.append(text[start:j])
                    break
                depth -= 1
            elif ch == ',' and depth == 0:
                args.append(text[start:j])
                start = j + 1
            j += 1
        if text[m.start() - 3:m.start()] == 'fn ':
            out.append(text[m.end():j])
        else:
            for k in POINTER_ARGS[m.group(1)]:
                if k < len(args) and args[k].strip() == '0':
                    args[k] = ' voidptr(0)'
            out.append(','.join(args))
        i = j
    return ''.join(out)


path = os.path.join(dst, 'pg.c.v')
s = open(path).read()
# 1. No C libpq: drop the library discovery and the C headers.
start = re.search(r"\$if \$pkgconfig\s*\(\s*'libpq'\s*\)\s*\{", s).start()
end = s.index('#include "@VMODROOT/vlib/db/pg/compatibility.h"')
end += len('#include "@VMODROOT/vlib/db/pg/compatibility.h"\n')
orm = s.index('// for orm', start)
keep = s[orm:s.index('#include "@VMODROOT/vlib/db/pg/compatibility.h"')]
s = s[:start] + keep + s[end:]
s = s.replace('import time\n', 'import time\nimport pg.libpq\n', 1)
# 2. The C declarations => adapters.
start = s.index('pub struct C.pg_result {}')
marker = 'fn C.PQescapeLiteral(conn &C.PGconn, str &char, length usize) &char\n'
end = s.index(marker) + len(marker)
s = s[:start] + ADAPTERS + s[end:]
open(path, 'w').write(s)

# 3. All files: the C calls and types.
for name in names:
    p = os.path.join(dst, name)
    t = open(p).read()
    for c_name, v_name in C_NAMES.items():
        t = re.sub(r'\bC\.' + c_name + r'\(', v_name + '(', t)
    for c_type, v_type in [('C.PGconn', 'libpq.PGconn'), ('C.pg_conn', 'libpq.PGconn'),
                           ('C.PGresult', 'libpq.PGresult'), ('C.pg_result', 'libpq.PGresult'),
                           ('C.PGnotify', 'libpq.PGnotify')]:
        t = re.sub(re.escape(c_type) + r'\b', v_type, t)
    t = null_pointer_args(t)
    t = t.replace('unsafe { notify.relname.vstring() }',
                  'unsafe { cstring_to_vstring(&char(notify.relname)) }')
    t = t.replace('unsafe { notify.extra.vstring() }',
                  'unsafe { cstring_to_vstring(&char(notify.extra)) }')
    # The tests import this module.
    t = re.sub(r'^import db\.pg$', 'import pg', t, flags=re.M)
    open(p, 'w').write(t)
print('ported', len(names), 'files to', dst)
