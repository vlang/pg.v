@[translated]
module libpq

pub fn c2v_fn_stat(a0 &i8, a1 &C.stat) int {
	return C.c2v_stat(a0, a1)
}

pub fn c2v_prefix_add[T](target &T, delta T) T {
	unsafe {
		*target += delta
		return *target
	}
}

pub fn c2v_assign[T](target &T, value T) T {
	unsafe {
		*target = value
	}
	return value
}

pub struct Timespec {
pub mut:
	tv_sec  i64
	tv_nsec i64
}

@[markused]
pub fn libpq_fe_connect_is_unixsock_path(path &i8) bool {
	return (int(path[false]) == i8(`/`)) || int(path[false]) == i8(`@`)
}

pub struct PromptInterruptContext {
pub mut:
	jmpbuf   voidptr
	enabled  &int
	canceled bool
}

pub fn pg_get_line(stream &C.FILE, prompt_ctx &PromptInterruptContext) &i8

pub fn pg_get_line_buf(stream &C.FILE, buf &C.StringInfoData) bool

pub fn pg_get_line_append(stream &C.FILE, buf &C.StringInfoData, prompt_ctx &PromptInterruptContext) bool

pub fn simple_prompt(prompt &i8, echo bool) &i8

pub fn simple_prompt_extended(prompt &i8, echo bool, prompt_ctx &PromptInterruptContext) &i8

pub type PGcancelConn_fe_connect = Pg_cancel_conn

pub type PGcancel_fe_connect = Pg_cancel

@[markused]
pub fn libpq_fe_connect_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_fe_connect_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_fe_connect_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_fe_connect_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_fe_connect_utf8_to_unicode(c &u8) Pg_wchar {
	if (int((unsafe { *c })) & 128) == 0 {
		return Pg_wchar(c[0])
	} else if (int((unsafe { *c })) & 224) == 192 {
		return Pg_wchar((((int(c[0]) & 31) << 6) | (int(c[1]) & 63)))
	} else if (int((unsafe { *c })) & 240) == 224 {
		return Pg_wchar((((int(c[0]) & 15) << 12) | ((int(c[1]) & 63) << 6) | (int(c[2]) & 63)))
	} else if (int((unsafe { *c })) & 248) == 240 {
		return Pg_wchar((((int(c[0]) & 7) << 18) | ((int(c[1]) & 63) << 12) | ((int(c[2]) & 63) << 6) | (int(c[3]) & 63)))
	} else {
		return u32(4294967295)
	}
}

@[markused]
pub fn libpq_fe_connect_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
	if c <= Pg_wchar(127) {
		utf8string[0] = u8(c)
	} else if c <= Pg_wchar(2047) {
		utf8string[0] = u8(Pg_wchar(192) | ((c >> 6) & Pg_wchar(31)))
		utf8string[1] = u8(Pg_wchar(128) | (c & Pg_wchar(63)))
	} else if c <= Pg_wchar(65535) {
		utf8string[0] = u8(Pg_wchar(224) | ((c >> 12) & Pg_wchar(15)))
		utf8string[1] = u8(Pg_wchar(128) | ((c >> 6) & Pg_wchar(63)))
		utf8string[2] = u8(Pg_wchar(128) | (c & Pg_wchar(63)))
	} else {
		utf8string[0] = u8(Pg_wchar(240) | ((c >> 18) & Pg_wchar(7)))
		utf8string[1] = u8(Pg_wchar(128) | ((c >> 12) & Pg_wchar(63)))
		utf8string[2] = u8(Pg_wchar(128) | ((c >> 6) & Pg_wchar(63)))
		utf8string[3] = u8(Pg_wchar(128) | (c & Pg_wchar(63)))
	}
	return utf8string
}

@[markused]
pub fn libpq_fe_connect_unicode_utf8len(c Pg_wchar) int {
	if c <= Pg_wchar(127) {
		return 1
	} else if c <= Pg_wchar(2047) {
		return 2
	} else if c <= Pg_wchar(65535) {
		return 3
	} else {
		return 4
	}
}

pub struct InternalPQconninfoOption {
pub mut:
	keyword  &i8
	envvar   &i8
	compiled &i8
	val      &i8
	label    &i8
	dispchar &i8
	dispsize int
	connofs  i64
}

@[export: 'pqDropConnection']
@[markused]
pub fn pq_drop_connection(conn &PGconn, flush_input bool) {
	pqsecure_close(conn)
	if conn.sock != (-1) {
		C.c2v_close(conn.sock)
	}
	conn.sock = (-1)
	if flush_input {
		conn.inEnd = 0
		conn.inCursor = conn.inEnd
		conn.inStart = conn.inCursor
	}
	conn.outCount = 0
	pq_free_command_queue(conn.cmd_queue_head)
	conn.cmd_queue_tail = (voidptr(0))
	conn.cmd_queue_head = conn.cmd_queue_tail
	pq_free_command_queue(conn.cmd_queue_recycle)
	conn.cmd_queue_recycle = (voidptr(0))
	if conn.cleanup_async_auth {
		conn.cleanup_async_auth(conn)
		conn.cleanup_async_auth = (voidptr(0))
	}
	conn.async_auth = (voidptr(0))
	conn.altsock = (-1)
	if conn.sasl_state {
		conn.sasl.free_(voidptr(conn.sasl_state))
		conn.sasl_state = (voidptr(0))
	}
}

@[markused]
pub fn pq_free_command_queue(queue &PGcmdQueueEntry) {
	for usize(queue) != usize((voidptr(0))) {
		cur := queue
		queue = cur.next
		C.c2v_free(voidptr(cur.query))
		C.c2v_free(voidptr(cur))
	}
}

@[markused]
pub fn pq_drop_server_data(conn &PGconn) {
	notify := &PGnotify(0)
	pstatus := &PgParameterStatus(0)
	notify = conn.notifyHead
	for usize(notify) != usize((voidptr(0))) {
		prev := notify
		notify = notify.next
		C.c2v_free(voidptr(prev))
	}
	conn.notifyTail = (voidptr(0))
	conn.notifyHead = conn.notifyTail
	pstatus = conn.pstatus
	for usize(pstatus) != usize((voidptr(0))) {
		prev := pstatus
		pstatus = pstatus.next
		C.c2v_free(voidptr(prev))
	}
	conn.pstatus = (voidptr(0))
	conn.client_encoding = Pg_enc.pg_sql_ascii
	conn.std_strings = (0 != 0)
	conn.default_transaction_read_only = PGTernaryBool.pg_bool_unknown
	conn.in_hot_standby = PGTernaryBool.pg_bool_unknown
	conn.scram_sha_256_iterations = 4096
	conn.sversion = 0
	C.c2v_free(voidptr(conn.lobjfuncs))
	conn.lobjfuncs = (voidptr(0))
	conn.last_sqlstate[0] = i8(`\0`)
	conn.pversion_negotiated = (0 != 0)
	conn.auth_req_received = (0 != 0)
	conn.client_finished_auth = (0 != 0)
	conn.password_needed = (0 != 0)
	conn.gssapi_used = (0 != 0)
	conn.write_failed = (0 != 0)
	C.c2v_free(voidptr(conn.write_err_msg))
	conn.write_err_msg = (voidptr(0))
	conn.oauth_want_retry = (0 != 0)
	if !conn.cancelRequest {
		conn.be_pid = 0
		if usize(conn.be_cancel_key) != usize((voidptr(0))) {
			C.c2v_free(voidptr(conn.be_cancel_key))
			conn.be_cancel_key = (voidptr(0))
		}
		conn.be_cancel_key_len = 0
	}
}

@[export: 'PQconnectdbParams']
@[markused]
pub fn pq_connectdb_params(keywords &&u8, values &&u8, expand_dbname int) &PGconn {
	conn := pq_connect_start_params(keywords, values, expand_dbname)
	if !isnil(conn) && u32(conn.status) != u32(ConnStatusType.connection_bad) {
		pq_connect_db_complete(conn)
	}
	return conn
}

@[export: 'PQpingParams']
@[markused]
pub fn pq_ping_params(keywords &&u8, values &&u8, expand_dbname int) PGPing {
	conn := pq_connect_start_params(keywords, values, expand_dbname)
	ret := PGPing{}
	ret = internal_ping(conn)
	pq_finish(conn)
	return ret
}

@[export: 'PQconnectdb']
@[markused]
pub fn pq_connectdb(conninfo &i8) &PGconn {
	conn := pq_connect_start(conninfo)
	if !isnil(conn) && u32(conn.status) != u32(ConnStatusType.connection_bad) {
		pq_connect_db_complete(conn)
	}
	return conn
}

@[export: 'PQping']
@[markused]
pub fn pq_ping(conninfo &i8) PGPing {
	conn := pq_connect_start(conninfo)
	ret := PGPing{}
	ret = internal_ping(conn)
	pq_finish(conn)
	return ret
}

@[export: 'PQconnectStartParams']
@[markused]
pub fn pq_connect_start_params(keywords &&u8, values &&u8, expand_dbname int) &PGconn {
	conn := &PGconn(0)
	conn_options := &PQconninfoOption(0)
	conn = pq_make_empty_pg_conn()
	if usize(conn) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	conn_options = conninfo_array_parse(keywords, values, &conn.errorMessage, (1 != 0), expand_dbname)
	if usize(conn_options) == usize((voidptr(0))) {
		conn.status = ConnStatusType.connection_bad
		return conn
	}
	if !fill_pg_conn(conn, conn_options) {
		pq_conninfo_free(conn_options)
		return conn
	}
	pq_conninfo_free(conn_options)
	if !pq_connect_options2(conn) {
		return conn
	}
	if !pq_connect_db_start(conn) {
		conn.status = ConnStatusType.connection_bad
	}
	return conn
}

@[export: 'PQconnectStart']
@[markused]
pub fn pq_connect_start(conninfo &i8) &PGconn {
	conn := &PGconn(0)
	conn = pq_make_empty_pg_conn()
	if usize(conn) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	if !connect_options1(conn, conninfo) {
		return conn
	}
	if !pq_connect_options2(conn) {
		return conn
	}
	if !pq_connect_db_start(conn) {
		conn.status = ConnStatusType.connection_bad
	}
	return conn
}

@[markused]
pub fn fill_pg_conn(conn &PGconn, conn_options &PQconninfoOption) bool {
	option := &InternalPQconninfoOption(0)
	for option = unsafe { &libpq_fe_connect_pq_conninfo_options[0] }; option.keyword; option = unsafe { option + 1 } {
		if option.connofs >= i64(0) {
			tmp := conninfo_getval(conn_options, option.keyword)
			if tmp {
				connmember := &&u8(voidptr((&i8(voidptr(conn)) + option.connofs)))
				C.c2v_free(voidptr((unsafe { *connmember })))
				unsafe { *connmember = C.c2v_strdup(tmp) }
				if usize((unsafe { *connmember })) == usize((voidptr(0))) {
					libpq_append_conn_error(conn, c'out of memory')
					return false != 0
				}
			}
		}
	}
	return true != 0
}

@[export: 'pqCopyPGconn']
@[markused]
pub fn pq_copy_pg_conn(src_conn &PGconn, dst_conn &PGconn) bool {
	option := &InternalPQconninfoOption(0)
	for option = unsafe { &libpq_fe_connect_pq_conninfo_options[0] }; option.keyword; option = unsafe { option + 1 } {
		if option.connofs >= i64(0) {
			tmp := &&u8(voidptr((&i8(voidptr(src_conn)) + option.connofs)))
			if unsafe { *tmp != nil } {
				dst_connmember := &&u8(voidptr((&i8(voidptr(dst_conn)) + option.connofs)))
				if unsafe { *dst_connmember != nil } {
					C.c2v_free(voidptr((unsafe { *dst_connmember })))
				}
				unsafe { *dst_connmember = C.c2v_strdup(*tmp) }
				if usize((unsafe { *dst_connmember })) == usize((voidptr(0))) {
					libpq_append_conn_error(dst_conn, c'out of memory')
					return false != 0
				}
			}
		}
	}
	return true != 0
}

@[markused]
pub fn connect_options1(conn &PGconn, conninfo &i8) bool {
	conn_options := &PQconninfoOption(0)
	conn_options = parse_connection_string(conninfo, &conn.errorMessage, (1 != 0))
	if usize(conn_options) == usize((voidptr(0))) {
		conn.status = ConnStatusType.connection_bad
		return false != 0
	}
	if !fill_pg_conn(conn, conn_options) {
		conn.status = ConnStatusType.connection_bad
		pq_conninfo_free(conn_options)
		return false != 0
	}
	pq_conninfo_free(conn_options)
	return true != 0
}

@[markused]
pub fn count_comma_separated_elems(input &i8) int {
	n := 0
	n = 1
	for ; int((unsafe { *input })) != i8(`\0`); input = unsafe { input + 1 } {
		if int((unsafe { *input })) == i8(`,`) {
			n++
		}
	}
	return n
}

@[markused]
pub fn parse_comma_separated_list(startptr &&u8, more &bool) &i8 {
	p := &i8(0)
	s := (unsafe { *startptr })
	e := &i8(0)
	len := usize(0)
	e = s
	for int((unsafe { *e })) != i8(`\0`) && int((unsafe { *e })) != i8(`,`) {
		c2v_pointer_prefix(voidptr(&e), e, isize(1))
	}
	unsafe { *more = ((int(*e) == i8(`,`)) != 0) }
	len = usize(i64((isize(e) - isize(s)) / isize(sizeof(i8))))
	p = &i8(C.c2v_malloc(sizeof(i8) * (len + usize(1))))
	if p {
		C.c2v_memcpy(voidptr(p), voidptr(s), len)
		p[len] = i8(`\0`)
	}
	unsafe { *startptr = e + 1 }
	return p
}

@[markused]
pub fn libpq_prng_init(conn &PGconn) {
	rseed := Uint64(0)
	tval := C.timeval{}

	if (if int(pg_strong_random(voidptr(&conn.prng_state), sizeof(Pg_prng_state))) {
		int(pg_prng_seed_check(&conn.prng_state))
	} else {
		0
	}) {
		return
	}
	C.c2v_gettimeofday(&tval, voidptr((voidptr(0))))
	rseed = Uint64((usize(voidptr(conn)))) ^ (Uint64(C.c2v_getpid())) ^ (Uint64(tval.tv_usec)) ^ (Uint64(tval.tv_sec))
	pg_prng_seed(&conn.prng_state, rseed)
}

@[markused]
pub fn fill_allowed_sasl_mechs(conn &PGconn) {
	for i := 0; u64(i) < 2; i++ {
		conn.allowed_sasl_mechs[i] = libpq_fe_connect_supported_sasl_mechs[i]
	}
}

@[markused]
pub fn clear_allowed_sasl_mechs(conn &PGconn) {
	for i := 0; u64(i) < 2; i++ {
		conn.allowed_sasl_mechs[i] = (voidptr(0))
	}
}

@[markused]
pub fn index_of_allowed_sasl_mech(conn &PGconn, mech &Pg_fe_sasl_mech) int {
	for i := 0; u64(i) < 2; i++ {
		if usize(conn.allowed_sasl_mechs[i]) == usize(mech) {
			return i
		}
	}
	return -1
}

@[export: 'pqConnectOptions2']
@[markused]
pub fn pq_connect_options2(conn &PGconn) bool {
	i := 0
	conn.whichhost = 0
	if !isnil(conn.pghostaddr) && int(conn.pghostaddr[0]) != i8(`\0`) {
		conn.nconnhost = count_comma_separated_elems(conn.pghostaddr)
	} else if !isnil(conn.pghost) && int(conn.pghost[0]) != i8(`\0`) {
		conn.nconnhost = count_comma_separated_elems(conn.pghost)
	} else {
		conn.nconnhost = 1
	}
	conn.connhost = &Pg_conn_host(C.c2v_calloc(u64(conn.nconnhost), sizeof(Pg_conn_host)))
	if usize(conn.connhost) == usize((voidptr(0))) {
		unsafe {
			goto oom_error
		}
	}
	if usize(conn.pghostaddr) != usize((voidptr(0))) && int(conn.pghostaddr[0]) != i8(`\0`) {
		s := conn.pghostaddr
		more := (1 != 0)
		for i = 0; i < conn.nconnhost && int(more); i++ {
			conn.connhost[i].hostaddr = parse_comma_separated_list(&&u8(&&i8(c2v_address_of(&s))), &more)
			if usize(conn.connhost[i].hostaddr) == usize((voidptr(0))) {
				unsafe {
					goto oom_error
				}
			}
		}
	}
	if usize(conn.pghost) != usize((voidptr(0))) && int(conn.pghost[0]) != i8(`\0`) {
		s := conn.pghost
		more := (1 != 0)
		for i = 0; i < conn.nconnhost && int(more); i++ {
			conn.connhost[i].host = parse_comma_separated_list(&&u8(&&i8(c2v_address_of(&s))), &more)
			if usize(conn.connhost[i].host) == usize((voidptr(0))) {
				unsafe {
					goto oom_error
				}
			}
		}
		if int(more) || i != conn.nconnhost {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'could not match %d host names to %d hostaddr values', count_comma_separated_elems(conn.pghost), conn.nconnhost)
			return false != 0
		}
	}
	for i = 0; i < conn.nconnhost; i++ {
		ch := unsafe { conn.connhost + i }
		if usize(ch.hostaddr) != usize((voidptr(0))) && int(ch.hostaddr[0]) != i8(`\0`) {
			ch.type_ = Pg_conn_host_type.cht_host_address
		} else if usize(ch.host) != usize((voidptr(0))) && int(ch.host[0]) != i8(`\0`) {
			ch.type_ = Pg_conn_host_type.cht_host_name
			if libpq_fe_connect_is_unixsock_path(ch.host) {
				ch.type_ = Pg_conn_host_type.cht_unix_socket
			}
		} else {
			C.c2v_free(voidptr(ch.host))
			if c'/tmp'[0] {
				ch.host = C.c2v_strdup(c'/tmp')
				ch.type_ = Pg_conn_host_type.cht_unix_socket
			} else {
				ch.host = C.c2v_strdup(c'localhost')
				ch.type_ = Pg_conn_host_type.cht_host_name
			}
			if usize(ch.host) == usize((voidptr(0))) {
				unsafe {
					goto oom_error
				}
			}
		}
	}
	if usize(conn.pgport) != usize((voidptr(0))) && int(conn.pgport[0]) != i8(`\0`) {
		s := conn.pgport
		more := (1 != 0)
		for i = 0; i < conn.nconnhost && int(more); i++ {
			conn.connhost[i].port = parse_comma_separated_list(&&u8(&&i8(c2v_address_of(&s))), &more)
			if usize(conn.connhost[i].port) == usize((voidptr(0))) {
				unsafe {
					goto oom_error
				}
			}
		}
		if i == 1 && !more {
			for i = 1; i < conn.nconnhost; i++ {
				conn.connhost[i].port = C.c2v_strdup(conn.connhost[0].port)
				if usize(conn.connhost[i].port) == usize((voidptr(0))) {
					unsafe {
						goto oom_error
					}
				}
			}
		} else if int(more) || i != conn.nconnhost {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'could not match %d port numbers to %d hosts', count_comma_separated_elems(conn.pgport), conn.nconnhost)
			return false != 0
		}
	}
	if usize(conn.pguser) == usize((voidptr(0))) || int(conn.pguser[0]) == i8(`\0`) {
		C.c2v_free(voidptr(conn.pguser))
		conn.pguser = pg_fe_getauthname(&conn.errorMessage)
		if isnil(conn.pguser) {
			conn.status = ConnStatusType.connection_bad
			return false != 0
		}
	}
	if usize(conn.dbName) == usize((voidptr(0))) || int(conn.dbName[0]) == i8(`\0`) {
		C.c2v_free(voidptr(conn.dbName))
		conn.dbName = C.c2v_strdup(conn.pguser)
		if isnil(conn.dbName) {
			unsafe {
				goto oom_error
			}
		}
	}
	if usize(conn.pgpass) == usize((voidptr(0))) || int(conn.pgpass[0]) == i8(`\0`) {
		if usize(conn.pgpassfile) == usize((voidptr(0))) || int(conn.pgpassfile[0]) == i8(`\0`) {
			homedir := [1024]i8{}
			if pq_get_home_directory(unsafe { &i8(&homedir[0]) }, int(sizeof([1024]i8))) {
				C.c2v_free(voidptr(conn.pgpassfile))
				conn.pgpassfile = &i8(C.c2v_malloc(u64(1024)))
				if isnil(conn.pgpassfile) {
					unsafe {
						goto oom_error
					}
				}
				pg_snprintf(conn.pgpassfile, usize(1024), c'%s/%s', unsafe { voidptr(&homedir[0]) }, voidptr(c'.pgpass'))
			}
		}
		if usize(conn.pgpassfile) != usize((voidptr(0))) && int(conn.pgpassfile[0]) != i8(`\0`) {
			for i = 0; i < conn.nconnhost; i++ {
				pwhost := conn.connhost[i].host
				if usize(pwhost) == usize((voidptr(0))) || int(pwhost[0]) == i8(`\0`) {
					pwhost = conn.connhost[i].hostaddr
				}
				conn.connhost[i].password = password_from_file(pwhost, conn.connhost[i].port, conn.dbName, conn.pguser, conn.pgpassfile)
			}
		}
	}
	if !isnil(conn.require_auth) && int(conn.require_auth[0]) {
		s := conn.require_auth
		first := false
		more := false

		negated := (0 != 0)
		conn.auth_required = (1 != 0)
		conn.allowed_auth_methods = Uint32(0)
		clear_allowed_sasl_mechs(conn)
		first = (1 != 0)
		for more = (1 != 0); more; first = (0 != 0) {
			method := &i8(0)
			part := &i8(0)

			bits := Uint32(0)
			mech := unsafe { &Pg_fe_sasl_mech(nil) }
			part = parse_comma_separated_list(&&u8(&&i8(c2v_address_of(&s))), &more)
			if usize(part) == usize((voidptr(0))) {
				unsafe {
					goto oom_error
				}
			}
			method = part
			if int((unsafe { *method })) == i8(`!`) {
				if first {
					conn.auth_required = (0 != 0)
					conn.allowed_auth_methods = Uint32(-1)
					fill_allowed_sasl_mechs(conn)
				} else if !negated {
					conn.status = ConnStatusType.connection_bad
					libpq_append_conn_error(conn, c'negative require_auth method "%s" cannot be mixed with non-negative methods', voidptr(method))
					C.c2v_free(voidptr(part))
					return false != 0
				}
				negated = (1 != 0)
				c2v_pointer_postfix(voidptr(&method), method, isize(1))
			} else if negated {
				conn.status = ConnStatusType.connection_bad
				libpq_append_conn_error(conn, c'require_auth method "%s" cannot be mixed with negative methods', voidptr(method))
				C.c2v_free(voidptr(part))
				return false != 0
			}
			if C.c2v_strcmp(method, c'password') == 0 {
				bits = Uint32((1 << 3))
			} else if C.c2v_strcmp(method, c'md5') == 0 {
				bits = Uint32((1 << 5))
			} else if C.c2v_strcmp(method, c'gss') == 0 {
				bits = Uint32((1 << 7))
				bits |= Uint32((1 << 8))
			} else if C.c2v_strcmp(method, c'sspi') == 0 {
				bits = Uint32((1 << 9))
				bits |= Uint32((1 << 8))
			} else if C.c2v_strcmp(method, c'scram-sha-256') == 0 {
				mech = &pg_scram_mech
			} else if C.c2v_strcmp(method, c'oauth') == 0 {
				mech = &pg_oauth_mech
			} else if C.c2v_strcmp(method, c'none') == 0 {
				if negated {
					if conn.auth_required {
						unsafe {
							goto duplicate
						}
					}
					conn.auth_required = (1 != 0)
				} else {
					if !conn.auth_required {
						unsafe {
							goto duplicate
						}
					}
					conn.auth_required = (0 != 0)
				}
				C.c2v_free(voidptr(part))
				continue
			} else {
				conn.status = ConnStatusType.connection_bad
				libpq_append_conn_error(conn, c'invalid %s value: "%s"', voidptr(c'require_auth'), voidptr(method))
				C.c2v_free(voidptr(part))
				return false != 0
			}
			if mech {
				if negated {
					i = index_of_allowed_sasl_mech(conn, mech)
					if i < 0 {
						unsafe {
							goto duplicate
						}
					}
					conn.allowed_sasl_mechs[i] = (voidptr(0))
				} else {
					i = index_of_allowed_sasl_mech(conn, mech)
					if i >= 0 {
						unsafe {
							goto duplicate
						}
					}
					i = index_of_allowed_sasl_mech(conn, (voidptr(0)))
					if i < 0 {
						conn.status = ConnStatusType.connection_bad
						libpq_append_conn_error(conn, c'internal error: no space in allowed_sasl_mechs')
						C.c2v_free(voidptr(part))
						return false != 0
					}
					conn.allowed_sasl_mechs[i] = mech
				}
			} else {
				if negated {
					if (conn.allowed_auth_methods & bits) == Uint32(0) {
						unsafe {
							goto duplicate
						}
					}
					conn.allowed_auth_methods &= ~bits
				} else {
					if (conn.allowed_auth_methods & bits) == bits {
						unsafe {
							goto duplicate
						}
					}
					conn.allowed_auth_methods |= bits
				}
			}
			C.c2v_free(voidptr(part))
			continue

			duplicate:
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'require_auth method "%s" is specified more than once', voidptr(part))
			C.c2v_free(voidptr(part))
			return false != 0
		}
		allowed := (0 != 0)
		sasl_bits := Uint32((1 << 10) | (1 << 11) | (1 << 12))
		for i = 0; u64(i) < 2; i++ {
			if conn.allowed_sasl_mechs[i] {
				allowed = (1 != 0)
				break
			}
		}
		if !negated && int(allowed) {
			conn.allowed_auth_methods |= sasl_bits
		} else if int(negated) && !allowed {
			conn.allowed_auth_methods &= ~sasl_bits
		}
	}
	if conn.channel_binding {
		if C.c2v_strcmp(conn.channel_binding, c'disable') != 0 && C.c2v_strcmp(conn.channel_binding, c'prefer') != 0 && C.c2v_strcmp(conn.channel_binding, c'require') != 0 {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'invalid %s value: "%s"', voidptr(c'channel_binding'), voidptr(conn.channel_binding))
			return false != 0
		}
	} else {
		conn.channel_binding = C.c2v_strdup(c'disable')
		if isnil(conn.channel_binding) {
			unsafe {
				goto oom_error
			}
		}
	}
	if !isnil(conn.sslrootcert) && C.c2v_strcmp(conn.sslrootcert, c'system') == 0 {
		conn.status = ConnStatusType.connection_bad
		libpq_append_conn_error(conn, c'%s value "%s" invalid when SSL support is not compiled in', voidptr(c'sslrootcert'), voidptr(conn.sslrootcert))
		return false != 0
	}
	if conn.sslmode {
		mut __c2v_condition_0 := false
		mut __c2v_condition_1 := false
		__c2v_condition_1 = C.c2v_strcmp(conn.sslmode, c'disable') != 0
		if __c2v_condition_1 {
			__c2v_condition_1 = C.c2v_strcmp(conn.sslmode, c'allow') != 0
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = C.c2v_strcmp(conn.sslmode, c'prefer') != 0
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = C.c2v_strcmp(conn.sslmode, c'require') != 0
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = C.c2v_strcmp(conn.sslmode, c'verify-ca') != 0
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = C.c2v_strcmp(conn.sslmode, c'verify-full') != 0
		}
		__c2v_condition_0 = __c2v_condition_1
		if __c2v_condition_0 {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'invalid %s value: "%s"', voidptr(c'sslmode'), voidptr(conn.sslmode))
			return false != 0
		}
		match int(conn.sslmode[0]) {
			int(`a`), int(`p`) {
			}
			int(`r`), int(`v`) {
				conn.status = ConnStatusType.connection_bad
				libpq_append_conn_error(conn, c'%s value "%s" invalid when SSL support is not compiled in', voidptr(c'sslmode'), voidptr(conn.sslmode))
				return false != 0
			}
			else {}
		}
	} else {
		conn.sslmode = C.c2v_strdup(c'disable')
		if isnil(conn.sslmode) {
			unsafe {
				goto oom_error
			}
		}
	}
	if conn.sslnegotiation {
		if C.c2v_strcmp(conn.sslnegotiation, c'postgres') != 0 && C.c2v_strcmp(conn.sslnegotiation, c'direct') != 0 {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'invalid %s value: "%s"', voidptr(c'sslnegotiation'), voidptr(conn.sslnegotiation))
			return false != 0
		}
		if int(conn.sslnegotiation[0]) != i8(`p`) {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'%s value "%s" invalid when SSL support is not compiled in', voidptr(c'sslnegotiation'), voidptr(conn.sslnegotiation))
			return false != 0
		}
		if int(conn.sslnegotiation[0]) == i8(`d`) && int(conn.sslmode[0]) != i8(`r`) && int(conn.sslmode[0]) != i8(`v`) {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'weak sslmode "%s" may not be used with sslnegotiation=direct (use "require", "verify-ca", or "verify-full")', voidptr(conn.sslmode))
			return false != 0
		}
	} else {
		conn.sslnegotiation = C.c2v_strdup(c'postgres')
		if isnil(conn.sslnegotiation) {
			unsafe {
				goto oom_error
			}
		}
	}
	if !ssl_verify_protocol_version(conn.ssl_min_protocol_version) {
		conn.status = ConnStatusType.connection_bad
		libpq_append_conn_error(conn, c'invalid "%s" value: "%s"', voidptr(c'ssl_min_protocol_version'), voidptr(conn.ssl_min_protocol_version))
		return false != 0
	}
	if !ssl_verify_protocol_version(conn.ssl_max_protocol_version) {
		conn.status = ConnStatusType.connection_bad
		libpq_append_conn_error(conn, c'invalid "%s" value: "%s"', voidptr(c'ssl_max_protocol_version'), voidptr(conn.ssl_max_protocol_version))
		return false != 0
	}
	if !ssl_verify_protocol_range(conn.ssl_min_protocol_version, conn.ssl_max_protocol_version) {
		conn.status = ConnStatusType.connection_bad
		libpq_append_conn_error(conn, c'invalid SSL protocol version range')
		return false != 0
	}
	if conn.sslcertmode {
		if C.c2v_strcmp(conn.sslcertmode, c'disable') != 0 && C.c2v_strcmp(conn.sslcertmode, c'allow') != 0 && C.c2v_strcmp(conn.sslcertmode, c'require') != 0 {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'invalid %s value: "%s"', voidptr(c'sslcertmode'), voidptr(conn.sslcertmode))
			return false != 0
		}
		if C.c2v_strcmp(conn.sslcertmode, c'require') == 0 {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'%s value "%s" invalid when SSL support is not compiled in', voidptr(c'sslcertmode'), voidptr(conn.sslcertmode))
			return false != 0
		}
		if C.c2v_strcmp(conn.sslcertmode, c'require') == 0 {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'%s value "%s" is not supported (check OpenSSL version)', voidptr(c'sslcertmode'), voidptr(conn.sslcertmode))
			return false != 0
		}
	} else {
		conn.sslcertmode = C.c2v_strdup(c'disable')
		if isnil(conn.sslcertmode) {
			unsafe {
				goto oom_error
			}
		}
	}
	if conn.gssencmode {
		if C.c2v_strcmp(conn.gssencmode, c'disable') != 0 && C.c2v_strcmp(conn.gssencmode, c'prefer') != 0 && C.c2v_strcmp(conn.gssencmode, c'require') != 0 {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'invalid %s value: "%s"', voidptr(c'gssencmode'), voidptr(conn.gssencmode))
			return false != 0
		}
		if C.c2v_strcmp(conn.gssencmode, c'require') == 0 {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'gssencmode value "%s" invalid when GSSAPI support is not compiled in', voidptr(conn.gssencmode))
			return false != 0
		}
	} else {
		conn.gssencmode = C.c2v_strdup(c'disable')
		if isnil(conn.gssencmode) {
			unsafe {
				goto oom_error
			}
		}
	}
	if conn.target_session_attrs {
		if C.c2v_strcmp(conn.target_session_attrs, c'any') == 0 {
			conn.target_server_type = PGTargetServerType.server_type_any
		} else if C.c2v_strcmp(conn.target_session_attrs, c'read-write') == 0 {
			conn.target_server_type = PGTargetServerType.server_type_read_write
		} else if C.c2v_strcmp(conn.target_session_attrs, c'read-only') == 0 {
			conn.target_server_type = PGTargetServerType.server_type_read_only
		} else if C.c2v_strcmp(conn.target_session_attrs, c'primary') == 0 {
			conn.target_server_type = PGTargetServerType.server_type_primary
		} else if C.c2v_strcmp(conn.target_session_attrs, c'standby') == 0 {
			conn.target_server_type = PGTargetServerType.server_type_standby
		} else if C.c2v_strcmp(conn.target_session_attrs, c'prefer-standby') == 0 {
			conn.target_server_type = PGTargetServerType.server_type_prefer_standby
		} else {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'invalid %s value: "%s"', voidptr(c'target_session_attrs'), voidptr(conn.target_session_attrs))
			return false != 0
		}
	} else {
		conn.target_server_type = PGTargetServerType.server_type_any
	}
	if conn.scram_client_key {
		len := 0
		len = pg_b64_dec_len(int(C.c2v_strlen(conn.scram_client_key)))
		conn.scram_client_key_binary = C.c2v_malloc(u64(len))
		if isnil(conn.scram_client_key_binary) {
			unsafe {
				goto oom_error
			}
		}
		len = pg_b64_decode(conn.scram_client_key, int(C.c2v_strlen(conn.scram_client_key)), conn.scram_client_key_binary, len)
		if len < 0 {
			libpq_append_conn_error(conn, c'invalid SCRAM client key')
			return false != 0
		}
		if len != 32 {
			libpq_append_conn_error(conn, c'invalid SCRAM client key length: %d', len)
			return false != 0
		}
		conn.scram_client_key_len = usize(len)
	}
	if conn.scram_server_key {
		len := 0
		len = pg_b64_dec_len(int(C.c2v_strlen(conn.scram_server_key)))
		conn.scram_server_key_binary = C.c2v_malloc(u64(len))
		if isnil(conn.scram_server_key_binary) {
			unsafe {
				goto oom_error
			}
		}
		len = pg_b64_decode(conn.scram_server_key, int(C.c2v_strlen(conn.scram_server_key)), conn.scram_server_key_binary, len)
		if len < 0 {
			libpq_append_conn_error(conn, c'invalid SCRAM server key')
			return false != 0
		}
		if len != 32 {
			libpq_append_conn_error(conn, c'invalid SCRAM server key length: %d', len)
			return false != 0
		}
		conn.scram_server_key_len = usize(len)
	}
	if conn.load_balance_hosts {
		if C.c2v_strcmp(conn.load_balance_hosts, c'disable') == 0 {
			conn.load_balance_type = PGLoadBalanceType.load_balance_disable
		} else if C.c2v_strcmp(conn.load_balance_hosts, c'random') == 0 {
			conn.load_balance_type = PGLoadBalanceType.load_balance_random
		} else {
			conn.status = ConnStatusType.connection_bad
			libpq_append_conn_error(conn, c'invalid %s value: "%s"', voidptr(c'load_balance_hosts'), voidptr(conn.load_balance_hosts))
			return false != 0
		}
	} else {
		conn.load_balance_type = PGLoadBalanceType.load_balance_disable
	}
	if u32(conn.load_balance_type) == u32(PGLoadBalanceType.load_balance_random) {
		libpq_prng_init(conn)
		for i = 1; i < conn.nconnhost; i++ {
			j := int(pg_prng_uint64_range(&conn.prng_state, Uint64(0), Uint64(i)))
			temp := conn.connhost[j]
			conn.connhost[j] = conn.connhost[i]
			conn.connhost[i] = temp
		}
	}
	if conn.min_protocol_version {
		if !pq_parse_protocol_version(conn.min_protocol_version, &conn.min_pversion, conn, c'min_protocol_version') {
			conn.status = ConnStatusType.connection_bad
			return false != 0
		}
	} else {
		conn.min_pversion = ProtocolVersion(((3 << 16) | 0))
	}
	if conn.max_protocol_version {
		if !pq_parse_protocol_version(conn.max_protocol_version, &conn.max_pversion, conn, c'max_protocol_version') {
			conn.status = ConnStatusType.connection_bad
			return false != 0
		}
	} else {
		if conn.min_pversion > ProtocolVersion(((3 << 16) | 0)) {
			conn.max_pversion = ProtocolVersion(((3 << 16) | 2))
		} else {
			conn.max_pversion = ProtocolVersion(((3 << 16) | 0))
		}
	}
	if conn.min_pversion > conn.max_pversion {
		conn.status = ConnStatusType.connection_bad
		libpq_append_conn_error(conn, c'"%s" is greater than "%s"', voidptr(c'min_protocol_version'), voidptr(c'max_protocol_version'))
		return false != 0
	}
	if !isnil(conn.client_encoding_initial) && C.c2v_strcmp(conn.client_encoding_initial, c'auto') == 0 {
		C.c2v_free(voidptr(conn.client_encoding_initial))
		conn.client_encoding_initial = C.c2v_strdup(pg_encoding_to_char(pg_get_encoding_from_locale((voidptr(0)), (1 != 0))))
		if isnil(conn.client_encoding_initial) {
			unsafe {
				goto oom_error
			}
		}
	}
	conn.options_valid = (1 != 0)
	return true != 0
	oom_error:
	conn.status = ConnStatusType.connection_bad
	libpq_append_conn_error(conn, c'out of memory')
	return false != 0
}

@[export: 'PQconndefaults']
@[markused]
pub fn pq_conndefaults() &PQconninfoOption {
	error_buf := PQExpBufferData{}
	conn_options := &PQconninfoOption(0)
	init_pq_exp_buffer(&error_buf)
	if (error_buf.maxlen == usize(0)) {
		return unsafe { nil }
	}
	conn_options = conninfo_init(&error_buf)
	if usize(conn_options) != usize((voidptr(0))) {
		if !conninfo_add_defaults(conn_options, (voidptr(0))) {
			pq_conninfo_free(conn_options)
			conn_options = (voidptr(0))
		}
	}
	term_pq_exp_buffer(&error_buf)
	return conn_options
}

@[export: 'PQsetdbLogin']
@[markused]
pub fn pq_setdb_login(pghost &i8, pgport &i8, pgoptions &i8, pgtty &i8, db_name &i8, login &i8, pwd &i8) &PGconn {
	conn := &PGconn(0)
	conn = pq_make_empty_pg_conn()
	if usize(conn) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	if !isnil(db_name) && int(recognized_connection_string(db_name)) {
		if !connect_options1(conn, db_name) {
			return conn
		}
	} else {
		if !connect_options1(conn, c'') {
			return conn
		}
		if !isnil(db_name) && int(db_name[0]) != i8(`\0`) {
			C.c2v_free(voidptr(conn.dbName))
			conn.dbName = C.c2v_strdup(db_name)
			if isnil(conn.dbName) {
				unsafe {
					goto oom_error
				}
			}
		}
	}
	if !isnil(pghost) && int(pghost[0]) != i8(`\0`) {
		C.c2v_free(voidptr(conn.pghost))
		conn.pghost = C.c2v_strdup(pghost)
		if isnil(conn.pghost) {
			unsafe {
				goto oom_error
			}
		}
	}
	if !isnil(pgport) && int(pgport[0]) != i8(`\0`) {
		C.c2v_free(voidptr(conn.pgport))
		conn.pgport = C.c2v_strdup(pgport)
		if isnil(conn.pgport) {
			unsafe {
				goto oom_error
			}
		}
	}
	if !isnil(pgoptions) && int(pgoptions[0]) != i8(`\0`) {
		C.c2v_free(voidptr(conn.pgoptions))
		conn.pgoptions = C.c2v_strdup(pgoptions)
		if isnil(conn.pgoptions) {
			unsafe {
				goto oom_error
			}
		}
	}
	if !isnil(login) && int(login[0]) != i8(`\0`) {
		C.c2v_free(voidptr(conn.pguser))
		conn.pguser = C.c2v_strdup(login)
		if isnil(conn.pguser) {
			unsafe {
				goto oom_error
			}
		}
	}
	if !isnil(pwd) && int(pwd[0]) != i8(`\0`) {
		C.c2v_free(voidptr(conn.pgpass))
		conn.pgpass = C.c2v_strdup(pwd)
		if isnil(conn.pgpass) {
			unsafe {
				goto oom_error
			}
		}
	}
	if !pq_connect_options2(conn) {
		return conn
	}
	if pq_connect_db_start(conn) {
		pq_connect_db_complete(conn)
	}
	return conn
	oom_error:
	conn.status = ConnStatusType.connection_bad
	libpq_append_conn_error(conn, c'out of memory')
	return conn
}

@[markused]
pub fn connect_no_delay(conn &PGconn) int {
	on := 1
	if C.c2v_setsockopt(conn.sock, 6, 1, voidptr(&i8(c2v_address_of(&on))), u32(sizeof(on))) < 0 {
		sebuf := [256]i8{}
		libpq_append_conn_error(conn, c'could not set socket to TCP no delay mode: %s', voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
		return 0
	}
	return 1
}

@[markused]
pub fn get_hostaddr(conn &PGconn, host_addr &i8, host_addr_len int) {
	addr := &conn.raddr.addr
	if int(addr.ss_family) == 2 {
		if usize(pg_inet_net_ntop(2, voidptr(&(&C.sockaddr_in(voidptr(addr))).sin_addr.s_addr), 32, host_addr, usize(host_addr_len))) == usize((voidptr(0))) {
			host_addr[0] = i8(`\0`)
		}
	} else if int(addr.ss_family) == 30 {
		if usize(pg_inet_net_ntop(30, voidptr(&(&C.sockaddr_in6(voidptr(addr))).sin6_addr.__u6_addr.__u6_addr8), 128, host_addr, usize(host_addr_len))) == usize((voidptr(0))) {
			host_addr[0] = i8(`\0`)
		}
	} else {
		host_addr[0] = i8(`\0`)
	}
}

@[markused]
pub fn emit_host_identity_info(conn &PGconn, host_addr &i8) {
	if int(conn.raddr.addr.ss_family) == 1 {
		service := [1025]i8{}
		pg_getnameinfo_all(&conn.raddr.addr, int(conn.raddr.salen), (voidptr(0)), 0, unsafe { &i8(&service[0]) }, int(sizeof([1025]i8)), 8)
		append_pq_exp_buffer(&conn.errorMessage, unsafe { &i8(&c'connection to server on socket "%s" failed: '[0]) }, unsafe { voidptr(&service[0]) })
	} else {
		displayed_host := &i8(0)
		displayed_port := &i8(0)
		if u32(conn.connhost[conn.whichhost].type_) == u32(Pg_conn_host_type.cht_host_address) {
			displayed_host = conn.connhost[conn.whichhost].hostaddr
		} else {
			displayed_host = conn.connhost[conn.whichhost].host
		}
		displayed_port = conn.connhost[conn.whichhost].port
		if usize(displayed_port) == usize((voidptr(0))) || int(displayed_port[0]) == i8(`\0`) {
			displayed_port = c'5432'
		}
		if u32(conn.connhost[conn.whichhost].type_) != u32(Pg_conn_host_type.cht_host_address) && int(host_addr[0]) && C.c2v_strcmp(displayed_host, host_addr) != 0 {
			append_pq_exp_buffer(&conn.errorMessage, unsafe { &i8(&c'connection to server at "%s" (%s), port %s failed: '[0]) }, voidptr(displayed_host), voidptr(host_addr), voidptr(displayed_port))
		} else {
			append_pq_exp_buffer(&conn.errorMessage, unsafe { &i8(&c'connection to server at "%s", port %s failed: '[0]) }, voidptr(displayed_host), voidptr(displayed_port))
		}
	}
}

@[markused]
pub fn connect_failure_message(conn &PGconn, errorno int) {
	sebuf := [256]i8{}
	append_pq_exp_buffer(&conn.errorMessage, c'%s\n', voidptr(pg_strerror_r(errorno, unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
	if int(conn.raddr.addr.ss_family) == 1 {
		libpq_append_conn_error(conn, c'\tIs the server running locally and accepting connections on that socket?')
	} else {
		libpq_append_conn_error(conn, c'\tIs the server running on that host and accepting TCP/IP connections?')
	}
}

@[markused]
pub fn use_keepalives(conn &PGconn) int {
	val := 0
	if usize(conn.keepalives) == usize((voidptr(0))) {
		return 1
	}
	if !pq_parse_int_param(conn.keepalives, &val, conn, c'keepalives') {
		return -1
	}
	return if val != 0 { 1 } else { 0 }
}

@[markused]
pub fn set_keepalives_idle(conn &PGconn) int {
	idle := 0
	if usize(conn.keepalives_idle) == usize((voidptr(0))) {
		return 1
	}
	if !pq_parse_int_param(conn.keepalives_idle, &idle, conn, c'keepalives_idle') {
		return 0
	}
	if idle < 0 {
		idle = 0
	}
	if C.c2v_setsockopt(conn.sock, 6, 16, voidptr(&i8(c2v_address_of(&idle))), u32(sizeof(idle))) < 0 {
		sebuf := [256]i8{}
		libpq_append_conn_error(conn, c'%s(%s) failed: %s', voidptr(c'setsockopt'), voidptr(c'TCP_KEEPALIVE'), voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
		return 0
	}
	return 1
}

@[markused]
pub fn set_keepalives_interval(conn &PGconn) int {
	interval := 0
	if usize(conn.keepalives_interval) == usize((voidptr(0))) {
		return 1
	}
	if !pq_parse_int_param(conn.keepalives_interval, &interval, conn, c'keepalives_interval') {
		return 0
	}
	if interval < 0 {
		interval = 0
	}
	if C.c2v_setsockopt(conn.sock, 6, 257, voidptr(&i8(c2v_address_of(&interval))), u32(sizeof(interval))) < 0 {
		sebuf := [256]i8{}
		libpq_append_conn_error(conn, c'%s(%s) failed: %s', voidptr(c'setsockopt'), voidptr(c'TCP_KEEPINTVL'), voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
		return 0
	}
	return 1
}

@[markused]
pub fn set_keepalives_count(conn &PGconn) int {
	count := 0
	if usize(conn.keepalives_count) == usize((voidptr(0))) {
		return 1
	}
	if !pq_parse_int_param(conn.keepalives_count, &count, conn, c'keepalives_count') {
		return 0
	}
	if count < 0 {
		count = 0
	}
	if C.c2v_setsockopt(conn.sock, 6, 258, voidptr(&i8(c2v_address_of(&count))), u32(sizeof(count))) < 0 {
		sebuf := [256]i8{}
		libpq_append_conn_error(conn, c'%s(%s) failed: %s', voidptr(c'setsockopt'), voidptr(c'TCP_KEEPCNT'), voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
		return 0
	}
	return 1
}

@[markused]
pub fn set_tcp_user_timeout(conn &PGconn) int {
	timeout := 0
	if usize(conn.pgtcp_user_timeout) == usize((voidptr(0))) {
		return 1
	}
	if !pq_parse_int_param(conn.pgtcp_user_timeout, &timeout, conn, c'tcp_user_timeout') {
		return 0
	}
	if timeout < 0 {
		timeout = 0
	}
	return 1
}

@[export: 'pqConnectDBStart']
@[markused]
pub fn pq_connect_db_start(conn &PGconn) int {
	if isnil(conn) {
		return 0
	}
	if !conn.options_valid {
		unsafe {
			goto connect_errReturn
		}
	}
	if !pg_link_canary_is_frontend() {
		append_pq_exp_buffer_str(&conn.errorMessage, c'libpq is incorrectly linked to backend functions\n')
		unsafe {
			goto connect_errReturn
		}
	}
	conn.inEnd = 0
	conn.inCursor = conn.inEnd
	conn.inStart = conn.inCursor
	conn.outCount = 0
	if !conn.cancelRequest {
		conn.whichhost = -1
		conn.try_next_host = (1 != 0)
		conn.try_next_addr = (0 != 0)
	}
	conn.status = ConnStatusType.connection_needed
	if u32(conn.target_server_type) == u32(PGTargetServerType.server_type_prefer_standby_pass2) {
		conn.target_server_type = PGTargetServerType.server_type_prefer_standby
	}
	if u32(pq_connect_poll(conn)) == u32(PostgresPollingStatusType.pgres_polling_writing) {
		return 1
	}
	connect_errReturn:
	pq_drop_connection(conn, (1 != 0))
	conn.status = ConnStatusType.connection_bad
	return 0
}

@[export: 'pqConnectDBComplete']
@[markused]
pub fn pq_connect_db_complete(conn &PGconn) int {
	flag := PostgresPollingStatusType.pgres_polling_writing
	end_time := Pg_usec_time_t(-1)
	timeout := 0
	last_whichhost := -2
	last_whichaddr := -2
	if usize(conn) == usize((voidptr(0))) || u32(conn.status) == u32(ConnStatusType.connection_bad) {
		return 0
	}
	if usize(conn.connect_timeout) != usize((voidptr(0))) {
		if !pq_parse_int_param(conn.connect_timeout, &timeout, conn, c'connect_timeout') {
			conn.status = ConnStatusType.connection_bad
			return 0
		}
	}
	for {
		ret := 0
		if u32(flag) != u32(PostgresPollingStatusType.pgres_polling_ok) && timeout > 0 && (conn.whichhost != last_whichhost || conn.whichaddr != last_whichaddr) {
			end_time = pq_get_current_time_us_ec() + Pg_usec_time_t(timeout) * Pg_usec_time_t(1000000)
			last_whichhost = conn.whichhost
			last_whichaddr = conn.whichaddr
		}
		match flag {
			.pgres_polling_ok {
				return 1
			}
			.pgres_polling_reading {
				ret = pq_wait_timed(1, 0, conn, end_time)
				if ret == -1 {
					conn.status = ConnStatusType.connection_bad
					return 0
				}
			}
			.pgres_polling_writing {
				ret = pq_wait_timed(0, 1, conn, end_time)
				if ret == -1 {
					conn.status = ConnStatusType.connection_bad
					return 0
				}
			}
			else {
				conn.status = ConnStatusType.connection_bad
				return 0
			}
		}

		if ret == 1 {
			conn.try_next_addr = (1 != 0)
			conn.status = ConnStatusType.connection_needed
		}
		if conn.cancelRequest {
			flag = pq_cancel_poll(&PGcancelConn_fe_connect(voidptr(conn)))
		} else {
			flag = pq_connect_poll(conn)
		}
	}
	panic('unreachable after C for (;;)')
}

@[export: 'PQconnectPoll']
@[markused]
pub fn pq_connect_poll(conn &PGconn) PostgresPollingStatusType {
	reset_connection_state_machine := (0 != 0)
	need_new_connection := (0 != 0)
	res := &PGresult(0)
	sebuf := [256]i8{}
	optval := 0
	if usize(conn) == usize((voidptr(0))) {
		return PostgresPollingStatusType.pgres_polling_failed
	}
	match conn.status {
		.connection_bad {
			return PostgresPollingStatusType.pgres_polling_failed
		}
		.connection_ok {
			return PostgresPollingStatusType.pgres_polling_ok
		}
		.connection_awaiting_response, .connection_auth_ok, .connection_check_writable, .connection_consume, .connection_check_standby {
			n := pq_read_data(conn)
			if n < 0 {
				unsafe {
					goto error_return
				}
			}
			if n == 0 {
				return PostgresPollingStatusType.pgres_polling_reading
			}
		}
		.connection_started, .connection_made {
		}
		.connection_ssl_startup, .connection_needed, .connection_gss_startup, .connection_check_target, .connection_authenticating {
		}
		else {
			libpq_append_conn_error(conn, c'invalid connection state, probably indicative of memory corruption')
			unsafe {
				goto error_return
			}
		}
	}

	keep_going:
	if conn.try_next_addr {
		if conn.whichaddr < conn.naddr {
			conn.whichaddr++
			reset_connection_state_machine = (1 != 0)
		} else {
			conn.try_next_host = (1 != 0)
		}
		conn.try_next_addr = (0 != 0)
	}
	if conn.try_next_host {
		ch := &Pg_conn_host(0)
		hint := C.addrinfo{}
		addrlist := &C.addrinfo(0)
		thisport := 0
		ret := 0
		portstr := [1024]i8{}
		if conn.whichhost + 1 < conn.nconnhost {
			conn.whichhost++
		} else {
			if u32(conn.target_server_type) == u32(PGTargetServerType.server_type_prefer_standby) && conn.nconnhost > 0 && !conn.cancelRequest {
				conn.target_server_type = PGTargetServerType.server_type_prefer_standby_pass2
				conn.whichhost = 0
			} else {
				unsafe {
					goto error_return
				}
			}
		}
		release_conn_addrinfo(conn)
		ch = unsafe { conn.connhost + conn.whichhost }
		for {
			vstart := voidptr(c2v_address_of(&hint))
			val := 0
			len := (sizeof(hint))
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
		hint.ai_socktype = 1
		hint.ai_family = 0
		if usize(ch.port) == usize((voidptr(0))) || int(ch.port[0]) == i8(`\0`) {
			thisport = 5432
		} else {
			if !pq_parse_int_param(ch.port, &thisport, conn, c'port') {
				unsafe {
					goto error_return
				}
			}
			if thisport < 1 || thisport > 65535 {
				libpq_append_conn_error(conn, c'invalid port number: "%s"', voidptr(ch.port))
				unsafe {
					goto keep_going
				}
			}
		}
		pg_snprintf(unsafe { &i8(&portstr[0]) }, sizeof([1024]i8), c'%d', thisport)
		match ch.type_ {
			.cht_host_name {
				ret = pg_getaddrinfo_all(ch.host, unsafe { &i8(&portstr[0]) }, &hint, &&C.addrinfo(&&C.addrinfo(c2v_address_of(&addrlist))))
				if ret || isnil(addrlist) {
					libpq_append_conn_error(conn, c'could not translate host name "%s" to address: %s', voidptr(ch.host), voidptr(C.c2v_gai_strerror(ret)))
					unsafe {
						goto keep_going
					}
				}
			}
			.cht_host_address {
				hint.ai_flags = 4
				ret = pg_getaddrinfo_all(ch.hostaddr, unsafe { &i8(&portstr[0]) }, &hint, &&C.addrinfo(&&C.addrinfo(c2v_address_of(&addrlist))))
				if ret || isnil(addrlist) {
					libpq_append_conn_error(conn, c'could not parse network address "%s": %s', voidptr(ch.hostaddr), voidptr(C.c2v_gai_strerror(ret)))
					unsafe {
						goto keep_going
					}
				}
			}
			.cht_unix_socket {
				hint.ai_family = 1

				pg_snprintf(unsafe { &i8(&portstr[0]) }, sizeof([1024]i8), c'%s/.s.PGSQL.%d', voidptr(ch.host), thisport)
				if C.c2v_strlen(unsafe { &i8(&portstr[0]) }) >= sizeof([104]i8) {
					libpq_append_conn_error(conn, c'Unix-domain socket path "%s" is too long (maximum %d bytes)', unsafe { voidptr(&portstr[0]) }, int((sizeof([104]i8) - u64(1))))
					unsafe {
						goto keep_going
					}
				}
				ret = pg_getaddrinfo_all((voidptr(0)), unsafe { &i8(&portstr[0]) }, &hint, &&C.addrinfo(&&C.addrinfo(c2v_address_of(&addrlist))))
				if ret || isnil(addrlist) {
					libpq_append_conn_error(conn, c'could not translate Unix-domain socket path "%s" to address: %s', unsafe { voidptr(&portstr[0]) }, voidptr(C.c2v_gai_strerror(ret)))
					unsafe {
						goto keep_going
					}
				}
			}
			else {}
		}

		ret = store_conn_addrinfo(conn, addrlist)
		pg_freeaddrinfo_all(hint.ai_family, addrlist)
		if ret {
			unsafe {
				goto error_return
			}
		}
		if u32(conn.load_balance_type) == u32(PGLoadBalanceType.load_balance_random) {
			for i := 1; i < conn.naddr; i++ {
				j := int(pg_prng_uint64_range(&conn.prng_state, Uint64(0), Uint64(i)))
				temp := conn.addr[j]
				conn.addr[j] = conn.addr[i]
				conn.addr[i] = temp
			}
		}
		reset_connection_state_machine = (1 != 0)
		conn.try_next_host = (0 != 0)
	}
	if reset_connection_state_machine {
		conn.pversion = conn.max_pversion
		conn.send_appname = (1 != 0)
		conn.failed_enc_methods = Uint8(0)
		conn.current_enc_method = Uint8(0)
		conn.allowed_enc_methods = Uint8(0)
		reset_connection_state_machine = (0 != 0)
		need_new_connection = (1 != 0)
	}
	if need_new_connection {
		pq_drop_connection(conn, (1 != 0))
		pq_drop_server_data(conn)
		conn.asyncStatus = PGAsyncStatusType.pgasync_idle
		conn.xactStatus = PGTransactionStatusType.pqtrans_idle
		conn.pipelineStatus = PGpipelineStatus.pq_pipeline_off
		pq_clear_async_result(conn)
		conn.status = ConnStatusType.connection_needed
		need_new_connection = (0 != 0)
	}
	match conn.status {
		.connection_needed {
			host_addr := [1025]i8{}
			sock_type := 0
			addr_cur := &AddrInfo(0)
			if conn.whichaddr == conn.naddr {
				conn.try_next_host = (1 != 0)
				unsafe {
					goto keep_going
				}
			}
			addr_cur = unsafe { conn.addr + conn.whichaddr }
			C.c2v_memcpy(voidptr(&conn.raddr), voidptr(&addr_cur.addr), sizeof(SockAddr))
			if !init_allowed_encryption_methods(conn) {
				unsafe {
					goto error_return
				}
			}
			if usize(conn.connip) != usize((voidptr(0))) {
				C.c2v_free(voidptr(conn.connip))
				conn.connip = (voidptr(0))
			}
			get_hostaddr(conn, unsafe { &i8(&host_addr[0]) }, 1025)
			if host_addr[0] {
				conn.connip = C.c2v_strdup(unsafe { &i8(&host_addr[0]) })
			}
			sock_type = 1
			conn.sock = C.c2v_socket(addr_cur.family, sock_type, 0)
			if conn.sock == (-1) {
				errorno := (unsafe { *C.c2v___error() })
				if conn.whichaddr < conn.naddr || conn.whichhost + 1 < conn.nconnhost {
					conn.try_next_addr = (1 != 0)
					unsafe {
						goto keep_going
					}
				}
				emit_host_identity_info(conn, unsafe { &i8(&host_addr[0]) })
				libpq_append_conn_error(conn, c'could not create socket: %s', voidptr(pg_strerror_r(errorno, unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
				unsafe {
					goto error_return
				}
			}
			emit_host_identity_info(conn, unsafe { &i8(&host_addr[0]) })
			if addr_cur.family != 1 {
				if !connect_no_delay(conn) {
					conn.try_next_addr = (1 != 0)
					unsafe {
						goto keep_going
					}
				}
			}
			if !pg_set_noblock(conn.sock) {
				libpq_append_conn_error(conn, c'could not set socket to nonblocking mode: %s', voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
				conn.try_next_addr = (1 != 0)
				unsafe {
					goto keep_going
				}
			}
			if C.c2v_fcntl(conn.sock, 2, 1) == -1 {
				libpq_append_conn_error(conn, c'could not set socket to close-on-exec mode: %s', voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
				conn.try_next_addr = (1 != 0)
				unsafe {
					goto keep_going
				}
			}
			if addr_cur.family != 1 {
				on := 1
				usekeepalives := use_keepalives(conn)
				err := 0
				if usekeepalives < 0 {
					err = 1
				} else if usekeepalives == 0 {
				} else if C.c2v_setsockopt(conn.sock, 65535, 8, voidptr(&i8(c2v_address_of(&on))), u32(sizeof(on))) < 0 {
					libpq_append_conn_error(conn, c'%s(%s) failed: %s', voidptr(c'setsockopt'), voidptr(c'SO_KEEPALIVE'), voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
					err = 1
				} else if !set_keepalives_idle(conn) || !set_keepalives_interval(conn) || !set_keepalives_count(conn) {
					err = 1
				} else if !set_tcp_user_timeout(conn) {
					err = 1
				}
				if err {
					conn.try_next_addr = (1 != 0)
					unsafe {
						goto keep_going
					}
				}
			}
			conn.sigpipe_so = (0 != 0)
			conn.sigpipe_flag = (1 != 0)
			optval = 1
			if C.c2v_setsockopt(conn.sock, 65535, 4130, voidptr(&i8(c2v_address_of(&optval))), u32(sizeof(optval))) == 0 {
				conn.sigpipe_so = (1 != 0)
				conn.sigpipe_flag = (0 != 0)
			}
			if C.c2v_connect(conn.sock, &C.sockaddr(voidptr(&addr_cur.addr.addr)), addr_cur.addr.salen) < 0 {
				if (unsafe { *C.c2v___error() }) == 36 || (unsafe { *C.c2v___error() }) == 4 {
					conn.status = ConnStatusType.connection_started
					return PostgresPollingStatusType.pgres_polling_writing
				}
			} else {
				conn.status = ConnStatusType.connection_started
				unsafe {
					goto keep_going
				}
			}
			connect_failure_message(conn, (unsafe { *C.c2v___error() }))
			conn.try_next_addr = (1 != 0)
			unsafe {
				goto keep_going
			}
		}
		.connection_started {
			optlen := u32(sizeof(optval))
			if C.c2v_getsockopt(conn.sock, 65535, 4103, voidptr(&i8(c2v_address_of(&optval))), &optlen) == -1 {
				libpq_append_conn_error(conn, c'could not get socket error status: %s', voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
				unsafe {
					goto error_return
				}
			} else if optval != 0 {
				connect_failure_message(conn, optval)
				conn.try_next_addr = (1 != 0)
				unsafe {
					goto keep_going
				}
			}
			conn.laddr.salen = u32(sizeof(C.sockaddr_storage))
			if C.c2v_getsockname(conn.sock, &C.sockaddr(voidptr(&conn.laddr.addr)), &conn.laddr.salen) < 0 {
				libpq_append_conn_error(conn, c'could not get client address from socket: %s', voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
				unsafe {
					goto error_return
				}
			}
			if !isnil(conn.requirepeer) && int(conn.requirepeer[0]) && int(conn.raddr.addr.ss_family) == 1 {
				remote_username := &i8(0)
				uid := u32(0)
				gid := u32(0)
				{
					c2v_target := C.c2v___error()
					unsafe { *c2v_target = 0 }
				}
				if C.c2v_getpeereid(conn.sock, &uid, &gid) != 0 {
					if (unsafe { *C.c2v___error() }) == 78 {
						libpq_append_conn_error(conn, c'requirepeer parameter is not supported on this platform')
					} else {
						libpq_append_conn_error(conn, c'could not get peer credentials: %s', voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
					}
					unsafe {
						goto error_return
					}
				}
				remote_username = pg_fe_getusername(uid, &conn.errorMessage)
				if usize(remote_username) == usize((voidptr(0))) {
					unsafe {
						goto error_return
					}
				}
				if C.c2v_strcmp(remote_username, conn.requirepeer) != 0 {
					libpq_append_conn_error(conn, c'requirepeer specifies "%s", but actual peer user name is "%s"', voidptr(conn.requirepeer), voidptr(remote_username))
					C.c2v_free(voidptr(remote_username))
					unsafe {
						goto error_return
					}
				}
				C.c2v_free(voidptr(remote_username))
			}
			conn.status = ConnStatusType.connection_made
			return PostgresPollingStatusType.pgres_polling_writing
		}
		.connection_made {
			startpacket := &i8(0)
			packetlen := 0
			if conn.cancelRequest {
				if pq_send_cancel_request(conn) != 0 {
					libpq_append_conn_error(conn, c'could not send cancel packet: %s', voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
					unsafe {
						goto error_return
					}
				}
				conn.status = ConnStatusType.connection_awaiting_response
				return PostgresPollingStatusType.pgres_polling_reading
			}
			startpacket = pq_build_startup_packet3(conn, &packetlen, &libpq_fe_connect_environment_options[0])
			if isnil(startpacket) {
				libpq_append_conn_error(conn, c'out of memory')
				unsafe {
					goto error_return
				}
			}
			if pq_packet_send(conn, i8(0), voidptr(startpacket), usize(packetlen)) != 0 {
				libpq_append_conn_error(conn, c'could not send startup packet: %s', voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
				C.c2v_free(voidptr(startpacket))
				unsafe {
					goto error_return
				}
			}
			C.c2v_free(voidptr(startpacket))
			conn.status = ConnStatusType.connection_awaiting_response
			return PostgresPollingStatusType.pgres_polling_reading
		}
		.connection_ssl_startup {
			unsafe {
				goto error_return
			}
		}
		.connection_gss_startup {
			unsafe {
				goto error_return
			}
		}
		.connection_awaiting_response {
			beresp := i8(0)
			msg_length := 0
			avail := 0
			areq := AuthRequest(0)
			res_2 := 0
			async := false
			conn.inCursor = conn.inStart
			if pq_getc(&beresp, conn) {
				return PostgresPollingStatusType.pgres_polling_reading
			}
			if int(beresp) != i8(`R`) && int(beresp) != i8(`E`) && int(beresp) != i8(`v`) {
				libpq_append_conn_error(conn, c'expected authentication request from server, but received %c', int(beresp))
				unsafe {
					goto error_return
				}
			}
			if pq_get_int(&msg_length, usize(4), conn) {
				return PostgresPollingStatusType.pgres_polling_reading
			}
			if int(beresp) == i8(`R`) && (msg_length < 8 || msg_length > 2000) {
				libpq_append_conn_error(conn, c'received invalid authentication request')
				unsafe {
					goto error_return
				}
			}
			if int(beresp) == i8(`v`) && (msg_length < 8 || msg_length > 2000) {
				libpq_append_conn_error(conn, c'received invalid protocol negotiation message')
				unsafe {
					goto error_return
				}
			}
			if int(beresp) == i8(`E`) && (msg_length < 8 || msg_length > 30000) {
				conn.inCursor = conn.inStart + 1
				if pq_gets_append(&conn.errorMessage, conn) {
					avail = conn.inEnd - conn.inCursor
					if avail > 30000 {
						libpq_append_conn_error(conn, c'received invalid error message')
						unsafe {
							goto error_return
						}
					}
					return PostgresPollingStatusType.pgres_polling_reading
				}
				pq_parse_done(conn, conn.inCursor)
				if conn.errorMessage.len == usize(0) || int(conn.errorMessage.data[conn.errorMessage.len - usize(1)]) != i8(`\n`) {
					append_pq_exp_buffer_char(&conn.errorMessage, i8(`\n`))
				}
				unsafe {
					goto error_return
				}
			}
			msg_length -= 4
			avail = conn.inEnd - conn.inCursor
			if avail < msg_length {
				if pq_check_in_buffer_space(usize(conn.inCursor) + usize(msg_length), conn) {
					unsafe {
						goto error_return
					}
				}
				return PostgresPollingStatusType.pgres_polling_reading
			}
			if int(beresp) == i8(`E`) {
				if pq_get_error_notice3(conn, (1 != 0)) {
					libpq_append_conn_error(conn, c'received invalid error message')
					unsafe {
						goto error_return
					}
				}
				pq_parse_done(conn, conn.inCursor)
				if C.c2v_strcmp(unsafe { &i8(&conn.last_sqlstate[0]) }, c'57P03') == 0 {
					conn.try_next_host = (1 != 0)
					unsafe {
						goto keep_going
					}
				}
				pgpassfile_warning(conn)
				for {
					if connection_failed(conn) {
						need_new_connection = (1 != 0)
						unsafe {
							goto keep_going
						}
					} else {
						unsafe {
							goto error_return
						}
					}
					break
				}
			} else if int(beresp) == i8(`v`) {
				if conn.pversion_negotiated {
					libpq_append_conn_error(conn, c'received duplicate protocol negotiation message')
					unsafe {
						goto error_return
					}
				}
				if pq_get_negotiate_protocol_version3(conn) {
					unsafe {
						goto error_return
					}
				}
				conn.pversion_negotiated = (1 != 0)
				pq_parse_done(conn, conn.inCursor)
				unsafe {
					goto keep_going
				}
			}
			conn.auth_req_received = (1 != 0)
			if pq_get_int(&int(c2v_address_of(&areq)), usize(4), conn) {
				libpq_append_conn_error(conn, c'received invalid authentication request')
				unsafe {
					goto error_return
				}
			}
			msg_length -= 4
			res_2 = pg_fe_sendauth(areq, msg_length, conn, &async)
			if int(async) && (res_2 == 0) {
				conn.status = ConnStatusType.connection_authenticating
				unsafe {
					goto keep_going
				}
			}
			conn.inStart = conn.inCursor
			if res_2 != 0 {
				if usize(conn.sasl) == usize(&pg_oauth_mech) && int(conn.oauth_want_retry) {
					need_new_connection = (1 != 0)
					unsafe {
						goto keep_going
					}
				}
				unsafe {
					goto error_return
				}
			}
			if pq_flush_vdup1(conn) {
				unsafe {
					goto error_return
				}
			}
			if areq == AuthRequest(0) {
				conn.status = ConnStatusType.connection_auth_ok
				conn.asyncStatus = PGAsyncStatusType.pgasync_busy
			}
			unsafe {
				goto keep_going
			}
		}
		.connection_authenticating {
			status := PostgresPollingStatusType{}
			if isnil(conn.async_auth) || isnil(conn.cleanup_async_auth) {
				libpq_append_conn_error(conn, c'internal error: async authentication has no handler')
				unsafe {
					goto error_return
				}
			}
			status = conn.async_auth(conn)
			if u32(status) == u32(PostgresPollingStatusType.pgres_polling_failed) {
				unsafe {
					goto error_return
				}
			}
			if u32(status) == u32(PostgresPollingStatusType.pgres_polling_ok) {
				conn.cleanup_async_auth(conn)
				conn.cleanup_async_auth = (voidptr(0))
				if conn.altsock != (-1) {
					libpq_append_conn_error(conn, c'internal error: async cleanup did not release polling socket')
					unsafe {
						goto error_return
					}
				}
				conn.status = ConnStatusType.connection_awaiting_response
				unsafe {
					goto keep_going
				}
			}
			if conn.altsock == (-1) {
				libpq_append_conn_error(conn, c'internal error: async authentication did not set a socket for polling')
				unsafe {
					goto error_return
				}
			}
			return status
		}
		.connection_auth_ok {
			if pq_is_busy(conn) {
				return PostgresPollingStatusType.pgres_polling_reading
			}
			res = pq_get_result(conn)
			if res {
				if u32(res.resultStatus) != u32(ExecStatusType.pgres_fatal_error) {
					libpq_append_conn_error(conn, c'unexpected message from server during startup')
				} else if int(conn.send_appname) && (!isnil(conn.appname) || !isnil(conn.fbappname)) {
					sqlstate := &i8(0)
					sqlstate = pq_result_error_field(res, `C`)
					if !isnil(sqlstate) && C.c2v_strcmp(sqlstate, c'42704') == 0 {
						pq_clear(res)
						conn.send_appname = (0 != 0)
						need_new_connection = (1 != 0)
						unsafe {
							goto keep_going
						}
					}
				}
				if conn.errorMessage.len <= usize(0) || int(conn.errorMessage.data[conn.errorMessage.len - usize(1)]) != i8(`\n`) {
					append_pq_exp_buffer_char(&conn.errorMessage, i8(`\n`))
				}
				pq_clear(res)
				unsafe {
					goto error_return
				}
			}
			conn.status = ConnStatusType.connection_check_target
			unsafe {
				goto keep_going
			}
		}
		.connection_check_target {
			if u32(conn.target_server_type) == u32(PGTargetServerType.server_type_read_write) || u32(conn.target_server_type) == u32(PGTargetServerType.server_type_read_only) {
				read_only_server := false
				if u32(conn.default_transaction_read_only) == u32(PGTernaryBool.pg_bool_unknown) || u32(conn.in_hot_standby) == u32(PGTernaryBool.pg_bool_unknown) {
					conn.status = ConnStatusType.connection_ok
					if !pq_send_query_continue(conn, c'SHOW transaction_read_only') {
						unsafe {
							goto error_return
						}
					}
					conn.status = ConnStatusType.connection_check_writable
					return PostgresPollingStatusType.pgres_polling_reading
				}
				read_only_server = ((u32(conn.default_transaction_read_only) == u32(PGTernaryBool.pg_bool_yes) || u32(conn.in_hot_standby) == u32(PGTernaryBool.pg_bool_yes)) != 0)
				if if (u32(conn.target_server_type) == u32(PGTargetServerType.server_type_read_write)) {
					int(read_only_server)
				} else {
					!read_only_server
				} {
					if u32(conn.target_server_type) == u32(PGTargetServerType.server_type_read_write) {
						libpq_append_conn_error(conn, c'session is read-only')
					} else {
						libpq_append_conn_error(conn, c'session is not read-only')
					}
					conn.status = ConnStatusType.connection_ok
					send_terminate_conn(conn)
					conn.try_next_host = (1 != 0)
					unsafe {
						goto keep_going
					}
				}
			} else if u32(conn.target_server_type) == u32(PGTargetServerType.server_type_primary) || u32(conn.target_server_type) == u32(PGTargetServerType.server_type_standby) || u32(conn.target_server_type) == u32(PGTargetServerType.server_type_prefer_standby) {
				if conn.sversion < 90000 {
					conn.in_hot_standby = PGTernaryBool.pg_bool_no
				}
				if u32(conn.in_hot_standby) == u32(PGTernaryBool.pg_bool_unknown) {
					conn.status = ConnStatusType.connection_ok
					if !pq_send_query_continue(conn, c'SELECT pg_catalog.pg_is_in_recovery()') {
						unsafe {
							goto error_return
						}
					}
					conn.status = ConnStatusType.connection_check_standby
					return PostgresPollingStatusType.pgres_polling_reading
				}
				if if (u32(conn.target_server_type) == u32(PGTargetServerType.server_type_primary)) {
					(u32(conn.in_hot_standby) == u32(PGTernaryBool.pg_bool_yes))
				} else {
					(u32(conn.in_hot_standby) == u32(PGTernaryBool.pg_bool_no))
				} {
					if u32(conn.target_server_type) == u32(PGTargetServerType.server_type_primary) {
						libpq_append_conn_error(conn, c'server is in hot standby mode')
					} else {
						libpq_append_conn_error(conn, c'server is not in hot standby mode')
					}
					conn.status = ConnStatusType.connection_ok
					send_terminate_conn(conn)
					conn.try_next_host = (1 != 0)
					unsafe {
						goto keep_going
					}
				}
			}
			pq_clear_oa_uth_token(conn)
			if !conn.cancelRequest {
				release_conn_addrinfo(conn)
			}
			reset_pq_exp_buffer(&conn.errorMessage)
			conn.errorReported = 0
			conn.status = ConnStatusType.connection_ok
			return PostgresPollingStatusType.pgres_polling_ok
		}
		.connection_consume {
			conn.status = ConnStatusType.connection_ok
			if !pq_consume_input(conn) {
				unsafe {
					goto error_return
				}
			}
			if pq_is_busy(conn) {
				conn.status = ConnStatusType.connection_consume
				return PostgresPollingStatusType.pgres_polling_reading
			}
			res = pq_get_result(conn)
			if usize(res) != usize((voidptr(0))) {
				pq_clear(res)
				conn.status = ConnStatusType.connection_consume
				return PostgresPollingStatusType.pgres_polling_reading
			}
			conn.status = ConnStatusType.connection_check_target
			unsafe {
				goto keep_going
			}
		}
		.connection_check_writable {
			conn.status = ConnStatusType.connection_ok
			if !pq_consume_input(conn) {
				unsafe {
					goto error_return
				}
			}
			if pq_is_busy(conn) {
				conn.status = ConnStatusType.connection_check_writable
				return PostgresPollingStatusType.pgres_polling_reading
			}
			res = pq_get_result(conn)
			if !isnil(res) && u32(pq_result_status(res)) == u32(ExecStatusType.pgres_tuples_ok) && pq_ntuples(res) == 1 {
				val := pq_getvalue(res, 0, 0)
				if C.c2v_strncmp(val, c'on', u64(2)) == 0 {
					conn.default_transaction_read_only = PGTernaryBool.pg_bool_yes
					conn.in_hot_standby = PGTernaryBool.pg_bool_yes
				} else {
					conn.default_transaction_read_only = PGTernaryBool.pg_bool_no
					conn.in_hot_standby = PGTernaryBool.pg_bool_no
				}
				pq_clear(res)
				conn.status = ConnStatusType.connection_consume
				unsafe {
					goto keep_going
				}
			}
			pq_clear(res)
			libpq_append_conn_error(conn, c'"%s" failed', voidptr(c'SHOW transaction_read_only'))
			conn.status = ConnStatusType.connection_ok
			send_terminate_conn(conn)
			conn.try_next_host = (1 != 0)
			unsafe {
				goto keep_going
			}
		}
		.connection_check_standby {
			conn.status = ConnStatusType.connection_ok
			if !pq_consume_input(conn) {
				unsafe {
					goto error_return
				}
			}
			if pq_is_busy(conn) {
				conn.status = ConnStatusType.connection_check_standby
				return PostgresPollingStatusType.pgres_polling_reading
			}
			res = pq_get_result(conn)
			if !isnil(res) && u32(pq_result_status(res)) == u32(ExecStatusType.pgres_tuples_ok) && pq_ntuples(res) == 1 {
				val := pq_getvalue(res, 0, 0)
				if C.c2v_strncmp(val, c't', u64(1)) == 0 {
					conn.in_hot_standby = PGTernaryBool.pg_bool_yes
				} else {
					conn.in_hot_standby = PGTernaryBool.pg_bool_no
				}
				pq_clear(res)
				conn.status = ConnStatusType.connection_consume
				unsafe {
					goto keep_going
				}
			}
			pq_clear(res)
			libpq_append_conn_error(conn, c'"%s" failed', voidptr(c'SELECT pg_is_in_recovery()'))
			conn.status = ConnStatusType.connection_ok
			send_terminate_conn(conn)
			conn.try_next_host = (1 != 0)
			unsafe {
				goto keep_going
			}
		}
		else {
			libpq_append_conn_error(conn, c'invalid connection state %d, probably indicative of memory corruption', u32(conn.status))
			unsafe {
				goto error_return
			}
		}
	}

	error_return:
	conn.status = ConnStatusType.connection_bad
	return PostgresPollingStatusType.pgres_polling_failed
}

@[markused]
pub fn init_allowed_encryption_methods(conn &PGconn) bool {
	if int(conn.raddr.addr.ss_family) == 1 {
		conn.allowed_enc_methods &= ~(4 | 2)
		if int(conn.gssencmode[0]) == i8(`r`) {
			libpq_append_conn_error(conn, c'GSSAPI encryption required but it is not supported over a local socket')
			conn.allowed_enc_methods = Uint8(0)
			conn.current_enc_method = Uint8(0)
			return false != 0
		}
		conn.allowed_enc_methods = Uint8(1)
		conn.current_enc_method = Uint8(1)
		return true != 0
	}
	conn.allowed_enc_methods = Uint8(0)
	if (int(conn.sslmode[0]) == i8(`d`) || int(conn.sslmode[0]) == i8(`p`) || int(conn.sslmode[0]) == i8(`a`)) && (int(conn.gssencmode[0]) == i8(`d`) || int(conn.gssencmode[0]) == i8(`p`)) {
		conn.allowed_enc_methods |= 1
	}
	return select_next_encryption_method(conn, (0 != 0))
}

@[markused]
pub fn connection_failed(conn &PGconn) bool {
	conn.failed_enc_methods |= int(conn.current_enc_method)
	return select_next_encryption_method(conn, (0 != 0))
}

@[markused]
pub fn select_next_encryption_method(conn &PGconn, have_valid_connection bool) bool {
	remaining_methods := 0
	remaining_methods = int(conn.allowed_enc_methods) & ~int(conn.failed_enc_methods)
	if int(conn.sslmode[0]) == i8(`a`) {
		for {
			if (remaining_methods & 1) != 0 {
				conn.current_enc_method = Uint8(1)
				return true != 0
			}
			break
		}
	}
	for {
		if (remaining_methods & 4) != 0 {
			conn.current_enc_method = Uint8(4)
			return true != 0
		}
		break
	}
	if int(conn.sslmode[0]) != i8(`a`) {
		for {
			if (remaining_methods & 1) != 0 {
				conn.current_enc_method = Uint8(1)
				return true != 0
			}
			break
		}
	}
	conn.current_enc_method = Uint8(0)
	return false != 0
}

@[markused]
pub fn internal_ping(conn &PGconn) PGPing {
	if isnil(conn) || !conn.options_valid {
		return PGPing.pqping_no_attempt
	}
	if u32(conn.status) != u32(ConnStatusType.connection_bad) {
		pq_connect_db_complete(conn)
	}
	if u32(conn.status) != u32(ConnStatusType.connection_bad) {
		return PGPing.pqping_ok
	}
	if conn.auth_req_received {
		return PGPing.pqping_ok
	}
	if C.c2v_strlen(unsafe { &i8(&conn.last_sqlstate[0]) }) != u64(5) {
		return PGPing.pqping_no_response
	}
	if C.c2v_strcmp(unsafe { &i8(&conn.last_sqlstate[0]) }, c'57P03') == 0 {
		return PGPing.pqping_reject
	}
	return PGPing.pqping_ok
}

@[export: 'pqMakeEmptyPGconn']
@[markused]
pub fn pq_make_empty_pg_conn() &PGconn {
	conn := &PGconn(0)
	conn = &PGconn(C.c2v_malloc(sizeof(PGconn)))
	if usize(conn) == usize((voidptr(0))) {
		return conn
	}
	for {
		vstart := voidptr(conn)
		val := 0
		len := (sizeof(PGconn))
		if ((usize(vstart)) & (sizeof(i64) - u64(1))) == u64(0) && (len & (sizeof(i64) - u64(1))) == u64(0) && val == 0 && len <= Size(1024) && 1024 != 0 {
			start := &i64(vstart)
			stop := &i64(voidptr((&i8(voidptr(start)) + len)))
			for usize(start) < usize(stop) {
				mut __c2v_lhs_tmp_1 := unsafe { c2v_pointer_postfix(voidptr(&start), start, isize(1)) }
				unsafe { *__c2v_lhs_tmp_1 = i64(0) }
			}
		} else {
			C.c2v_memset(voidptr(vstart), val, len)
		}
		break
	}
	conn.noticeHooks.noticeRec = default_notice_receiver
	conn.noticeHooks.noticeProc = default_notice_processor
	conn.status = ConnStatusType.connection_bad
	conn.asyncStatus = PGAsyncStatusType.pgasync_idle
	conn.pipelineStatus = PGpipelineStatus.pq_pipeline_off
	conn.xactStatus = PGTransactionStatusType.pqtrans_idle
	conn.options_valid = (0 != 0)
	conn.nonblocking = (0 != 0)
	conn.client_encoding = Pg_enc.pg_sql_ascii
	conn.std_strings = (0 != 0)
	conn.default_transaction_read_only = PGTernaryBool.pg_bool_unknown
	conn.in_hot_standby = PGTernaryBool.pg_bool_unknown
	conn.scram_sha_256_iterations = 4096
	conn.verbosity = PGVerbosity.pqerrors_default
	conn.show_context = PGContextVisibility.pqshow_context_errors
	conn.sock = (-1)
	conn.altsock = (-1)
	conn.pfdebug = (voidptr(0))
	conn.inBufSize = 16 * 1024
	conn.inBuffer = &i8(C.c2v_malloc(u64(conn.inBufSize)))
	conn.outBufSize = 16 * 1024
	conn.outBuffer = &i8(C.c2v_malloc(u64(conn.outBufSize)))
	conn.rowBufLen = 32
	conn.rowBuf = &PGdataValue(C.c2v_malloc(u64(conn.rowBufLen) * sizeof(PGdataValue)))
	init_pq_exp_buffer(&conn.errorMessage)
	init_pq_exp_buffer(&conn.workBuffer)
	mut __c2v_condition_2 := false
	mut __c2v_condition_3 := false
	__c2v_condition_3 = usize(conn.inBuffer) == usize((voidptr(0)))
	__c2v_condition_2 = __c2v_condition_3
	if !__c2v_condition_2 {
		mut __c2v_condition_4 := false
		__c2v_condition_4 = usize(conn.outBuffer) == usize((voidptr(0)))
		__c2v_condition_2 = __c2v_condition_4
	}
	if !__c2v_condition_2 {
		mut __c2v_condition_5 := false
		__c2v_condition_5 = usize(conn.rowBuf) == usize((voidptr(0)))
		__c2v_condition_2 = __c2v_condition_5
	}
	if !__c2v_condition_2 {
		mut __c2v_condition_6 := false
		__c2v_condition_6 = (usize((&conn.errorMessage)) == usize((voidptr(0))) || conn.errorMessage.maxlen == usize(0))
		__c2v_condition_2 = __c2v_condition_6
	}
	if !__c2v_condition_2 {
		mut __c2v_condition_7 := false
		__c2v_condition_7 = (usize((&conn.workBuffer)) == usize((voidptr(0))) || conn.workBuffer.maxlen == usize(0))
		__c2v_condition_2 = __c2v_condition_7
	}
	if __c2v_condition_2 {
		free_pg_conn(conn)
		conn = (voidptr(0))
	}
	return conn
}

@[markused]
pub fn free_pg_conn(conn &PGconn) {
	for i := 0; i < conn.nEvents; i++ {
		evt := PGEventConnDestroy{}
		evt.conn = conn
		conn.events[i].proc(PGEventId(PGEventId.pgevt_conndestroy), voidptr(&evt), voidptr(conn.events[i].passThrough))
		C.c2v_free(voidptr(conn.events[i].name))
	}
	C.c2v_free(voidptr(conn.pghost))
	C.c2v_free(voidptr(conn.pghostaddr))
	C.c2v_free(voidptr(conn.pgport))
	C.c2v_free(voidptr(conn.connect_timeout))
	C.c2v_free(voidptr(conn.pgtcp_user_timeout))
	C.c2v_free(voidptr(conn.client_encoding_initial))
	C.c2v_free(voidptr(conn.pgoptions))
	C.c2v_free(voidptr(conn.appname))
	C.c2v_free(voidptr(conn.fbappname))
	C.c2v_free(voidptr(conn.dbName))
	C.c2v_free(voidptr(conn.replication))
	C.c2v_free(voidptr(conn.pgservice))
	C.c2v_free(voidptr(conn.pguser))
	if conn.pgpass {
		explicit_bzero(voidptr(conn.pgpass), C.c2v_strlen(conn.pgpass))
		C.c2v_free(voidptr(conn.pgpass))
	}
	C.c2v_free(voidptr(conn.pgpassfile))
	C.c2v_free(voidptr(conn.channel_binding))
	C.c2v_free(voidptr(conn.keepalives))
	C.c2v_free(voidptr(conn.keepalives_idle))
	C.c2v_free(voidptr(conn.keepalives_interval))
	C.c2v_free(voidptr(conn.keepalives_count))
	C.c2v_free(voidptr(conn.sslmode))
	C.c2v_free(voidptr(conn.sslnegotiation))
	C.c2v_free(voidptr(conn.sslcompression))
	C.c2v_free(voidptr(conn.sslkey))
	C.c2v_free(voidptr(conn.sslcert))
	if conn.sslpassword {
		explicit_bzero(voidptr(conn.sslpassword), C.c2v_strlen(conn.sslpassword))
		C.c2v_free(voidptr(conn.sslpassword))
	}
	C.c2v_free(voidptr(conn.sslcertmode))
	C.c2v_free(voidptr(conn.sslrootcert))
	C.c2v_free(voidptr(conn.sslcrl))
	C.c2v_free(voidptr(conn.sslcrldir))
	C.c2v_free(voidptr(conn.sslsni))
	C.c2v_free(voidptr(conn.requirepeer))
	C.c2v_free(voidptr(conn.gssencmode))
	C.c2v_free(voidptr(conn.krbsrvname))
	C.c2v_free(voidptr(conn.gsslib))
	C.c2v_free(voidptr(conn.gssdelegation))
	C.c2v_free(voidptr(conn.min_protocol_version))
	C.c2v_free(voidptr(conn.max_protocol_version))
	C.c2v_free(voidptr(conn.ssl_min_protocol_version))
	C.c2v_free(voidptr(conn.ssl_max_protocol_version))
	C.c2v_free(voidptr(conn.target_session_attrs))
	C.c2v_free(voidptr(conn.require_auth))
	C.c2v_free(voidptr(conn.load_balance_hosts))
	C.c2v_free(voidptr(conn.scram_client_key))
	C.c2v_free(voidptr(conn.scram_server_key))
	C.c2v_free(voidptr(conn.sslkeylogfile))
	C.c2v_free(voidptr(conn.oauth_issuer))
	C.c2v_free(voidptr(conn.oauth_issuer_id))
	C.c2v_free(voidptr(conn.oauth_discovery_uri))
	C.c2v_free(voidptr(conn.oauth_client_id))
	C.c2v_free(voidptr(conn.oauth_client_secret))
	C.c2v_free(voidptr(conn.oauth_scope))
	C.c2v_free(voidptr(conn.events))
	pq_release_conn_hosts(conn)
	C.c2v_free(voidptr(conn.connip))
	release_conn_addrinfo(conn)
	C.c2v_free(voidptr(conn.scram_client_key_binary))
	C.c2v_free(voidptr(conn.scram_server_key_binary))
	C.c2v_free(voidptr(conn.be_cancel_key))
	C.c2v_free(voidptr(conn.inBuffer))
	C.c2v_free(voidptr(conn.outBuffer))
	C.c2v_free(voidptr(conn.rowBuf))
	term_pq_exp_buffer(&conn.errorMessage)
	term_pq_exp_buffer(&conn.workBuffer)
	C.c2v_free(voidptr(conn))
}

@[export: 'pqReleaseConnHosts']
@[markused]
pub fn pq_release_conn_hosts(conn &PGconn) {
	if conn.connhost {
		for i := 0; i < conn.nconnhost; i++ {
			C.c2v_free(voidptr(conn.connhost[i].host))
			C.c2v_free(voidptr(conn.connhost[i].hostaddr))
			C.c2v_free(voidptr(conn.connhost[i].port))
			if usize(conn.connhost[i].password) != usize((voidptr(0))) {
				explicit_bzero(voidptr(conn.connhost[i].password), C.c2v_strlen(conn.connhost[i].password))
				C.c2v_free(voidptr(conn.connhost[i].password))
			}
		}
		C.c2v_free(voidptr(conn.connhost))
		conn.connhost = (voidptr(0))
	}
}

@[markused]
pub fn store_conn_addrinfo(conn &PGconn, addrlist &C.addrinfo) int {
	ai := addrlist
	conn.whichaddr = 0
	conn.naddr = 0
	for ai {
		ai = ai.ai_next
		conn.naddr++
	}
	conn.addr = C.c2v_calloc(u64(conn.naddr), sizeof(AddrInfo))
	if usize(conn.addr) == usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'out of memory')
		return 1
	}
	ai = addrlist
	for i := 0; i < conn.naddr; i++ {
		conn.addr[i].family = ai.ai_family
		C.c2v_memcpy(voidptr(&conn.addr[i].addr.addr), voidptr(ai.ai_addr), u64(ai.ai_addrlen))
		conn.addr[i].addr.salen = ai.ai_addrlen
		ai = ai.ai_next
	}
	return 0
}

@[markused]
pub fn release_conn_addrinfo(conn &PGconn) {
	if conn.addr {
		C.c2v_free(voidptr(conn.addr))
		conn.addr = (voidptr(0))
	}
}

@[markused]
pub fn send_terminate_conn(conn &PGconn) {
	if conn.cancelRequest {
		return
	}
	if conn.sock != (-1) && u32(conn.status) == u32(ConnStatusType.connection_ok) {
		pq_put_msg_start(i8(`X`), conn)
		pq_put_msg_end(conn)
		pq_flush_vdup1(conn)
	}
}

@[export: 'pqClosePGconn']
@[markused]
pub fn pq_close_pg_conn(conn &PGconn) {
	send_terminate_conn(conn)
	conn.nonblocking = (0 != 0)
	pq_drop_connection(conn, (1 != 0))
	conn.status = ConnStatusType.connection_bad
	conn.asyncStatus = PGAsyncStatusType.pgasync_idle
	conn.xactStatus = PGTransactionStatusType.pqtrans_idle
	conn.pipelineStatus = PGpipelineStatus.pq_pipeline_off
	pq_clear_oa_uth_token(conn)
	pq_clear_async_result(conn)
	reset_pq_exp_buffer(&conn.errorMessage)
	conn.errorReported = 0
	if !conn.cancelRequest {
		release_conn_addrinfo(conn)
	}
	pq_drop_server_data(conn)
}

@[export: 'PQfinish']
@[markused]
pub fn pq_finish(conn &PGconn) {
	if conn {
		pq_close_pg_conn(conn)
		free_pg_conn(conn)
	}
}

@[export: 'PQreset']
@[markused]
pub fn pq_reset(conn &PGconn) {
	if conn {
		pq_close_pg_conn(conn)
		if pq_connect_db_start(conn) && pq_connect_db_complete(conn) {
			i := 0
			for i = 0; i < conn.nEvents; i++ {
				evt := PGEventConnReset{}
				evt.conn = conn
				conn.events[i].proc(PGEventId(PGEventId.pgevt_connreset), voidptr(&evt), voidptr(conn.events[i].passThrough))
			}
		}
	}
}

@[export: 'PQresetStart']
@[markused]
pub fn pq_reset_start(conn &PGconn) int {
	if conn {
		pq_close_pg_conn(conn)
		return pq_connect_db_start(conn)
	}
	return 0
}

@[export: 'PQresetPoll']
@[markused]
pub fn pq_reset_poll(conn &PGconn) PostgresPollingStatusType {
	if conn {
		status := pq_connect_poll(conn)
		if u32(status) == u32(PostgresPollingStatusType.pgres_polling_ok) {
			i := 0
			for i = 0; i < conn.nEvents; i++ {
				evt := PGEventConnReset{}
				evt.conn = conn
				conn.events[i].proc(PGEventId(PGEventId.pgevt_connreset), voidptr(&evt), voidptr(conn.events[i].passThrough))
			}
		}
		return status
	}
	return PostgresPollingStatusType.pgres_polling_failed
}

@[export: 'pqPacketSend']
@[markused]
pub fn pq_packet_send(conn &PGconn, pack_type i8, buf voidptr, buf_len usize) int {
	if pq_put_msg_start(i8(pack_type), conn) {
		return -1
	}
	if pq_putnchar(voidptr(buf), buf_len, conn) {
		return -1
	}
	if pq_put_msg_end(conn) {
		return -1
	}
	if pq_flush_vdup1(conn) {
		return -1
	}
	return 0
}

@[markused]
pub fn parse_service_info(options &PQconninfoOption, error_message PQExpBuffer) int {
	service := conninfo_getval(options, c'service')
	service_file := [1024]i8{}
	env := &i8(0)
	group_found := (0 != 0)
	status := 0
	stat_buf := C.stat{}
	if usize(service) == usize((voidptr(0))) {
		service = C.c2v_getenv(c'PGSERVICE')
	}
	if usize(service) == usize((voidptr(0))) {
		return 0
	}
	env = C.c2v_getenv(c'PGSERVICEFILE')
	if usize(env) != usize((voidptr(0))) {
		C.c2v_strlcpy(unsafe { &i8(&service_file[0]) }, env, sizeof([1024]i8))
	} else {
		homedir := [1024]i8{}
		if !pq_get_home_directory(unsafe { &i8(&homedir[0]) }, int(sizeof([1024]i8))) {
			unsafe {
				goto next_file
			}
		}
		pg_snprintf(unsafe { &i8(&service_file[0]) }, usize(1024), c'%s/%s', unsafe { voidptr(&homedir[0]) }, voidptr(c'.pg_service.conf'))
		if c2v_fn_stat(unsafe { &i8(&service_file[0]) }, &stat_buf) != 0 {
			unsafe {
				goto next_file
			}
		}
	}
	status = parse_service_file(unsafe { &i8(&service_file[0]) }, service, options, error_message, &group_found)
	if int(group_found) || status != 0 {
		return status
	}
	next_file:
	pg_snprintf(unsafe { &i8(&service_file[0]) }, usize(1024), c'%s/pg_service.conf', voidptr(if C.c2v_getenv(c'PGSYSCONFDIR') {
		C.c2v_getenv(c'PGSYSCONFDIR')
	} else {
		c'/usr/local/pgsql/etc'
	}))
	if c2v_fn_stat(unsafe { &i8(&service_file[0]) }, &stat_buf) != 0 {
		unsafe {
			goto last_file
		}
	}
	status = parse_service_file(unsafe { &i8(&service_file[0]) }, service, options, error_message, &group_found)
	if status != 0 {
		return status
	}
	last_file:
	if !group_found {
		libpq_append_error(error_message, c'definition of service "%s" not found', voidptr(service))
		return 3
	}
	return 0
}

@[markused]
pub fn parse_service_file(service_file &i8, service &i8, options &PQconninfoOption, error_message PQExpBuffer, group_found &bool) int {
	result := 0
	linenr := 0
	i := 0

	f := &C.FILE(0)
	line := &i8(0)
	buf := [1024]i8{}
	unsafe { *group_found = (0 != 0) }
	f = C.c2v_fopen(service_file, c'r')
	if usize(f) == usize((voidptr(0))) {
		libpq_append_error(error_message, c'service file "%s" not found', voidptr(service_file))
		return 1
	}
	for {
		line = C.c2v_fgets(&buf[0], int(sizeof([1024]i8)), f)
		if !(usize(line) != usize((voidptr(0)))) {
			break
		}
		len := 0
		linenr++
		if C.c2v_strlen(line) >= sizeof([1024]i8) - u64(1) {
			libpq_append_error(error_message, c'line %d too long in service file "%s"', linenr, voidptr(service_file))
			result = 2
			unsafe {
				goto exit
			}
		}
		len = int(C.c2v_strlen(line))
		for len > 0 && C.c2v_isspace(int(u8(line[len - 1]))) {
			line[c2v_prefix_add(unsafe { &len }, -1)] = i8(`\0`)
		}
		for int((unsafe { *line })) && C.c2v_isspace(int(u8(line[0]))) {
			c2v_pointer_postfix(voidptr(&line), line, isize(1))
		}
		if int(line[0]) == i8(`\0`) || int(line[0]) == i8(`#`) {
			continue
		}
		if int(line[0]) == i8(`[`) {
			if (unsafe { *group_found }) {
				unsafe {
					goto exit
				}
			}
			if C.c2v_strncmp(line + 1, service, C.c2v_strlen(service)) == 0 && int(line[C.c2v_strlen(service) + u64(1)]) == i8(`]`) {
				unsafe { *group_found = (1 != 0) }
			} else {
				unsafe { *group_found = (0 != 0) }
			}
		} else {
			if (unsafe { *group_found }) {
				key := &i8(0)
				val := &i8(0)

				found_keyword := false
				key = line
				val = C.c2v_strchr(line, `=`)
				if usize(val) == usize((voidptr(0))) {
					libpq_append_error(error_message, c'syntax error in service file "%s", line %d', voidptr(service_file), linenr)
					result = 3
					unsafe {
						goto exit
					}
				}
				mut __c2v_lhs_tmp_2 := unsafe { c2v_pointer_postfix(voidptr(&val), val, isize(1)) }
				unsafe { *__c2v_lhs_tmp_2 = i8(`\0`) }
				if C.c2v_strcmp(key, c'service') == 0 {
					libpq_append_error(error_message, c'nested service specifications not supported in service file "%s", line %d', voidptr(service_file), linenr)
					result = 3
					unsafe {
						goto exit
					}
				}
				found_keyword = (0 != 0)
				for i = 0; options[i].keyword; i++ {
					if C.c2v_strcmp(options[i].keyword, key) == 0 {
						if usize(options[i].val) == usize((voidptr(0))) {
							options[i].val = C.c2v_strdup(val)
						}
						if isnil(options[i].val) {
							libpq_append_error(error_message, c'out of memory')
							result = 3
							unsafe {
								goto exit
							}
						}
						found_keyword = (1 != 0)
						break
					}
				}
				if !found_keyword {
					libpq_append_error(error_message, c'syntax error in service file "%s", line %d', voidptr(service_file), linenr)
					result = 3
					unsafe {
						goto exit
					}
				}
			}
		}
	}
	exit:
	C.c2v_fclose(f)
	return result
}

@[export: 'PQconninfoParse']
@[markused]
pub fn pq_conninfo_parse(conninfo &i8, errmsg &&u8) &PQconninfoOption {
	error_buf := PQExpBufferData{}
	conn_options := &PQconninfoOption(0)
	if errmsg {
		unsafe { *errmsg = (voidptr(0)) }
	}
	init_pq_exp_buffer(&error_buf)
	if (error_buf.maxlen == usize(0)) {
		return unsafe { nil }
	}
	conn_options = parse_connection_string(conninfo, &error_buf, (0 != 0))
	if usize(conn_options) == usize((voidptr(0))) && !isnil(errmsg) {
		unsafe { *errmsg = error_buf.data }
	} else {
		term_pq_exp_buffer(&error_buf)
	}
	return conn_options
}

@[markused]
pub fn conninfo_init(error_message PQExpBuffer) &PQconninfoOption {
	options := &PQconninfoOption(0)
	opt_dest := &PQconninfoOption(0)
	cur_opt := &InternalPQconninfoOption(0)
	options = &PQconninfoOption(C.c2v_malloc(sizeof(PQconninfoOption) * sizeof([51]InternalPQconninfoOption) / sizeof(InternalPQconninfoOption)))
	if usize(options) == usize((voidptr(0))) {
		libpq_append_error(error_message, c'out of memory')
		return unsafe { nil }
	}
	opt_dest = options
	for cur_opt = unsafe { &libpq_fe_connect_pq_conninfo_options[0] }; cur_opt.keyword; cur_opt = unsafe { cur_opt + 1 } {
		C.c2v_memcpy(voidptr(opt_dest), voidptr(cur_opt), sizeof(PQconninfoOption))
		c2v_pointer_postfix(voidptr(&opt_dest), opt_dest, isize(1))
	}
	for {
		vstart := voidptr(opt_dest)
		val := 0
		len := (sizeof(PQconninfoOption))
		if ((usize(vstart)) & (sizeof(i64) - u64(1))) == u64(0) && (len & (sizeof(i64) - u64(1))) == u64(0) && val == 0 && len <= Size(1024) && 1024 != 0 {
			start := &i64(vstart)
			stop := &i64(voidptr((&i8(voidptr(start)) + len)))
			for usize(start) < usize(stop) {
				mut __c2v_lhs_tmp_3 := unsafe { c2v_pointer_postfix(voidptr(&start), start, isize(1)) }
				unsafe { *__c2v_lhs_tmp_3 = i64(0) }
			}
		} else {
			C.c2v_memset(voidptr(vstart), val, len)
		}
		break
	}
	return options
}

@[markused]
pub fn parse_connection_string(connstr &i8, error_message PQExpBuffer, use_defaults bool) &PQconninfoOption {
	if uri_prefix_length(connstr) != 0 {
		return conninfo_uri_parse(connstr, error_message, use_defaults)
	}
	return conninfo_parse(connstr, error_message, use_defaults)
}

@[markused]
pub fn uri_prefix_length(connstr &i8) int {
	if C.c2v_strncmp(connstr, unsafe { &i8(&libpq_fe_connect_uri_designator[0]) }, sizeof([14]i8) - u64(1)) == 0 {
		return int(sizeof([14]i8) - u64(1))
	}
	if C.c2v_strncmp(connstr, unsafe { &i8(&libpq_fe_connect_short_uri_designator[0]) }, sizeof([12]i8) - u64(1)) == 0 {
		return int(sizeof([12]i8) - u64(1))
	}
	return 0
}

@[markused]
pub fn recognized_connection_string(connstr &i8) bool {
	return uri_prefix_length(connstr) != false || usize(C.c2v_strchr(connstr, `=`)) != usize((voidptr(0)))
}

@[markused]
pub fn conninfo_parse(conninfo &i8, error_message PQExpBuffer, use_defaults bool) &PQconninfoOption {
	pname := &i8(0)
	pval := &i8(0)
	buf := &i8(0)
	cp := &i8(0)
	cp2 := &i8(0)
	options := &PQconninfoOption(0)
	options = conninfo_init(error_message)
	if usize(options) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	buf = C.c2v_strdup(conninfo)
	if usize(buf) == usize((voidptr(0))) {
		libpq_append_error(error_message, c'out of memory')
		pq_conninfo_free(options)
		return unsafe { nil }
	}
	cp = buf
	for (unsafe { *cp }) {
		if C.c2v_isspace(int(u8((unsafe { *cp })))) {
			c2v_pointer_postfix(voidptr(&cp), cp, isize(1))
			continue
		}
		pname = cp
		for (unsafe { *cp }) {
			if int((unsafe { *cp })) == i8(`=`) {
				break
			}
			if C.c2v_isspace(int(u8((unsafe { *cp })))) {
				mut __c2v_lhs_tmp_4 := unsafe { c2v_pointer_postfix(voidptr(&cp), cp, isize(1)) }
				unsafe { *__c2v_lhs_tmp_4 = i8(`\0`) }
				for (unsafe { *cp }) {
					if !C.c2v_isspace(int(u8((unsafe { *cp })))) {
						break
					}
					c2v_pointer_postfix(voidptr(&cp), cp, isize(1))
				}
				break
			}
			c2v_pointer_postfix(voidptr(&cp), cp, isize(1))
		}
		if int((unsafe { *cp })) != i8(`=`) {
			libpq_append_error(error_message, c'missing "=" after "%s" in connection info string', voidptr(pname))
			pq_conninfo_free(options)
			C.c2v_free(voidptr(buf))
			return unsafe { nil }
		}
		mut __c2v_lhs_tmp_5 := unsafe { c2v_pointer_postfix(voidptr(&cp), cp, isize(1)) }
		unsafe { *__c2v_lhs_tmp_5 = i8(`\0`) }
		for (unsafe { *cp }) {
			if !C.c2v_isspace(int(u8((unsafe { *cp })))) {
				break
			}
			c2v_pointer_postfix(voidptr(&cp), cp, isize(1))
		}
		pval = cp
		if int((unsafe { *cp })) != i8(`\'`) {
			cp2 = pval
			for (unsafe { *cp }) {
				if C.c2v_isspace(int(u8((unsafe { *cp })))) {
					mut __c2v_lhs_tmp_6 := unsafe { c2v_pointer_postfix(voidptr(&cp), cp, isize(1)) }
					unsafe { *__c2v_lhs_tmp_6 = i8(`\0`) }
					break
				}
				if int((unsafe { *cp })) == i8(`\\`) {
					c2v_pointer_postfix(voidptr(&cp), cp, isize(1))
					if int((unsafe { *cp })) != i8(`\0`) {
						mut __c2v_lhs_tmp_7 := unsafe { c2v_pointer_postfix(voidptr(&cp2), cp2, isize(1)) }
						unsafe { *__c2v_lhs_tmp_7 = *c2v_pointer_postfix(voidptr(&cp), cp, isize(1)) }
					}
				} else {
					mut __c2v_lhs_tmp_8 := unsafe { c2v_pointer_postfix(voidptr(&cp2), cp2, isize(1)) }
					unsafe { *__c2v_lhs_tmp_8 = *c2v_pointer_postfix(voidptr(&cp), cp, isize(1)) }
				}
			}
			unsafe { *cp2 = i8(`\0`) }
		} else {
			cp2 = pval
			c2v_pointer_postfix(voidptr(&cp), cp, isize(1))
			for {
				if int((unsafe { *cp })) == i8(`\0`) {
					libpq_append_error(error_message, c'unterminated quoted string in connection info string')
					pq_conninfo_free(options)
					C.c2v_free(voidptr(buf))
					return unsafe { nil }
				}
				if int((unsafe { *cp })) == i8(`\\`) {
					c2v_pointer_postfix(voidptr(&cp), cp, isize(1))
					if int((unsafe { *cp })) != i8(`\0`) {
						mut __c2v_lhs_tmp_9 := unsafe { c2v_pointer_postfix(voidptr(&cp2), cp2, isize(1)) }
						unsafe { *__c2v_lhs_tmp_9 = *c2v_pointer_postfix(voidptr(&cp), cp, isize(1)) }
					}
					continue
				}
				if int((unsafe { *cp })) == i8(`\'`) {
					unsafe { *cp2 = i8(`\0`) }
					c2v_pointer_postfix(voidptr(&cp), cp, isize(1))
					break
				}
				mut __c2v_lhs_tmp_10 := unsafe { c2v_pointer_postfix(voidptr(&cp2), cp2, isize(1)) }
				unsafe { *__c2v_lhs_tmp_10 = *c2v_pointer_postfix(voidptr(&cp), cp, isize(1)) }
			}
		}
		if isnil(conninfo_storeval(options, pname, pval, error_message, (0 != 0), (0 != 0))) {
			pq_conninfo_free(options)
			C.c2v_free(voidptr(buf))
			return unsafe { nil }
		}
	}
	C.c2v_free(voidptr(buf))
	if use_defaults {
		if !conninfo_add_defaults(options, error_message) {
			pq_conninfo_free(options)
			return unsafe { nil }
		}
	}
	return options
}

@[markused]
pub fn conninfo_array_parse(keywords &&u8, values &&u8, error_message PQExpBuffer, use_defaults bool, expand_dbname int) &PQconninfoOption {
	mut options := &PQconninfoOption(0)
	dbname_options := unsafe { &PQconninfoOption(nil) }
	option := &PQconninfoOption(0)
	i := 0
	for expand_dbname && !isnil(keywords[i]) {
		pname := keywords[i]
		pvalue := values[i]
		if C.c2v_strcmp(pname, c'dbname') == 0 && !isnil(pvalue) {
			if recognized_connection_string(pvalue) {
				dbname_options = parse_connection_string(pvalue, error_message, (0 != 0))
				if usize(dbname_options) == usize((voidptr(0))) {
					return unsafe { nil }
				}
			}
			break
		}
		i++
	}
	options = conninfo_init(error_message)
	if usize(options) == usize((voidptr(0))) {
		pq_conninfo_free(dbname_options)
		return unsafe { nil }
	}
	i = 0
	for keywords[i] {
		pname := keywords[i]
		pvalue := values[i]
		if usize(pvalue) != usize((voidptr(0))) && int(pvalue[0]) != i8(`\0`) {
			for option = options; usize(option.keyword) != usize((voidptr(0))); option = unsafe { option + 1 } {
				if C.c2v_strcmp(option.keyword, pname) == 0 {
					break
				}
			}
			if usize(option.keyword) == usize((voidptr(0))) {
				libpq_append_error(error_message, c'invalid connection option "%s"', voidptr(pname))
				pq_conninfo_free(options)
				pq_conninfo_free(dbname_options)
				return unsafe { nil }
			}
			if C.c2v_strcmp(pname, c'dbname') == 0 && !isnil(dbname_options) {
				str_option := &PQconninfoOption(0)
				for str_option = dbname_options; usize(str_option.keyword) != usize((voidptr(0))); str_option = unsafe { str_option + 1 } {
					if usize(str_option.val) != usize((voidptr(0))) {
						k := 0
						for k = 0; options[k].keyword; k++ {
							if C.c2v_strcmp(options[k].keyword, str_option.keyword) == 0 {
								C.c2v_free(voidptr(options[k].val))
								options[k].val = C.c2v_strdup(str_option.val)
								if isnil(options[k].val) {
									libpq_append_error(error_message, c'out of memory')
									pq_conninfo_free(options)
									pq_conninfo_free(dbname_options)
									return unsafe { nil }
								}
								break
							}
						}
					}
				}
				pq_conninfo_free(dbname_options)
				dbname_options = (voidptr(0))
			} else {
				C.c2v_free(voidptr(option.val))
				option.val = C.c2v_strdup(pvalue)
				if isnil(option.val) {
					libpq_append_error(error_message, c'out of memory')
					pq_conninfo_free(options)
					pq_conninfo_free(dbname_options)
					return unsafe { nil }
				}
			}
		}
		i++
	}
	pq_conninfo_free(dbname_options)
	if use_defaults {
		if !conninfo_add_defaults(options, error_message) {
			pq_conninfo_free(options)
			return unsafe { nil }
		}
	}
	return options
}

@[markused]
pub fn conninfo_add_defaults(options &PQconninfoOption, error_message PQExpBuffer) bool {
	option := &PQconninfoOption(0)
	sslmode_default := unsafe { &PQconninfoOption(nil) }
	sslrootcert := unsafe { &PQconninfoOption(nil) }

	tmp := &i8(0)
	if parse_service_info(options, error_message) != 0 && !isnil(error_message) {
		return false != 0
	}
	for option = options; usize(option.keyword) != usize((voidptr(0))); option = unsafe { option + 1 } {
		if C.c2v_strcmp(option.keyword, c'sslrootcert') == 0 {
			sslrootcert = option
		}
		if usize(option.val) != usize((voidptr(0))) {
			continue
		}
		if usize(option.envvar) != usize((voidptr(0))) {
			tmp = C.c2v_getenv(option.envvar)
			if usize(tmp) != usize((voidptr(0))) {
				option.val = C.c2v_strdup(tmp)
				if isnil(option.val) {
					if error_message {
						libpq_append_error(error_message, c'out of memory')
					}
					return false != 0
				}
				continue
			}
		}
		if C.c2v_strcmp(option.keyword, c'sslmode') == 0 {
			requiresslenv := C.c2v_getenv(c'PGREQUIRESSL')
			if usize(requiresslenv) != usize((voidptr(0))) && int(requiresslenv[0]) == i8(`1`) {
				option.val = C.c2v_strdup(c'require')
				if isnil(option.val) {
					if error_message {
						libpq_append_error(error_message, c'out of memory')
					}
					return false != 0
				}
				continue
			}
			sslmode_default = option
		}
		if usize(option.compiled) != usize((voidptr(0))) {
			option.val = C.c2v_strdup(option.compiled)
			if isnil(option.val) {
				if error_message {
					libpq_append_error(error_message, c'out of memory')
				}
				return false != 0
			}
			continue
		}
		if C.c2v_strcmp(option.keyword, c'user') == 0 {
			option.val = pg_fe_getauthname((voidptr(0)))
			continue
		}
	}
	if !isnil(sslmode_default) && !isnil(sslrootcert) {
		if !isnil(sslrootcert.val) && C.c2v_strcmp(sslrootcert.val, c'system') == 0 {
			C.c2v_free(voidptr(sslmode_default.val))
			sslmode_default.val = C.c2v_strdup(c'verify-full')
			if isnil(sslmode_default.val) {
				if error_message {
					libpq_append_error(error_message, c'out of memory')
				}
				return false != 0
			}
		}
	}
	return true != 0
}

@[markused]
pub fn conninfo_uri_parse(uri &i8, error_message PQExpBuffer, use_defaults bool) &PQconninfoOption {
	options := &PQconninfoOption(0)
	options = conninfo_init(error_message)
	if usize(options) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	if !conninfo_uri_parse_options(options, uri, error_message) {
		pq_conninfo_free(options)
		return unsafe { nil }
	}
	if use_defaults {
		if !conninfo_add_defaults(options, error_message) {
			pq_conninfo_free(options)
			return unsafe { nil }
		}
	}
	return options
}

@[markused]
pub fn conninfo_uri_parse_options(options &PQconninfoOption, uri &i8, error_message PQExpBuffer) bool {
	prefix_len := 0
	p := &i8(0)
	buf := unsafe { &i8(nil) }
	start := &i8(0)
	prevchar := i8(`\0`)
	user := unsafe { &i8(nil) }
	host := unsafe { &i8(nil) }
	retval := (0 != 0)
	hostbuf := PQExpBufferData{}
	portbuf := PQExpBufferData{}
	init_pq_exp_buffer(&hostbuf)
	init_pq_exp_buffer(&portbuf)
	if (hostbuf.maxlen == usize(0)) || (portbuf.maxlen == usize(0)) {
		libpq_append_error(error_message, c'out of memory')
		unsafe {
			goto cleanup
		}
	}
	buf = C.c2v_strdup(uri)
	if usize(buf) == usize((voidptr(0))) {
		libpq_append_error(error_message, c'out of memory')
		unsafe {
			goto cleanup
		}
	}
	start = buf
	prefix_len = uri_prefix_length(uri)
	if prefix_len == 0 {
		libpq_append_error(error_message, c'invalid URI propagated to internal parser routine: "%s"', voidptr(uri))
		unsafe {
			goto cleanup
		}
	}
	c2v_pointer_prefix(voidptr(&start), start, isize(prefix_len))
	p = start
	for int((unsafe { *p })) && int((unsafe { *p })) != i8(`@`) && int((unsafe { *p })) != i8(`/`) {
		c2v_pointer_prefix(voidptr(&p), p, isize(1))
	}
	if int((unsafe { *p })) == i8(`@`) {
		user = start
		p = user
		for int((unsafe { *p })) != i8(`:`) && int((unsafe { *p })) != i8(`@`) {
			c2v_pointer_prefix(voidptr(&p), p, isize(1))
		}
		prevchar = unsafe { *p }
		unsafe { *p = i8(`\0`) }
		if int((unsafe { *user })) && isnil(conninfo_storeval(options, c'user', user, error_message, (0 != 0), (1 != 0))) {
			unsafe {
				goto cleanup
			}
		}
		if int(prevchar) == i8(`:`) {
			password := p + 1
			for int((unsafe { *p })) != i8(`@`) {
				c2v_pointer_prefix(voidptr(&p), p, isize(1))
			}
			unsafe { *p = i8(`\0`) }
			if int((unsafe { *password })) && isnil(conninfo_storeval(options, c'password', password, error_message, (0 != 0), (1 != 0))) {
				unsafe {
					goto cleanup
				}
			}
		}
		c2v_pointer_prefix(voidptr(&p), p, isize(1))
	} else {
		p = start
	}
	for {
		if int((unsafe { *p })) == i8(`[`) {
			host = c2v_pointer_prefix(voidptr(&p), p, isize(1))
			for int((unsafe { *p })) && int((unsafe { *p })) != i8(`]`) {
				c2v_pointer_prefix(voidptr(&p), p, isize(1))
			}
			if !(unsafe { *p }) {
				libpq_append_error(error_message, c'end of string reached when looking for matching "]" in IPv6 host address in URI: "%s"', voidptr(uri))
				unsafe {
					goto cleanup
				}
			}
			if usize(p) == usize(host) {
				libpq_append_error(error_message, c'IPv6 host address may not be empty in URI: "%s"', voidptr(uri))
				unsafe {
					goto cleanup
				}
			}
			mut __c2v_lhs_tmp_11 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
			unsafe { *__c2v_lhs_tmp_11 = i8(`\0`) }
			if int((unsafe { *p })) && int((unsafe { *p })) != i8(`:`) && int((unsafe { *p })) != i8(`/`) && int((unsafe { *p })) != i8(`?`) && int((unsafe { *p })) != i8(`,`) {
				libpq_append_error(error_message, c'unexpected character "%c" at position %d in URI (expected ":" or "/"): "%s"', int((unsafe { *p })), int((i64((isize(p) - isize(buf)) / isize(sizeof(i8))) + i64(1))), voidptr(uri))
				unsafe {
					goto cleanup
				}
			}
		} else {
			host = p
			for int((unsafe { *p })) && int((unsafe { *p })) != i8(`:`) && int((unsafe { *p })) != i8(`/`) && int((unsafe { *p })) != i8(`?`) && int((unsafe { *p })) != i8(`,`) {
				c2v_pointer_prefix(voidptr(&p), p, isize(1))
			}
		}
		prevchar = unsafe { *p }
		unsafe { *p = i8(`\0`) }
		append_pq_exp_buffer_str(&hostbuf, host)
		if int(prevchar) == i8(`:`) {
			port := c2v_pointer_prefix(voidptr(&p), p, isize(1))
			for int((unsafe { *p })) && int((unsafe { *p })) != i8(`/`) && int((unsafe { *p })) != i8(`?`) && int((unsafe { *p })) != i8(`,`) {
				c2v_pointer_prefix(voidptr(&p), p, isize(1))
			}
			prevchar = unsafe { *p }
			unsafe { *p = i8(`\0`) }
			append_pq_exp_buffer_str(&portbuf, port)
		}
		if int(prevchar) != i8(`,`) {
			break
		}
		c2v_pointer_prefix(voidptr(&p), p, isize(1))
		append_pq_exp_buffer_char(&hostbuf, i8(`,`))
		append_pq_exp_buffer_char(&portbuf, i8(`,`))
	}
	if (hostbuf.maxlen == usize(0)) || (portbuf.maxlen == usize(0)) {
		unsafe {
			goto cleanup
		}
	}
	if int(hostbuf.data[0]) && isnil(conninfo_storeval(options, c'host', hostbuf.data, error_message, (0 != 0), (1 != 0))) {
		unsafe {
			goto cleanup
		}
	}
	if int(portbuf.data[0]) && isnil(conninfo_storeval(options, c'port', portbuf.data, error_message, (0 != 0), (1 != 0))) {
		unsafe {
			goto cleanup
		}
	}
	if int(prevchar) && int(prevchar) != i8(`?`) {
		dbname := c2v_pointer_prefix(voidptr(&p), p, isize(1))
		for int((unsafe { *p })) && int((unsafe { *p })) != i8(`?`) {
			c2v_pointer_prefix(voidptr(&p), p, isize(1))
		}
		prevchar = unsafe { *p }
		unsafe { *p = i8(`\0`) }
		if int((unsafe { *dbname })) && isnil(conninfo_storeval(options, c'dbname', dbname, error_message, (0 != 0), (1 != 0))) {
			unsafe {
				goto cleanup
			}
		}
	}
	if prevchar {
		c2v_pointer_prefix(voidptr(&p), p, isize(1))
		if !conninfo_uri_parse_params(p, options, error_message) {
			unsafe {
				goto cleanup
			}
		}
	}
	retval = (1 != 0)
	cleanup:
	term_pq_exp_buffer(&hostbuf)
	term_pq_exp_buffer(&portbuf)
	C.c2v_free(voidptr(buf))
	return retval
}

@[markused]
pub fn conninfo_uri_parse_params(params &i8, conn_options &PQconninfoOption, error_message PQExpBuffer) bool {
	for (unsafe { *params }) {
		keyword := params
		value := unsafe { &i8(nil) }
		p := params
		malloced := (0 != 0)
		oldmsglen := 0
		for {
			if int((unsafe { *p })) == i8(`=`) {
				if usize(value) != usize((voidptr(0))) {
					libpq_append_error(error_message, c'extra key/value separator "=" in URI query parameter: "%s"', voidptr(keyword))
					return false != 0
				}
				mut __c2v_lhs_tmp_12 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
				unsafe { *__c2v_lhs_tmp_12 = i8(`\0`) }
				value = p
			} else if int((unsafe { *p })) == i8(`&`) || int((unsafe { *p })) == i8(`\0`) {
				if int((unsafe { *p })) != i8(`\0`) {
					mut __c2v_lhs_tmp_13 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
					unsafe { *__c2v_lhs_tmp_13 = i8(`\0`) }
				}
				if usize(value) == usize((voidptr(0))) {
					libpq_append_error(error_message, c'missing key/value separator "=" in URI query parameter: "%s"', voidptr(keyword))
					return false != 0
				}
				break
			} else {
				c2v_pointer_prefix(voidptr(&p), p, isize(1))
			}
		}
		keyword = conninfo_uri_decode(keyword, error_message)
		if usize(keyword) == usize((voidptr(0))) {
			return false != 0
		}
		value = conninfo_uri_decode(value, error_message)
		if usize(value) == usize((voidptr(0))) {
			C.c2v_free(voidptr(keyword))
			return false != 0
		}
		malloced = (1 != 0)
		if C.c2v_strcmp(keyword, c'ssl') == 0 && C.c2v_strcmp(value, c'true') == 0 {
			C.c2v_free(voidptr(keyword))
			C.c2v_free(voidptr(value))
			malloced = (0 != 0)
			keyword = c'sslmode'
			value = c'require'
		}
		oldmsglen = int(error_message.len)
		if isnil(conninfo_storeval(conn_options, keyword, value, error_message, (1 != 0), (0 != 0))) {
			if error_message.len == usize(oldmsglen) {
				libpq_append_error(error_message, c'invalid URI query parameter: "%s"', voidptr(keyword))
			}
			if malloced {
				C.c2v_free(voidptr(keyword))
				C.c2v_free(voidptr(value))
			}
			return false != 0
		}
		if malloced {
			C.c2v_free(voidptr(keyword))
			C.c2v_free(voidptr(value))
		}
		params = p
	}
	return true != 0
}

@[markused]
pub fn conninfo_uri_decode(str &i8, error_message PQExpBuffer) &i8 {
	buf := &i8(0)
	p := &i8(0)
	q := str
	buf = &i8(C.c2v_malloc(C.c2v_strlen(str) + u64(1)))
	if usize(buf) == usize((voidptr(0))) {
		libpq_append_error(error_message, c'out of memory')
		return unsafe { nil }
	}
	p = buf
	for s := q; int((unsafe { *s })) == i8(` `); s = unsafe { s + 1 } {
		c2v_pointer_postfix(voidptr(&q), q, isize(1))
		continue
	}
	for {
		if int((unsafe { *q })) != i8(`%`) {
			if int((unsafe { *q })) == i8(` `) || int((unsafe { *q })) == i8(`\0`) {
				unsafe {
					goto end
				}
			}
			mut __c2v_lhs_tmp_14 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
			unsafe { *__c2v_lhs_tmp_14 = *(c2v_pointer_postfix(voidptr(&q), q, isize(1))) }
		} else {
			hi := 0
			lo := 0
			c := 0
			c2v_pointer_prefix(voidptr(&q), q, isize(1))
			if !(int(get_hexdigit(i8((unsafe { *c2v_pointer_postfix(voidptr(&q), q, isize(1)) })), &hi)) && int(get_hexdigit(i8((unsafe { *c2v_pointer_postfix(voidptr(&q), q, isize(1)) })), &lo))) {
				libpq_append_error(error_message, c'invalid percent-encoded token: "%s"', voidptr(str))
				C.c2v_free(voidptr(buf))
				return unsafe { nil }
			}
			c = (hi << 4) | lo
			if c == 0 {
				libpq_append_error(error_message, c'forbidden value %%00 in percent-encoded value: "%s"', voidptr(str))
				C.c2v_free(voidptr(buf))
				return unsafe { nil }
			}
			mut __c2v_lhs_tmp_15 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
			unsafe { *__c2v_lhs_tmp_15 = i8(c) }
		}
	}
	end: for s := q; int((unsafe { *s })) == i8(` `); s = unsafe { s + 1 } {
		c2v_pointer_postfix(voidptr(&q), q, isize(1))
		continue
	}
	if int((unsafe { *q })) != i8(`\0`) {
		libpq_append_error(error_message, c'unexpected spaces found in "%s", use percent-encoded spaces (%%20) instead', voidptr(str))
		C.c2v_free(voidptr(buf))
		return unsafe { nil }
	}
	unsafe { *p = i8(`\0`) }
	return buf
}

@[markused]
pub fn get_hexdigit(digit i8, value &int) bool {
	if i8(`0`) <= int(digit) && int(digit) <= i8(`9`) {
		unsafe { *value = int(digit) - int(`0`) }
	} else if i8(`A`) <= int(digit) && int(digit) <= i8(`F`) {
		unsafe { *value = int(digit) - int(`A`) + 10 }
	} else if i8(`a`) <= int(digit) && int(digit) <= i8(`f`) {
		unsafe { *value = int(digit) - int(`a`) + 10 }
	} else {
		return false != 0
	}
	return true != 0
}

@[markused]
pub fn conninfo_getval(conn_options &PQconninfoOption, keyword &i8) &i8 {
	option := &PQconninfoOption(0)
	option = conninfo_find(conn_options, keyword)
	return unsafe { if option { option.val } else { &i8(nil) } }
}

@[markused]
pub fn conninfo_storeval(conn_options &PQconninfoOption, keyword &i8, value &i8, error_message PQExpBuffer, ignore_missing bool, uri_decode bool) &PQconninfoOption {
	option := &PQconninfoOption(0)
	value_copy := &i8(0)
	if C.c2v_strcmp(keyword, c'requiressl') == 0 {
		keyword = c'sslmode'
		if int(value[0]) == i8(`1`) {
			value = c'require'
		} else {
			value = c'prefer'
		}
	}
	option = conninfo_find(conn_options, keyword)
	if usize(option) == usize((voidptr(0))) {
		if !ignore_missing {
			libpq_append_error(error_message, c'invalid connection option "%s"', voidptr(keyword))
		}
		return unsafe { nil }
	}
	if uri_decode {
		value_copy = conninfo_uri_decode(value, error_message)
		if usize(value_copy) == usize((voidptr(0))) {
			return unsafe { nil }
		}
	} else {
		value_copy = C.c2v_strdup(value)
		if usize(value_copy) == usize((voidptr(0))) {
			libpq_append_error(error_message, c'out of memory')
			return unsafe { nil }
		}
	}
	C.c2v_free(voidptr(option.val))
	option.val = value_copy
	return option
}

@[markused]
pub fn conninfo_find(conn_options &PQconninfoOption, keyword &i8) &PQconninfoOption {
	option := &PQconninfoOption(0)
	for option = conn_options; usize(option.keyword) != usize((voidptr(0))); option = unsafe { option + 1 } {
		if C.c2v_strcmp(option.keyword, keyword) == 0 {
			return option
		}
	}
	return unsafe { nil }
}

@[export: 'PQconninfo']
@[markused]
pub fn pq_conninfo(conn &PGconn) &PQconninfoOption {
	error_buf := PQExpBufferData{}
	conn_options := &PQconninfoOption(0)
	if usize(conn) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	init_pq_exp_buffer(&error_buf)
	if (error_buf.maxlen == usize(0)) {
		return unsafe { nil }
	}
	conn_options = conninfo_init(&error_buf)
	if usize(conn_options) != usize((voidptr(0))) {
		option := &InternalPQconninfoOption(0)
		for option = unsafe { &libpq_fe_connect_pq_conninfo_options[0] }; option.keyword; option = unsafe { option + 1 } {
			connmember := &&u8(0)
			if option.connofs < i64(0) {
				continue
			}
			connmember = &&u8(voidptr((&i8(voidptr(conn)) + option.connofs)))
			if unsafe { *connmember != nil } {
				conninfo_storeval(conn_options, option.keyword, (unsafe { *connmember }), &error_buf, (1 != 0), (0 != 0))
			}
		}
	}
	term_pq_exp_buffer(&error_buf)
	return conn_options
}

@[export: 'PQconninfoFree']
@[markused]
pub fn pq_conninfo_free(conn_options &PQconninfoOption) {
	if usize(conn_options) == usize((voidptr(0))) {
		return
	}
	for option := conn_options; usize(option.keyword) != usize((voidptr(0))); option = unsafe { option + 1 } {
		C.c2v_free(voidptr(option.val))
	}
	C.c2v_free(voidptr(conn_options))
}

@[export: 'PQdb']
@[markused]
pub fn pq_db(conn &PGconn) &i8 {
	if isnil(conn) {
		return unsafe { nil }
	}
	return conn.dbName
}

@[export: 'PQuser']
@[markused]
pub fn pq_user(conn &PGconn) &i8 {
	if isnil(conn) {
		return unsafe { nil }
	}
	return conn.pguser
}

@[export: 'PQpass']
@[markused]
pub fn pq_pass(conn &PGconn) &i8 {
	password := unsafe { &i8(nil) }
	if isnil(conn) {
		return unsafe { nil }
	}
	if usize(conn.connhost) != usize((voidptr(0))) {
		password = conn.connhost[conn.whichhost].password
	}
	if usize(password) == usize((voidptr(0))) {
		password = conn.pgpass
	}
	if usize(password) == usize((voidptr(0))) {
		password = c''
	}
	return password
}

@[export: 'PQhost']
@[markused]
pub fn pq_host(conn &PGconn) &i8 {
	if isnil(conn) {
		return unsafe { nil }
	}
	if usize(conn.connhost) != usize((voidptr(0))) {
		if usize(conn.connhost[conn.whichhost].host) != usize((voidptr(0))) && int(conn.connhost[conn.whichhost].host[0]) != i8(`\0`) {
			return conn.connhost[conn.whichhost].host
		} else if usize(conn.connhost[conn.whichhost].hostaddr) != usize((voidptr(0))) && int(conn.connhost[conn.whichhost].hostaddr[0]) != i8(`\0`) {
			return conn.connhost[conn.whichhost].hostaddr
		}
	}
	return unsafe { &i8(&c''[0]) }
}

@[export: 'PQhostaddr']
@[markused]
pub fn pq_hostaddr(conn &PGconn) &i8 {
	if isnil(conn) {
		return unsafe { nil }
	}
	if usize(conn.connhost) != usize((voidptr(0))) && usize(conn.connip) != usize((voidptr(0))) {
		return conn.connip
	}
	return unsafe { &i8(&c''[0]) }
}

@[export: 'PQport']
@[markused]
pub fn pq_port(conn &PGconn) &i8 {
	if isnil(conn) {
		return unsafe { nil }
	}
	if usize(conn.connhost) != usize((voidptr(0))) && usize(conn.connhost[conn.whichhost].port) != usize((voidptr(0))) && int(conn.connhost[conn.whichhost].port[0]) != i8(`\0`) {
		return conn.connhost[conn.whichhost].port
	}
	return unsafe { &i8(&c'5432'[0]) }
}

@[export: 'PQtty']
@[markused]
pub fn pq_tty(conn &PGconn) &i8 {
	if isnil(conn) {
		return unsafe { nil }
	}
	return unsafe { &i8(&c''[0]) }
}

@[export: 'PQoptions']
@[markused]
pub fn pq_options(conn &PGconn) &i8 {
	if isnil(conn) {
		return unsafe { nil }
	}
	return conn.pgoptions
}

@[export: 'PQstatus']
@[markused]
pub fn pq_status(conn &PGconn) ConnStatusType {
	if isnil(conn) {
		return ConnStatusType.connection_bad
	}
	return conn.status
}

@[export: 'PQtransactionStatus']
@[markused]
pub fn pq_transaction_status(conn &PGconn) PGTransactionStatusType {
	if isnil(conn) || u32(conn.status) != u32(ConnStatusType.connection_ok) {
		return PGTransactionStatusType.pqtrans_unknown
	}
	if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_idle) {
		return PGTransactionStatusType.pqtrans_active
	}
	return conn.xactStatus
}

@[export: 'PQparameterStatus']
@[markused]
pub fn pq_parameter_status(conn &PGconn, param_name &i8) &i8 {
	pstatus := &PgParameterStatus(0)
	if isnil(conn) || isnil(param_name) {
		return unsafe { nil }
	}
	for pstatus = conn.pstatus; usize(pstatus) != usize((voidptr(0))); pstatus = pstatus.next {
		if C.c2v_strcmp(pstatus.name, param_name) == 0 {
			return pstatus.value
		}
	}
	return unsafe { nil }
}

@[export: 'PQprotocolVersion']
@[markused]
pub fn pq_protocol_version(conn &PGconn) int {
	if isnil(conn) {
		return 0
	}
	if u32(conn.status) == u32(ConnStatusType.connection_bad) {
		return 0
	}
	return int((conn.pversion >> 16))
}

@[export: 'PQfullProtocolVersion']
@[markused]
pub fn pq_full_protocol_version(conn &PGconn) int {
	if isnil(conn) {
		return 0
	}
	if u32(conn.status) == u32(ConnStatusType.connection_bad) {
		return 0
	}
	return int(((conn.pversion >> 16) * ProtocolVersion(10000) + (conn.pversion & ProtocolVersion(65535))))
}

@[export: 'PQserverVersion']
@[markused]
pub fn pq_server_version(conn &PGconn) int {
	if isnil(conn) {
		return 0
	}
	if u32(conn.status) == u32(ConnStatusType.connection_bad) {
		return 0
	}
	return conn.sversion
}

@[export: 'PQerrorMessage']
@[markused]
pub fn pq_error_message(conn &PGconn) &i8 {
	if isnil(conn) {
		return unsafe { &i8(&c'connection pointer is NULL\n'[0]) }
	}
	if (usize((&conn.errorMessage)) == usize((voidptr(0))) || conn.errorMessage.maxlen == usize(0)) {
		return unsafe { &i8(&c'out of memory\n'[0]) }
	}
	return conn.errorMessage.data
}

@[export: 'PQsocket']
@[markused]
pub fn pq_socket(conn &PGconn) int {
	if isnil(conn) {
		return -1
	}
	if conn.altsock != (-1) {
		return conn.altsock
	}
	return if (conn.sock != (-1)) { conn.sock } else { -1 }
}

@[export: 'PQbackendPID']
@[markused]
pub fn pq_backend_pid(conn &PGconn) int {
	if isnil(conn) || u32(conn.status) != u32(ConnStatusType.connection_ok) {
		return 0
	}
	return conn.be_pid
}

@[export: 'PQpipelineStatus']
@[markused]
pub fn pq_pipeline_status(conn &PGconn) PGpipelineStatus {
	if isnil(conn) {
		return PGpipelineStatus.pq_pipeline_off
	}
	return conn.pipelineStatus
}

@[export: 'PQconnectionNeedsPassword']
@[markused]
pub fn pq_connection_needs_password(conn &PGconn) int {
	password := &i8(0)
	if isnil(conn) {
		return 0
	}
	password = pq_pass(conn)
	if int(conn.password_needed) && (usize(password) == usize((voidptr(0))) || int(password[0]) == i8(`\0`)) {
		return 1
	} else {
		return 0
	}
}

@[export: 'PQconnectionUsedPassword']
@[markused]
pub fn pq_connection_used_password(conn &PGconn) int {
	if isnil(conn) {
		return 0
	}
	if conn.password_needed {
		return 1
	} else {
		return 0
	}
}

@[export: 'PQconnectionUsedGSSAPI']
@[markused]
pub fn pq_connection_used_gssapi(conn &PGconn) int {
	if isnil(conn) {
		return 0
	}
	if conn.gssapi_used {
		return 1
	} else {
		return 0
	}
}

@[export: 'PQclientEncoding']
@[markused]
pub fn pq_client_encoding(conn &PGconn) int {
	if isnil(conn) || u32(conn.status) != u32(ConnStatusType.connection_ok) {
		return -1
	}
	return conn.client_encoding
}

@[export: 'PQsetClientEncoding']
@[markused]
pub fn pq_set_client_encoding(conn &PGconn, encoding &i8) int {
	qbuf := [128]i8{}
	if !pq_set_client_encoding_query_inited {
		c2v_static_init := [i8(115), 101, 116, 32, 99, 108, 105, 101, 110, 116, 95, 101, 110, 99,
			111, 100, 105, 110, 103, 32, 116, 111, 32, 39, 37, 115, 39, 0]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			pq_set_client_encoding_query[c2v_i_0] = c2v_element_0
		}
		pq_set_client_encoding_query_inited = true
	}

	res := &PGresult(0)
	status := 0
	if isnil(conn) || u32(conn.status) != u32(ConnStatusType.connection_ok) {
		return -1
	}
	if isnil(encoding) {
		return -1
	}
	if C.c2v_strcmp(encoding, c'auto') == 0 {
		encoding = pg_encoding_to_char(pg_get_encoding_from_locale((voidptr(0)), (1 != 0)))
	}
	if sizeof([128]i8) < (sizeof([28]i8) + C.c2v_strlen(encoding)) {
		return -1
	}
	pg_sprintf(unsafe { &i8(&qbuf[0]) }, unsafe { &i8(&pq_set_client_encoding_query[0]) }, voidptr(encoding))
	res = pq_exec(conn, unsafe { &i8(&qbuf[0]) })
	if usize(res) == usize((voidptr(0))) {
		return -1
	}
	if u32(res.resultStatus) != u32(ExecStatusType.pgres_command_ok) {
		status = -1
	} else {
		status = 0
	}
	pq_clear(res)
	return status
}

@[export: 'PQsetErrorVerbosity']
@[markused]
pub fn pq_set_error_verbosity(conn &PGconn, verbosity PGVerbosity) PGVerbosity {
	old := PGVerbosity{}
	if isnil(conn) {
		return PGVerbosity.pqerrors_default
	}
	old = conn.verbosity
	conn.verbosity = verbosity
	return old
}

@[export: 'PQsetErrorContextVisibility']
@[markused]
pub fn pq_set_error_context_visibility(conn &PGconn, show_context PGContextVisibility) PGContextVisibility {
	old := PGContextVisibility{}
	if isnil(conn) {
		return PGContextVisibility.pqshow_context_errors
	}
	old = conn.show_context
	conn.show_context = show_context
	return old
}

@[export: 'PQsetNoticeReceiver']
@[markused]
pub fn pq_set_notice_receiver(conn &PGconn, proc PQnoticeReceiver, arg voidptr) PQnoticeReceiver {
	old := unsafe { PQnoticeReceiver(nil) }
	if usize(conn) == usize((voidptr(0))) {
		return unsafe { PQnoticeReceiver(nil) }
	}
	old = conn.noticeHooks.noticeRec
	if proc {
		conn.noticeHooks.noticeRec = proc
		conn.noticeHooks.noticeRecArg = arg
	}
	return old
}

@[export: 'PQsetNoticeProcessor']
@[markused]
pub fn pq_set_notice_processor(conn &PGconn, proc PQnoticeProcessor, arg voidptr) PQnoticeProcessor {
	old := unsafe { PQnoticeProcessor(nil) }
	if usize(conn) == usize((voidptr(0))) {
		return unsafe { PQnoticeProcessor(nil) }
	}
	old = conn.noticeHooks.noticeProc
	if proc {
		conn.noticeHooks.noticeProc = proc
		conn.noticeHooks.noticeProcArg = arg
	}
	return old
}

@[markused]
pub fn default_notice_receiver(arg voidptr, res &PGresult) {
	c2v_gc_register_thread()

	if res.noticeHooks.noticeProc != (voidptr(0)) {
		res.noticeHooks.noticeProc(voidptr(res.noticeHooks.noticeProcArg), pq_result_error_message(res))
	}
}

@[markused]
pub fn default_notice_processor(arg voidptr, message &i8) {
	c2v_gc_register_thread()

	pg_fprintf(C.stderr, c'%s', voidptr(message))
}

@[markused]
pub fn pwdf_matches_string(buf &i8, token &i8) &i8 {
	tbuf := &i8(0)
	ttok := &i8(0)
	bslash := (0 != 0)
	if usize(buf) == usize((voidptr(0))) || usize(token) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	tbuf = buf
	ttok = token
	if int(tbuf[0]) == i8(`*`) && int(tbuf[1]) == i8(`:`) {
		return tbuf + 2
	}
	for int((unsafe { *tbuf })) != 0 {
		if int((unsafe { *tbuf })) == i8(`\\`) && !bslash {
			c2v_pointer_postfix(voidptr(&tbuf), tbuf, isize(1))
			bslash = (1 != 0)
		}
		if int((unsafe { *tbuf })) == i8(`:`) && int((unsafe { *ttok })) == 0 && !bslash {
			return tbuf + 1
		}
		bslash = (0 != 0)
		if int((unsafe { *ttok })) == 0 {
			return unsafe { nil }
		}
		if int((unsafe { *tbuf })) == int((unsafe { *ttok })) {
			c2v_pointer_postfix(voidptr(&tbuf), tbuf, isize(1))
			c2v_pointer_postfix(voidptr(&ttok), ttok, isize(1))
		} else {
			return unsafe { nil }
		}
	}
	return unsafe { nil }
}

@[markused]
pub fn password_from_file(hostname &i8, port &i8, dbname &i8, username &i8, pgpassfile &i8) &i8 {
	fp := &C.FILE(0)
	stat_buf := C.stat{}
	buf := PQExpBufferData{}
	if usize(dbname) == usize((voidptr(0))) || int(dbname[0]) == i8(`\0`) {
		return unsafe { nil }
	}
	if usize(username) == usize((voidptr(0))) || int(username[0]) == i8(`\0`) {
		return unsafe { nil }
	}
	if usize(hostname) == usize((voidptr(0))) || int(hostname[0]) == i8(`\0`) {
		hostname = c'localhost'
	} else if libpq_fe_connect_is_unixsock_path(hostname) {
		if C.c2v_strcmp(hostname, c'/tmp') == 0 {
			hostname = c'localhost'
		}
	}
	if usize(port) == usize((voidptr(0))) || int(port[0]) == i8(`\0`) {
		port = c'5432'
	}
	fp = C.c2v_fopen(pgpassfile, c'r')
	if usize(fp) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	if C.c2v_fstat(C.c2v_fileno(fp), &stat_buf) != 0 {
		C.c2v_fclose(fp)
		return unsafe { nil }
	}
	if !((int(stat_buf.st_mode) & 61440) == 32768) {
		pg_fprintf(C.stderr, unsafe { &i8(&c'WARNING: password file "%s" is not a plain file\n'[0]) }, voidptr(pgpassfile))
		C.c2v_fclose(fp)
		return unsafe { nil }
	}
	if int(stat_buf.st_mode) & (56 | 7) {
		pg_fprintf(C.stderr, unsafe { &i8(&c'WARNING: password file "%s" has group or world access; permissions should be u=rw (0600) or less\n'[0]) }, voidptr(pgpassfile))
		C.c2v_fclose(fp)
		return unsafe { nil }
	}
	init_pq_exp_buffer(&buf)
	for !C.c2v_feof(fp) && !C.c2v_ferror(fp) {
		if !enlarge_pq_exp_buffer(&buf, usize(128)) {
			break
		}
		if usize(C.c2v_fgets(buf.data + buf.len, int(buf.maxlen - buf.len), fp)) == usize((voidptr(0))) {
			break
		}
		buf.len += C.c2v_strlen(buf.data + buf.len)
		if !(buf.len > usize(0) && int(buf.data[buf.len - usize(1)]) == i8(`\n`)) && !C.c2v_feof(fp) {
			continue
		}
		if int(buf.data[0]) != i8(`#`) {
			t := buf.data
			len := 0
			len = pg_strip_crlf(t)
			mut __c2v_condition_8 := false
			mut __c2v_condition_9 := false
			__c2v_condition_9 = len > 0
			if __c2v_condition_9 {
				__c2v_condition_9 = usize(c2v_assign[&i8](unsafe { &t }, pwdf_matches_string(t, hostname))) != usize((voidptr(0)))
			}
			if __c2v_condition_9 {
				__c2v_condition_9 = usize(c2v_assign[&i8](unsafe { &t }, pwdf_matches_string(t, port))) != usize((voidptr(0)))
			}
			if __c2v_condition_9 {
				__c2v_condition_9 = usize(c2v_assign[&i8](unsafe { &t }, pwdf_matches_string(t, dbname))) != usize((voidptr(0)))
			}
			if __c2v_condition_9 {
				__c2v_condition_9 = usize(c2v_assign[&i8](unsafe { &t }, pwdf_matches_string(t, username))) != usize((voidptr(0)))
			}
			__c2v_condition_8 = __c2v_condition_9
			if __c2v_condition_8 {
				ret := &i8(0)
				p1 := &i8(0)
				p2 := &i8(0)

				ret = C.c2v_strdup(t)
				C.c2v_fclose(fp)
				explicit_bzero(voidptr(buf.data), buf.maxlen)
				term_pq_exp_buffer(&buf)
				if isnil(ret) {
					return unsafe { nil }
				}
				p2 = ret
				for p1 = ret; int((unsafe { *p1 })) != i8(`:`) && int((unsafe { *p1 })) != i8(`\0`); p1 = unsafe { p1 + 1 } {
					if int((unsafe { *p1 })) == i8(`\\`) && int(p1[1]) != i8(`\0`) {
						c2v_pointer_prefix(voidptr(&p1), p1, isize(1))
					}
					unsafe { *p2 = *p1 }
					c2v_pointer_prefix(voidptr(&p2), p2, isize(1))
				}
				unsafe { *p2 = i8(`\0`) }
				return ret
			}
		}
		buf.len = usize(0)
	}
	C.c2v_fclose(fp)
	explicit_bzero(voidptr(buf.data), buf.maxlen)
	term_pq_exp_buffer(&buf)
	return unsafe { nil }
}

@[markused]
pub fn pgpassfile_warning(conn &PGconn) {
	if int(conn.password_needed) && usize(conn.connhost[conn.whichhost].password) != usize((voidptr(0))) && !isnil(conn.result) {
		sqlstate := pq_result_error_field(conn.result, `C`)
		if !isnil(sqlstate) && C.c2v_strcmp(sqlstate, c'28P01') == 0 {
			libpq_append_conn_error(conn, c'password retrieved from file "%s"', voidptr(conn.pgpassfile))
		}
	}
}

@[markused]
pub fn ssl_verify_protocol_version(version &i8) bool {
	if isnil(version) || C.c2v_strlen(version) == u64(0) {
		return true != 0
	}
	if pg_strcasecmp(version, c'TLSv1') == 0 || pg_strcasecmp(version, c'TLSv1.1') == 0 || pg_strcasecmp(version, c'TLSv1.2') == 0 || pg_strcasecmp(version, c'TLSv1.3') == 0 {
		return true != 0
	}
	return false != 0
}

@[markused]
pub fn ssl_verify_protocol_range(min &i8, max &i8) bool {
	if usize(min) == usize((voidptr(0))) || usize(max) == usize((voidptr(0))) || C.c2v_strlen(min) == u64(0) || C.c2v_strlen(max) == u64(0) {
		return true != 0
	}
	if pg_strcasecmp(min, c'TLSv1') == 0 {
		return true != 0
	}
	if pg_strcasecmp(max, c'TLSv1') == 0 {
		return false != 0
	}
	if pg_strcasecmp(min, max) > 0 {
		return false != 0
	}
	return true != 0
}

@[export: 'pqGetHomeDirectory']
@[markused]
pub fn pq_get_home_directory(buf &i8, bufsize int) bool {
	home := &i8(0)
	home = C.c2v_getenv(c'HOME')
	if !isnil(home) && int(home[0]) {
		C.c2v_strlcpy(buf, home, u64(bufsize))
		return true != 0
	} else {
		pwbuf := C.passwd{}
		pw := &C.passwd(0)
		tmpbuf := [1024]i8{}
		rc := 0
		rc = C.c2v_getpwuid_r(C.c2v_geteuid(), &pwbuf, unsafe { &i8(&tmpbuf[0]) }, sizeof([1024]i8), &&C.passwd(&&C.passwd(c2v_address_of(&pw))))
		if rc != 0 || isnil(pw) {
			return false != 0
		}
		C.c2v_strlcpy(buf, pw.pw_dir, u64(bufsize))
		return true != 0
	}
}

@[export: 'pqParseIntParam']
@[markused]
pub fn pq_parse_int_param(value &i8, result &int, conn &PGconn, context &i8) bool {
	end := &i8(0)
	numval := i64(0)

	unsafe { *result = 0 }
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = 0 }
	}
	numval = C.c2v_strtol(value, &&u8(&&i8(c2v_address_of(&end))), 10)
	if usize(value) == usize(end) || (unsafe { *C.c2v___error() }) != 0 || numval != i64(int(numval)) {
		unsafe {
			goto error
		}
	}
	for int((unsafe { *end })) != i8(`\0`) && C.c2v_isspace(int(u8((unsafe { *end })))) {
		c2v_pointer_postfix(voidptr(&end), end, isize(1))
	}
	if int((unsafe { *end })) != i8(`\0`) {
		unsafe {
			goto error
		}
	}
	unsafe { *result = int(numval) }
	return true != 0
	error:
	libpq_append_conn_error(conn, c'invalid integer value "%s" for connection option "%s"', voidptr(value), voidptr(context))
	return false != 0
}

@[markused]
pub fn pq_parse_protocol_version(value &i8, result &ProtocolVersion, conn &PGconn, context &i8) bool {
	if C.c2v_strcmp(value, c'latest') == 0 {
		unsafe { *result = ProtocolVersion(((3 << 16) | 2)) }
		return true != 0
	}
	if C.c2v_strcmp(value, c'3.0') == 0 {
		unsafe { *result = ProtocolVersion(((3 << 16) | 0)) }
		return true != 0
	}
	if C.c2v_strcmp(value, c'3.2') == 0 {
		unsafe { *result = ProtocolVersion(((3 << 16) | 2)) }
		return true != 0
	}
	libpq_append_conn_error(conn, c'invalid %s value: "%s"', voidptr(context), voidptr(value))
	return false != 0
}

@[markused]
pub fn default_threadlock(acquire int) {
	c2v_gc_register_thread()
	if !default_threadlock_singlethread_lock_inited {
		default_threadlock_singlethread_lock = C.pthread_mutex_t{
			__sig: i64(850045863)
			__opaque: [i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0),
				i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0),
				i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0),
				i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0),
				i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0), i8(0)]!
		}

		default_threadlock_singlethread_lock_inited = true
	}

	if acquire {
		if C.c2v_pthread_mutex_lock(&default_threadlock_singlethread_lock) {
		}
	} else {
		if C.c2v_pthread_mutex_unlock(&default_threadlock_singlethread_lock) {
		}
	}
}

@[export: 'PQregisterThreadLock']
@[markused]
pub fn pq_register_thread_lock(newhandler Pgthreadlock_t) Pgthreadlock_t {
	prev := pg_g_threadlock
	if newhandler {
		pg_g_threadlock = newhandler
	} else {
		pg_g_threadlock = default_threadlock
	}
	return prev
}
