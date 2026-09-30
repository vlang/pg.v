@[translated]
module libpq

@[markused]
pub fn libpq_fe_auth_is_unixsock_path(path &i8) bool {
	return (int(path[false]) == i8(`/`)) || int(path[false]) == i8(`@`)
}

@[markused]
pub fn pg_sasl_init(conn &PGconn, payloadlen int, async &bool) int {
	initialresponse := unsafe { &i8(nil) }
	initialresponselen := 0
	selected_mechanism := &i8(0)
	mechanism_buf := PQExpBufferData{}
	password := unsafe { &i8(nil) }
	status := SASLStatus{}
	init_pq_exp_buffer(&mechanism_buf)
	if int(conn.channel_binding[0]) == i8(`r`) && !conn.ssl_in_use {
		libpq_append_conn_error(conn, c'channel binding required, but SSL not in use')
		unsafe {
			goto error
		}
	}
	if !isnil(conn.sasl_state) && isnil(conn.async_auth) {
		libpq_append_conn_error(conn, c'duplicate SASL authentication request')
		unsafe {
			goto error
		}
	}
	selected_mechanism = (voidptr(0))
	for {
		if pq_gets(&mechanism_buf, conn) {
			append_pq_exp_buffer_str(&conn.errorMessage, c'fe_sendauth: invalid authentication request from server: invalid list of authentication mechanisms\n')
			unsafe {
				goto error
			}
		}
		if (mechanism_buf.maxlen == usize(0)) {
			unsafe {
				goto oom_error
			}
		}
		if int(mechanism_buf.data[0]) == i8(`\0`) {
			break
		}
		if C.c2v_strcmp(mechanism_buf.data, c'SCRAM-SHA-256-PLUS') == 0 {
			if conn.ssl_in_use {
				if int(conn.channel_binding[0]) == i8(`r`) {
					libpq_append_conn_error(conn, c'channel binding is required, but client does not support it')
					unsafe {
						goto error
					}
				}
			} else {
				libpq_append_conn_error(conn, c'server offered SCRAM-SHA-256-PLUS authentication over a non-SSL connection')
				unsafe {
					goto error
				}
			}
		} else if C.c2v_strcmp(mechanism_buf.data, c'SCRAM-SHA-256') == 0 && isnil(selected_mechanism) {
			selected_mechanism = c'SCRAM-SHA-256'
			conn.sasl = &pg_scram_mech
			conn.password_needed = (1 != 0)
		} else if C.c2v_strcmp(mechanism_buf.data, c'OAUTHBEARER') == 0 && isnil(selected_mechanism) {
			selected_mechanism = c'OAUTHBEARER'
			conn.sasl = &pg_oauth_mech
			conn.password_needed = (0 != 0)
		}
	}
	if isnil(selected_mechanism) {
		libpq_append_conn_error(conn, c"none of the server's SASL authentication mechanisms are supported")
		unsafe {
			goto error
		}
	}
	if conn.require_auth {
		allowed := (0 != 0)
		for i := 0; u64(i) < 2; i++ {
			if usize(conn.sasl) == usize(conn.allowed_sasl_mechs[i]) {
				allowed = (1 != 0)
				break
			}
		}
		if !allowed {
			libpq_append_conn_error(conn, c'authentication method requirement "%s" failed: server requested %s authentication', voidptr(conn.require_auth), voidptr(selected_mechanism))
			unsafe {
				goto error
			}
		}
	}
	if int(conn.channel_binding[0]) == i8(`r`) && C.c2v_strcmp(selected_mechanism, c'SCRAM-SHA-256-PLUS') != 0 {
		libpq_append_conn_error(conn, c'channel binding is required, but server did not offer an authentication method that supports channel binding')
		unsafe {
			goto error
		}
	}
	if int(conn.password_needed) && isnil(conn.scram_client_key_binary) {
		password = conn.connhost[conn.whichhost].password
		if usize(password) == usize((voidptr(0))) {
			password = conn.pgpass
		}
		if usize(password) == usize((voidptr(0))) || int(password[0]) == i8(`\0`) {
			append_pq_exp_buffer_str(&conn.errorMessage, c'fe_sendauth: no password supplied\n')
			unsafe {
				goto error
			}
		}
	}
	if conn.pfdebug {
		pq_trace_output_message(conn, conn.inBuffer + conn.inStart, (0 != 0))
	}

	if isnil(conn.sasl_state) {
		conn.sasl_state = conn.sasl.init(conn, password, selected_mechanism)
		if isnil(conn.sasl_state) {
			unsafe {
				goto oom_error
			}
		}
	} else {
		conn.async_auth = (voidptr(0))
	}
	status = conn.sasl.exchange(voidptr(conn.sasl_state), (0 != 0), (voidptr(0)), -1, &&u8(&&i8(c2v_address_of(&initialresponse))), &initialresponselen)
	if u32(status) == u32(SASLStatus.sasl_failed) {
		unsafe {
			goto error
		}
	}
	if u32(status) == u32(SASLStatus.sasl_async) {
		unsafe { *async = (1 != 0) }
		return 0
	}
	if pq_put_msg_start(i8(`p`), conn) {
		unsafe {
			goto error
		}
	}
	if pq_puts(selected_mechanism, conn) {
		unsafe {
			goto error
		}
	}
	if initialresponse {
		if pq_put_int(initialresponselen, usize(4), conn) {
			unsafe {
				goto error
			}
		}
		if pq_putnchar(voidptr(initialresponse), usize(initialresponselen), conn) {
			unsafe {
				goto error
			}
		}
	}
	conn.current_auth_response = i8(`I`)
	if pq_put_msg_end(conn) {
		unsafe {
			goto error
		}
	}
	if pq_flush_vdup1(conn) {
		unsafe {
			goto error
		}
	}
	term_pq_exp_buffer(&mechanism_buf)
	C.c2v_free(voidptr(initialresponse))
	return 0
	error:
	term_pq_exp_buffer(&mechanism_buf)
	C.c2v_free(voidptr(initialresponse))
	return -1
	oom_error:
	term_pq_exp_buffer(&mechanism_buf)
	C.c2v_free(voidptr(initialresponse))
	libpq_append_conn_error(conn, c'out of memory')
	return -1
}

@[markused]
pub fn pg_sasl_continue(conn &PGconn, payloadlen int, final bool, async &bool) int {
	output := &i8(0)
	outputlen := 0
	res := 0
	challenge := &i8(0)
	status := SASLStatus{}
	challenge = &i8(C.c2v_malloc(u64(payloadlen + 1)))
	if isnil(challenge) {
		libpq_append_conn_error(conn, c'out of memory allocating SASL buffer (%d)', payloadlen)
		return -1
	}
	if pq_getnchar(voidptr(challenge), usize(payloadlen), conn) {
		C.c2v_free(voidptr(challenge))
		return -1
	}
	if conn.pfdebug {
		pq_trace_output_message(conn, conn.inBuffer + conn.inStart, (0 != 0))
	}
	challenge[payloadlen] = i8(`\0`)
	status = conn.sasl.exchange(voidptr(conn.sasl_state), final, challenge, payloadlen, &&u8(&&i8(c2v_address_of(&output))), &outputlen)
	C.c2v_free(voidptr(challenge))
	if u32(status) == u32(SASLStatus.sasl_async) {
		unsafe { *async = (1 != 0) }
	}
	if int(final) && u32(status) == u32(SASLStatus.sasl_continue) {
		if outputlen != 0 {
			C.c2v_free(voidptr(output))
		}
		libpq_append_conn_error(conn, c'AuthenticationSASLFinal received from server, but SASL authentication was not completed')
		return -1
	}
	if usize(output) == usize((voidptr(0))) && u32(status) == u32(SASLStatus.sasl_continue) {
		libpq_append_conn_error(conn, c'no client response found after SASL exchange success')
		return -1
	}
	if output {
		conn.current_auth_response = i8(`S`)
		res = pq_packet_send(conn, i8(`p`), voidptr(output), usize(outputlen))
		C.c2v_free(voidptr(output))
		if res != 0 {
			return -1
		}
	}
	if u32(status) == u32(SASLStatus.sasl_failed) {
		return -1
	}
	return 0
}

@[markused]
pub fn pg_password_sendauth(conn &PGconn, password &i8, areq AuthRequest) int {
	ret := 0
	crypt_pwd := unsafe { &i8(nil) }
	pwd_to_send := &i8(0)
	md5_salt := [4]Uint8{}
	if areq == AuthRequest(5) {
		if pq_getnchar(voidptr(unsafe { &md5_salt[0] }), usize(4), conn) {
			return -1
		}
	}
	if conn.pfdebug {
		pq_trace_output_message(conn, conn.inBuffer + conn.inStart, (0 != 0))
	}
	match areq {
		5 {
			crypt_pwd2 := &i8(0)
			errstr := unsafe { &i8(nil) }
			crypt_pwd = &i8(C.c2v_malloc(u64(2 * (35 + 1))))
			if isnil(crypt_pwd) {
				libpq_append_conn_error(conn, c'out of memory')
				return -1
			}
			crypt_pwd2 = crypt_pwd + 35 + 1
			if !pg_md5_encrypt(password, &Uint8(voidptr(conn.pguser)), C.c2v_strlen(conn.pguser), crypt_pwd2, &&u8(&&i8(c2v_address_of(&errstr)))) {
				libpq_append_conn_error(conn, c'could not encrypt password: %s', voidptr(errstr))
				C.c2v_free(voidptr(crypt_pwd))
				return -1
			}
			if !pg_md5_encrypt(crypt_pwd2 + C.c2v_strlen(c'md5'), unsafe { &md5_salt[0] }, usize(4), crypt_pwd, &&u8(&&i8(c2v_address_of(&errstr)))) {
				libpq_append_conn_error(conn, c'could not encrypt password: %s', voidptr(errstr))
				C.c2v_free(voidptr(crypt_pwd))
				return -1
			}
			pwd_to_send = crypt_pwd
		}
		3 {
			pwd_to_send = password
		}
		else {
			return -1
		}
	}

	conn.current_auth_response = i8(`P`)
	ret = pq_packet_send(conn, i8(`p`), voidptr(pwd_to_send), C.c2v_strlen(pwd_to_send) + u64(1))
	C.c2v_free(voidptr(crypt_pwd))
	return ret
}

@[markused]
pub fn auth_method_description(areq AuthRequest) &i8 {
	match areq {
		3 {
			return unsafe { &i8(&c'server requested a cleartext password'[0]) }
		}
		5 {
			return unsafe { &i8(&c'server requested a hashed password'[0]) }
		}
		7, 8 {
			return unsafe { &i8(&c'server requested GSSAPI authentication'[0]) }
		}
		9 {
			return unsafe { &i8(&c'server requested SSPI authentication'[0]) }
		}
		10, 11, 12 {
			return unsafe { &i8(&c'server requested SASL authentication'[0]) }
		}
		else {}
	}

	return unsafe { &i8(&c'server requested an unknown authentication type'[0]) }
}

@[markused]
pub fn check_expected_areq(areq AuthRequest, conn &PGconn) bool {
	result := (1 != 0)
	reason := unsafe { &i8(nil) }

	if int(conn.sslcertmode[0]) == i8(`r`) && areq == AuthRequest(0) {
		if !conn.ssl_cert_requested {
			libpq_append_conn_error(conn, c'server did not request an SSL certificate')
			return false != 0
		} else if !conn.ssl_cert_sent {
			libpq_append_conn_error(conn, c'server accepted connection without a valid SSL certificate')
			return false != 0
		}
	}
	if conn.require_auth {
		match areq {
			0 {
				if !conn.auth_required || int(conn.client_finished_auth) {
					unsafe {
						goto c2v_switch_end_8
					}
				}
				reason = unsafe { &c'server did not complete authentication'[0] }
				result = (0 != 0)
			}
			3, 5, 7, 8, 9, 10, 11, 12 {
				result = (((conn.allowed_auth_methods & Uint32((1 << u32(areq)))) != Uint32(0)) != 0)
			}
			else {
				result = (0 != 0)
			}
		}
		c2v_switch_end_8:
	}
	if !result {
		if isnil(reason) {
			reason = auth_method_description(areq)
		}
		libpq_append_conn_error(conn, c'authentication method requirement "%s" failed: %s', voidptr(conn.require_auth), voidptr(reason))
		return result
	}
	if int(conn.channel_binding[0]) == i8(`r`) {
		match areq {
			10, 11, 12 {
			}
			0 {
				if isnil(conn.sasl) || !conn.sasl.channel_bound(voidptr(conn.sasl_state)) {
					libpq_append_conn_error(conn, c'channel binding required, but server authenticated client without channel binding')
					result = (0 != 0)
				}
			}
			else {
				libpq_append_conn_error(conn, c"channel binding required but not supported by server's authentication request")
				result = (0 != 0)
			}
		}
	}
	return result
}

@[export: 'pg_fe_sendauth']
@[markused]
pub fn pg_fe_sendauth(areq AuthRequest, payloadlen int, conn &PGconn, async &bool) int {
	oldmsglen := 0
	unsafe { *async = (0 != 0) }
	if !check_expected_areq(areq, conn) {
		return -1
	}
	match areq {
		0 {
		}
		1 {
			libpq_append_conn_error(conn, c'Kerberos 4 authentication not supported')
			return -1
		}
		2 {
			libpq_append_conn_error(conn, c'Kerberos 5 authentication not supported')
			return -1
		}
		7, 8 {
			libpq_append_conn_error(conn, c'GSSAPI authentication not supported')
			return -1
		}
		9 {
			libpq_append_conn_error(conn, c'SSPI authentication not supported')
			return -1
		}
		4 {
			libpq_append_conn_error(conn, c'Crypt authentication not supported')
			return -1
		}
		5, 3 {
			password := &i8(0)
			conn.password_needed = (1 != 0)
			password = conn.connhost[conn.whichhost].password
			if usize(password) == usize((voidptr(0))) {
				password = conn.pgpass
			}
			if usize(password) == usize((voidptr(0))) || int(password[0]) == i8(`\0`) {
				append_pq_exp_buffer_str(&conn.errorMessage, c'fe_sendauth: no password supplied\n')
				return -1
			}
			if pg_password_sendauth(conn, password, areq) != 0 {
				append_pq_exp_buffer_str(&conn.errorMessage, c'fe_sendauth: error sending password authentication\n')
				return -1
			}
			conn.client_finished_auth = (1 != 0)
		}
		10 {
			if pg_sasl_init(conn, payloadlen, async) != 0 {
				return -1
			}
		}
		11, 12 {
			final := (0 != 0)
			if usize(conn.sasl_state) == usize((voidptr(0))) {
				append_pq_exp_buffer_str(&conn.errorMessage, c'fe_sendauth: invalid authentication request from server: AUTH_REQ_SASL_CONT without AUTH_REQ_SASL\n')
				return -1
			}
			oldmsglen = int(conn.errorMessage.len)
			if areq == AuthRequest(12) {
				final = (1 != 0)
			}
			if pg_sasl_continue(conn, payloadlen, final, async) != 0 {
				if conn.errorMessage.len == usize(oldmsglen) {
					append_pq_exp_buffer_str(&conn.errorMessage, c'fe_sendauth: error in SASL authentication\n')
				}
				return -1
			}
		}
		else {
			libpq_append_conn_error(conn, c'authentication method %u not supported', areq)
			return -1
		}
	}

	return 0
}

@[export: 'pg_fe_getusername']
@[markused]
pub fn pg_fe_getusername(user_id u32, error_message PQExpBuffer) &i8 {
	result := unsafe { &i8(nil) }
	name := unsafe { &i8(nil) }
	pwbuf := C.passwd{}
	pw := unsafe { &C.passwd(nil) }
	buf := [1024]i8{}
	rc := 0
	rc = C.c2v_getpwuid_r(user_id, &pwbuf, unsafe { &i8(&buf[0]) }, sizeof([1024]i8), &&C.passwd(&&C.passwd(c2v_address_of(&pw))))
	if rc != 0 {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = rc }
		}
		if error_message {
			libpq_append_error(error_message, c'could not look up local user ID %ld: %m', i64(user_id))
		}
	} else if isnil(pw) {
		if error_message {
			libpq_append_error(error_message, c'local user with ID %ld does not exist', i64(user_id))
		}
	} else {
		name = pw.pw_name
	}
	if name {
		result = C.c2v_strdup(name)
		if usize(result) == usize((voidptr(0))) && !isnil(error_message) {
			libpq_append_error(error_message, c'out of memory')
		}
	}
	return result
}

@[export: 'pg_fe_getauthname']
@[markused]
pub fn pg_fe_getauthname(error_message PQExpBuffer) &i8 {
	return pg_fe_getusername(C.c2v_geteuid(), error_message)
}

@[export: 'PQencryptPassword']
@[markused]
pub fn pq_encrypt_password(passwd &i8, user &i8) &i8 {
	crypt_pwd := &i8(0)
	errstr := unsafe { &i8(nil) }
	crypt_pwd = &i8(C.c2v_malloc(u64(35 + 1)))
	if isnil(crypt_pwd) {
		return unsafe { nil }
	}
	if !pg_md5_encrypt(passwd, &Uint8(voidptr(user)), C.c2v_strlen(user), crypt_pwd, &&u8(&&i8(c2v_address_of(&errstr)))) {
		C.c2v_free(voidptr(crypt_pwd))
		return unsafe { nil }
	}
	return crypt_pwd
}

@[export: 'PQencryptPasswordConn']
@[markused]
pub fn pq_encrypt_password_conn(conn &PGconn, passwd &i8, user &i8, algorithm &i8) &i8 {
	algobuf := [51]i8{}
	crypt_pwd := unsafe { &i8(nil) }
	if isnil(conn) {
		return unsafe { nil }
	}
	reset_pq_exp_buffer(&conn.errorMessage)
	conn.errorReported = 0
	if usize(algorithm) == usize((voidptr(0))) {
		res := &PGresult(0)
		val := &i8(0)
		res = pq_exec(conn, c'show password_encryption')
		if usize(res) == usize((voidptr(0))) {
			return unsafe { nil }
		}
		if u32(pq_result_status(res)) != u32(ExecStatusType.pgres_tuples_ok) {
			pq_clear(res)
			return unsafe { nil }
		}
		if pq_ntuples(res) != 1 || pq_nfields(res) != 1 {
			pq_clear(res)
			libpq_append_conn_error(conn, c'unexpected shape of result set returned for SHOW')
			return unsafe { nil }
		}
		val = pq_getvalue(res, 0, 0)
		if C.c2v_strlen(val) > u64(50) {
			pq_clear(res)
			libpq_append_conn_error(conn, c'"password_encryption" value too long')
			return unsafe { nil }
		}
		C.c2v_strcpy(unsafe { &i8(&algobuf[0]) }, val)
		pq_clear(res)
		algorithm = unsafe { &algobuf[0] }
	}
	if C.c2v_strcmp(algorithm, c'on') == 0 || C.c2v_strcmp(algorithm, c'off') == 0 {
		algorithm = c'md5'
	}
	if C.c2v_strcmp(algorithm, c'scram-sha-256') == 0 {
		errstr := unsafe { &i8(nil) }
		crypt_pwd = pg_fe_scram_build_secret(passwd, conn.scram_sha_256_iterations, &&u8(&&i8(c2v_address_of(&errstr))))
		if isnil(crypt_pwd) {
			libpq_append_conn_error(conn, c'could not encrypt password: %s', voidptr(errstr))
		}
	} else if C.c2v_strcmp(algorithm, c'md5') == 0 {
		crypt_pwd = &i8(C.c2v_malloc(u64(35 + 1)))
		if crypt_pwd {
			errstr := unsafe { &i8(nil) }
			if !pg_md5_encrypt(passwd, &Uint8(voidptr(user)), C.c2v_strlen(user), crypt_pwd, &&u8(&&i8(c2v_address_of(&errstr)))) {
				libpq_append_conn_error(conn, c'could not encrypt password: %s', voidptr(errstr))
				C.c2v_free(voidptr(crypt_pwd))
				crypt_pwd = (voidptr(0))
			}
		} else {
			libpq_append_conn_error(conn, c'out of memory')
		}
	} else {
		libpq_append_conn_error(conn, c'unrecognized password encryption algorithm "%s"', voidptr(algorithm))
		return unsafe { nil }
	}
	return crypt_pwd
}

@[export: 'PQchangePassword']
@[markused]
pub fn pq_change_password(conn &PGconn, user &i8, passwd &i8) &PGresult {
	encrypted_password := pq_encrypt_password_conn(conn, passwd, user, (voidptr(0)))
	if isnil(encrypted_password) {
		return unsafe { nil }
	} else {
		fmtpw := pq_escape_literal(conn, encrypted_password, C.c2v_strlen(encrypted_password))
		pq_freemem(voidptr(encrypted_password))
		if isnil(fmtpw) {
			return unsafe { nil }
		} else {
			fmtuser := pq_escape_identifier(conn, user, C.c2v_strlen(user))
			if isnil(fmtuser) {
				pq_freemem(voidptr(fmtpw))
				return unsafe { nil }
			} else {
				buf := PQExpBufferData{}
				res := &PGresult(0)
				init_pq_exp_buffer(&buf)
				printf_pq_exp_buffer(&buf, c'ALTER USER %s PASSWORD %s', voidptr(fmtuser), voidptr(fmtpw))
				res = pq_exec(conn, buf.data)
				term_pq_exp_buffer(&buf)
				pq_freemem(voidptr(fmtuser))
				pq_freemem(voidptr(fmtpw))
				return res
			}
		}
	}
}

@[export: 'PQgetAuthDataHook']
@[markused]
pub fn pq_get_auth_data_hook() PQauthDataHook_type {
	return pq_auth_data_hook
}

@[export: 'PQsetAuthDataHook']
@[markused]
pub fn pq_set_auth_data_hook(hook PQauthDataHook_type) {
	pq_auth_data_hook = if hook { hook } else { pq_default_auth_data_hook }
}

@[export: 'PQdefaultAuthDataHook']
@[markused]
pub fn pq_default_auth_data_hook(type_ PGauthData, conn &PGconn, data voidptr) int {
	c2v_gc_register_thread()
	return 0
}
