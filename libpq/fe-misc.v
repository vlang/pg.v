@[translated]
module libpq

pub type PGcancelConn_fe_misc = Pg_cancel_conn

pub type PGcancel_fe_misc = Pg_cancel

@[markused]
pub fn libpq_fe_misc_is_unixsock_path(path &i8) bool {
	return (int(path[false]) == i8(`/`)) || int(path[false]) == i8(`@`)
}

@[markused]
pub fn libpq_fe_misc_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_fe_misc_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_fe_misc_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_fe_misc_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_fe_misc_utf8_to_unicode(c &u8) Pg_wchar {
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
pub fn libpq_fe_misc_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
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
pub fn libpq_fe_misc_unicode_utf8len(c Pg_wchar) int {
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

@[export: 'PQlibVersion']
@[markused]
pub fn pq_lib_version() int {
	return 180006
}

@[export: 'pqGetc']
@[markused]
pub fn pq_getc(result &i8, conn &PGconn) int {
	if conn.inCursor >= conn.inEnd {
		return -1
	}
	unsafe { *result = conn.inBuffer[conn.inCursor++] }
	return 0
}

@[export: 'pqPutc']
@[markused]
pub fn pq_putc(c i8, conn &PGconn) int {
	if pq_put_msg_bytes(voidptr(&c), usize(1), conn) {
		return -1
	}
	return 0
}

@[markused]
pub fn pq_gets_internal(buf PQExpBuffer, conn &PGconn, resetbuffer bool) int {
	in_buffer := conn.inBuffer
	in_cursor := conn.inCursor
	in_end := conn.inEnd
	slen := 0
	for in_cursor < in_end && int(in_buffer[in_cursor]) {
		in_cursor++
	}
	if in_cursor >= in_end {
		return -1
	}
	slen = in_cursor - conn.inCursor
	if resetbuffer {
		reset_pq_exp_buffer(buf)
	}
	append_binary_pq_exp_buffer(buf, in_buffer + conn.inCursor, usize(slen))
	conn.inCursor = c2v_prefix_add(unsafe { &in_cursor }, 1)
	return 0
}

@[export: 'pqGets']
@[markused]
pub fn pq_gets(buf PQExpBuffer, conn &PGconn) int {
	return pq_gets_internal(buf, conn, (1 != 0))
}

@[export: 'pqGets_append']
@[markused]
pub fn pq_gets_append(buf PQExpBuffer, conn &PGconn) int {
	return pq_gets_internal(buf, conn, (0 != 0))
}

@[export: 'pqPuts']
@[markused]
pub fn pq_puts(s &i8, conn &PGconn) int {
	if pq_put_msg_bytes(voidptr(s), C.c2v_strlen(s) + u64(1), conn) {
		return -1
	}
	return 0
}

@[export: 'pqGetnchar']
@[markused]
pub fn pq_getnchar(s voidptr, len usize, conn &PGconn) int {
	if len > usize((conn.inEnd - conn.inCursor)) {
		return -1
	}
	C.c2v_memcpy(voidptr(s), voidptr(conn.inBuffer + conn.inCursor), len)
	conn.inCursor += len
	return 0
}

@[export: 'pqSkipnchar']
@[markused]
pub fn pq_skipnchar(len usize, conn &PGconn) int {
	if len > usize((conn.inEnd - conn.inCursor)) {
		return -1
	}
	conn.inCursor += len
	return 0
}

@[export: 'pqPutnchar']
@[markused]
pub fn pq_putnchar(s voidptr, len usize, conn &PGconn) int {
	if pq_put_msg_bytes(voidptr(s), len, conn) {
		return -1
	}
	return 0
}

@[export: 'pqGetInt']
@[markused]
pub fn pq_get_int(result &int, bytes usize, conn &PGconn) int {
	tmp2 := Uint16(0)
	tmp4 := Uint32(0)
	match bytes {
		usize(2) {
			if conn.inCursor + 2 > conn.inEnd {
				return -1
			}
			C.c2v_memcpy(voidptr(&tmp2), voidptr(conn.inBuffer + conn.inCursor), u64(2))
			conn.inCursor += 2
			unsafe { *result = int(c2v_builtin_bswap16(tmp2)) }
		}
		usize(4) {
			if conn.inCursor + 4 > conn.inEnd {
				return -1
			}
			C.c2v_memcpy(voidptr(&tmp4), voidptr(conn.inBuffer + conn.inCursor), u64(4))
			conn.inCursor += 4
			unsafe { *result = int(c2v_builtin_bswap32(tmp4)) }
		}
		else {
			pq_internal_notice(&conn.noticeHooks, c'integer of size %lu not supported by pqGetInt', u64(bytes))
			return -1
		}
	}

	return 0
}

@[export: 'pqPutInt']
@[markused]
pub fn pq_put_int(value int, bytes usize, conn &PGconn) int {
	tmp2 := Uint16(0)
	tmp4 := Uint32(0)
	match bytes {
		usize(2) {
			tmp2 = c2v_builtin_bswap16(Uint16(value))
			if pq_put_msg_bytes(voidptr(&i8(c2v_address_of(&tmp2))), usize(2), conn) {
				return -1
			}
		}
		usize(4) {
			tmp4 = c2v_builtin_bswap32(Uint32(value))
			if pq_put_msg_bytes(voidptr(&i8(c2v_address_of(&tmp4))), usize(4), conn) {
				return -1
			}
		}
		else {
			pq_internal_notice(&conn.noticeHooks, c'integer of size %lu not supported by pqPutInt', u64(bytes))
			return -1
		}
	}

	return 0
}

@[export: 'pqCheckOutBufferSpace']
@[markused]
pub fn pq_check_out_buffer_space(bytes_needed usize, conn &PGconn) int {
	newsize := conn.outBufSize
	newbuf := &i8(0)
	if bytes_needed <= usize(newsize) {
		return 0
	}
	for {
		newsize *= 2
		if !(newsize > 0 && bytes_needed > usize(newsize)) {
			break
		}
	}
	if newsize > 0 && bytes_needed <= usize(newsize) {
		newbuf = &i8(C.c2v_realloc(voidptr(conn.outBuffer), u64(newsize)))
		if newbuf {
			conn.outBuffer = newbuf
			conn.outBufSize = newsize
			return 0
		}
	}
	newsize = conn.outBufSize
	for {
		newsize += 8192
		if !(newsize > 0 && bytes_needed > usize(newsize)) {
			break
		}
	}
	if newsize > 0 && bytes_needed <= usize(newsize) {
		newbuf = &i8(C.c2v_realloc(voidptr(conn.outBuffer), u64(newsize)))
		if newbuf {
			conn.outBuffer = newbuf
			conn.outBufSize = newsize
			return 0
		}
	}
	append_pq_exp_buffer_str(&conn.errorMessage, c'cannot allocate memory for output buffer\n')
	return -1
}

@[export: 'pqCheckInBufferSpace']
@[markused]
pub fn pq_check_in_buffer_space(bytes_needed usize, conn &PGconn) int {
	newsize := conn.inBufSize
	newbuf := &i8(0)
	if bytes_needed <= usize(newsize) {
		return 0
	}
	bytes_needed -= usize(conn.inStart)
	if conn.inStart < conn.inEnd {
		if conn.inStart > 0 {
			C.c2v_memmove(voidptr(conn.inBuffer), voidptr(conn.inBuffer + conn.inStart), u64(conn.inEnd - conn.inStart))
			conn.inEnd -= conn.inStart
			conn.inCursor -= conn.inStart
			conn.inStart = 0
		}
	} else {
		conn.inEnd = 0
		conn.inCursor = conn.inEnd
		conn.inStart = conn.inCursor
	}
	if bytes_needed <= usize(newsize) {
		return 0
	}
	for {
		newsize *= 2
		if !(newsize > 0 && bytes_needed > usize(newsize)) {
			break
		}
	}
	if newsize > 0 && bytes_needed <= usize(newsize) {
		newbuf = &i8(C.c2v_realloc(voidptr(conn.inBuffer), u64(newsize)))
		if newbuf {
			conn.inBuffer = newbuf
			conn.inBufSize = newsize
			return 0
		}
	}
	newsize = conn.inBufSize
	for {
		newsize += 8192
		if !(newsize > 0 && bytes_needed > usize(newsize)) {
			break
		}
	}
	if newsize > 0 && bytes_needed <= usize(newsize) {
		newbuf = &i8(C.c2v_realloc(voidptr(conn.inBuffer), u64(newsize)))
		if newbuf {
			conn.inBuffer = newbuf
			conn.inBufSize = newsize
			return 0
		}
	}
	append_pq_exp_buffer_str(&conn.errorMessage, c'cannot allocate memory for input buffer\n')
	return -1
}

@[export: 'pqParseDone']
@[markused]
pub fn pq_parse_done(conn &PGconn, new_in_start int) {
	if conn.pfdebug {
		pq_trace_output_message(conn, conn.inBuffer + conn.inStart, (0 != 0))
	}
	conn.inStart = new_in_start
}

@[export: 'pqPutMsgStart']
@[markused]
pub fn pq_put_msg_start(msg_type i8, conn &PGconn) int {
	len_pos := 0
	end_pos := 0
	if msg_type {
		end_pos = conn.outCount + 1
	} else {
		end_pos = conn.outCount
	}
	len_pos = end_pos
	end_pos += 4
	if pq_check_out_buffer_space(usize(end_pos), conn) {
		return -1
	}
	if msg_type {
		conn.outBuffer[conn.outCount] = msg_type
	}
	conn.outMsgStart = len_pos
	conn.outMsgEnd = end_pos
	return 0
}

@[markused]
pub fn pq_put_msg_bytes(buf voidptr, len usize, conn &PGconn) int {
	if pq_check_out_buffer_space(usize(conn.outMsgEnd) + len, conn) {
		return -1
	}
	C.c2v_memcpy(voidptr(conn.outBuffer + conn.outMsgEnd), voidptr(buf), len)
	conn.outMsgEnd += len
	return 0
}

@[export: 'pqPutMsgEnd']
@[markused]
pub fn pq_put_msg_end(conn &PGconn) int {
	if conn.outMsgStart >= 0 {
		msg_len := Uint32(conn.outMsgEnd - conn.outMsgStart)
		msg_len = c2v_builtin_bswap32(msg_len)
		C.c2v_memcpy(voidptr(conn.outBuffer + conn.outMsgStart), voidptr(&msg_len), u64(4))
	}
	if conn.pfdebug {
		if conn.outCount < conn.outMsgStart {
			pq_trace_output_message(conn, conn.outBuffer + conn.outCount, (1 != 0))
		} else {
			pq_trace_output_no_type_byte_message(conn, conn.outBuffer + conn.outMsgStart)
		}
	}
	conn.outCount = conn.outMsgEnd
	if conn.outCount >= 8192 {
		to_send := conn.outCount
		if int(conn.raddr.addr.ss_family) == 1 {
			to_send -= to_send % 8192
		}
		if pq_send_some(conn, to_send) < 0 {
			return -1
		}
	}
	return 0
}

@[export: 'pqReadData']
@[markused]
pub fn pq_read_data(conn &PGconn) int {
	available := 0
	if conn.sock == (-1) {
		libpq_append_conn_error(conn, c'connection not open')
		return -1
	}
	available = pq_read_data_internal(conn)
	if available < 0 {
		return -1
	} else if available > 0 {
		if pq_drain_pending(conn) {
			return -1
		}
	} else {
	}
	return available
}

@[markused]
pub fn pq_read_data_internal(conn &PGconn) int {
	someread := 0
	nread := 0
	if conn.inStart < conn.inEnd {
		if conn.inStart > 0 {
			C.c2v_memmove(voidptr(conn.inBuffer), voidptr(conn.inBuffer + conn.inStart), u64(conn.inEnd - conn.inStart))
			conn.inEnd -= conn.inStart
			conn.inCursor -= conn.inStart
			conn.inStart = 0
		}
	} else {
		conn.inEnd = 0
		conn.inCursor = conn.inEnd
		conn.inStart = conn.inCursor
	}
	if conn.inBufSize - conn.inEnd < 8192 {
		if pq_check_in_buffer_space(usize(conn.inEnd) + usize(8192), conn) {
			if conn.inBufSize - conn.inEnd < 100 {
				return -1
			}
		}
	}
	retry3:
	nread = int(pqsecure_read(conn, voidptr(conn.inBuffer + conn.inEnd), usize(conn.inBufSize - conn.inEnd)))
	if nread < 0 {
		match (unsafe { *C.c2v___error() }) {
			4 {
				unsafe {
					goto retry3
				}
			}
			35 {
				return someread
			}
			32, 54, 53, 64, 65, 50, 52, 51, 60 {
				unsafe {
					goto definitelyFailed
				}
			}
			else {
				return -1
			}
		}
	}
	if nread > 0 {
		conn.inEnd += nread
		if conn.inEnd > 32768 && (conn.inBufSize - conn.inEnd) >= 8192 {
			someread = 1
			unsafe {
				goto retry3
			}
		}
		return 1
	}
	if someread {
		return 1
	}
	match pq_read_ready(conn) {
		0 {
			return 0
		}
		1 {
		}
		else {
			unsafe {
				goto definitelyEOF
			}
		}
	}

	retry4:
	nread = int(pqsecure_read(conn, voidptr(conn.inBuffer + conn.inEnd), usize(conn.inBufSize - conn.inEnd)))
	if nread < 0 {
		match (unsafe { *C.c2v___error() }) {
			4 {
				unsafe {
					goto retry4
				}
			}
			35 {
				return 0
			}
			32, 54, 53, 64, 65, 50, 52, 51, 60 {
				unsafe {
					goto definitelyFailed
				}
			}
			else {
				return -1
			}
		}
	}
	if nread > 0 {
		conn.inEnd += nread
		return 1
	}
	definitelyEOF:
	libpq_append_conn_error(conn, c'server closed the connection unexpectedly\n\tThis probably means the server terminated abnormally\n\tbefore or while processing the request.')
	definitelyFailed:
	pq_drop_connection(conn, (0 != 0))
	conn.status = ConnStatusType.connection_bad
	return -1
}

@[markused]
pub fn pq_drain_pending(conn &PGconn) int {
	bytes_pending := isize(0)
	nread := isize(0)
	bytes_pending = pqsecure_bytes_pending(conn)
	if bytes_pending <= isize(0) {
		return int(bytes_pending)
	}
	if pq_check_in_buffer_space(usize(conn.inEnd) + usize(bytes_pending), conn) {
		return -1
	}
	nread = pqsecure_read(conn, voidptr(conn.inBuffer + conn.inEnd), usize(bytes_pending))
	if nread < isize(0) {
		return -1
	}
	conn.inEnd += nread
	if nread != bytes_pending {
		libpq_append_conn_error(conn, c'drained only %zd of %zd pending bytes in transport buffer', nread, bytes_pending)
		return -1
	}
	return 0
}

@[markused]
pub fn pq_send_some(conn &PGconn, len int) int {
	ptr := conn.outBuffer
	remaining := conn.outCount
	result := 0
	if conn.write_failed {
		conn.outCount = 0
		if conn.sock != (-1) {
			if pq_read_data(conn) < 0 {
				return -1
			}
		}
		return 0
	}
	if conn.sock == (-1) {
		conn.write_failed = (1 != 0)
		conn.write_err_msg = C.c2v_strdup(unsafe { &i8(&c'connection not open\n'[0]) })
		conn.outCount = 0
		return 0
	}
	for len > 0 {
		sent := 0
		sent = int(pqsecure_write(conn, voidptr(ptr), usize(len)))
		if sent < 0 {
			match (unsafe { *C.c2v___error() }) {
				35 {
				}
				4 {
					continue
				}
				else {
					conn.outCount = 0
					if conn.sock != (-1) {
						if pq_read_data(conn) < 0 {
							return -1
						}
					}
					if conn.write_failed {
						return 0
					} else {
						return -1
					}
				}
			}
		} else {
			c2v_pointer_prefix(voidptr(&ptr), ptr, isize(sent))
			len -= sent
			remaining -= sent
		}
		if len > 0 {
			if pq_read_data(conn) < 0 {
				result = -1
				break
			}
			if conn.nonblocking {
				result = 1
				break
			}
			if pq_wait(1, 1, conn) {
				result = -1
				break
			}
		}
	}
	if remaining > 0 {
		C.c2v_memmove(voidptr(conn.outBuffer), voidptr(ptr), u64(remaining))
	}
	conn.outCount = remaining
	return result
}

@[export: 'pqFlush']
@[markused]
pub fn pq_flush_vdup1(conn &PGconn) int {
	if conn.outCount > 0 {
		if conn.pfdebug {
			C.c2v_fflush(conn.pfdebug)
		}
		return pq_send_some(conn, conn.outCount)
	}
	return 0
}

@[export: 'pqWait']
@[markused]
pub fn pq_wait(for_read int, for_write int, conn &PGconn) int {
	return pq_wait_timed(for_read, for_write, conn, Pg_usec_time_t(-1))
}

@[export: 'pqWaitTimed']
@[markused]
pub fn pq_wait_timed(for_read int, for_write int, conn &PGconn, end_time Pg_usec_time_t) int {
	result := 0
	result = pq_socket_check(conn, for_read, for_write, end_time)
	if result < 0 {
		return -1
	}
	if result == 0 {
		libpq_append_conn_error(conn, c'timeout expired')
		return 1
	}
	return 0
}

@[export: 'pqReadReady']
@[markused]
pub fn pq_read_ready(conn &PGconn) int {
	return pq_socket_check(conn, 1, 0, Pg_usec_time_t(0))
}

@[export: 'pqWriteReady']
@[markused]
pub fn pq_write_ready(conn &PGconn) int {
	return pq_socket_check(conn, 0, 1, Pg_usec_time_t(0))
}

@[markused]
pub fn pq_socket_check(conn &PGconn, for_read int, for_write int, end_time Pg_usec_time_t) int {
	result := 0
	sock := Pgsocket(0)
	if isnil(conn) {
		return -1
	}
	if conn.altsock != (-1) {
		sock = conn.altsock
	} else {
		sock = conn.sock
		if sock == (-1) {
			libpq_append_conn_error(conn, c'invalid socket')
			return -1
		}
		if for_read && pqsecure_bytes_pending(conn) != isize(0) {
			return 1
		}
	}
	for {
		result = pq_socket_poll(sock, for_read, for_write, end_time)
		if !(result < 0 && (unsafe { *C.c2v___error() }) == 4) {
			break
		}
	}
	if result < 0 {
		sebuf := [256]i8{}
		libpq_append_conn_error(conn, c'%s() failed: %s', voidptr(c'select'), voidptr(pg_strerror_r((unsafe { *C.c2v___error() }), unsafe { &i8(&sebuf[0]) }, sizeof([256]i8))))
	}
	return result
}

@[export: 'PQsocketPoll']
@[markused]
pub fn pq_socket_poll(sock int, for_read int, for_write int, end_time Pg_usec_time_t) int {
	input_fd := C.pollfd{}
	timeout_ms := 0
	if !for_read && !for_write {
		return 0
	}
	input_fd.fd = sock
	input_fd.events = i16(8)
	input_fd.revents = i16(0)
	if for_read {
		input_fd.events |= 1
	}
	if for_write {
		input_fd.events |= 4
	}
	if end_time == Pg_usec_time_t(-1) {
		timeout_ms = -1
	} else if end_time == Pg_usec_time_t(0) {
		timeout_ms = 0
	} else {
		now := pq_get_current_time_us_ec()
		if end_time > now {
			timeout_ms = int((end_time - now) / Pg_usec_time_t(1000))
		} else {
			timeout_ms = 0
		}
	}
	return C.c2v_poll(&input_fd, u32(1), timeout_ms)
}

@[export: 'PQgetCurrentTimeUSec']
@[markused]
pub fn pq_get_current_time_us_ec() Pg_usec_time_t {
	tval := C.timeval{}
	C.c2v_gettimeofday(&tval, voidptr((voidptr(0))))
	return Pg_usec_time_t(tval.tv_sec) * Pg_usec_time_t(1000000) + Pg_usec_time_t(tval.tv_usec)
}

@[export: 'PQmblen']
@[markused]
pub fn pq_mblen(s &i8, encoding int) int {
	return pg_encoding_mblen(encoding, s)
}

@[export: 'PQmblenBounded']
@[markused]
pub fn pq_mblen_bounded(s &i8, encoding int) int {
	return int(C.c2v_strnlen(s, usize(pg_encoding_mblen(encoding, s))))
}

@[export: 'PQdsplen']
@[markused]
pub fn pq_dsplen(s &i8, encoding int) int {
	return pg_encoding_dsplen(encoding, s)
}

@[export: 'PQenv2encoding']
@[markused]
pub fn pq_env2encoding() int {
	str := &i8(0)
	encoding := int(Pg_enc.pg_sql_ascii)
	str = C.c2v_getenv(c'PGCLIENTENCODING')
	if !isnil(str) && int((unsafe { *str })) != i8(`\0`) {
		encoding = pg_char_to_encoding(str)
		if encoding < 0 {
			encoding = Pg_enc.pg_sql_ascii
		}
	}
	return encoding
}

@[c: 'libpq_append_error']
@[c2v_variadic; markused]
pub fn libpq_append_error(error_message PQExpBuffer, fmt &i8, ...) {
	save_errno := (unsafe { *C.c2v___error() })
	done := false
	args := C.va_list{}

	if (usize(voidptr(error_message)) == usize(voidptr((voidptr(0)))) || error_message.maxlen == usize(0)) {
		return
	}
	for {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = save_errno }
		}
		C.c2v_va_start(args, fmt)
		done = append_pq_exp_buffer_va(error_message, fmt, args)
		C.c2v_va_end(args)
		if !(!done) {
			break
		}
	}
	append_pq_exp_buffer_char(error_message, i8(`\n`))
}

@[c: 'libpq_append_conn_error']
@[c2v_variadic; markused]
pub fn libpq_append_conn_error(conn &PGconn, fmt &i8, ...) {
	save_errno := (unsafe { *C.c2v___error() })
	done := false
	args := C.va_list{}

	if (usize((&conn.errorMessage)) == usize((voidptr(0))) || conn.errorMessage.maxlen == usize(0)) {
		return
	}
	for {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = save_errno }
		}
		C.c2v_va_start(args, fmt)
		done = append_pq_exp_buffer_va(&conn.errorMessage, fmt, args)
		C.c2v_va_end(args)
		if !(!done) {
			break
		}
	}
	append_pq_exp_buffer_char(&conn.errorMessage, i8(`\n`))
}
