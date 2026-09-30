@[translated]
module libpq

pub type PGcancelConn_fe_secure = Pg_cancel_conn

pub type PGcancel_fe_secure = Pg_cancel

@[markused]
pub fn libpq_fe_secure_is_unixsock_path(path &i8) bool {
	return (int(path[false]) == i8(`/`)) || int(path[false]) == i8(`@`)
}

pub struct Sigpipe_info {
pub mut:
	oldsigmask      u32
	sigpipe_pending bool
	got_epipe       bool
}

@[export: 'PQsslInUse']
@[markused]
pub fn pq_ssl_in_use(conn &PGconn) int {
	if isnil(conn) {
		return 0
	}
	return int(conn.ssl_in_use)
}

@[export: 'PQinitSSL']
@[markused]
pub fn pq_init_ssl(do_init int) {
}

@[export: 'PQinitOpenSSL']
@[markused]
pub fn pq_init_open_ssl(do_ssl int, do_crypto int) {
}

@[export: 'pqsecure_open_client']
@[markused]
pub fn pqsecure_open_client(conn &PGconn) PostgresPollingStatusType {
	return PostgresPollingStatusType.pgres_polling_failed
}

@[export: 'pqsecure_close']
@[markused]
pub fn pqsecure_close(conn &PGconn) {
}

@[export: 'pqsecure_read']
@[markused]
pub fn pqsecure_read(conn &PGconn, ptr voidptr, len usize) isize {
	n := isize(0)
	n = pqsecure_raw_read(conn, voidptr(ptr), len)
	return isize(n)
}

@[export: 'pqsecure_raw_read']
@[markused]
pub fn pqsecure_raw_read(conn &PGconn, ptr voidptr, len usize) isize {
	n := isize(0)
	result_errno := 0
	sebuf := [256]i8{}
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = 0 }
	}
	n = C.c2v_recv(conn.sock, voidptr(ptr), len, 0)
	if n < isize(0) {
		result_errno = unsafe { *C.c2v___error() }
		match result_errno {
			35, 4 {
			}
			32, 54 {
				libpq_append_conn_error(conn, c'server closed the connection unexpectedly\n\tThis probably means the server terminated abnormally\n\tbefore or while processing the request.')
			}
			0 {
				n = isize(0)
			}
			else {
				libpq_append_conn_error(conn, c'could not receive data from server: %s', voidptr(pg_strerror_r(result_errno, unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
			}
		}
	}
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = result_errno }
	}
	return isize(n)
}

@[export: 'pqsecure_bytes_pending']
@[markused]
pub fn pqsecure_bytes_pending(conn &PGconn) isize {
	return isize(0)
}

@[export: 'pqsecure_write']
@[markused]
pub fn pqsecure_write(conn &PGconn, ptr voidptr, len usize) isize {
	n := isize(0)
	n = pqsecure_raw_write(conn, voidptr(ptr), len)
	return isize(n)
}

@[export: 'pqsecure_raw_write']
@[markused]
pub fn pqsecure_raw_write(conn &PGconn, ptr voidptr, len usize) isize {
	n := isize(0)
	flags := 0
	result_errno := 0
	msgbuf := [1024]i8{}
	sebuf := [256]i8{}
	spinfo := Sigpipe_info{}
	if conn.write_failed {
		return isize(len)
	}
	if conn.sigpipe_flag {
		flags |= 524288
	}
	retry_masked: for {
		spinfo.got_epipe = (0 != 0)
		if !(int(conn.sigpipe_so) || int(conn.sigpipe_flag)) {
			if pq_block_sigpipe(&spinfo.oldsigmask, &spinfo.sigpipe_pending) < 0 {
				return isize(-1)
			}
		}
		break
	}
	n = C.c2v_send(conn.sock, voidptr(ptr), len, flags)
	if n < isize(0) {
		result_errno = unsafe { *C.c2v___error() }
		if flags != 0 && result_errno == 22 {
			conn.sigpipe_flag = (0 != 0)
			flags = 0
			unsafe {
				goto retry_masked
			}
		}
		match result_errno {
			35, 4 {
			}
			32 {
				for {
					if 1 {
						spinfo.got_epipe = (1 != 0)
					}
					break
				}
				unsafe {
					goto c2v_case_35_2
				}
			}
			54 {
				c2v_case_35_2:
				conn.write_failed = (1 != 0)
				pg_snprintf(unsafe { &i8(&msgbuf[0]) }, sizeof([1024]i8), unsafe { &i8(&c'server closed the connection unexpectedly\n\tThis probably means the server terminated abnormally\n\tbefore or while processing the request.'[0]) })
				C.c2v_strlcat(unsafe { &i8(&msgbuf[0]) }, c'\n', sizeof([1024]i8))
				conn.write_err_msg = C.c2v_strdup(unsafe { &i8(&msgbuf[0]) })
				n = isize(len)
			}
			else {
				conn.write_failed = (1 != 0)
				pg_snprintf(unsafe { &i8(&msgbuf[0]) }, sizeof([1024]i8), unsafe { &i8(&c'could not send data to server: %s'[0]) }, voidptr(pg_strerror_r(result_errno, unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
				C.c2v_strlcat(unsafe { &i8(&msgbuf[0]) }, c'\n', sizeof([1024]i8))
				conn.write_err_msg = C.c2v_strdup(unsafe { &i8(&msgbuf[0]) })
				n = isize(len)
			}
		}
	}
	for {
		if !(int(conn.sigpipe_so) || int(conn.sigpipe_flag)) {
			pq_reset_sigpipe(&spinfo.oldsigmask, spinfo.sigpipe_pending, spinfo.got_epipe)
		}
		break
	}
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = result_errno }
	}
	return isize(n)
}

@[export: 'PQgetssl']
@[markused]
pub fn pq_getssl(conn &PGconn) voidptr {
	return unsafe { nil }
}

@[export: 'PQsslStruct']
@[markused]
pub fn pq_ssl_struct(conn &PGconn, struct_name &i8) voidptr {
	return unsafe { nil }
}

@[export: 'PQsslAttribute']
@[markused]
pub fn pq_ssl_attribute(conn &PGconn, attribute_name &i8) &i8 {
	return unsafe { nil }
}

@[export: 'PQsslAttributeNames']
@[markused]
pub fn pq_ssl_attribute_names(conn &PGconn) &&u8 {
	if !pq_ssl_attribute_names_result_inited {
		c2v_static_init := [unsafe { &i8(nil) }]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			pq_ssl_attribute_names_result[c2v_i_0] = c2v_element_0
		}
		pq_ssl_attribute_names_result_inited = true
	}

	return unsafe { &pq_ssl_attribute_names_result[0] }
}

@[export: 'PQgetSSLKeyPassHook_OpenSSL']
@[markused]
pub fn pq_get_ssl_key_pass_hook_open_ssl() PQsslKeyPassHook_OpenSSL_type {
	return unsafe { PQsslKeyPassHook_OpenSSL_type(nil) }
}

@[export: 'PQsetSSLKeyPassHook_OpenSSL']
@[markused]
pub fn pq_set_ssl_key_pass_hook_open_ssl(hook PQsslKeyPassHook_OpenSSL_type) {
	return
}

@[export: 'PQdefaultSSLKeyPassHook_OpenSSL']
@[markused]
pub fn pq_default_ssl_key_pass_hook_open_ssl(buf &i8, size int, conn &PGconn) int {
	return 0
}

@[export: 'PQgetgssctx']
@[markused]
pub fn pq_getgssctx(conn &PGconn) voidptr {
	return unsafe { nil }
}

@[export: 'PQgssEncInUse']
@[markused]
pub fn pq_gss_enc_in_use(conn &PGconn) int {
	return 0
}

@[export: 'pq_block_sigpipe']
@[markused]
pub fn pq_block_sigpipe(osigset &u32, sigpipe_pending &bool) int {
	sigpipe_sigset := u32(0)
	sigset := u32(0)
	mut __c2v_lhs_tmp_0 := unsafe { &sigpipe_sigset }
	unsafe { *__c2v_lhs_tmp_0 = u32(0) }
	0
	mut __c2v_lhs_tmp_1 := unsafe { &sigpipe_sigset }
	unsafe { *__c2v_lhs_tmp_1 |= C.c2v___sigbits(13) }
	0
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = C.c2v_pthread_sigmask(1, &sigpipe_sigset, osigset) }
	}
	if (unsafe { *C.c2v___error() }) {
		return -1
	}
	if (((unsafe { *osigset }) & (C.c2v___sigbits(13))) != u32(0)) {
		if C.c2v_sigpending(&sigset) != 0 {
			return -1
		}
		if (((unsafe { *(&sigset) }) & (C.c2v___sigbits(13))) != u32(0)) {
			unsafe { *sigpipe_pending = (1 != 0) }
		} else {
			unsafe { *sigpipe_pending = (0 != 0) }
		}
	} else {
		unsafe { *sigpipe_pending = (0 != 0) }
	}
	return 0
}

@[export: 'pq_reset_sigpipe']
@[markused]
pub fn pq_reset_sigpipe(osigset &u32, sigpipe_pending bool, got_epipe bool) {
	save_errno := (unsafe { *C.c2v___error() })
	signo := 0
	sigset := u32(0)
	if int(got_epipe) && !sigpipe_pending {
		if C.c2v_sigpending(&sigset) == 0 && (((unsafe { *(&sigset) }) & (C.c2v___sigbits(13))) != u32(0)) {
			sigpipe_sigset := u32(0)
			mut __c2v_lhs_tmp_2 := unsafe { &sigpipe_sigset }
			unsafe { *__c2v_lhs_tmp_2 = u32(0) }
			0
			mut __c2v_lhs_tmp_3 := unsafe { &sigpipe_sigset }
			unsafe { *__c2v_lhs_tmp_3 |= C.c2v___sigbits(13) }
			0
			C.c2v_sigwait(&sigpipe_sigset, &signo)
		}
	}
	C.c2v_pthread_sigmask(3, osigset, (voidptr(0)))
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = save_errno }
	}
}
