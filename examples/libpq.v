// libpq's C API, in V.
// usage: v -w run examples/libpq.v
// (Connects to the server on localhost as postgres, port $PGPORT or 5432.)
import pg.libpq

fn main() {
	conn := libpq.pq_connectdb(c'host=localhost user=postgres dbname=postgres')
	defer {
		libpq.pq_finish(conn)
	}
	if libpq.pq_status(conn) != .connection_ok {
		eprintln(unsafe { cstring_to_vstring(&char(libpq.pq_error_message(conn))) })
		exit(1)
	}
	server_version := libpq.pq_server_version(conn)
	println('server ${server_version / 10000}.${server_version % 10000}, protocol ${libpq.pq_protocol_version(conn)}')
	// A query with parameters, results in text format.
	params := [c'2', c'10']
	res := libpq.pq_exec_params(conn, c'select i, i * i from generate_series($1::int, $2::int) as i',
		2, unsafe { nil }, unsafe { &&u8(&params[0]) }, unsafe { nil }, unsafe { nil }, 0)
	defer {
		libpq.pq_clear(res)
	}
	if libpq.pq_result_status(res) != .pgres_tuples_ok {
		eprintln(unsafe { cstring_to_vstring(&char(libpq.pq_result_error_message(res))) })
		exit(1)
	}
	for row in i32(0) .. libpq.pq_ntuples(res) {
		i := unsafe { cstring_to_vstring(&char(libpq.pq_getvalue(res, row, 0))) }
		square := unsafe { cstring_to_vstring(&char(libpq.pq_getvalue(res, row, 1))) }
		println('${i}² = ${square}')
	}
}
