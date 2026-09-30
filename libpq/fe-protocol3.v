@[translated]
module libpq

@[markused]
pub fn libpq_fe_protocol3_pg_sub_s16_overflow(a Int16, b Int16, result &Int16) bool {
	res := Int32(a) - Int32(b)
	if res > 32767 || res < -32768 {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_mul_s16_overflow(a Int16, b Int16, result &Int16) bool {
	res := Int32(a) * Int32(b)
	if res > 32767 || res < -32768 {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_neg_s16_overflow(a Int16, result &Int16) bool {
	if (i64((i32(a) == -32768) != 0)) {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(-i32(a)) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_abs_s16(a Int16) Uint16 {
	return Uint16(C.c2v_abs(Int32(a)))
}

@[markused]
pub fn libpq_fe_protocol3_pg_add_s32_overflow(a Int32, b Int32, result &Int32) bool {
	res := Int64(a) + Int64(b)
	if res > Int64(2147483647) || res < Int64((-2147483647 - 1)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_sub_s32_overflow(a Int32, b Int32, result &Int32) bool {
	res := Int64(a) - Int64(b)
	if res > Int64(2147483647) || res < Int64((-2147483647 - 1)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_mul_s32_overflow(a Int32, b Int32, result &Int32) bool {
	res := Int64(a) * Int64(b)
	if res > Int64(2147483647) || res < Int64((-2147483647 - 1)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_neg_s32_overflow(a Int32, result &Int32) bool {
	if (i64((a == (-2147483647 - 1)) != 0)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = -a }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_abs_s32(a Int32) Uint32 {
	return Uint32((Int64(C.c2v_labs(i64(Int64(a))))))
}

@[markused]
pub fn libpq_fe_protocol3_pg_add_s64_overflow(a Int64, b Int64, result &Int64) bool {
	res := c2v_u128_add(c2v_i128(i64(a)), c2v_i128(i64(b)))
	if c2v_i128_cmp(res, c2v_i128(i64(9223372036854775807))) > 0 || c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0 {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_sub_s64_overflow(a Int64, b Int64, result &Int64) bool {
	res := c2v_u128_sub(c2v_i128(i64(a)), c2v_i128(i64(b)))
	if c2v_i128_cmp(res, c2v_i128(i64(9223372036854775807))) > 0 || c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0 {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_mul_s64_overflow(a Int64, b Int64, result &Int64) bool {
	res := c2v_u128_mul(c2v_i128(i64(a)), c2v_i128(i64(b)))
	if c2v_i128_cmp(res, c2v_i128(i64(9223372036854775807))) > 0 || c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0 {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_neg_s64_overflow(a Int64, result &Int64) bool {
	if (i64((a == (-9223372036854775807 - i64(1))) != 0)) {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = -a }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_abs_s64(a Int64) Uint64 {
	if (i64((a == (-9223372036854775807 - i64(1))) != 0)) {
		return Uint64(9223372036854775807) + Uint64(1)
	}
	return Uint64((Int64(C.c2v_labs(i64(a)))))
}

@[markused]
pub fn libpq_fe_protocol3_pg_add_u16_overflow(a Uint16, b Uint16, result &Uint16) bool {
	res := Uint16(i32(a) + i32(b))
	if i32(res) < i32(a) {
		unsafe { *result = Uint16(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_sub_u16_overflow(a Uint16, b Uint16, result &Uint16) bool {
	if i32(b) > i32(a) {
		unsafe { *result = Uint16(24301) }
		return true != 0
	}
	unsafe { *result = Uint16(i32(a) - i32(b)) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_mul_u16_overflow(a Uint16, b Uint16, result &Uint16) bool {
	res := Uint32(a) * Uint32(b)
	if res > Uint32(65535) {
		unsafe { *result = Uint16(24301) }
		return true != 0
	}
	unsafe { *result = Uint16(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_neg_u16_overflow(a Uint16, result &Int16) bool {
	res := -(Int32(a))
	if (i64((res < -32768) != 0)) {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_add_u32_overflow(a Uint32, b Uint32, result &Uint32) bool {
	res := a + b
	if res < a {
		unsafe { *result = Uint32(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_sub_u32_overflow(a Uint32, b Uint32, result &Uint32) bool {
	if b > a {
		unsafe { *result = Uint32(24301) }
		return true != 0
	}
	unsafe { *result = a - b }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_mul_u32_overflow(a Uint32, b Uint32, result &Uint32) bool {
	res := Uint64(a) * Uint64(b)
	if res > Uint64(u32(4294967295)) {
		unsafe { *result = Uint32(24301) }
		return true != 0
	}
	unsafe { *result = Uint32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_neg_u32_overflow(a Uint32, result &Int32) bool {
	res := -(Int64(a))
	if (i64((res < Int64((-2147483647 - 1))) != 0)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_add_u64_overflow(a Uint64, b Uint64, result &Uint64) bool {
	res := a + b
	if res < a {
		unsafe { *result = Uint64(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_sub_u64_overflow(a Uint64, b Uint64, result &Uint64) bool {
	if b > a {
		unsafe { *result = Uint64(24301) }
		return true != 0
	}
	unsafe { *result = a - b }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_mul_u64_overflow(a Uint64, b Uint64, result &Uint64) bool {
	res := c2v_u128_mul(c2v_u128(u64(a)), c2v_u128(u64(b)))
	if c2v_u128_cmp(res, c2v_u128(u64(u64(18446744073709551615)))) > 0 {
		unsafe { *result = Uint64(24301) }
		return true != 0
	}
	unsafe { *result = Uint64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_neg_u64_overflow(a Uint64, result &Int64) bool {
	res := c2v_u128_neg((c2v_u128(u64(a))))
	if (i64((c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0) != 0)) {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_add_size_overflow(a usize, b usize, result &usize) bool {
	res := a + b
	if res < a {
		unsafe { *result = usize(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_sub_size_overflow(a usize, b usize, result &usize) bool {
	if b > a {
		unsafe { *result = usize(24301) }
		return true != 0
	}
	unsafe { *result = a - b }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_mul_size_overflow(a usize, b usize, result &usize) bool {
	res := a * b
	if a != usize(0) && b != res / a {
		unsafe { *result = usize(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_protocol3_pg_cmp_s16(a Int16, b Int16) i32 {
	return Int32(a) - Int32(b)
}

@[markused]
pub fn libpq_fe_protocol3_pg_cmp_u16(a Uint16, b Uint16) i32 {
	return Int32(a) - Int32(b)
}

@[markused]
pub fn libpq_fe_protocol3_pg_cmp_s32(a Int32, b Int32) i32 {
	return i32((a > b)) - i32((a < b))
}

@[markused]
pub fn libpq_fe_protocol3_pg_cmp_u32(a Uint32, b Uint32) i32 {
	return i32((a > b)) - i32((a < b))
}

@[markused]
pub fn libpq_fe_protocol3_pg_cmp_s64(a Int64, b Int64) i32 {
	return i32((a > b)) - i32((a < b))
}

@[markused]
pub fn libpq_fe_protocol3_pg_cmp_u64(a Uint64, b Uint64) i32 {
	return i32((a > b)) - i32((a < b))
}

@[markused]
pub fn libpq_fe_protocol3_pg_cmp_size(a usize, b usize) i32 {
	return i32((a > b)) - i32((a < b))
}

pub type PGcancelConn_fe_protocol3 = Pg_cancel_conn

pub type PGcancel_fe_protocol3 = Pg_cancel

@[markused]
pub fn libpq_fe_protocol3_is_unixsock_path(path &i8) bool {
	return (i32(path[false]) == i8(`/`)) || i32(path[false]) == i8(`@`)
}

@[markused]
pub fn libpq_fe_protocol3_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_fe_protocol3_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_fe_protocol3_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_fe_protocol3_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_fe_protocol3_utf8_to_unicode(c &u8) Pg_wchar {
	if (i32((unsafe { *c })) & 128) == 0 {
		return Pg_wchar(c[0])
	} else if (i32((unsafe { *c })) & 224) == 192 {
		return Pg_wchar((((i32(c[0]) & 31) << 6) | (i32(c[1]) & 63)))
	} else if (i32((unsafe { *c })) & 240) == 224 {
		return Pg_wchar((((i32(c[0]) & 15) << 12) | ((i32(c[1]) & 63) << 6) | (i32(c[2]) & 63)))
	} else if (i32((unsafe { *c })) & 248) == 240 {
		return Pg_wchar((((i32(c[0]) & 7) << 18) | ((i32(c[1]) & 63) << 12) | ((i32(c[2]) & 63) << 6) | (i32(c[3]) & 63)))
	} else {
		return u32(4294967295)
	}
}

@[markused]
pub fn libpq_fe_protocol3_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
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
pub fn libpq_fe_protocol3_unicode_utf8len(c Pg_wchar) i32 {
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

@[export: 'pqParseInput3']
@[markused]
pub fn pq_parse_input3(conn &PGconn) {
	id := i8(0)
	msg_length := i32(0)
	avail := i32(0)
	for {
		conn.inCursor = conn.inStart
		if pq_getc(&id, conn) {
			return
		}
		if pq_get_int(&msg_length, usize(4), conn) {
			return
		}
		if msg_length < 4 {
			handle_sync_loss(conn, i8(id), msg_length)
			return
		}
		mut __c2v_condition_0 := false
		mut __c2v_condition_1 := false
		__c2v_condition_1 = msg_length > 30000
		if __c2v_condition_1 {
			__c2v_condition_1 = !(i32(id) == i8(`d`) || i32(id) == i8(`D`) || i32(id) == i8(`E`) || i32(id) == i8(`V`) || i32(id) == i8(`N`) || i32(id) == i8(`A`) || i32(id) == i8(`T`) || i32(id) == i8(`t`))
		}
		__c2v_condition_0 = __c2v_condition_1
		if __c2v_condition_0 {
			handle_sync_loss(conn, i8(id), msg_length)
			return
		}
		msg_length -= 4
		avail = conn.inEnd - conn.inCursor
		if avail < msg_length {
			if pq_check_in_buffer_space(usize(conn.inCursor) + usize(msg_length), conn) {
				handle_fatal_error(conn)
			}
			return
		}
		if i32(id) == i8(`A`) {
			if get_notify(conn) {
				return
			}
		} else if i32(id) == i8(`N`) {
			if pq_get_error_notice3(conn, (0 != 0)) {
				return
			}
		} else if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_busy) {
			if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_idle) {
				return
			}
			if i32(id) == i8(`E`) {
				if pq_get_error_notice3(conn, (0 != 0)) {
					return
				}
			} else if i32(id) == i8(`S`) {
				if get_parameter_status(conn) {
					return
				}
			} else {
				pq_internal_notice(&conn.noticeHooks, c'message type 0x%02x arrived from server while idle', i32(id))
				conn.inCursor += msg_length
			}
		} else {
			match i32(id) {
				i32(`C`) {
					if pq_gets(&conn.workBuffer, conn) {
						return
					}
					if !(usize(conn.result) != usize((voidptr(0))) || i32(conn.error_result)) {
						conn.result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_command_ok))
						if isnil(conn.result) {
							libpq_append_conn_error(conn, c'out of memory')
							pq_save_error_result(conn)
						}
					}
					if conn.result {
						C.c2v_strlcpy(unsafe { &i8(&conn.result.cmdStatus[0]) }, conn.workBuffer.data, u64(64))
					}
					conn.asyncStatus = PGAsyncStatusType.pgasync_ready
				}
				i32(`E`) {
					if pq_get_error_notice3(conn, (1 != 0)) {
						return
					}
					conn.asyncStatus = PGAsyncStatusType.pgasync_ready
				}
				i32(`Z`) {
					if get_ready_for_query(conn) {
						return
					}
					if u32(conn.pipelineStatus) != u32(PGpipelineStatus.pq_pipeline_off) {
						conn.result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_pipeline_sync))
						if isnil(conn.result) {
							libpq_append_conn_error(conn, c'out of memory')
							pq_save_error_result(conn)
						} else {
							conn.pipelineStatus = PGpipelineStatus.pq_pipeline_on
							conn.asyncStatus = PGAsyncStatusType.pgasync_ready
						}
					} else {
						pq_command_queue_advance(conn, (1 != 0), (0 != 0))
						conn.asyncStatus = PGAsyncStatusType.pgasync_idle
					}
				}
				i32(`I`) {
					if !(usize(conn.result) != usize((voidptr(0))) || i32(conn.error_result)) {
						conn.result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_empty_query))
						if isnil(conn.result) {
							libpq_append_conn_error(conn, c'out of memory')
							pq_save_error_result(conn)
						}
					}
					conn.asyncStatus = PGAsyncStatusType.pgasync_ready
				}
				i32(`1`) {
					if !isnil(conn.cmd_queue_head) && u32(conn.cmd_queue_head.queryclass) == u32(PGQueryClass.pgquery_prepare) {
						if !(usize(conn.result) != usize((voidptr(0))) || i32(conn.error_result)) {
							conn.result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_command_ok))
							if isnil(conn.result) {
								libpq_append_conn_error(conn, c'out of memory')
								pq_save_error_result(conn)
							}
						}
						conn.asyncStatus = PGAsyncStatusType.pgasync_ready
					}
				}
				i32(`2`) {
				}
				i32(`3`) {
					if !isnil(conn.cmd_queue_head) && u32(conn.cmd_queue_head.queryclass) == u32(PGQueryClass.pgquery_close) {
						if !(usize(conn.result) != usize((voidptr(0))) || i32(conn.error_result)) {
							conn.result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_command_ok))
							if isnil(conn.result) {
								libpq_append_conn_error(conn, c'out of memory')
								pq_save_error_result(conn)
							}
						}
						conn.asyncStatus = PGAsyncStatusType.pgasync_ready
					}
				}
				i32(`S`) {
					if get_parameter_status(conn) {
						return
					}
				}
				i32(`K`) {
					if get_backend_key_data(conn, msg_length) {
						return
					}
				}
				i32(`T`) {
					if i32(conn.error_result) || (usize(conn.result) != usize((voidptr(0))) && u32(conn.result.resultStatus) == u32(ExecStatusType.pgres_fatal_error)) {
						conn.inCursor += msg_length
					} else if usize(conn.result) == usize((voidptr(0))) || (!isnil(conn.cmd_queue_head) && u32(conn.cmd_queue_head.queryclass) == u32(PGQueryClass.pgquery_describe)) {
						if get_row_descriptions(conn, msg_length) {
							return
						}
					} else {
						conn.asyncStatus = PGAsyncStatusType.pgasync_ready
						return
					}
				}
				i32(`n`) {
					if !isnil(conn.cmd_queue_head) && u32(conn.cmd_queue_head.queryclass) == u32(PGQueryClass.pgquery_describe) {
						if !(usize(conn.result) != usize((voidptr(0))) || i32(conn.error_result)) {
							conn.result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_command_ok))
							if isnil(conn.result) {
								libpq_append_conn_error(conn, c'out of memory')
								pq_save_error_result(conn)
							}
						}
						conn.asyncStatus = PGAsyncStatusType.pgasync_ready
					}
				}
				i32(`t`) {
					if get_param_descriptions(conn, msg_length) {
						return
					}
				}
				i32(`D`) {
					if usize(conn.result) != usize((voidptr(0))) && (u32(conn.result.resultStatus) == u32(ExecStatusType.pgres_tuples_ok) || u32(conn.result.resultStatus) == u32(ExecStatusType.pgres_tuples_chunk)) {
						if get_another_tuple(conn, msg_length) {
							return
						}
					} else if i32(conn.error_result) || (usize(conn.result) != usize((voidptr(0))) && u32(conn.result.resultStatus) == u32(ExecStatusType.pgres_fatal_error)) {
						conn.inCursor += msg_length
					} else {
						libpq_append_conn_error(conn, c'server sent data ("D" message) without prior row description ("T" message)')
						pq_save_error_result(conn)
						conn.inCursor += msg_length
					}
				}
				i32(`G`) {
					if get_copy_start(conn, ExecStatusType(ExecStatusType.pgres_copy_in)) {
						return
					}
					conn.asyncStatus = PGAsyncStatusType.pgasync_copy_in
				}
				i32(`H`) {
					if get_copy_start(conn, ExecStatusType(ExecStatusType.pgres_copy_out)) {
						return
					}
					conn.asyncStatus = PGAsyncStatusType.pgasync_copy_out
					conn.copy_already_done = 0
				}
				i32(`W`) {
					if get_copy_start(conn, ExecStatusType(ExecStatusType.pgres_copy_both)) {
						return
					}
					conn.asyncStatus = PGAsyncStatusType.pgasync_copy_both
					conn.copy_already_done = 0
				}
				i32(`d`) {
					conn.inCursor += msg_length
				}
				i32(`c`) {
				}
				else {
					libpq_append_conn_error(conn, c'unexpected response from server; first received character was "%c"', i32(id))
					pq_save_error_result(conn)
					conn.asyncStatus = PGAsyncStatusType.pgasync_ready
					conn.inCursor += msg_length
				}
			}
		}
		if conn.inCursor == conn.inStart + 5 + msg_length {
			pq_parse_done(conn, conn.inCursor)
		} else if i32(conn.error_result) && u32(conn.status) == u32(ConnStatusType.connection_bad) {
			return
		} else {
			libpq_append_conn_error(conn, c'message contents do not agree with length in message type "%c"', i32(id))
			pq_save_error_result(conn)
			conn.asyncStatus = PGAsyncStatusType.pgasync_ready
			conn.inStart += 5 + msg_length
		}
	}
}

@[markused]
pub fn handle_fatal_error(conn &PGconn) {
	pq_save_error_result(conn)
	conn.asyncStatus = PGAsyncStatusType.pgasync_ready
	pq_drop_connection(conn, (1 != 0))
	conn.status = ConnStatusType.connection_bad
}

@[markused]
pub fn handle_sync_loss(conn &PGconn, id i8, msg_length i32) {
	libpq_append_conn_error(conn, c'lost synchronization with server: got message type "%c", length %d', i32(id), msg_length)
	handle_fatal_error(conn)
}

@[markused]
pub fn get_row_descriptions(conn &PGconn, msg_length i32) i32 {
	result := &PGresult(0)
	nfields := i32(0)
	errmsg := &i8(0)
	i := i32(0)
	if isnil(conn.cmd_queue_head) || (!isnil(conn.cmd_queue_head) && u32(conn.cmd_queue_head.queryclass) == u32(PGQueryClass.pgquery_describe)) {
		if conn.result {
			result = conn.result
		} else {
			result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_command_ok))
		}
	} else {
		result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_tuples_ok))
	}
	if isnil(result) {
		errmsg = unsafe { nil }
		unsafe {
			goto advance_and_error
		}
	}
	if pq_get_int(&result.numAttributes, usize(2), conn) {
		errmsg = unsafe { &c'insufficient data in "T" message'[0] }
		unsafe {
			goto advance_and_error
		}
	}
	nfields = result.numAttributes
	if nfields > 0 {
		result.attDescs = &PGresAttDesc(pq_result_alloc_vdup0(result, u64(nfields) * sizeof(PGresAttDesc), (1 != 0)))
		if isnil(result.attDescs) {
			errmsg = unsafe { nil }
			unsafe {
				goto advance_and_error
			}
		}
		for {
			vstart := voidptr(result.attDescs)
			val := i32(0)
			len := (u64(nfields) * sizeof(PGresAttDesc))
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
	}
	result.binary = if (nfields > 0) { 1 } else { 0 }
	for i = 0; i < nfields; i++ {
		tableid := i32(0)
		columnid := i32(0)
		typid := i32(0)
		typlen := i32(0)
		atttypmod := i32(0)
		format := i32(0)
		mut __c2v_condition_2 := false
		mut __c2v_condition_3 := false
		__c2v_condition_3 = pq_gets(&conn.workBuffer, conn)
		__c2v_condition_2 = __c2v_condition_3
		if !__c2v_condition_2 {
			mut __c2v_condition_4 := false
			__c2v_condition_4 = pq_get_int(&tableid, usize(4), conn)
			__c2v_condition_2 = __c2v_condition_4
		}
		if !__c2v_condition_2 {
			mut __c2v_condition_5 := false
			__c2v_condition_5 = pq_get_int(&columnid, usize(2), conn)
			__c2v_condition_2 = __c2v_condition_5
		}
		if !__c2v_condition_2 {
			mut __c2v_condition_6 := false
			__c2v_condition_6 = pq_get_int(&typid, usize(4), conn)
			__c2v_condition_2 = __c2v_condition_6
		}
		if !__c2v_condition_2 {
			mut __c2v_condition_7 := false
			__c2v_condition_7 = pq_get_int(&typlen, usize(2), conn)
			__c2v_condition_2 = __c2v_condition_7
		}
		if !__c2v_condition_2 {
			mut __c2v_condition_8 := false
			__c2v_condition_8 = pq_get_int(&atttypmod, usize(4), conn)
			__c2v_condition_2 = __c2v_condition_8
		}
		if !__c2v_condition_2 {
			mut __c2v_condition_9 := false
			__c2v_condition_9 = pq_get_int(&format, usize(2), conn)
			__c2v_condition_2 = __c2v_condition_9
		}
		if __c2v_condition_2 {
			errmsg = unsafe { &c'insufficient data in "T" message'[0] }
			unsafe {
				goto advance_and_error
			}
		}
		columnid = i32((Int16(columnid)))
		typlen = i32((Int16(typlen)))
		format = i32((Int16(format)))
		result.attDescs[i].name = pq_result_strdup(result, conn.workBuffer.data)
		if isnil(result.attDescs[i].name) {
			errmsg = unsafe { nil }
			unsafe {
				goto advance_and_error
			}
		}
		result.attDescs[i].tableid = Oid(tableid)
		result.attDescs[i].columnid = columnid
		result.attDescs[i].format = format
		result.attDescs[i].typid = Oid(typid)
		result.attDescs[i].typlen = typlen
		result.attDescs[i].atttypmod = atttypmod
		if format != 1 {
			result.binary = 0
		}
	}
	conn.result = result
	if (isnil(conn.cmd_queue_head)) || (!isnil(conn.cmd_queue_head) && u32(conn.cmd_queue_head.queryclass) == u32(PGQueryClass.pgquery_describe)) {
		conn.asyncStatus = PGAsyncStatusType.pgasync_ready
		return 0
	}
	return 0
	advance_and_error:
	if !isnil(result) && usize(result) != usize(conn.result) {
		pq_clear(result)
	}
	pq_clear_async_result(conn)
	if isnil(errmsg) {
		errmsg = unsafe { &c'out of memory for query result'[0] }
	}
	append_pq_exp_buffer(&conn.errorMessage, c'%s\n', voidptr(errmsg))
	pq_save_error_result(conn)
	conn.inCursor = conn.inStart + 5 + msg_length
	return 0
}

@[markused]
pub fn get_param_descriptions(conn &PGconn, msg_length i32) i32 {
	result := &PGresult(0)
	errmsg := unsafe { &i8(nil) }
	nparams := i32(0)
	i := i32(0)
	result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_command_ok))
	if isnil(result) {
		unsafe {
			goto advance_and_error
		}
	}
	if pq_get_int(&result.numParameters, usize(2), conn) {
		unsafe {
			goto not_enough_data
		}
	}
	nparams = result.numParameters
	if nparams > 0 {
		result.paramDescs = &PGresParamDesc(pq_result_alloc_vdup0(result, u64(nparams) * sizeof(PGresParamDesc), (1 != 0)))
		if isnil(result.paramDescs) {
			unsafe {
				goto advance_and_error
			}
		}
		for {
			vstart := voidptr(result.paramDescs)
			val := i32(0)
			len := (u64(nparams) * sizeof(PGresParamDesc))
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
	}
	for i = 0; i < nparams; i++ {
		typid := i32(0)
		if pq_get_int(&typid, usize(4), conn) {
			unsafe {
				goto not_enough_data
			}
		}
		result.paramDescs[i].typid = Oid(typid)
	}
	conn.result = result
	return 0
	not_enough_data:
	errmsg = unsafe { &c'insufficient data in "t" message'[0] }
	advance_and_error:
	if !isnil(result) && usize(result) != usize(conn.result) {
		pq_clear(result)
	}
	pq_clear_async_result(conn)
	if isnil(errmsg) {
		errmsg = unsafe { &c'out of memory'[0] }
	}
	append_pq_exp_buffer(&conn.errorMessage, c'%s\n', voidptr(errmsg))
	pq_save_error_result(conn)
	conn.inCursor = conn.inStart + 5 + msg_length
	return 0
}

@[markused]
pub fn get_another_tuple(conn &PGconn, msg_length i32) i32 {
	result := conn.result
	nfields := result.numAttributes
	errmsg := &i8(0)
	mut rowbuf := &PGdataValue(0)
	tupnfields := i32(0)
	vlen := i32(0)
	i := i32(0)
	if pq_get_int(&tupnfields, usize(2), conn) {
		errmsg = unsafe { &c'insufficient data in "D" message'[0] }
		unsafe {
			goto advance_and_error
		}
	}
	if tupnfields != nfields {
		errmsg = unsafe { &c'unexpected field count in "D" message'[0] }
		unsafe {
			goto advance_and_error
		}
	}
	rowbuf = conn.rowBuf
	if nfields > conn.rowBufLen {
		rowbuf = &PGdataValue(C.c2v_realloc(voidptr(rowbuf), u64(nfields) * sizeof(PGdataValue)))
		if isnil(rowbuf) {
			errmsg = unsafe { nil }
			unsafe {
				goto advance_and_error
			}
		}
		conn.rowBuf = rowbuf
		conn.rowBufLen = nfields
	}
	for i = 0; i < nfields; i++ {
		if pq_get_int(&vlen, usize(4), conn) {
			errmsg = unsafe { &c'insufficient data in "D" message'[0] }
			unsafe {
				goto advance_and_error
			}
		}
		rowbuf[i].len = vlen
		rowbuf[i].value = conn.inBuffer + conn.inCursor
		if vlen > 0 {
			if pq_skipnchar(usize(vlen), conn) {
				errmsg = unsafe { &c'insufficient data in "D" message'[0] }
				unsafe {
					goto advance_and_error
				}
			}
		}
	}
	errmsg = unsafe { nil }
	if pq_row_processor(conn, &&u8(&&i8(c2v_address_of(&errmsg)))) {
		return 0
	}
	advance_and_error:
	pq_clear_async_result(conn)
	if isnil(errmsg) {
		errmsg = unsafe { &c'out of memory for query result'[0] }
	}
	append_pq_exp_buffer(&conn.errorMessage, c'%s\n', voidptr(errmsg))
	pq_save_error_result(conn)
	conn.inCursor = conn.inStart + 5 + msg_length
	return 0
}

@[export: 'pqGetErrorNotice3']
@[markused]
pub fn pq_get_error_notice3(conn &PGconn, is_error bool) i32 {
	res := unsafe { &PGresult(nil) }
	have_position := (0 != 0)
	work_buf := PQExpBufferData{}
	id := i8(0)
	if i32(is_error) && u32(conn.pipelineStatus) != u32(PGpipelineStatus.pq_pipeline_off) {
		conn.pipelineStatus = PGpipelineStatus.pq_pipeline_aborted
	}
	if is_error {
		pq_clear_async_result(conn)
	}
	init_pq_exp_buffer(&work_buf)
	res = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_empty_query))
	if res {
		res.resultStatus = if i32(is_error) {
			ExecStatusType.pgres_fatal_error
		} else {
			ExecStatusType.pgres_nonfatal_error
		}
	}
	for {
		if pq_getc(&id, conn) {
			unsafe {
				goto fail
			}
		}
		if i32(id) == i8(`\0`) {
			break
		}
		if pq_gets(&work_buf, conn) {
			unsafe {
				goto fail
			}
		}
		pq_save_message_field(res, i8(id), work_buf.data)
		if i32(id) == i8(`C`) {
			C.c2v_strlcpy(unsafe { &i8(&conn.last_sqlstate[0]) }, work_buf.data, sizeof([6]i8))
		} else if i32(id) == i8(`P`) {
			have_position = (1 != 0)
		}
	}
	if i32(have_position) && !isnil(res) && !isnil(conn.cmd_queue_head) && !isnil(conn.cmd_queue_head.query) {
		res.errQuery = pq_result_strdup(res, conn.cmd_queue_head.query)
	}
	reset_pq_exp_buffer(&work_buf)
	pq_build_error_message3(&work_buf, res, conn.verbosity, conn.show_context)
	if is_error {
		pq_clear_async_result(conn)
		if res {
			pq_set_result_error(res, &work_buf, 0)
			conn.result = res
		} else {
			conn.error_result = (1 != 0)
		}
		if (work_buf.maxlen == usize(0)) {
			libpq_append_conn_error(conn, c'out of memory')
		} else {
			append_pq_exp_buffer_str(&conn.errorMessage, work_buf.data)
		}
	} else {
		if res {
			if (work_buf.maxlen == usize(0)) {
				res.errMsg = unsafe { &c'out of memory\n'[0] }
			} else {
				res.errMsg = work_buf.data
			}
			if res.noticeHooks.noticeRec != (voidptr(0)) {
				res.noticeHooks.noticeRec(voidptr(res.noticeHooks.noticeRecArg), res)
			}
			pq_clear(res)
		}
	}
	term_pq_exp_buffer(&work_buf)
	return 0
	fail:
	pq_clear(res)
	term_pq_exp_buffer(&work_buf)
	return -1
}

@[export: 'pqBuildErrorMessage3']
@[markused]
pub fn pq_build_error_message3(msg PQExpBuffer, res &PGresult, verbosity PGVerbosity, show_context PGContextVisibility) {
	val := &i8(0)
	querytext := unsafe { &i8(nil) }
	querypos := i32(0)
	if usize(res) == usize((voidptr(0))) {
		append_pq_exp_buffer_str(msg, unsafe { &i8(&c'out of memory\n'[0]) })
		return
	}
	if usize(res.errFields) == usize((voidptr(0))) {
		if !isnil(res.errMsg) && i32(res.errMsg[0]) {
			append_pq_exp_buffer_str(msg, res.errMsg)
		} else {
			append_pq_exp_buffer_str(msg, unsafe { &i8(&c'no error message available\n'[0]) })
		}
		return
	}
	val = pq_result_error_field(res, `S`)
	if val {
		append_pq_exp_buffer(msg, c'%s:  ', voidptr(val))
	}
	if u32(verbosity) == u32(PGVerbosity.pqerrors_sqlstate) {
		val = pq_result_error_field(res, `C`)
		if val {
			append_pq_exp_buffer(msg, c'%s\n', voidptr(val))
			return
		}
		verbosity = PGVerbosity.pqerrors_terse
	}
	if u32(verbosity) == u32(PGVerbosity.pqerrors_verbose) {
		val = pq_result_error_field(res, `C`)
		if val {
			append_pq_exp_buffer(msg, c'%s: ', voidptr(val))
		}
	}
	val = pq_result_error_field(res, `M`)
	if val {
		append_pq_exp_buffer_str(msg, val)
	}
	val = pq_result_error_field(res, `P`)
	if val {
		if u32(verbosity) != u32(PGVerbosity.pqerrors_terse) && usize(res.errQuery) != usize((voidptr(0))) {
			querytext = res.errQuery
			querypos = C.c2v_atoi(val)
		} else {
			append_pq_exp_buffer(msg, unsafe { &i8(&c' at character %s'[0]) }, voidptr(val))
		}
	} else {
		val = pq_result_error_field(res, `p`)
		if val {
			querytext = pq_result_error_field(res, `q`)
			if u32(verbosity) != u32(PGVerbosity.pqerrors_terse) && usize(querytext) != usize((voidptr(0))) {
				querypos = C.c2v_atoi(val)
			} else {
				append_pq_exp_buffer(msg, unsafe { &i8(&c' at character %s'[0]) }, voidptr(val))
			}
		}
	}
	append_pq_exp_buffer_char(msg, i8(`\n`))
	if u32(verbosity) != u32(PGVerbosity.pqerrors_terse) {
		if !isnil(querytext) && querypos > 0 {
			report_error_position(msg, querytext, querypos, res.client_encoding)
		}
		val = pq_result_error_field(res, `D`)
		if val {
			append_pq_exp_buffer(msg, unsafe { &i8(&c'DETAIL:  %s\n'[0]) }, voidptr(val))
		}
		val = pq_result_error_field(res, `H`)
		if val {
			append_pq_exp_buffer(msg, unsafe { &i8(&c'HINT:  %s\n'[0]) }, voidptr(val))
		}
		val = pq_result_error_field(res, `q`)
		if val {
			append_pq_exp_buffer(msg, unsafe { &i8(&c'QUERY:  %s\n'[0]) }, voidptr(val))
		}
		mut __c2v_condition_10 := false
		mut __c2v_condition_11 := false
		__c2v_condition_11 = u32(show_context) == u32(PGContextVisibility.pqshow_context_always)
		__c2v_condition_10 = __c2v_condition_11
		if !__c2v_condition_10 {
			mut __c2v_condition_12 := false
			__c2v_condition_12 = (u32(show_context) == u32(PGContextVisibility.pqshow_context_errors) && u32(res.resultStatus) == u32(ExecStatusType.pgres_fatal_error))
			__c2v_condition_10 = __c2v_condition_12
		}
		if __c2v_condition_10 {
			val = pq_result_error_field(res, `W`)
			if val {
				append_pq_exp_buffer(msg, unsafe { &i8(&c'CONTEXT:  %s\n'[0]) }, voidptr(val))
			}
		}
	}
	if u32(verbosity) == u32(PGVerbosity.pqerrors_verbose) {
		val = pq_result_error_field(res, `s`)
		if val {
			append_pq_exp_buffer(msg, unsafe { &i8(&c'SCHEMA NAME:  %s\n'[0]) }, voidptr(val))
		}
		val = pq_result_error_field(res, `t`)
		if val {
			append_pq_exp_buffer(msg, unsafe { &i8(&c'TABLE NAME:  %s\n'[0]) }, voidptr(val))
		}
		val = pq_result_error_field(res, `c`)
		if val {
			append_pq_exp_buffer(msg, unsafe { &i8(&c'COLUMN NAME:  %s\n'[0]) }, voidptr(val))
		}
		val = pq_result_error_field(res, `d`)
		if val {
			append_pq_exp_buffer(msg, unsafe { &i8(&c'DATATYPE NAME:  %s\n'[0]) }, voidptr(val))
		}
		val = pq_result_error_field(res, `n`)
		if val {
			append_pq_exp_buffer(msg, unsafe { &i8(&c'CONSTRAINT NAME:  %s\n'[0]) }, voidptr(val))
		}
	}
	if u32(verbosity) == u32(PGVerbosity.pqerrors_verbose) {
		valf := &i8(0)
		vall := &i8(0)
		valf = pq_result_error_field(res, `F`)
		vall = pq_result_error_field(res, `L`)
		val = pq_result_error_field(res, `R`)
		if !isnil(val) || !isnil(valf) || !isnil(vall) {
			append_pq_exp_buffer_str(msg, unsafe { &i8(&c'LOCATION:  '[0]) })
			if val {
				append_pq_exp_buffer(msg, unsafe { &i8(&c'%s, '[0]) }, voidptr(val))
			}
			if !isnil(valf) && !isnil(vall) {
				append_pq_exp_buffer(msg, unsafe { &i8(&c'%s:%s'[0]) }, voidptr(valf), voidptr(vall))
			}
			append_pq_exp_buffer_char(msg, i8(`\n`))
		}
	}
}

@[markused]
pub fn report_error_position(msg PQExpBuffer, query &i8, loc i32, encoding i32) {
	wquery := &i8(0)
	slen := i32(0)
	cno := i32(0)
	i := i32(0)
	qidx := &i32(0)
	scridx := &i32(0)
	qoffset := i32(0)
	scroffset := i32(0)
	ibeg := i32(0)
	iend := i32(0)
	loc_line := i32(0)

	mb_encoding := false
	beg_trunc := false
	end_trunc := false

	loc--
	if loc < 0 {
		return
	}
	wquery = C.c2v_strdup(query)
	if usize(wquery) == usize((voidptr(0))) {
		return
	}
	slen = i32(C.c2v_strlen(wquery) + u64(1))
	if u64(slen) > u64(18446744073709551615) / sizeof(i32) {
		C.c2v_free(voidptr(wquery))
		return
	}
	qidx = &i32(C.c2v_malloc(u64(slen) * sizeof(i32)))
	if usize(qidx) == usize((voidptr(0))) {
		C.c2v_free(voidptr(wquery))
		return
	}
	scridx = &i32(C.c2v_malloc(u64(slen) * sizeof(i32)))
	if usize(scridx) == usize((voidptr(0))) {
		C.c2v_free(voidptr(qidx))
		C.c2v_free(voidptr(wquery))
		return
	}
	mb_encoding = ((pg_encoding_max_length(encoding) != 1) != 0)
	qoffset = 0
	scroffset = 0
	loc_line = 1
	ibeg = 0
	iend = -1
	for cno = 0; i32(wquery[qoffset]) != i8(`\0`); cno++ {
		ch := wquery[qoffset]
		qidx[cno] = qoffset
		scridx[cno] = scroffset
		if i32(ch) == i8(`\t`) {
			wquery[qoffset] = i8(` `)
		} else if i32(ch) == i8(`\r`) || i32(ch) == i8(`\n`) {
			if cno < loc {
				if i32(ch) == i8(`\r`) || cno == 0 || i32(wquery[qidx[cno - 1]]) != i8(`\r`) {
					loc_line++
				}
				ibeg = cno + 1
			} else {
				iend = cno
				break
			}
		}
		if mb_encoding {
			w := i32(0)
			w = pg_encoding_dsplen(encoding, unsafe { wquery + qoffset })
			if w <= 0 {
				w = 1
			}
			scroffset += w
			qoffset += pq_mblen_bounded(unsafe { wquery + qoffset }, encoding)
		} else {
			scroffset++
			qoffset++
		}
	}
	if iend < 0 {
		iend = cno
		qidx[iend] = qoffset
		scridx[iend] = scroffset
	}
	if loc <= cno {
		beg_trunc = (0 != 0)
		end_trunc = (0 != 0)
		if scridx[iend] - scridx[ibeg] > 60 {
			if scridx[ibeg] + 60 >= scridx[loc] + 10 {
				for scridx[iend] - scridx[ibeg] > 60 {
					iend--
				}
				end_trunc = (1 != 0)
			} else {
				for scridx[loc] + 10 < scridx[iend] {
					iend--
					end_trunc = (1 != 0)
				}
				for scridx[iend] - scridx[ibeg] > 60 {
					ibeg++
					beg_trunc = (1 != 0)
				}
			}
		}
		wquery[qidx[iend]] = i8(`\0`)
		i = i32(msg.len)
		append_pq_exp_buffer(msg, unsafe { &i8(&c'LINE %d: '[0]) }, loc_line)
		if beg_trunc {
			append_pq_exp_buffer_str(msg, c'...')
		}
		scroffset = 0
		for ; usize(i) < msg.len; i += pq_mblen_bounded(unsafe { msg.data + i }, encoding) {
			w := pg_encoding_dsplen(encoding, unsafe { msg.data + i })
			if w <= 0 {
				w = 1
			}
			scroffset += w
		}
		append_pq_exp_buffer_str(msg, unsafe { wquery + qidx[ibeg] })
		if end_trunc {
			append_pq_exp_buffer_str(msg, c'...')
		}
		append_pq_exp_buffer_char(msg, i8(`\n`))
		scroffset += scridx[loc] - scridx[ibeg]
		for i = 0; i < scroffset; i++ {
			append_pq_exp_buffer_char(msg, i8(` `))
		}
		append_pq_exp_buffer_char(msg, i8(`^`))
		append_pq_exp_buffer_char(msg, i8(`\n`))
	}
	C.c2v_free(voidptr(scridx))
	C.c2v_free(voidptr(qidx))
	C.c2v_free(voidptr(wquery))
}

@[export: 'pqGetNegotiateProtocolVersion3']
@[markused]
pub fn pq_get_negotiate_protocol_version3(conn &PGconn) i32 {
	their_version := i32(0)
	num := i32(0)
	if pq_get_int(&their_version, usize(4), conn) != 0 {
		unsafe {
			goto eof
		}
	}
	if pq_get_int(&num, usize(4), conn) != 0 {
		unsafe {
			goto eof
		}
	}
	if ProtocolVersion(their_version) > conn.pversion {
		libpq_append_conn_error(conn, c'received invalid protocol negotiation message: server requested downgrade to a higher-numbered version')
		unsafe {
			goto failure
		}
	}
	if their_version < ((3 << 16) | 0) {
		libpq_append_conn_error(conn, c'received invalid protocol negotiation message: server requested downgrade to pre-3.0 protocol version')
		unsafe {
			goto failure
		}
	}
	if their_version == ((3 << 16) | 1) {
		libpq_append_conn_error(conn, c'received invalid protocol negotiation message: server requested downgrade to non-existent 3.1 protocol version')
		unsafe {
			goto failure
		}
	}
	if num < 0 {
		libpq_append_conn_error(conn, c'received invalid protocol negotiation message: server reported negative number of unsupported parameters')
		unsafe {
			goto failure
		}
	}
	if ProtocolVersion(their_version) == conn.pversion && num == 0 {
		libpq_append_conn_error(conn, c'received invalid protocol negotiation message: server negotiated but asks for no changes')
		unsafe {
			goto failure
		}
	}
	if ProtocolVersion(their_version) < conn.min_pversion {
		libpq_append_conn_error(conn, c'server only supports protocol version %d.%d, but "%s" was set to %d.%d', (their_version >> 16), (their_version & 65535), voidptr(c'min_protocol_version'), (conn.min_pversion >> 16), (conn.min_pversion & ProtocolVersion(65535)))
		unsafe {
			goto failure
		}
	}
	conn.pversion = ProtocolVersion(their_version)
	for i := i32(0); i < num; i++ {
		if pq_gets(&conn.workBuffer, conn) {
			unsafe {
				goto eof
			}
		}
		if C.c2v_strncmp(conn.workBuffer.data, c'_pq_.', u64(5)) != 0 {
			libpq_append_conn_error(conn, c'received invalid protocol negotiation message: server reported unsupported parameter name without a "%s" prefix ("%s")', voidptr(c'_pq_.'), voidptr(conn.workBuffer.data))
			unsafe {
				goto failure
			}
		}
		libpq_append_conn_error(conn, c'received invalid protocol negotiation message: server reported an unsupported parameter that was not requested ("%s")', voidptr(conn.workBuffer.data))
		unsafe {
			goto failure
		}
	}
	return 0
	eof:
	libpq_append_conn_error(conn, c'received invalid protocol negotiation message: message too short')
	failure:
	conn.asyncStatus = PGAsyncStatusType.pgasync_ready
	pq_save_error_result(conn)
	return 1
}

@[markused]
pub fn get_parameter_status(conn &PGconn) i32 {
	value_buf := PQExpBufferData{}
	if pq_gets(&conn.workBuffer, conn) {
		return -1
	}
	init_pq_exp_buffer(&value_buf)
	if pq_gets(&value_buf, conn) {
		term_pq_exp_buffer(&value_buf)
		return -1
	}
	if !pq_save_parameter_status(conn, conn.workBuffer.data, value_buf.data) {
		libpq_append_conn_error(conn, c'out of memory')
		handle_fatal_error(conn)
	}
	term_pq_exp_buffer(&value_buf)
	return 0
}

@[markused]
pub fn get_backend_key_data(conn &PGconn, msg_length i32) i32 {
	cancel_key_len := i32(0)
	if conn.be_cancel_key {
		C.c2v_free(voidptr(conn.be_cancel_key))
		conn.be_cancel_key = unsafe { nil }
		conn.be_cancel_key_len = 0
	}
	if pq_get_int(&conn.be_pid, usize(4), conn) {
		return -1
	}
	cancel_key_len = 5 + msg_length - (conn.inCursor - conn.inStart)
	if cancel_key_len != 4 && conn.pversion == ProtocolVersion(((3 << 16) | 0)) {
		libpq_append_conn_error(conn, c'received invalid BackendKeyData message: cancel key with length %d not allowed in protocol version 3.0 (must be 4 bytes)', cancel_key_len)
		handle_fatal_error(conn)
		return 0
	}
	if cancel_key_len < 4 {
		libpq_append_conn_error(conn, c'received invalid BackendKeyData message: cancel key with length %d is too short (minimum 4 bytes)', cancel_key_len)
		handle_fatal_error(conn)
		return 0
	}
	if cancel_key_len > 256 {
		libpq_append_conn_error(conn, c'received invalid BackendKeyData message: cancel key with length %d is too long (maximum 256 bytes)', cancel_key_len)
		handle_fatal_error(conn)
		return 0
	}
	conn.be_cancel_key = C.c2v_malloc(u64(cancel_key_len))
	if usize(conn.be_cancel_key) == usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'out of memory')
		handle_fatal_error(conn)
		return 0
	}
	if pq_getnchar(voidptr(conn.be_cancel_key), usize(cancel_key_len), conn) {
		C.c2v_free(voidptr(conn.be_cancel_key))
		conn.be_cancel_key = unsafe { nil }
		return -1
	}
	conn.be_cancel_key_len = cancel_key_len
	return 0
}

@[markused]
pub fn get_notify(conn &PGconn) i32 {
	be_pid := i32(0)
	svname := &i8(0)
	nmlen := i32(0)
	extralen := i32(0)
	new_notify := &PGnotify(0)
	if pq_get_int(&be_pid, usize(4), conn) {
		return -1
	}
	if pq_gets(&conn.workBuffer, conn) {
		return -1
	}
	svname = C.c2v_strdup(conn.workBuffer.data)
	if isnil(svname) {
		libpq_append_conn_error(conn, c'out of memory')
		handle_fatal_error(conn)
		return 0
	}
	if pq_gets(&conn.workBuffer, conn) {
		C.c2v_free(voidptr(svname))
		return -1
	}
	nmlen = i32(C.c2v_strlen(svname))
	extralen = i32(C.c2v_strlen(conn.workBuffer.data))
	new_notify = &PGnotify(C.c2v_malloc(sizeof(PGnotify) + u64(nmlen) + u64(extralen) + u64(2)))
	if isnil(new_notify) {
		C.c2v_free(voidptr(svname))
		libpq_append_conn_error(conn, c'out of memory')
		handle_fatal_error(conn)
		return 0
	}
	new_notify.relname = &i8(voidptr(new_notify)) + sizeof(PGnotify)
	C.c2v_strcpy(new_notify.relname, svname)
	new_notify.extra = new_notify.relname + nmlen + 1
	C.c2v_strcpy(new_notify.extra, conn.workBuffer.data)
	new_notify.be_pid = be_pid
	new_notify.next = unsafe { nil }
	if conn.notifyTail {
		conn.notifyTail.next = new_notify
	} else {
		conn.notifyHead = new_notify
	}
	conn.notifyTail = new_notify
	C.c2v_free(voidptr(svname))
	return 0
}

@[markused]
pub fn get_copy_start(conn &PGconn, copytype ExecStatusType) i32 {
	result := &PGresult(0)
	nfields := i32(0)
	i := i32(0)
	result = pq_make_empty_pg_result(conn, copytype)
	if isnil(result) {
		unsafe {
			goto failure
		}
	}
	if pq_getc(&conn.copy_is_binary, conn) {
		unsafe {
			goto failure
		}
	}
	result.binary = i32(conn.copy_is_binary)
	if pq_get_int(&result.numAttributes, usize(2), conn) {
		unsafe {
			goto failure
		}
	}
	nfields = result.numAttributes
	if nfields > 0 {
		result.attDescs = &PGresAttDesc(pq_result_alloc_vdup0(result, u64(nfields) * sizeof(PGresAttDesc), (1 != 0)))
		if isnil(result.attDescs) {
			unsafe {
				goto failure
			}
		}
		for {
			vstart := voidptr(result.attDescs)
			val := i32(0)
			len := (u64(nfields) * sizeof(PGresAttDesc))
			if ((usize(vstart)) & (sizeof(i64) - u64(1))) == u64(0) && (len & (sizeof(i64) - u64(1))) == u64(0) && val == 0 && len <= Size(1024) && 1024 != 0 {
				start := &i64(vstart)
				stop := &i64(voidptr((&i8(voidptr(start)) + len)))
				for usize(start) < usize(stop) {
					mut __c2v_lhs_tmp_2 := unsafe { c2v_pointer_postfix(voidptr(&start), start, isize(1)) }
					unsafe { *__c2v_lhs_tmp_2 = i64(0) }
				}
			} else {
				C.c2v_memset(voidptr(vstart), val, len)
			}
			break
		}
	}
	for i = 0; i < nfields; i++ {
		format := i32(0)
		if pq_get_int(&format, usize(2), conn) {
			unsafe {
				goto failure
			}
		}
		format = i32((Int16(format)))
		result.attDescs[i].format = format
	}
	conn.result = result
	return 0
	failure:
	pq_clear(result)
	return -1
}

@[markused]
pub fn get_ready_for_query(conn &PGconn) i32 {
	xact_status := i8(0)
	if pq_getc(&xact_status, conn) {
		return -1
	}
	match i32(xact_status) {
		i32(`I`) {
			conn.xactStatus = PGTransactionStatusType.pqtrans_idle
		}
		i32(`T`) {
			conn.xactStatus = PGTransactionStatusType.pqtrans_intrans
		}
		i32(`E`) {
			conn.xactStatus = PGTransactionStatusType.pqtrans_inerror
		}
		else {
			conn.xactStatus = PGTransactionStatusType.pqtrans_unknown
		}
	}

	return 0
}

@[markused]
pub fn get_copy_data_message(conn &PGconn) i32 {
	id := i8(0)
	msg_length := i32(0)
	avail := i32(0)
	for {
		conn.inCursor = conn.inStart
		if pq_getc(&id, conn) {
			return 0
		}
		if pq_get_int(&msg_length, usize(4), conn) {
			return 0
		}
		if msg_length < 4 {
			handle_sync_loss(conn, i8(id), msg_length)
			return -2
		}
		avail = conn.inEnd - conn.inCursor
		if avail < msg_length - 4 {
			if pq_check_in_buffer_space(usize(conn.inCursor) + usize(msg_length) - usize(4), conn) {
				handle_fatal_error(conn)
				return -2
			}
			return 0
		}
		match i32(id) {
			i32(`A`) {
				if get_notify(conn) {
					return 0
				}
			}
			i32(`N`) {
				if pq_get_error_notice3(conn, (0 != 0)) {
					return 0
				}
			}
			i32(`S`) {
				if get_parameter_status(conn) {
					return 0
				}
			}
			i32(`d`) {
				return msg_length
			}
			i32(`c`) {
				if u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_copy_both) {
					conn.asyncStatus = PGAsyncStatusType.pgasync_copy_in
				} else {
					conn.asyncStatus = PGAsyncStatusType.pgasync_busy
				}
				return -1
			}
			else {
				conn.asyncStatus = PGAsyncStatusType.pgasync_busy
				return -1
			}
		}

		if i32(conn.error_result) && u32(conn.status) == u32(ConnStatusType.connection_bad) {
			return -2
		}
		pq_parse_done(conn, conn.inCursor)
	}
	panic('unreachable after C for (;;)')
}

@[export: 'pqGetCopyData3']
@[markused]
pub fn pq_get_copy_data3(conn &PGconn, buffer &&u8, async i32) i32 {
	msg_length := i32(0)
	for {
		msg_length = get_copy_data_message(conn)
		if msg_length < 0 {
			return msg_length
		}
		if msg_length == 0 {
			if async {
				return 0
			}
			if pq_wait(1, 0, conn) || pq_read_data(conn) < 0 {
				return -2
			}
			continue
		}
		msg_length -= 4
		if msg_length > 0 {
			unsafe { *buffer = &i8(C.c2v_malloc(u64(msg_length + 1))) }
			if usize((unsafe { *buffer })) == usize((voidptr(0))) {
				libpq_append_conn_error(conn, c'out of memory')
				return -2
			}
			C.c2v_memcpy(voidptr((unsafe { *buffer })), voidptr(unsafe { conn.inBuffer + conn.inCursor }), u64(msg_length))
			unsafe { (*buffer)[msg_length] = i8(`\0`) }
			pq_parse_done(conn, conn.inCursor + msg_length)
			return msg_length
		}
		pq_parse_done(conn, conn.inCursor)
	}
	panic('unreachable after C for (;;)')
}

@[export: 'pqGetline3']
@[markused]
pub fn pq_getline3(conn &PGconn, s &i8, maxlen i32) i32 {
	status := i32(0)
	if conn.sock == (-1) || (u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_out) && u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_both)) || i32(conn.copy_is_binary) {
		libpq_append_conn_error(conn, c'PQgetline: not doing text COPY OUT')
		unsafe { *s = i8(`\0`) }
		return -1
	}
	for {
		status = pq_getline_async(conn, s, maxlen - 1)
		if !(status == 0) {
			break
		}
		if pq_wait(1, 0, conn) || pq_read_data(conn) < 0 {
			unsafe { *s = i8(`\0`) }
			return -1
		}
	}
	if status < 0 {
		C.c2v_strcpy(s, c'\\.')
		return 0
	}
	if i32(s[status - 1]) == i8(`\n`) {
		s[status - 1] = i8(`\0`)
		return 0
	} else {
		s[status] = i8(`\0`)
		return 1
	}
}

@[export: 'pqGetlineAsync3']
@[markused]
pub fn pq_getline_async3(conn &PGconn, buffer &i8, bufsize i32) i32 {
	msg_length := i32(0)
	avail := i32(0)
	if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_out) && u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_both) {
		return -1
	}
	msg_length = get_copy_data_message(conn)
	if msg_length < 0 {
		return -1
	}
	if msg_length == 0 {
		return 0
	}
	conn.inCursor += conn.copy_already_done
	avail = msg_length - 4 - conn.copy_already_done
	if avail <= bufsize {
		C.c2v_memcpy(voidptr(buffer), voidptr(unsafe { conn.inBuffer + conn.inCursor }), u64(avail))
		conn.inStart = conn.inCursor + avail
		conn.copy_already_done = 0
		return avail
	} else {
		C.c2v_memcpy(voidptr(buffer), voidptr(unsafe { conn.inBuffer + conn.inCursor }), u64(bufsize))
		conn.copy_already_done += bufsize
		return bufsize
	}
}

@[export: 'pqEndcopy3']
@[markused]
pub fn pq_endcopy3(conn &PGconn) i32 {
	result := &PGresult(0)
	mut __c2v_condition_13 := false
	mut __c2v_condition_14 := false
	__c2v_condition_14 = u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_in)
	if __c2v_condition_14 {
		__c2v_condition_14 = u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_out)
	}
	if __c2v_condition_14 {
		__c2v_condition_14 = u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_both)
	}
	__c2v_condition_13 = __c2v_condition_14
	if __c2v_condition_13 {
		libpq_append_conn_error(conn, c'no COPY in progress')
		return 1
	}
	if u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_copy_in) || u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_copy_both) {
		if pq_put_msg_start(i8(`c`), conn) < 0 || pq_put_msg_end(conn) < 0 {
			return 1
		}
		if !isnil(conn.cmd_queue_head) && u32(conn.cmd_queue_head.queryclass) != u32(PGQueryClass.pgquery_simple) {
			if pq_put_msg_start(i8(`S`), conn) < 0 || pq_put_msg_end(conn) < 0 {
				return 1
			}
		}
	}
	if pq_flush_vdup1(conn) && i32(conn.nonblocking) {
		return 1
	}
	conn.asyncStatus = PGAsyncStatusType.pgasync_busy
	if i32(conn.nonblocking) && pq_is_busy(conn) {
		return 1
	}
	result = pq_get_result(conn)
	if !isnil(result) && u32(result.resultStatus) == u32(ExecStatusType.pgres_command_ok) {
		pq_clear(result)
		return 0
	}
	if conn.errorMessage.len > usize(0) {
		sv_last := conn.errorMessage.data[conn.errorMessage.len - usize(1)]
		if i32(sv_last) == i8(`\n`) {
			conn.errorMessage.data[conn.errorMessage.len - usize(1)] = i8(`\0`)
		}
		pq_internal_notice(&conn.noticeHooks, c'%s', voidptr(conn.errorMessage.data))
		conn.errorMessage.data[conn.errorMessage.len - usize(1)] = sv_last
	}
	pq_clear(result)
	return 1
}

@[export: 'pqFunctionCall3']
@[markused]
pub fn pq_function_call3(conn &PGconn, fnid Oid, result_buf &i32, buf_size i32, actual_result_len &i32, result_is_int i32, args &PQArgBlock, nargs i32) &PGresult {
	need_input := (0 != 0)
	status := ExecStatusType.pgres_fatal_error
	id := i8(0)
	msg_length := i32(0)
	avail := i32(0)
	i := i32(0)

	mut __c2v_condition_15 := false
	mut __c2v_condition_16 := false
	__c2v_condition_16 = pq_put_msg_start(i8(`F`), conn) < 0
	__c2v_condition_15 = __c2v_condition_16
	if !__c2v_condition_15 {
		mut __c2v_condition_17 := false
		__c2v_condition_17 = pq_put_int(i32(fnid), usize(4), conn) < 0
		__c2v_condition_15 = __c2v_condition_17
	}
	if !__c2v_condition_15 {
		mut __c2v_condition_18 := false
		__c2v_condition_18 = pq_put_int(1, usize(2), conn) < 0
		__c2v_condition_15 = __c2v_condition_18
	}
	if !__c2v_condition_15 {
		mut __c2v_condition_19 := false
		__c2v_condition_19 = pq_put_int(1, usize(2), conn) < 0
		__c2v_condition_15 = __c2v_condition_19
	}
	if !__c2v_condition_15 {
		mut __c2v_condition_20 := false
		__c2v_condition_20 = pq_put_int(nargs, usize(2), conn) < 0
		__c2v_condition_15 = __c2v_condition_20
	}
	if __c2v_condition_15 {
		return unsafe { nil }
	}
	for i = 0; i < nargs; i++ {
		if pq_put_int(args[i].len, usize(4), conn) {
			return unsafe { nil }
		}
		if args[i].len == -1 {
			continue
		}
		if args[i].isint {
			if pq_put_int(args[i].u.integer, usize(args[i].len), conn) {
				return unsafe { nil }
			}
		} else {
			if pq_putnchar(voidptr(args[i].u.ptr), usize(args[i].len), conn) {
				return unsafe { nil }
			}
		}
	}
	if pq_put_int(1, usize(2), conn) < 0 {
		return unsafe { nil }
	}
	if pq_put_msg_end(conn) < 0 || pq_flush_vdup1(conn) {
		return unsafe { nil }
	}
	for {
		if need_input {
			if pq_wait(1, 0, conn) || pq_read_data(conn) < 0 {
				break
			}
		}
		need_input = (1 != 0)
		conn.inCursor = conn.inStart
		if pq_getc(&id, conn) {
			continue
		}
		if pq_get_int(&msg_length, usize(4), conn) {
			continue
		}
		if msg_length < 4 {
			handle_sync_loss(conn, i8(id), msg_length)
			break
		}
		mut __c2v_condition_21 := false
		mut __c2v_condition_22 := false
		__c2v_condition_22 = msg_length > 30000
		if __c2v_condition_22 {
			__c2v_condition_22 = !(i32(id) == i8(`d`) || i32(id) == i8(`D`) || i32(id) == i8(`E`) || i32(id) == i8(`V`) || i32(id) == i8(`N`) || i32(id) == i8(`A`) || i32(id) == i8(`T`) || i32(id) == i8(`t`))
		}
		__c2v_condition_21 = __c2v_condition_22
		if __c2v_condition_21 {
			handle_sync_loss(conn, i8(id), msg_length)
			break
		}
		msg_length -= 4
		avail = conn.inEnd - conn.inCursor
		if avail < msg_length {
			if pq_check_in_buffer_space(usize(conn.inCursor) + usize(msg_length), conn) {
				handle_fatal_error(conn)
				break
			}
			continue
		}
		match i32(id) {
			i32(`V`) {
				if pq_get_int(actual_result_len, usize(4), conn) {
					continue
				}
				if (unsafe { *actual_result_len }) != -1 {
					if result_is_int {
						if pq_get_int(result_buf, usize((unsafe { *actual_result_len })), conn) {
							continue
						}
					} else {
						if buf_size != -1 && (unsafe { *actual_result_len }) > buf_size {
							libpq_append_conn_error(conn, c'server returned too much data')
							handle_fatal_error(conn)
							return pq_prepare_async_result(conn)
						}
						if pq_getnchar(voidptr(result_buf), usize((unsafe { *actual_result_len })), conn) {
							continue
						}
					}
				}
				status = ExecStatusType.pgres_command_ok
			}
			i32(`E`) {
				if pq_get_error_notice3(conn, (1 != 0)) {
					continue
				}
				status = ExecStatusType.pgres_fatal_error
			}
			i32(`A`) {
				if get_notify(conn) {
					continue
				}
			}
			i32(`N`) {
				if pq_get_error_notice3(conn, (0 != 0)) {
					continue
				}
			}
			i32(`Z`) {
				if get_ready_for_query(conn) {
					continue
				}
				pq_parse_done(conn, conn.inStart + 5 + msg_length)
				if !(usize(conn.result) != usize((voidptr(0))) || i32(conn.error_result)) {
					if u32(status) == u32(ExecStatusType.pgres_command_ok) {
						conn.result = pq_make_empty_pg_result(conn, status)
						if isnil(conn.result) {
							libpq_append_conn_error(conn, c'out of memory')
							pq_save_error_result(conn)
						}
					} else {
						libpq_append_conn_error(conn, c'protocol error: no function result')
						pq_save_error_result(conn)
					}
				}
				return pq_prepare_async_result(conn)
			}
			i32(`S`) {
				if get_parameter_status(conn) {
					continue
				}
			}
			else {
				libpq_append_conn_error(conn, c'protocol error: id=0x%x', i32(id))
				pq_save_error_result(conn)
				conn.inStart += 5 + msg_length
				return pq_prepare_async_result(conn)
			}
		}

		if i32(conn.error_result) && u32(conn.status) == u32(ConnStatusType.connection_bad) {
			return pq_prepare_async_result(conn)
		}
		pq_parse_done(conn, conn.inStart + 5 + msg_length)
		need_input = (0 != 0)
	}
	pq_save_error_result(conn)
	return pq_prepare_async_result(conn)
}

@[export: 'pqBuildStartupPacket3']
@[markused]
pub fn pq_build_startup_packet3(conn &PGconn, packetlen &i32, options &PQEnvironmentOption) &i8 {
	startpacket := &i8(0)
	len := usize(0)
	len = build_startup_packet(conn, (voidptr(0)), options)
	if len == usize(0) || len > usize(2147483647) {
		return unsafe { nil }
	}
	unsafe { *packetlen = i32(len) }
	startpacket = &i8(C.c2v_malloc(u64((unsafe { *packetlen }))))
	if isnil(startpacket) {
		return unsafe { nil }
	}
	len = build_startup_packet(conn, startpacket, options)

	return startpacket
}

@[markused]
pub fn build_startup_packet(conn &PGconn, packet &i8, options &PQEnvironmentOption) usize {
	packet_len := usize(0)
	next_eo := &PQEnvironmentOption(0)
	val := &i8(0)
	if packet {
		pv := c2v_builtin_bswap32(conn.pversion)
		C.c2v_memcpy(voidptr(packet + packet_len), voidptr(&pv), sizeof(ProtocolVersion))
	}
	packet_len += sizeof(ProtocolVersion)
	if !isnil(conn.pguser) && i32(conn.pguser[0]) {
		for {
			if packet {
				C.c2v_strcpy(packet + packet_len, c'user')
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(c'user') + u64(1), &packet_len) {
				return usize(0)
			}
			if packet {
				C.c2v_strcpy(packet + packet_len, conn.pguser)
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(conn.pguser) + u64(1), &packet_len) {
				return usize(0)
			}
			break
		}
	}
	if !isnil(conn.dbName) && i32(conn.dbName[0]) {
		for {
			if packet {
				C.c2v_strcpy(packet + packet_len, c'database')
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(c'database') + u64(1), &packet_len) {
				return usize(0)
			}
			if packet {
				C.c2v_strcpy(packet + packet_len, conn.dbName)
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(conn.dbName) + u64(1), &packet_len) {
				return usize(0)
			}
			break
		}
	}
	if !isnil(conn.replication) && i32(conn.replication[0]) {
		for {
			if packet {
				C.c2v_strcpy(packet + packet_len, c'replication')
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(c'replication') + u64(1), &packet_len) {
				return usize(0)
			}
			if packet {
				C.c2v_strcpy(packet + packet_len, conn.replication)
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(conn.replication) + u64(1), &packet_len) {
				return usize(0)
			}
			break
		}
	}
	if !isnil(conn.pgoptions) && i32(conn.pgoptions[0]) {
		for {
			if packet {
				C.c2v_strcpy(packet + packet_len, c'options')
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(c'options') + u64(1), &packet_len) {
				return usize(0)
			}
			if packet {
				C.c2v_strcpy(packet + packet_len, conn.pgoptions)
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(conn.pgoptions) + u64(1), &packet_len) {
				return usize(0)
			}
			break
		}
	}
	if conn.send_appname {
		val = if conn.appname { conn.appname } else { conn.fbappname }
		if !isnil(val) && i32(val[0]) {
			for {
				if packet {
					C.c2v_strcpy(packet + packet_len, c'application_name')
				}
				if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(c'application_name') + u64(1), &packet_len) {
					return usize(0)
				}
				if packet {
					C.c2v_strcpy(packet + packet_len, val)
				}
				if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(val) + u64(1), &packet_len) {
					return usize(0)
				}
				break
			}
		}
	}
	if !isnil(conn.client_encoding_initial) && i32(conn.client_encoding_initial[0]) {
		for {
			if packet {
				C.c2v_strcpy(packet + packet_len, c'client_encoding')
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(c'client_encoding') + u64(1), &packet_len) {
				return usize(0)
			}
			if packet {
				C.c2v_strcpy(packet + packet_len, conn.client_encoding_initial)
			}
			if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(conn.client_encoding_initial) + u64(1), &packet_len) {
				return usize(0)
			}
			break
		}
	}
	for next_eo = options; next_eo.envName; next_eo = unsafe { next_eo + 1 } {
		val = C.c2v_getenv(next_eo.envName)
		if usize(val) != usize((voidptr(0))) {
			if pg_strcasecmp(val, c'default') != 0 {
				for {
					if packet {
						C.c2v_strcpy(packet + packet_len, next_eo.pgName)
					}
					if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(next_eo.pgName) + u64(1), &packet_len) {
						return usize(0)
					}
					if packet {
						C.c2v_strcpy(packet + packet_len, val)
					}
					if libpq_fe_protocol3_pg_add_size_overflow(packet_len, C.c2v_strlen(val) + u64(1), &packet_len) {
						return usize(0)
					}
					break
				}
			}
		}
	}
	if packet {
		packet[packet_len] = i8(`\0`)
	}
	if libpq_fe_protocol3_pg_add_size_overflow(packet_len, usize(1), &packet_len) {
		return usize(0)
	}
	return usize(packet_len)
}
