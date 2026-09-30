@[translated]
module libpq

pub type PGcancelConn_fe_cancel = Pg_cancel_conn

pub type PGcancel_fe_cancel = Pg_cancel

@[markused]
pub fn libpq_fe_cancel_is_unixsock_path(path &i8) bool {
	return (i32(path[false]) == i8(`/`)) || i32(path[false]) == i8(`@`)
}

pub struct Pg_cancel_conn {
pub mut:
	conn PGconn
}

pub struct Pg_cancel {
pub mut:
	raddr               SockAddr
	be_pid              i32
	pgtcp_user_timeout  i32
	keepalives          i32
	keepalives_idle     i32
	keepalives_interval i32
	keepalives_count    i32
	cancel_pkt_len      Int32
	cancel_req          [1]i8
}

@[export: 'PQcancelCreate']
@[markused]
pub fn pq_cancel_create(conn &PGconn) &PGcancelConn_fe_cancel {
	cancel_conn := pq_make_empty_pg_conn()
	original_host := Pg_conn_host{}
	if usize(cancel_conn) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	if isnil(conn) {
		libpq_append_conn_error(cancel_conn, c'connection pointer is NULL')
		return &PGcancelConn_fe_cancel(voidptr(cancel_conn))
	}
	if conn.sock == (-1) {
		libpq_append_conn_error(cancel_conn, c'connection not open')
		return &PGcancelConn_fe_cancel(voidptr(cancel_conn))
	}
	if conn.be_cancel_key_len == 0 {
		libpq_append_conn_error(cancel_conn, c'no cancellation key received')
		return &PGcancelConn_fe_cancel(voidptr(cancel_conn))
	}
	cancel_conn.cancelRequest = (1 != 0)
	if !pq_copy_pg_conn(conn, cancel_conn) {
		return &PGcancelConn_fe_cancel(voidptr(cancel_conn))
	}
	if !pq_connect_options2(cancel_conn) {
		return &PGcancelConn_fe_cancel(voidptr(cancel_conn))
	}
	cancel_conn.be_pid = conn.be_pid
	if usize(conn.be_cancel_key) != usize((voidptr(0))) {
		cancel_conn.be_cancel_key = C.c2v_malloc(u64(conn.be_cancel_key_len))
		if usize(cancel_conn.be_cancel_key) == usize((voidptr(0))) {
			unsafe {
				goto oom_error
			}
		}
		C.c2v_memcpy(voidptr(cancel_conn.be_cancel_key), voidptr(conn.be_cancel_key), u64(conn.be_cancel_key_len))
	}
	cancel_conn.be_cancel_key_len = conn.be_cancel_key_len
	cancel_conn.pversion = conn.pversion
	pq_release_conn_hosts(cancel_conn)
	cancel_conn.nconnhost = 1
	cancel_conn.naddr = 1
	cancel_conn.connhost = C.c2v_calloc(u64(cancel_conn.nconnhost), sizeof(Pg_conn_host))
	if isnil(cancel_conn.connhost) {
		unsafe {
			goto oom_error
		}
	}
	original_host = conn.connhost[conn.whichhost]
	cancel_conn.connhost[0].type_ = original_host.type_
	if original_host.host {
		cancel_conn.connhost[0].host = C.c2v_strdup(original_host.host)
		if isnil(cancel_conn.connhost[0].host) {
			unsafe {
				goto oom_error
			}
		}
	}
	if original_host.hostaddr {
		cancel_conn.connhost[0].hostaddr = C.c2v_strdup(original_host.hostaddr)
		if isnil(cancel_conn.connhost[0].hostaddr) {
			unsafe {
				goto oom_error
			}
		}
	}
	if original_host.port {
		cancel_conn.connhost[0].port = C.c2v_strdup(original_host.port)
		if isnil(cancel_conn.connhost[0].port) {
			unsafe {
				goto oom_error
			}
		}
	}
	if original_host.password {
		cancel_conn.connhost[0].password = C.c2v_strdup(original_host.password)
		if isnil(cancel_conn.connhost[0].password) {
			unsafe {
				goto oom_error
			}
		}
	}
	cancel_conn.addr = C.c2v_calloc(u64(cancel_conn.naddr), sizeof(AddrInfo))
	if isnil(cancel_conn.addr) {
		unsafe {
			goto oom_error
		}
	}
	cancel_conn.addr[0].addr = conn.raddr
	cancel_conn.addr[0].family = i32(conn.raddr.addr.ss_family)
	cancel_conn.status = ConnStatusType.connection_allocated
	return &PGcancelConn_fe_cancel(voidptr(cancel_conn))
	oom_error:
	cancel_conn.status = ConnStatusType.connection_bad
	libpq_append_conn_error(cancel_conn, c'out of memory')
	return &PGcancelConn_fe_cancel(voidptr(cancel_conn))
}

@[export: 'PQcancelBlocking']
@[markused]
pub fn pq_cancel_blocking(cancel_conn &PGcancelConn_fe_cancel) i32 {
	if !pq_cancel_start(cancel_conn) {
		return 0
	}
	return pq_connect_db_complete(&cancel_conn.conn)
}

@[export: 'PQcancelStart']
@[markused]
pub fn pq_cancel_start(cancel_conn &PGcancelConn_fe_cancel) i32 {
	if isnil(cancel_conn) || u32(cancel_conn.conn.status) == u32(ConnStatusType.connection_bad) {
		return 0
	}
	if u32(cancel_conn.conn.status) != u32(ConnStatusType.connection_allocated) {
		libpq_append_conn_error(&cancel_conn.conn, c'cancel request is already being sent on this connection')
		cancel_conn.conn.status = ConnStatusType.connection_bad
		return 0
	}
	return pq_connect_db_start(&cancel_conn.conn)
}

@[export: 'PQcancelPoll']
@[markused]
pub fn pq_cancel_poll(cancel_conn &PGcancelConn_fe_cancel) PostgresPollingStatusType {
	conn := &cancel_conn.conn
	n := i32(0)
	if u32(conn.status) != u32(ConnStatusType.connection_awaiting_response) {
		return pq_connect_poll(conn)
	}
	n = pq_read_data(conn)
	if n == 0 {
		return PostgresPollingStatusType.pgres_polling_reading
	}
	if n < 0 && (unsafe { *C.c2v___error() }) != 0 {
		conn.status = ConnStatusType.connection_bad
		return PostgresPollingStatusType.pgres_polling_failed
	}
	if n > 0 {
		libpq_append_conn_error(conn, c'unexpected response from server')
		conn.status = ConnStatusType.connection_bad
		return PostgresPollingStatusType.pgres_polling_failed
	}
	cancel_conn.conn.status = ConnStatusType.connection_ok
	reset_pq_exp_buffer(&conn.errorMessage)
	return PostgresPollingStatusType.pgres_polling_ok
}

@[export: 'PQcancelStatus']
@[markused]
pub fn pq_cancel_status(cancel_conn &PGcancelConn_fe_cancel) ConnStatusType {
	return pq_status(&cancel_conn.conn)
}

@[export: 'PQcancelSocket']
@[markused]
pub fn pq_cancel_socket(cancel_conn &PGcancelConn_fe_cancel) i32 {
	return pq_socket(&cancel_conn.conn)
}

@[export: 'PQcancelErrorMessage']
@[markused]
pub fn pq_cancel_error_message(cancel_conn &PGcancelConn_fe_cancel) &i8 {
	return pq_error_message(&cancel_conn.conn)
}

@[export: 'PQcancelReset']
@[markused]
pub fn pq_cancel_reset(cancel_conn &PGcancelConn_fe_cancel) {
	pq_close_pg_conn(&cancel_conn.conn)
	cancel_conn.conn.status = ConnStatusType.connection_allocated
	cancel_conn.conn.whichhost = 0
	cancel_conn.conn.whichaddr = 0
	cancel_conn.conn.try_next_host = (0 != 0)
	cancel_conn.conn.try_next_addr = (0 != 0)
}

@[export: 'PQcancelFinish']
@[markused]
pub fn pq_cancel_finish(cancel_conn &PGcancelConn_fe_cancel) {
	pq_finish(&cancel_conn.conn)
}

@[export: 'PQgetCancel']
@[markused]
pub fn pq_get_cancel(conn &PGconn) &PGcancel_fe_cancel {
	cancel := &PGcancel_fe_cancel(0)
	cancel_req_len := i32(0)
	req := &CancelRequestPacket(0)
	if isnil(conn) {
		return unsafe { nil }
	}
	if conn.sock == (-1) {
		return unsafe { nil }
	}
	if conn.be_cancel_key_len == 0 {
		return C.c2v_calloc(u64(1), sizeof(PGcancel_fe_cancel))
	}
	cancel_req_len = i32((u64(usize(__offsetof(CancelRequestPacket, cancelAuthCode)))) + u64(conn.be_cancel_key_len))
	cancel = C.c2v_malloc((u64(usize(__offsetof(PGcancel_fe_cancel, cancel_req)))) + u64(cancel_req_len))
	if usize(cancel) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	C.c2v_memcpy(voidptr(&cancel.raddr), voidptr(&conn.raddr), sizeof(SockAddr))
	cancel.pgtcp_user_timeout = -1
	cancel.keepalives = -1
	cancel.keepalives_idle = -1
	cancel.keepalives_interval = -1
	cancel.keepalives_count = -1
	if usize(conn.pgtcp_user_timeout) != usize((voidptr(0))) {
		if !pq_parse_int_param(conn.pgtcp_user_timeout, &cancel.pgtcp_user_timeout, conn, c'tcp_user_timeout') {
			unsafe {
				goto fail
			}
		}
	}
	if usize(conn.keepalives) != usize((voidptr(0))) {
		if !pq_parse_int_param(conn.keepalives, &cancel.keepalives, conn, c'keepalives') {
			unsafe {
				goto fail
			}
		}
	}
	if usize(conn.keepalives_idle) != usize((voidptr(0))) {
		if !pq_parse_int_param(conn.keepalives_idle, &cancel.keepalives_idle, conn, c'keepalives_idle') {
			unsafe {
				goto fail
			}
		}
	}
	if usize(conn.keepalives_interval) != usize((voidptr(0))) {
		if !pq_parse_int_param(conn.keepalives_interval, &cancel.keepalives_interval, conn, c'keepalives_interval') {
			unsafe {
				goto fail
			}
		}
	}
	if usize(conn.keepalives_count) != usize((voidptr(0))) {
		if !pq_parse_int_param(conn.keepalives_count, &cancel.keepalives_count, conn, c'keepalives_count') {
			unsafe {
				goto fail
			}
		}
	}
	req = &CancelRequestPacket(voidptr(unsafe { &cancel.cancel_req }))
	req.cancelRequestCode = MsgType(c2v_builtin_bswap32(u32(((1234 << 16) | 5678))))
	req.backendPID = c2v_builtin_bswap32(u32(conn.be_pid))
	C.c2v_memcpy(req.cancelAuthCode, voidptr(conn.be_cancel_key), u64(conn.be_cancel_key_len))
	cancel.cancel_pkt_len = Int32(c2v_builtin_bswap32(u32(cancel_req_len + 4)))
	return cancel
	fail:
	C.c2v_free(voidptr(cancel))
	return unsafe { nil }
}

@[export: 'PQsendCancelRequest']
@[markused]
pub fn pq_send_cancel_request(cancel_conn &PGconn) i32 {
	req := CancelRequestPacket{}
	if pq_put_msg_start(i8(0), cancel_conn) {
		return -1
	}
	C.c2v_memset(voidptr(&req), 0, (u64(usize(__offsetof(CancelRequestPacket, cancelAuthCode)))))
	req.cancelRequestCode = MsgType(c2v_builtin_bswap32(u32(((1234 << 16) | 5678))))
	req.backendPID = c2v_builtin_bswap32(u32(cancel_conn.be_pid))
	if pq_putnchar(voidptr(&req), (u64(usize(__offsetof(CancelRequestPacket, cancelAuthCode)))), cancel_conn) {
		return -1
	}
	if pq_putnchar(voidptr(cancel_conn.be_cancel_key), usize(cancel_conn.be_cancel_key_len), cancel_conn) {
		return -1
	}
	if pq_put_msg_end(cancel_conn) {
		return -1
	}
	if pq_flush_vdup1(cancel_conn) {
		return -1
	}
	return 0
}

@[export: 'PQfreeCancel']
@[markused]
pub fn pq_free_cancel(cancel &PGcancel_fe_cancel) {
	C.c2v_free(voidptr(cancel))
}

@[markused]
pub fn optional_setsockopt(fd i32, protoid i32, optid i32, value i32) bool {
	if value < 0 {
		return true != 0
	}
	if C.c2v_setsockopt(fd, protoid, optid, voidptr(&i8(c2v_address_of(&value))), u32(sizeof(value))) < 0 {
		return false != 0
	}
	return true != 0
}

@[export: 'PQcancel']
@[markused]
pub fn pq_cancel(cancel &PGcancel_fe_cancel, errbuf &i8, errbufsize i32) i32 {
	save_errno := (unsafe { *C.c2v___error() })
	tmpsock := Pgsocket((-1))
	maxlen := i32(0)
	recvbuf := i8(0)
	cancel_pkt_len := i32(0)
	if isnil(cancel) {
		C.c2v_strlcpy(errbuf, c'PQcancel() -- no cancel object supplied', u64(errbufsize))
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = save_errno }
		}
		return 0
	}
	if cancel.cancel_pkt_len == 0 {
		C.c2v_strlcpy(errbuf, c'PQcancel() -- no cancellation key received', u64(errbufsize))
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = save_errno }
		}
		return 0
	}
	tmpsock = C.c2v_socket(i32(cancel.raddr.addr.ss_family), 1, 0)
	if tmpsock == (-1) {
		C.c2v_strlcpy(errbuf, c'PQcancel() -- socket() failed: ', u64(errbufsize))
		unsafe {
			goto cancel_errReturn
		}
	}
	if i32(cancel.raddr.addr.ss_family) != 1 && cancel.keepalives != 0 {
		if !optional_setsockopt(tmpsock, 65535, 8, 1) {
			C.c2v_strlcpy(errbuf, c'PQcancel() -- setsockopt(SO_KEEPALIVE) failed: ', u64(errbufsize))
			unsafe {
				goto cancel_errReturn
			}
		}
	}
	retry3:
	if C.c2v_connect(tmpsock, &C.sockaddr(voidptr(&cancel.raddr.addr)), cancel.raddr.salen) < 0 {
		if (unsafe { *C.c2v___error() }) == 4 {
			unsafe {
				goto retry3
			}
		}
		C.c2v_strlcpy(errbuf, c'PQcancel() -- connect() failed: ', u64(errbufsize))
		unsafe {
			goto cancel_errReturn
		}
	}
	cancel_pkt_len = i32(c2v_builtin_bswap32(u32(cancel.cancel_pkt_len)))
	retry4:
	if C.c2v_send(tmpsock, voidptr(&i8(voidptr(&cancel.cancel_pkt_len))), usize(cancel_pkt_len), 0) != isize(cancel_pkt_len) {
		if (unsafe { *C.c2v___error() }) == 4 {
			unsafe {
				goto retry4
			}
		}
		C.c2v_strlcpy(errbuf, c'PQcancel() -- send() failed: ', u64(errbufsize))
		unsafe {
			goto cancel_errReturn
		}
	}
	retry5:
	if C.c2v_recv(tmpsock, voidptr(&recvbuf), usize(1), 0) < isize(0) {
		if (unsafe { *C.c2v___error() }) == 4 {
			unsafe {
				goto retry5
			}
		}
	}
	C.c2v_close(tmpsock)
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = save_errno }
	}
	return 1
	cancel_errReturn:
	maxlen = i32(u64(errbufsize) - C.c2v_strlen(errbuf) - u64(2))
	if maxlen >= 0 {
		val := (unsafe { *C.c2v___error() })
		buf := [32]i8{}
		bufp := &i8(0)
		bufp = unsafe { &buf[0] } + sizeof([32]i8) - 1
		unsafe { *bufp = i8(`\0`) }
		for {
			mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_prefix(voidptr(&bufp), bufp, isize(-1)) }
			unsafe { *__c2v_lhs_tmp_0 = i8((val % 10) + i32(`0`)) }
			val /= 10
			if !(val > 0) {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&bufp), bufp, isize(-(6)))
		C.c2v_memcpy(voidptr(bufp), voidptr(c'error '), u64(6))
		C.c2v_strncat(errbuf, bufp, u64(maxlen))
		C.c2v_strcat(errbuf, c'\n')
	}
	if tmpsock != (-1) {
		C.c2v_close(tmpsock)
	}
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = save_errno }
	}
	return 0
}

@[export: 'PQrequestCancel']
@[markused]
pub fn pq_request_cancel(conn &PGconn) i32 {
	r := i32(0)
	cancel := &PGcancel_fe_cancel(0)
	if isnil(conn) {
		return 0
	}
	if conn.sock == (-1) {
		C.c2v_strlcpy(conn.errorMessage.data, c'PQrequestCancel() -- connection is not open\n', conn.errorMessage.maxlen)
		conn.errorMessage.len = C.c2v_strlen(conn.errorMessage.data)
		conn.errorReported = 0
		return 0
	}
	cancel = pq_get_cancel(conn)
	if cancel {
		r = pq_cancel(cancel, conn.errorMessage.data, i32(conn.errorMessage.maxlen))
		pq_free_cancel(cancel)
	} else {
		C.c2v_strlcpy(conn.errorMessage.data, c'out of memory', conn.errorMessage.maxlen)
		r = 0
	}
	if !r {
		conn.errorMessage.len = C.c2v_strlen(conn.errorMessage.data)
		conn.errorReported = 0
	}
	return r
}
