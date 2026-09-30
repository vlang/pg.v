@[translated]
module libpq

pub type PGcancelConn_fe_trace = Pg_cancel_conn

pub type PGcancel_fe_trace = Pg_cancel

@[markused]
pub fn libpq_fe_trace_is_unixsock_path(path &i8) bool {
	return (i32(path[false]) == i8(`/`)) || i32(path[false]) == i8(`@`)
}

@[export: 'PQtrace']
@[markused]
pub fn pq_trace(conn &PGconn, debug_port &C.FILE) {
	if usize(conn) == usize((voidptr(0))) {
		return
	}
	pq_untrace(conn)
	if usize(debug_port) == usize((voidptr(0))) {
		return
	}
	conn.pfdebug = debug_port
	conn.traceFlags = 0
}

@[export: 'PQuntrace']
@[markused]
pub fn pq_untrace(conn &PGconn) {
	if usize(conn) == usize((voidptr(0))) {
		return
	}
	if conn.pfdebug {
		C.c2v_fflush(conn.pfdebug)
		conn.pfdebug = (voidptr(0))
	}
	conn.traceFlags = 0
}

@[export: 'PQsetTraceFlags']
@[markused]
pub fn pq_set_trace_flags(conn &PGconn, flags i32) {
	if usize(conn) == usize((voidptr(0))) {
		return
	}
	if usize(conn.pfdebug) == usize((voidptr(0))) {
		return
	}
	conn.traceFlags = flags
}

@[markused]
pub fn pq_trace_format_timestamp(timestr &i8, ts_len usize) {
	tval := C.timeval{}
	now := i64(0)
	tmbuf := C.tm{}
	C.c2v_gettimeofday(&tval, voidptr((voidptr(0))))
	now = tval.tv_sec
	C.c2v_strftime(timestr, ts_len, c'%Y-%m-%d %H:%M:%S', C.c2v_localtime_r(&now, &tmbuf))
	pg_snprintf(timestr + C.c2v_strlen(timestr), ts_len - C.c2v_strlen(timestr), c'.%06u', u32(tval.tv_usec))
}

@[markused]
pub fn pq_trace_output_byte1(pfdebug &C.FILE, data &i8, cursor &i32) {
	v := data + (unsafe { *cursor })
	if !C.c2v_isprint(i32(u8((unsafe { *v })))) {
		pg_fprintf(pfdebug, c' \\x%02x', i32(u8((unsafe { *v }))))
	} else {
		pg_fprintf(pfdebug, c' %c', i32((unsafe { *v })))
	}
	unsafe { *cursor += 1 }
}

@[markused]
pub fn pq_trace_output_int16(pfdebug &C.FILE, data &i8, cursor &i32) i32 {
	tmp := Uint16(0)
	result := i32(0)
	C.c2v_memcpy(voidptr(&tmp), voidptr(data + (unsafe { *cursor })), u64(2))
	unsafe { *cursor += 2 }
	result = i32(c2v_builtin_bswap16(tmp))
	pg_fprintf(pfdebug, c' %d', result)
	return result
}

@[markused]
pub fn pq_trace_output_int32(pfdebug &C.FILE, data &i8, cursor &i32, suppress bool) i32 {
	result := i32(0)
	C.c2v_memcpy(voidptr(&result), voidptr(data + (unsafe { *cursor })), u64(4))
	unsafe { *cursor += 4 }
	result = i32(c2v_builtin_bswap32(u32(result)))
	if suppress {
		pg_fprintf(pfdebug, c' NNNN')
	} else {
		pg_fprintf(pfdebug, c' %d', result)
	}
	return result
}

@[markused]
pub fn pq_trace_output_string(pfdebug &C.FILE, data &i8, cursor &i32, suppress bool) {
	len := i32(0)
	if suppress {
		pg_fprintf(pfdebug, c' "SSSS"')
		unsafe { *cursor += C.c2v_strlen(data + *cursor) + u64(1) }
	} else {
		len = pg_fprintf(pfdebug, c' "%s"', voidptr(data + (unsafe { *cursor })))
		unsafe { *cursor += (len - 3 + 1) }
	}
}

@[markused]
pub fn pq_trace_output_nchar(pfdebug &C.FILE, len i32, data &i8, cursor &i32, suppress bool) {
	i := i32(0)
	next := i32(0)

	v := data + (unsafe { *cursor })
	if suppress {
		pg_fprintf(pfdebug, c" 'BBBB'")
		unsafe { *cursor += len }
		return
	}
	pg_fprintf(pfdebug, c" '")
	i = 0
	for next = 0; i < len; i++ {
		if C.c2v_isprint(i32(u8(v[i]))) {
			continue
		} else {
			C.c2v_fwrite(voidptr(v + next), u64(1), u64(i - next), pfdebug)
			pg_fprintf(pfdebug, c'\\x%02x', i32(u8(v[i])))
			next = i + 1
		}
	}
	if next < len {
		C.c2v_fwrite(voidptr(v + next), u64(1), u64(len - next), pfdebug)
	}
	pg_fprintf(pfdebug, c"'")
	unsafe { *cursor += len }
}

@[markused]
pub fn pq_trace_output_notification_response(f &C.FILE, message &i8, cursor &i32, regress bool) {
	pg_fprintf(f, c'NotificationResponse\t')
	pq_trace_output_int32(f, message, cursor, regress)
	pq_trace_output_string(f, message, cursor, (0 != 0))
	pq_trace_output_string(f, message, cursor, (0 != 0))
}

@[markused]
pub fn pq_trace_output_bind(f &C.FILE, message &i8, cursor &i32) {
	nparams := i32(0)
	pg_fprintf(f, c'Bind\t')
	pq_trace_output_string(f, message, cursor, (0 != 0))
	pq_trace_output_string(f, message, cursor, (0 != 0))
	nparams = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nparams; i++ {
		pq_trace_output_int16(f, message, cursor)
	}
	nparams = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nparams; i++ {
		nbytes := i32(0)
		nbytes = pq_trace_output_int32(f, message, cursor, (0 != 0))
		if nbytes == -1 {
			continue
		}
		pq_trace_output_nchar(f, nbytes, message, cursor, (0 != 0))
	}
	nparams = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nparams; i++ {
		pq_trace_output_int16(f, message, cursor)
	}
}

@[markused]
pub fn pq_trace_output_close(f &C.FILE, message &i8, cursor &i32) {
	pg_fprintf(f, c'Close\t')
	pq_trace_output_byte1(f, message, cursor)
	pq_trace_output_string(f, message, cursor, (0 != 0))
}

@[markused]
pub fn pq_trace_output_command_complete(f &C.FILE, message &i8, cursor &i32) {
	pg_fprintf(f, c'CommandComplete\t')
	pq_trace_output_string(f, message, cursor, (0 != 0))
}

@[markused]
pub fn pq_trace_output_copy_data(f &C.FILE, message &i8, cursor &i32, length i32, suppress bool) {
	pg_fprintf(f, c'CopyData\t')
	pq_trace_output_nchar(f, length - (unsafe { *cursor }) + 1, message, cursor, suppress)
}

@[markused]
pub fn pq_trace_output_data_row(f &C.FILE, message &i8, cursor &i32) {
	nfields := i32(0)
	len := i32(0)
	i := i32(0)
	pg_fprintf(f, c'DataRow\t')
	nfields = pq_trace_output_int16(f, message, cursor)
	for i = 0; i < nfields; i++ {
		len = pq_trace_output_int32(f, message, cursor, (0 != 0))
		if len == -1 {
			continue
		}
		pq_trace_output_nchar(f, len, message, cursor, (0 != 0))
	}
}

@[markused]
pub fn pq_trace_output_describe(f &C.FILE, message &i8, cursor &i32) {
	pg_fprintf(f, c'Describe\t')
	pq_trace_output_byte1(f, message, cursor)
	pq_trace_output_string(f, message, cursor, (0 != 0))
}

@[markused]
pub fn pq_trace_output_nr(f &C.FILE, type_ &i8, message &i8, cursor &i32, regress bool) {
	pg_fprintf(f, c'%s\t', voidptr(type_))
	for {
		field := i8(0)
		suppress := false
		pq_trace_output_byte1(f, message, cursor)
		field = message[(unsafe { *cursor }) - 1]
		if i32(field) == i8(`\0`) {
			break
		}
		suppress = (i32(regress) && (i32(field) == i8(`L`) || i32(field) == i8(`F`) || i32(field) == i8(`R`)))
		pq_trace_output_string(f, message, cursor, suppress)
	}
}

@[markused]
pub fn pq_trace_output_error_response(f &C.FILE, message &i8, cursor &i32, regress bool) {
	pq_trace_output_nr(f, c'ErrorResponse', message, cursor, regress)
}

@[markused]
pub fn pq_trace_output_notice_response(f &C.FILE, message &i8, cursor &i32, regress bool) {
	pq_trace_output_nr(f, c'NoticeResponse', message, cursor, regress)
}

@[markused]
pub fn pq_trace_output_execute(f &C.FILE, message &i8, cursor &i32, regress bool) {
	pg_fprintf(f, c'Execute\t')
	pq_trace_output_string(f, message, cursor, (0 != 0))
	pq_trace_output_int32(f, message, cursor, (0 != 0))
}

@[markused]
pub fn pq_trace_output_copy_fail(f &C.FILE, message &i8, cursor &i32) {
	pg_fprintf(f, c'CopyFail\t')
	pq_trace_output_string(f, message, cursor, (0 != 0))
}

@[markused]
pub fn pq_trace_output_gss_response(f &C.FILE, message &i8, cursor &i32, length i32, regress bool) {
	pg_fprintf(f, c'GSSResponse\t')
	pq_trace_output_nchar(f, length - (unsafe { *cursor }) + 1, message, cursor, regress)
}

@[markused]
pub fn pq_trace_output_password_message(f &C.FILE, message &i8, cursor &i32) {
	pg_fprintf(f, c'PasswordMessage\t')
	pq_trace_output_string(f, message, cursor, (0 != 0))
}

@[markused]
pub fn pq_trace_output_sasl_initial_response(f &C.FILE, message &i8, cursor &i32, regress bool) {
	initial_response := i32(0)
	pg_fprintf(f, c'SASLInitialResponse\t')
	pq_trace_output_string(f, message, cursor, (0 != 0))
	initial_response = pq_trace_output_int32(f, message, cursor, (0 != 0))
	if initial_response != -1 {
		pq_trace_output_nchar(f, initial_response, message, cursor, regress)
	}
}

@[markused]
pub fn pq_trace_output_sasl_response(f &C.FILE, message &i8, cursor &i32, length i32, regress bool) {
	pg_fprintf(f, c'SASLResponse\t')
	pq_trace_output_nchar(f, length - (unsafe { *cursor }) + 1, message, cursor, regress)
}

@[markused]
pub fn pq_trace_output_function_call(f &C.FILE, message &i8, cursor &i32, regress bool) {
	nfields := i32(0)
	nbytes := i32(0)
	pg_fprintf(f, c'FunctionCall\t')
	pq_trace_output_int32(f, message, cursor, regress)
	nfields = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nfields; i++ {
		pq_trace_output_int16(f, message, cursor)
	}
	nfields = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nfields; i++ {
		nbytes = pq_trace_output_int32(f, message, cursor, (0 != 0))
		if nbytes == -1 {
			continue
		}
		pq_trace_output_nchar(f, nbytes, message, cursor, (0 != 0))
	}
	pq_trace_output_int16(f, message, cursor)
}

@[markused]
pub fn pq_trace_output_copy_in_response(f &C.FILE, message &i8, cursor &i32) {
	nfields := i32(0)
	pg_fprintf(f, c'CopyInResponse\t')
	pq_trace_output_byte1(f, message, cursor)
	nfields = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nfields; i++ {
		pq_trace_output_int16(f, message, cursor)
	}
}

@[markused]
pub fn pq_trace_output_copy_out_response(f &C.FILE, message &i8, cursor &i32) {
	nfields := i32(0)
	pg_fprintf(f, c'CopyOutResponse\t')
	pq_trace_output_byte1(f, message, cursor)
	nfields = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nfields; i++ {
		pq_trace_output_int16(f, message, cursor)
	}
}

@[markused]
pub fn pq_trace_output_backend_key_data(f &C.FILE, message &i8, cursor &i32, length i32, regress bool) {
	pg_fprintf(f, c'BackendKeyData\t')
	pq_trace_output_int32(f, message, cursor, regress)
	pq_trace_output_nchar(f, length - (unsafe { *cursor }) + 1, message, cursor, regress)
}

@[markused]
pub fn pq_trace_output_parse(f &C.FILE, message &i8, cursor &i32, regress bool) {
	nparams := i32(0)
	pg_fprintf(f, c'Parse\t')
	pq_trace_output_string(f, message, cursor, (0 != 0))
	pq_trace_output_string(f, message, cursor, (0 != 0))
	nparams = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nparams; i++ {
		pq_trace_output_int32(f, message, cursor, regress)
	}
}

@[markused]
pub fn pq_trace_output_query(f &C.FILE, message &i8, cursor &i32) {
	pg_fprintf(f, c'Query\t')
	pq_trace_output_string(f, message, cursor, (0 != 0))
}

@[markused]
pub fn pq_trace_output_authentication(f &C.FILE, message &i8, cursor &i32, length i32, suppress bool) {
	auth_type := i32(0)
	C.c2v_memcpy(voidptr(&auth_type), voidptr(message + (unsafe { *cursor })), u64(4))
	auth_type = i32(c2v_builtin_bswap32(u32(auth_type)))
	unsafe { *cursor += 4 }
	match auth_type {
		0 {
			pg_fprintf(f, c'AuthenticationOk')
		}
		3 {
			pg_fprintf(f, c'AuthenticationCleartextPassword')
		}
		5 {
			pg_fprintf(f, c'AuthenticationMD5Password')
		}
		7 {
			pg_fprintf(f, c'AuthenticationGSS')
		}
		8 {
			pg_fprintf(f, c'AuthenticationGSSContinue\t')
			pq_trace_output_nchar(f, length - (unsafe { *cursor }) + 1, message, cursor, suppress)
		}
		9 {
			pg_fprintf(f, c'AuthenticationSSPI')
		}
		10 {
			pg_fprintf(f, c'AuthenticationSASL\t')
			for i32(message[(unsafe { *cursor })]) != i8(`\0`) {
				pq_trace_output_string(f, message, cursor, (0 != 0))
			}
			pq_trace_output_string(f, message, cursor, (0 != 0))
		}
		11 {
			pg_fprintf(f, c'AuthenticationSASLContinue\t')
			pq_trace_output_nchar(f, length - (unsafe { *cursor }) + 1, message, cursor, suppress)
		}
		12 {
			pg_fprintf(f, c'AuthenticationSASLFinal\t')
			pq_trace_output_nchar(f, length - (unsafe { *cursor }) + 1, message, cursor, suppress)
		}
		else {
			pg_fprintf(f, c'Unknown authentication message %d', auth_type)
		}
	}
}

@[markused]
pub fn pq_trace_output_parameter_status(f &C.FILE, message &i8, cursor &i32) {
	pg_fprintf(f, c'ParameterStatus\t')
	pq_trace_output_string(f, message, cursor, (0 != 0))
	pq_trace_output_string(f, message, cursor, (0 != 0))
}

@[markused]
pub fn pq_trace_output_parameter_description(f &C.FILE, message &i8, cursor &i32, regress bool) {
	nfields := i32(0)
	pg_fprintf(f, c'ParameterDescription\t')
	nfields = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nfields; i++ {
		pq_trace_output_int32(f, message, cursor, regress)
	}
}

@[markused]
pub fn pq_trace_output_row_description(f &C.FILE, message &i8, cursor &i32, regress bool) {
	nfields := i32(0)
	pg_fprintf(f, c'RowDescription\t')
	nfields = pq_trace_output_int16(f, message, cursor)
	for i := i32(0); i < nfields; i++ {
		pq_trace_output_string(f, message, cursor, (0 != 0))
		pq_trace_output_int32(f, message, cursor, regress)
		pq_trace_output_int16(f, message, cursor)
		pq_trace_output_int32(f, message, cursor, regress)
		pq_trace_output_int16(f, message, cursor)
		pq_trace_output_int32(f, message, cursor, (0 != 0))
		pq_trace_output_int16(f, message, cursor)
	}
}

@[markused]
pub fn pq_trace_output_negotiate_protocol_version(f &C.FILE, message &i8, cursor &i32) {
	nparams := i32(0)
	pg_fprintf(f, c'NegotiateProtocolVersion\t')
	pq_trace_output_int32(f, message, cursor, (0 != 0))
	nparams = pq_trace_output_int32(f, message, cursor, (0 != 0))
	for i := i32(0); i < nparams; i++ {
		pq_trace_output_string(f, message, cursor, (0 != 0))
	}
}

@[markused]
pub fn pq_trace_output_function_call_response(f &C.FILE, message &i8, cursor &i32) {
	len := i32(0)
	pg_fprintf(f, c'FunctionCallResponse\t')
	len = pq_trace_output_int32(f, message, cursor, (0 != 0))
	if len != -1 {
		pq_trace_output_nchar(f, len, message, cursor, (0 != 0))
	}
}

@[markused]
pub fn pq_trace_output_copy_both_response(f &C.FILE, message &i8, cursor &i32, length i32) {
	pg_fprintf(f, c'CopyBothResponse\t')
	pq_trace_output_byte1(f, message, cursor)
	for length > (unsafe { *cursor }) {
		pq_trace_output_int16(f, message, cursor)
	}
}

@[markused]
pub fn pq_trace_output_ready_for_query(f &C.FILE, message &i8, cursor &i32) {
	pg_fprintf(f, c'ReadyForQuery\t')
	pq_trace_output_byte1(f, message, cursor)
}

@[export: 'pqTraceOutputMessage']
@[markused]
pub fn pq_trace_output_message(conn &PGconn, message &i8, to_server bool) {
	id := i8(0)
	length := i32(0)
	prefix := if i32(to_server) { c'F' } else { c'B' }
	log_cursor := i32(0)
	regress := false
	if (conn.traceFlags & (1 << 0)) == 0 {
		timestr := [128]i8{}
		pq_trace_format_timestamp(unsafe { &i8(&timestr[0]) }, sizeof([128]i8))
		pg_fprintf(conn.pfdebug, c'%s\t', unsafe { voidptr(&timestr[0]) })
	}
	regress = ((conn.traceFlags & (1 << 1)) != 0)
	id = message[log_cursor++]
	C.c2v_memcpy(voidptr(&length), voidptr(message + log_cursor), u64(4))
	length = i32(c2v_builtin_bswap32(u32(length)))
	log_cursor += 4
	if i32(regress) && !to_server && (i32(id) == i8(`E`) || i32(id) == i8(`N`)) {
		pg_fprintf(conn.pfdebug, c'%s\tNN\t', voidptr(prefix))
	} else {
		pg_fprintf(conn.pfdebug, c'%s\t%d\t', voidptr(prefix), length)
	}
	match i32(id) {
		i32(`1`) {
			pg_fprintf(conn.pfdebug, c'ParseComplete')
		}
		i32(`2`) {
			pg_fprintf(conn.pfdebug, c'BindComplete')
		}
		i32(`3`) {
			pg_fprintf(conn.pfdebug, c'CloseComplete')
		}
		i32(`A`) {
			pq_trace_output_notification_response(conn.pfdebug, message, &log_cursor, regress)
		}
		i32(`B`) {
			pq_trace_output_bind(conn.pfdebug, message, &log_cursor)
		}
		i32(`c`) {
			pg_fprintf(conn.pfdebug, c'CopyDone')
		}
		i32(`C`) {
			if to_server {
				pq_trace_output_close(conn.pfdebug, message, &log_cursor)
			} else {
				pq_trace_output_command_complete(conn.pfdebug, message, &log_cursor)
			}
		}
		i32(`d`) {
			pq_trace_output_copy_data(conn.pfdebug, message, &log_cursor, length, regress)
		}
		i32(`D`) {
			if to_server {
				pq_trace_output_describe(conn.pfdebug, message, &log_cursor)
			} else {
				pq_trace_output_data_row(conn.pfdebug, message, &log_cursor)
			}
		}
		i32(`E`) {
			if to_server {
				pq_trace_output_execute(conn.pfdebug, message, &log_cursor, regress)
			} else {
				pq_trace_output_error_response(conn.pfdebug, message, &log_cursor, regress)
			}
		}
		i32(`f`) {
			pq_trace_output_copy_fail(conn.pfdebug, message, &log_cursor)
		}
		i32(`p`) {
			match i32(conn.current_auth_response) {
				i32(`G`) {
					pq_trace_output_gss_response(conn.pfdebug, message, &log_cursor, length, regress)
				}
				i32(`P`) {
					pq_trace_output_password_message(conn.pfdebug, message, &log_cursor)
				}
				i32(`I`) {
					pq_trace_output_sasl_initial_response(conn.pfdebug, message, &log_cursor, regress)
				}
				i32(`S`) {
					pq_trace_output_sasl_response(conn.pfdebug, message, &log_cursor, length, regress)
				}
				else {
					pg_fprintf(conn.pfdebug, c'UnknownAuthenticationResponse')
				}
			}
			conn.current_auth_response = i8(`\0`)
		}
		i32(`F`) {
			pq_trace_output_function_call(conn.pfdebug, message, &log_cursor, regress)
		}
		i32(`G`) {
			pq_trace_output_copy_in_response(conn.pfdebug, message, &log_cursor)
		}
		i32(`H`) {
			if to_server {
				pg_fprintf(conn.pfdebug, c'Flush')
			} else {
				pq_trace_output_copy_out_response(conn.pfdebug, message, &log_cursor)
			}
		}
		i32(`I`) {
			pg_fprintf(conn.pfdebug, c'EmptyQueryResponse')
		}
		i32(`K`) {
			pq_trace_output_backend_key_data(conn.pfdebug, message, &log_cursor, length, regress)
		}
		i32(`n`) {
			pg_fprintf(conn.pfdebug, c'NoData')
		}
		i32(`N`) {
			pq_trace_output_notice_response(conn.pfdebug, message, &log_cursor, regress)
		}
		i32(`P`) {
			pq_trace_output_parse(conn.pfdebug, message, &log_cursor, regress)
		}
		i32(`Q`) {
			pq_trace_output_query(conn.pfdebug, message, &log_cursor)
		}
		i32(`R`) {
			pq_trace_output_authentication(conn.pfdebug, message, &log_cursor, length, regress)
		}
		i32(`s`) {
			pg_fprintf(conn.pfdebug, c'PortalSuspended')
		}
		i32(`S`) {
			if to_server {
				pg_fprintf(conn.pfdebug, c'Sync')
			} else {
				pq_trace_output_parameter_status(conn.pfdebug, message, &log_cursor)
			}
		}
		i32(`t`) {
			pq_trace_output_parameter_description(conn.pfdebug, message, &log_cursor, regress)
		}
		i32(`T`) {
			pq_trace_output_row_description(conn.pfdebug, message, &log_cursor, regress)
		}
		i32(`v`) {
			pq_trace_output_negotiate_protocol_version(conn.pfdebug, message, &log_cursor)
		}
		i32(`V`) {
			pq_trace_output_function_call_response(conn.pfdebug, message, &log_cursor)
		}
		i32(`W`) {
			pq_trace_output_copy_both_response(conn.pfdebug, message, &log_cursor, length)
		}
		i32(`X`) {
			pg_fprintf(conn.pfdebug, c'Terminate')
		}
		i32(`Z`) {
			pq_trace_output_ready_for_query(conn.pfdebug, message, &log_cursor)
		}
		else {
			pg_fprintf(conn.pfdebug, c'Unknown message: %02x', i32(id))
		}
	}

	C.c2v_fputc(`\n`, conn.pfdebug)
	if log_cursor - 1 != length {
		pg_fprintf(conn.pfdebug, c'mismatched message length: consumed %d, expected %d\n', log_cursor - 1, length)
	}
}

@[export: 'pqTraceOutputNoTypeByteMessage']
@[markused]
pub fn pq_trace_output_no_type_byte_message(conn &PGconn, message &i8) {
	length := i32(0)
	version := i32(0)
	regress := false
	log_cursor := i32(0)
	regress = ((conn.traceFlags & (1 << 1)) != 0)
	if (conn.traceFlags & (1 << 0)) == 0 {
		timestr := [128]i8{}
		pq_trace_format_timestamp(unsafe { &i8(&timestr[0]) }, sizeof([128]i8))
		pg_fprintf(conn.pfdebug, c'%s\t', unsafe { voidptr(&timestr[0]) })
	}
	C.c2v_memcpy(voidptr(&length), voidptr(message + log_cursor), u64(4))
	length = i32(c2v_builtin_bswap32(u32(length)))
	log_cursor += 4
	pg_fprintf(conn.pfdebug, c'F\t%d\t', length)
	if length < 8 {
		pg_fprintf(conn.pfdebug, c'Unknown message\n')
		return
	}
	C.c2v_memcpy(voidptr(&version), voidptr(message + log_cursor), u64(4))
	version = i32(c2v_builtin_bswap32(u32(version)))
	if version == ((1234 << 16) | 5678) && length >= 16 {
		pg_fprintf(conn.pfdebug, c'CancelRequest\t')
		pq_trace_output_int16(conn.pfdebug, message, &log_cursor)
		pq_trace_output_int16(conn.pfdebug, message, &log_cursor)
		pq_trace_output_int32(conn.pfdebug, message, &log_cursor, regress)
		pq_trace_output_nchar(conn.pfdebug, length - log_cursor, message, &log_cursor, regress)
	} else if version == ((1234 << 16) | 5679) {
		pg_fprintf(conn.pfdebug, c'SSLRequest\t')
		pq_trace_output_int16(conn.pfdebug, message, &log_cursor)
		pq_trace_output_int16(conn.pfdebug, message, &log_cursor)
	} else if version == ((1234 << 16) | 5680) {
		pg_fprintf(conn.pfdebug, c'GSSENCRequest\t')
		pq_trace_output_int16(conn.pfdebug, message, &log_cursor)
		pq_trace_output_int16(conn.pfdebug, message, &log_cursor)
	} else {
		pg_fprintf(conn.pfdebug, c'StartupMessage\t')
		pq_trace_output_int16(conn.pfdebug, message, &log_cursor)
		pq_trace_output_int16(conn.pfdebug, message, &log_cursor)
		for i32(message[log_cursor]) != i8(`\0`) {
			pq_trace_output_string(conn.pfdebug, message, &log_cursor, (0 != 0))
			pq_trace_output_string(conn.pfdebug, message, &log_cursor, (0 != 0))
		}
	}
	C.c2v_fputc(`\n`, conn.pfdebug)
}

@[export: 'pqTraceOutputCharResponse']
@[markused]
pub fn pq_trace_output_char_response(conn &PGconn, response_type &i8, response i8) {
	if (conn.traceFlags & (1 << 0)) == 0 {
		timestr := [128]i8{}
		pq_trace_format_timestamp(unsafe { &i8(&timestr[0]) }, sizeof([128]i8))
		pg_fprintf(conn.pfdebug, c'%s\t', unsafe { voidptr(&timestr[0]) })
	}
	pg_fprintf(conn.pfdebug, c'B\t1\t%s\t %c\n', voidptr(response_type), i32(response))
}
