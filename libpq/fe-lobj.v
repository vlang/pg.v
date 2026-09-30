@[translated]
module libpq

pub union AnonStruct_1025 {
pub mut:
	i64 Int64
	i32 [2]Uint32
}

pub union AnonStruct_1050 {
pub mut:
	i64 Int64
	i32 [2]Uint32
}

pub type PGcancelConn_fe_lobj = Pg_cancel_conn

pub type PGcancel_fe_lobj = Pg_cancel

@[markused]
pub fn libpq_fe_lobj_is_unixsock_path(path &i8) bool {
	return (i32(path[false]) == i8(`/`)) || i32(path[false]) == i8(`@`)
}

@[export: 'lo_open']
@[markused]
pub fn lo_open(conn &PGconn, lobj_id Oid, mode i32) i32 {
	fd := i32(0)
	result_len := i32(0)
	argv := [2]PQArgBlock{}
	res := &PGresult(0)
	if lo_initialize(conn) < 0 {
		return -1
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = i32(lobj_id)
	argv[1].isint = 1
	argv[1].len = 4
	argv[1].u.integer = mode
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_open), &fd, &result_len, 1, unsafe { &argv[0] }, 2)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return fd
	} else {
		pq_clear(res)
		return -1
	}
}

@[export: 'lo_close']
@[markused]
pub fn lo_close(conn &PGconn, fd i32) i32 {
	argv := [1]PQArgBlock{}
	res := &PGresult(0)
	retval := i32(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return -1
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = fd
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_close), &retval, &result_len, 1, unsafe { &argv[0] }, 1)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return retval
	} else {
		pq_clear(res)
		return -1
	}
}

@[export: 'lo_truncate']
@[markused]
pub fn lo_truncate(conn &PGconn, fd i32, len usize) i32 {
	argv := [2]PQArgBlock{}
	res := &PGresult(0)
	retval := i32(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return -1
	}
	if conn.lobjfuncs.fn_lo_truncate == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_truncate'))
		return -1
	}
	if len > usize(2147483647) {
		libpq_append_conn_error(conn, c'argument of lo_truncate exceeds integer range')
		return -1
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = fd
	argv[1].isint = 1
	argv[1].len = 4
	argv[1].u.integer = i32(len)
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_truncate), &retval, &result_len, 1, unsafe { &argv[0] }, 2)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return retval
	} else {
		pq_clear(res)
		return -1
	}
}

@[export: 'lo_truncate64']
@[markused]
pub fn lo_truncate64(conn &PGconn, fd i32, len i64) i32 {
	argv := [2]PQArgBlock{}
	res := &PGresult(0)
	retval := i32(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return -1
	}
	if conn.lobjfuncs.fn_lo_truncate64 == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_truncate64'))
		return -1
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = fd
	len = lo_hton64(len)
	argv[1].isint = 0
	argv[1].len = 8
	argv[1].u.ptr = &i32(c2v_address_of(&len))
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_truncate64), &retval, &result_len, 1, unsafe { &argv[0] }, 2)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return retval
	} else {
		pq_clear(res)
		return -1
	}
}

@[export: 'lo_read']
@[markused]
pub fn lo_read(conn &PGconn, fd i32, buf &i8, len usize) i32 {
	argv := [2]PQArgBlock{}
	res := &PGresult(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return -1
	}
	if len > usize(2147483647) {
		libpq_append_conn_error(conn, c'argument of lo_read exceeds integer range')
		return -1
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = fd
	argv[1].isint = 1
	argv[1].len = 4
	argv[1].u.integer = i32(len)
	res = pq_nfn(conn, i32(conn.lobjfuncs.fn_lo_read), voidptr(buf), i32(len), &result_len, 0, unsafe { &argv[0] }, 2)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return result_len
	} else {
		pq_clear(res)
		return -1
	}
}

@[export: 'lo_write']
@[markused]
pub fn lo_write(conn &PGconn, fd i32, buf &i8, len usize) i32 {
	argv := [2]PQArgBlock{}
	res := &PGresult(0)
	result_len := i32(0)
	retval := i32(0)
	if lo_initialize(conn) < 0 {
		return -1
	}
	if len > usize(2147483647) {
		libpq_append_conn_error(conn, c'argument of lo_write exceeds integer range')
		return -1
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = fd
	argv[1].isint = 0
	argv[1].len = i32(len)
	argv[1].u.ptr = &i32(voidptr((if true {
		&i8(buf)
	} else {
		unsafe { nil }
	})))
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_write), &retval, &result_len, 1, unsafe { &argv[0] }, 2)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return retval
	} else {
		pq_clear(res)
		return -1
	}
}

@[export: 'lo_lseek']
@[markused]
pub fn lo_lseek(conn &PGconn, fd i32, offset i32, whence i32) i32 {
	argv := [3]PQArgBlock{}
	res := &PGresult(0)
	retval := i32(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return -1
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = fd
	argv[1].isint = 1
	argv[1].len = 4
	argv[1].u.integer = offset
	argv[2].isint = 1
	argv[2].len = 4
	argv[2].u.integer = whence
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_lseek), &retval, &result_len, 1, unsafe { &argv[0] }, 3)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return retval
	} else {
		pq_clear(res)
		return -1
	}
}

@[export: 'lo_lseek64']
@[markused]
pub fn lo_lseek64(conn &PGconn, fd i32, offset i64, whence i32) i64 {
	argv := [3]PQArgBlock{}
	res := &PGresult(0)
	retval := Int64(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return i64(-1)
	}
	if conn.lobjfuncs.fn_lo_lseek64 == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_lseek64'))
		return i64(-1)
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = fd
	offset = lo_hton64(offset)
	argv[1].isint = 0
	argv[1].len = 8
	argv[1].u.ptr = &i32(c2v_address_of(&offset))
	argv[2].isint = 1
	argv[2].len = 4
	argv[2].u.integer = whence
	res = pq_nfn(conn, i32(conn.lobjfuncs.fn_lo_lseek64), voidptr(c2v_address_of(&retval)), i32(sizeof(retval)), &result_len, 0, unsafe { &argv[0] }, 3)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) && result_len == 8 {
		pq_clear(res)
		return lo_ntoh64(retval)
	} else {
		pq_clear(res)
		return i64(-1)
	}
}

@[export: 'lo_creat']
@[markused]
pub fn lo_creat(conn &PGconn, mode i32) Oid {
	argv := [1]PQArgBlock{}
	res := &PGresult(0)
	retval := i32(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return Oid(0)
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = mode
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_creat), &retval, &result_len, 1, unsafe { &argv[0] }, 1)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return Oid(retval)
	} else {
		pq_clear(res)
		return Oid(0)
	}
}

@[export: 'lo_create']
@[markused]
pub fn lo_create(conn &PGconn, lobj_id Oid) Oid {
	argv := [1]PQArgBlock{}
	res := &PGresult(0)
	retval := i32(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return Oid(0)
	}
	if conn.lobjfuncs.fn_lo_create == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_create'))
		return Oid(0)
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = i32(lobj_id)
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_create), &retval, &result_len, 1, unsafe { &argv[0] }, 1)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return Oid(retval)
	} else {
		pq_clear(res)
		return Oid(0)
	}
}

@[export: 'lo_tell']
@[markused]
pub fn lo_tell(conn &PGconn, fd i32) i32 {
	retval := i32(0)
	argv := [1]PQArgBlock{}
	res := &PGresult(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return -1
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = fd
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_tell), &retval, &result_len, 1, unsafe { &argv[0] }, 1)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return retval
	} else {
		pq_clear(res)
		return -1
	}
}

@[export: 'lo_tell64']
@[markused]
pub fn lo_tell64(conn &PGconn, fd i32) i64 {
	retval := Int64(0)
	argv := [1]PQArgBlock{}
	res := &PGresult(0)
	result_len := i32(0)
	if lo_initialize(conn) < 0 {
		return i64(-1)
	}
	if conn.lobjfuncs.fn_lo_tell64 == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_tell64'))
		return i64(-1)
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = fd
	res = pq_nfn(conn, i32(conn.lobjfuncs.fn_lo_tell64), voidptr(c2v_address_of(&retval)), i32(sizeof(retval)), &result_len, 0, unsafe { &argv[0] }, 1)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) && result_len == 8 {
		pq_clear(res)
		return lo_ntoh64(retval)
	} else {
		pq_clear(res)
		return i64(-1)
	}
}

@[export: 'lo_unlink']
@[markused]
pub fn lo_unlink(conn &PGconn, lobj_id Oid) i32 {
	argv := [1]PQArgBlock{}
	res := &PGresult(0)
	result_len := i32(0)
	retval := i32(0)
	if lo_initialize(conn) < 0 {
		return -1
	}
	argv[0].isint = 1
	argv[0].len = 4
	argv[0].u.integer = i32(lobj_id)
	res = pq_fn(conn, i32(conn.lobjfuncs.fn_lo_unlink), &retval, &result_len, 1, unsafe { &argv[0] }, 1)
	if u32(pq_result_status(res)) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(res)
		return retval
	} else {
		pq_clear(res)
		return -1
	}
}

@[export: 'lo_import']
@[markused]
pub fn lo_import(conn &PGconn, filename &i8) Oid {
	return lo_import_internal(conn, filename, (Oid(0)))
}

@[export: 'lo_import_with_oid']
@[markused]
pub fn lo_import_with_oid(conn &PGconn, filename &i8, lobj_id Oid) Oid {
	return lo_import_internal(conn, filename, lobj_id)
}

@[markused]
pub fn lo_import_internal(conn &PGconn, filename &i8, oid Oid) Oid {
	fd := i32(0)
	nbytes := i32(0)
	tmp := i32(0)

	buf := [8192]i8{}
	lobj_oid := Oid(0)
	lobj := i32(0)
	sebuf := [256]i8{}
	if usize(conn) == usize((voidptr(0))) {
		return Oid(0)
	}
	reset_pq_exp_buffer(&conn.errorMessage)
	conn.errorReported = 0
	fd = C.c2v_open(filename, 0 | 0, 438)
	if fd < 0 {
		libpq_append_conn_error(conn, c'could not open file "%s": %s', voidptr(filename), voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
		return Oid(0)
	}
	if oid == (Oid(0)) {
		lobj_oid = lo_creat(conn, 262144 | 131072)
	} else {
		lobj_oid = lo_create(conn, oid)
	}
	if lobj_oid == (Oid(0)) {
		C.c2v_close(fd)
		return Oid(0)
	}
	lobj = lo_open(conn, lobj_oid, 131072)
	if lobj == -1 {
		C.c2v_close(fd)
		return Oid(0)
	}
	for {
		nbytes = i32(C.c2v_read(fd, voidptr(unsafe { &buf[0] }), usize(8192)))
		if !(nbytes > 0) {
			break
		}
		tmp = lo_write(conn, lobj, unsafe { &i8(&buf[0]) }, usize(nbytes))
		if tmp != nbytes {
			C.c2v_close(fd)
			return Oid(0)
		}
	}
	if nbytes < 0 {
		save_errno := (unsafe { *C.c2v___error() })
		lo_close(conn, lobj)
		C.c2v_close(fd)
		reset_pq_exp_buffer(&conn.errorMessage)
		conn.errorReported = 0
		libpq_append_conn_error(conn, c'could not read from file "%s": %s', voidptr(filename), voidptr(pg_strerror_r(save_errno, unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
		return Oid(0)
	}
	C.c2v_close(fd)
	if lo_close(conn, lobj) != 0 {
		return Oid(0)
	}
	return lobj_oid
}

@[export: 'lo_export']
@[markused]
pub fn lo_export(conn &PGconn, lobj_id Oid, filename &i8) i32 {
	result := i32(1)
	fd := i32(0)
	nbytes := i32(0)
	tmp := i32(0)

	buf := [8192]i8{}
	lobj := i32(0)
	sebuf := [256]i8{}
	lobj = lo_open(conn, lobj_id, 262144)
	if lobj == -1 {
		return -1
	}
	fd = C.c2v_open(filename, 512 | 1 | 1024 | 0, 438)
	if fd < 0 {
		save_errno := (unsafe { *C.c2v___error() })
		lo_close(conn, lobj)
		reset_pq_exp_buffer(&conn.errorMessage)
		conn.errorReported = 0
		libpq_append_conn_error(conn, c'could not open file "%s": %s', voidptr(filename), voidptr(pg_strerror_r(save_errno, unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
		return -1
	}
	for {
		nbytes = lo_read(conn, lobj, unsafe { &i8(&buf[0]) }, usize(8192))
		if !(nbytes > 0) {
			break
		}
		tmp = i32(C.c2v_write(fd, voidptr(unsafe { &buf[0] }), usize(nbytes)))
		if tmp != nbytes {
			save_errno := (unsafe { *C.c2v___error() })
			lo_close(conn, lobj)
			C.c2v_close(fd)
			reset_pq_exp_buffer(&conn.errorMessage)
			conn.errorReported = 0
			libpq_append_conn_error(conn, c'could not write to file "%s": %s', voidptr(filename), voidptr(pg_strerror_r(save_errno, unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
			return -1
		}
	}
	if nbytes < 0 || lo_close(conn, lobj) != 0 {
		result = -1
	}
	if C.c2v_close(fd) != 0 && result >= 0 {
		libpq_append_conn_error(conn, c'could not write to file "%s": %s', voidptr(filename), voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
		result = -1
	}
	return result
}

@[markused]
pub fn lo_initialize(conn &PGconn) i32 {
	res := &PGresult(0)
	lobjfuncs := &PGlobjfuncs(0)
	n := i32(0)
	query := &i8(0)
	fname := &i8(0)
	foid := Oid(0)
	if usize(conn) == usize((voidptr(0))) {
		return -1
	}
	reset_pq_exp_buffer(&conn.errorMessage)
	conn.errorReported = 0
	if usize(conn.lobjfuncs) != usize((voidptr(0))) {
		return 0
	}
	lobjfuncs = &PGlobjfuncs(C.c2v_malloc(sizeof(PGlobjfuncs)))
	if usize(lobjfuncs) == usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'out of memory')
		return -1
	}
	for {
		vstart := voidptr(lobjfuncs)
		val := i32(0)
		len := (sizeof(PGlobjfuncs))
		if ((usize(vstart)) & (sizeof(i64) - u64(1))) == u64(0) && (len & (sizeof(i64) - u64(1))) == u64(0) && val == 0 && len <= Size(1024) && 1024 != 0 {
			start := &i64(vstart)
			stop := &i64(voidptr((&i8(voidptr(start)) + len)))
			for usize(start) < usize(stop) {
				mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_postfix(voidptr(&start), start, isize(1)) }
				unsafe { *__c2v_lhs_tmp_0 = i64(0) }
			}
		} else {
			C.c2v_memset(voidptr(vstart), val, len)
		}
		break
	}
	query = c"select proname, oid from pg_catalog.pg_proc where proname in ('lo_open', 'lo_close', 'lo_creat', 'lo_create', 'lo_unlink', 'lo_lseek', 'lo_lseek64', 'lo_tell', 'lo_tell64', 'lo_truncate', 'lo_truncate64', 'loread', 'lowrite') and pronamespace = (select oid from pg_catalog.pg_namespace where nspname = 'pg_catalog')"
	res = pq_exec(conn, query)
	if usize(res) == usize((voidptr(0))) {
		C.c2v_free(voidptr(lobjfuncs))
		return -1
	}
	if u32(res.resultStatus) != u32(ExecStatusType.pgres_tuples_ok) {
		C.c2v_free(voidptr(lobjfuncs))
		pq_clear(res)
		libpq_append_conn_error(conn, c'query to initialize large object functions did not return data')
		return -1
	}
	for n = 0; n < pq_ntuples(res); n++ {
		fname = pq_getvalue(res, n, 0)
		foid = Oid(C.c2v_atoi(pq_getvalue(res, n, 1)))
		if C.c2v_strcmp(fname, c'lo_open') == 0 {
			lobjfuncs.fn_lo_open = foid
		} else if C.c2v_strcmp(fname, c'lo_close') == 0 {
			lobjfuncs.fn_lo_close = foid
		} else if C.c2v_strcmp(fname, c'lo_creat') == 0 {
			lobjfuncs.fn_lo_creat = foid
		} else if C.c2v_strcmp(fname, c'lo_create') == 0 {
			lobjfuncs.fn_lo_create = foid
		} else if C.c2v_strcmp(fname, c'lo_unlink') == 0 {
			lobjfuncs.fn_lo_unlink = foid
		} else if C.c2v_strcmp(fname, c'lo_lseek') == 0 {
			lobjfuncs.fn_lo_lseek = foid
		} else if C.c2v_strcmp(fname, c'lo_lseek64') == 0 {
			lobjfuncs.fn_lo_lseek64 = foid
		} else if C.c2v_strcmp(fname, c'lo_tell') == 0 {
			lobjfuncs.fn_lo_tell = foid
		} else if C.c2v_strcmp(fname, c'lo_tell64') == 0 {
			lobjfuncs.fn_lo_tell64 = foid
		} else if C.c2v_strcmp(fname, c'lo_truncate') == 0 {
			lobjfuncs.fn_lo_truncate = foid
		} else if C.c2v_strcmp(fname, c'lo_truncate64') == 0 {
			lobjfuncs.fn_lo_truncate64 = foid
		} else if C.c2v_strcmp(fname, c'loread') == 0 {
			lobjfuncs.fn_lo_read = foid
		} else if C.c2v_strcmp(fname, c'lowrite') == 0 {
			lobjfuncs.fn_lo_write = foid
		}
	}
	pq_clear(res)
	if lobjfuncs.fn_lo_open == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_open'))
		C.c2v_free(voidptr(lobjfuncs))
		return -1
	}
	if lobjfuncs.fn_lo_close == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_close'))
		C.c2v_free(voidptr(lobjfuncs))
		return -1
	}
	if lobjfuncs.fn_lo_creat == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_creat'))
		C.c2v_free(voidptr(lobjfuncs))
		return -1
	}
	if lobjfuncs.fn_lo_unlink == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_unlink'))
		C.c2v_free(voidptr(lobjfuncs))
		return -1
	}
	if lobjfuncs.fn_lo_lseek == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_lseek'))
		C.c2v_free(voidptr(lobjfuncs))
		return -1
	}
	if lobjfuncs.fn_lo_tell == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lo_tell'))
		C.c2v_free(voidptr(lobjfuncs))
		return -1
	}
	if lobjfuncs.fn_lo_read == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'loread'))
		C.c2v_free(voidptr(lobjfuncs))
		return -1
	}
	if lobjfuncs.fn_lo_write == Oid(0) {
		libpq_append_conn_error(conn, c'cannot determine OID of function %s', voidptr(c'lowrite'))
		C.c2v_free(voidptr(lobjfuncs))
		return -1
	}
	conn.lobjfuncs = lobjfuncs
	return 0
}

@[markused]
pub fn lo_hton64(host64 i64) i64 {
	swap := AnonStruct_1025{}

	t := Uint32(0)
	t = Uint32((host64 >> 32))
	swap.i32[0] = c2v_builtin_bswap32(t)
	t = Uint32(host64)
	swap.i32[1] = c2v_builtin_bswap32(t)
	return swap.i64
}

@[markused]
pub fn lo_ntoh64(net64 i64) i64 {
	swap := AnonStruct_1050{}

	result := Int64(0)
	swap.i64 = net64
	result = Int64(Uint32(c2v_builtin_bswap32(swap.i32[0])))
	result <<= 32
	result |= Int64(Uint32(c2v_builtin_bswap32(swap.i32[1])))
	return result
}
