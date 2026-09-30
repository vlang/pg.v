@[translated]
module libpq

@[typedef]
struct C.va_list {}

@[c: 'va_start']
fn C.c2v_va_start(C.va_list, ...)

@[c: 'va_end']
fn C.c2v_va_end(C.va_list)

@[c: 'va_copy']
fn C.c2v_va_copy(C.va_list, C.va_list)

pub type C2vFn_666e2028766f69647074722c20265047726573756c7429 = fn (voidptr, &PGresult)

pub type C2vFn_666e2028766f69647074722c2026693829 = fn (voidptr, &i8)

@[markused]
pub fn pg_sub_s16_overflow(a Int16, b Int16, result &Int16) bool {
	res := Int32(a) - Int32(b)
	if res > 32767 || res < -32768 {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(res) }
	return false != 0
}

@[markused]
pub fn pg_mul_s16_overflow(a Int16, b Int16, result &Int16) bool {
	res := Int32(a) * Int32(b)
	if res > 32767 || res < -32768 {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(res) }
	return false != 0
}

@[markused]
pub fn pg_neg_s16_overflow(a Int16, result &Int16) bool {
	if (i64((i32(a) == -32768) != 0)) {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(-i32(a)) }
	return false != 0
}

@[markused]
pub fn pg_abs_s16(a Int16) Uint16 {
	return Uint16(C.c2v_abs(Int32(a)))
}

@[markused]
pub fn pg_add_s32_overflow(a Int32, b Int32, result &Int32) bool {
	res := Int64(a) + Int64(b)
	if res > Int64(2147483647) || res < Int64((-2147483647 - 1)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn pg_sub_s32_overflow(a Int32, b Int32, result &Int32) bool {
	res := Int64(a) - Int64(b)
	if res > Int64(2147483647) || res < Int64((-2147483647 - 1)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn pg_mul_s32_overflow(a Int32, b Int32, result &Int32) bool {
	res := Int64(a) * Int64(b)
	if res > Int64(2147483647) || res < Int64((-2147483647 - 1)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn pg_neg_s32_overflow(a Int32, result &Int32) bool {
	if (i64((a == (-2147483647 - 1)) != 0)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = -a }
	return false != 0
}

@[markused]
pub fn pg_abs_s32(a Int32) Uint32 {
	return Uint32((Int64(C.c2v_labs(i64(Int64(a))))))
}

@[markused]
pub fn pg_add_s64_overflow(a Int64, b Int64, result &Int64) bool {
	res := c2v_u128_add(c2v_i128(i64(a)), c2v_i128(i64(b)))
	if c2v_i128_cmp(res, c2v_i128(i64(9223372036854775807))) > 0 || c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0 {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn pg_sub_s64_overflow(a Int64, b Int64, result &Int64) bool {
	res := c2v_u128_sub(c2v_i128(i64(a)), c2v_i128(i64(b)))
	if c2v_i128_cmp(res, c2v_i128(i64(9223372036854775807))) > 0 || c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0 {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn pg_mul_s64_overflow(a Int64, b Int64, result &Int64) bool {
	res := c2v_u128_mul(c2v_i128(i64(a)), c2v_i128(i64(b)))
	if c2v_i128_cmp(res, c2v_i128(i64(9223372036854775807))) > 0 || c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0 {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn pg_neg_s64_overflow(a Int64, result &Int64) bool {
	if (i64((a == (-9223372036854775807 - i64(1))) != 0)) {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = -a }
	return false != 0
}

@[markused]
pub fn pg_abs_s64(a Int64) Uint64 {
	if (i64((a == (-9223372036854775807 - i64(1))) != 0)) {
		return Uint64(9223372036854775807) + Uint64(1)
	}
	return Uint64((Int64(C.c2v_labs(i64(a)))))
}

@[markused]
pub fn pg_add_u16_overflow(a Uint16, b Uint16, result &Uint16) bool {
	res := Uint16(i32(a) + i32(b))
	if i32(res) < i32(a) {
		unsafe { *result = Uint16(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn pg_sub_u16_overflow(a Uint16, b Uint16, result &Uint16) bool {
	if i32(b) > i32(a) {
		unsafe { *result = Uint16(24301) }
		return true != 0
	}
	unsafe { *result = Uint16(i32(a) - i32(b)) }
	return false != 0
}

@[markused]
pub fn pg_mul_u16_overflow(a Uint16, b Uint16, result &Uint16) bool {
	res := Uint32(a) * Uint32(b)
	if res > Uint32(65535) {
		unsafe { *result = Uint16(24301) }
		return true != 0
	}
	unsafe { *result = Uint16(res) }
	return false != 0
}

@[markused]
pub fn pg_neg_u16_overflow(a Uint16, result &Int16) bool {
	res := -(Int32(a))
	if (i64((res < -32768) != 0)) {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(res) }
	return false != 0
}

@[markused]
pub fn pg_add_u32_overflow(a Uint32, b Uint32, result &Uint32) bool {
	res := a + b
	if res < a {
		unsafe { *result = Uint32(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn pg_sub_u32_overflow(a Uint32, b Uint32, result &Uint32) bool {
	if b > a {
		unsafe { *result = Uint32(24301) }
		return true != 0
	}
	unsafe { *result = a - b }
	return false != 0
}

@[markused]
pub fn pg_mul_u32_overflow(a Uint32, b Uint32, result &Uint32) bool {
	res := Uint64(a) * Uint64(b)
	if res > Uint64(u32(4294967295)) {
		unsafe { *result = Uint32(24301) }
		return true != 0
	}
	unsafe { *result = Uint32(res) }
	return false != 0
}

@[markused]
pub fn pg_neg_u32_overflow(a Uint32, result &Int32) bool {
	res := -(Int64(a))
	if (i64((res < Int64((-2147483647 - 1))) != 0)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn pg_add_u64_overflow(a Uint64, b Uint64, result &Uint64) bool {
	res := a + b
	if res < a {
		unsafe { *result = Uint64(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn pg_sub_u64_overflow(a Uint64, b Uint64, result &Uint64) bool {
	if b > a {
		unsafe { *result = Uint64(24301) }
		return true != 0
	}
	unsafe { *result = a - b }
	return false != 0
}

@[markused]
pub fn pg_mul_u64_overflow(a Uint64, b Uint64, result &Uint64) bool {
	res := c2v_u128_mul(c2v_u128(u64(a)), c2v_u128(u64(b)))
	if c2v_u128_cmp(res, c2v_u128(u64(u64(18446744073709551615)))) > 0 {
		unsafe { *result = Uint64(24301) }
		return true != 0
	}
	unsafe { *result = Uint64(res.lo) }
	return false != 0
}

@[markused]
pub fn pg_neg_u64_overflow(a Uint64, result &Int64) bool {
	res := c2v_u128_neg((c2v_u128(u64(a))))
	if (i64((c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0) != 0)) {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn pg_add_size_overflow(a usize, b usize, result &usize) bool {
	res := a + b
	if res < a {
		unsafe { *result = usize(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn pg_sub_size_overflow(a usize, b usize, result &usize) bool {
	if b > a {
		unsafe { *result = usize(24301) }
		return true != 0
	}
	unsafe { *result = a - b }
	return false != 0
}

@[markused]
pub fn pg_mul_size_overflow(a usize, b usize, result &usize) bool {
	res := a * b
	if a != usize(0) && b != res / a {
		unsafe { *result = usize(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn pg_cmp_s16(a Int16, b Int16) i32 {
	return Int32(a) - Int32(b)
}

@[markused]
pub fn pg_cmp_u16(a Uint16, b Uint16) i32 {
	return Int32(a) - Int32(b)
}

@[markused]
pub fn pg_cmp_s32(a Int32, b Int32) i32 {
	return i32((a > b)) - i32((a < b))
}

@[markused]
pub fn pg_cmp_u32(a Uint32, b Uint32) i32 {
	return i32((a > b)) - i32((a < b))
}

@[markused]
pub fn pg_cmp_s64(a Int64, b Int64) i32 {
	return i32((a > b)) - i32((a < b))
}

@[markused]
pub fn pg_cmp_u64(a Uint64, b Uint64) i32 {
	return i32((a > b)) - i32((a < b))
}

@[markused]
pub fn pg_cmp_size(a usize, b usize) i32 {
	return i32((a > b)) - i32((a < b))
}

pub type PGcancelConn_fe_exec = Pg_cancel_conn

pub type PGcancel_fe_exec = Pg_cancel

@[markused]
pub fn libpq_fe_exec_is_unixsock_path(path &i8) bool {
	return (i32(path[false]) == i8(`/`)) || i32(path[false]) == i8(`@`)
}

@[markused]
pub fn libpq_fe_exec_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_fe_exec_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_fe_exec_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_fe_exec_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_fe_exec_utf8_to_unicode(c &u8) Pg_wchar {
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
pub fn libpq_fe_exec_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
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
pub fn libpq_fe_exec_unicode_utf8len(c Pg_wchar) i32 {
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

@[export: 'PQmakeEmptyPGresult']
@[markused]
pub fn pq_make_empty_pg_result(conn &PGconn, status ExecStatusType) &PGresult {
	result := &PGresult(0)
	result = &PGresult(C.c2v_malloc(sizeof(PGresult)))
	if isnil(result) {
		return unsafe { nil }
	}
	result.ntups = 0
	result.numAttributes = 0
	result.attDescs = unsafe { nil }
	result.tuples = unsafe { nil }
	result.tupArrSize = 0
	result.numParameters = 0
	result.paramDescs = unsafe { nil }
	result.resultStatus = status
	result.cmdStatus[0] = i8(`\0`)
	result.binary = 0
	result.events = unsafe { nil }
	result.nEvents = 0
	result.errMsg = unsafe { nil }
	result.errFields = unsafe { nil }
	result.errQuery = unsafe { nil }
	result.null_field[0] = i8(`\0`)
	result.curBlock = unsafe { nil }
	result.curOffset = 0
	result.spaceLeft = 0
	result.memorySize = sizeof(PGresult)
	if conn {
		result.noticeHooks = conn.noticeHooks
		result.client_encoding = conn.client_encoding
		match status {
			.pgres_empty_query, .pgres_command_ok, .pgres_tuples_ok, .pgres_copy_out, .pgres_copy_in, .pgres_copy_both, .pgres_single_tuple, .pgres_tuples_chunk {
			}
			else {
				pq_set_result_error(result, &conn.errorMessage, 0)
			}
		}

		if conn.nEvents > 0 {
			result.events = dup_events(conn.events, conn.nEvents, &result.memorySize)
			if isnil(result.events) {
				pq_clear(result)
				return unsafe { nil }
			}
			result.nEvents = conn.nEvents
		}
	} else {
		result.noticeHooks.noticeRec = C2vFn_666e2028766f69647074722c20265047726573756c7429(voidptr(0))
		result.noticeHooks.noticeRecArg = unsafe { nil }
		result.noticeHooks.noticeProc = C2vFn_666e2028766f69647074722c2026693829(voidptr(0))
		result.noticeHooks.noticeProcArg = unsafe { nil }
		result.client_encoding = Pg_enc.pg_sql_ascii
	}
	return result
}

@[export: 'PQsetResultAttrs']
@[markused]
pub fn pq_set_result_attrs(res &PGresult, num_attributes i32, att_descs &PGresAttDesc) i32 {
	i := i32(0)
	if isnil(res) || usize(&PGresult(res)) == usize(&libpq_fe_exec_oom_result) {
		return 0
	}
	if res.numAttributes > 0 {
		return 0
	}
	if num_attributes <= 0 || isnil(att_descs) {
		return 1
	}
	res.attDescs = &PGresAttDesc(pq_result_alloc(res, u64(num_attributes) * sizeof(PGresAttDesc)))
	if isnil(res.attDescs) {
		return 0
	}
	res.numAttributes = num_attributes
	C.c2v_memcpy(voidptr(res.attDescs), voidptr(att_descs), u64(num_attributes) * sizeof(PGresAttDesc))
	res.binary = 1
	for i = 0; i < res.numAttributes; i++ {
		if res.attDescs[i].name {
			res.attDescs[i].name = pq_result_strdup(res, res.attDescs[i].name)
		} else {
			res.attDescs[i].name = unsafe { &res.null_field[0] }
		}
		if isnil(res.attDescs[i].name) {
			return 0
		}
		if res.attDescs[i].format == 0 {
			res.binary = 0
		}
	}
	return 1
}

@[export: 'PQcopyResult']
@[markused]
pub fn pq_copy_result(src &PGresult, flags i32) &PGresult {
	dest := &PGresult(0)
	i := i32(0)
	if isnil(src) {
		return unsafe { nil }
	}
	dest = pq_make_empty_pg_result((voidptr(0)), ExecStatusType(ExecStatusType.pgres_tuples_ok))
	if isnil(dest) {
		return unsafe { nil }
	}
	dest.client_encoding = src.client_encoding
	C.c2v_strcpy(unsafe { &i8(&dest.cmdStatus[0]) }, unsafe { &i8(&src.cmdStatus[0]) })
	if flags & (1 | 2) {
		if !pq_set_result_attrs(dest, src.numAttributes, src.attDescs) {
			pq_clear(dest)
			return unsafe { nil }
		}
	}
	if flags & 2 {
		tup := i32(0)
		field := i32(0)

		for tup = 0; tup < src.ntups; tup++ {
			for field = 0; field < src.numAttributes; field++ {
				if !pq_setvalue(dest, tup, field, src.tuples[tup][field].value, src.tuples[tup][field].len) {
					pq_clear(dest)
					return unsafe { nil }
				}
			}
		}
	}
	if flags & 8 {
		dest.noticeHooks = src.noticeHooks
	}
	if (flags & 4) && src.nEvents > 0 {
		dest.events = dup_events(src.events, src.nEvents, &dest.memorySize)
		if isnil(dest.events) {
			pq_clear(dest)
			return unsafe { nil }
		}
		dest.nEvents = src.nEvents
	}
	for i = 0; i < dest.nEvents; i++ {
		if src.events[i].resultInitialized {
			evt := PGEventResultCopy{}
			evt.src = src
			evt.dest = dest
			if dest.events[i].proc(PGEventId(PGEventId.pgevt_resultcopy), voidptr(&evt), voidptr(dest.events[i].passThrough)) {
				dest.events[i].resultInitialized = (1 != 0)
			}
		}
	}
	return dest
}

@[markused]
pub fn dup_events(events &PGEvent, count i32, mem_size &usize) &PGEvent {
	mut new_events := &PGEvent(0)
	msize := usize(0)
	i := i32(0)
	if isnil(events) || count <= 0 {
		return unsafe { nil }
	}
	msize = u64(count) * sizeof(PGEvent)
	new_events = &PGEvent(C.c2v_malloc(msize))
	if isnil(new_events) {
		return unsafe { nil }
	}
	for i = 0; i < count; i++ {
		new_events[i].proc = events[i].proc
		new_events[i].passThrough = events[i].passThrough
		new_events[i].data = unsafe { nil }
		new_events[i].resultInitialized = (0 != 0)
		new_events[i].name = C.c2v_strdup(events[i].name)
		if isnil(new_events[i].name) {
			for {
				i--
				if !(i >= 0) {
					break
				}
				C.c2v_free(voidptr(new_events[i].name))
			}
			C.c2v_free(voidptr(new_events))
			return unsafe { nil }
		}
		msize += C.c2v_strlen(events[i].name) + u64(1)
	}
	unsafe { *mem_size += msize }
	return new_events
}

@[export: 'PQsetvalue']
@[markused]
pub fn pq_setvalue(res &PGresult, tup_num i32, field_num i32, value &i8, len i32) i32 {
	attval := &PGresAttValue(0)
	errmsg := unsafe { &i8(nil) }
	if isnil(res) || usize(&PGresult(res)) == usize(&libpq_fe_exec_oom_result) {
		return 0
	}
	if !check_field_number(res, field_num) {
		return 0
	}
	if tup_num < 0 || tup_num > res.ntups {
		pq_internal_notice(&res.noticeHooks, c'row number %d is out of range 0..%d', tup_num, res.ntups)
		return 0
	}
	if tup_num == res.ntups {
		mut tup := &PGresAttValue(0)
		i := i32(0)
		tup = &PGresAttValue(pq_result_alloc_vdup0(res, u64(res.numAttributes) * sizeof(PGresAttValue), (1 != 0)))
		if isnil(tup) {
			unsafe {
				goto fail
			}
		}
		for i = 0; i < res.numAttributes; i++ {
			tup[i].len = (-1)
			tup[i].value = unsafe { &res.null_field[0] }
		}
		if !pq_add_tuple(res, tup, &&u8(&&i8(c2v_address_of(&errmsg)))) {
			unsafe {
				goto fail
			}
		}
	}
	attval = unsafe { res.tuples[tup_num] + field_num }
	if len == (-1) || usize(value) == usize((voidptr(0))) {
		attval.len = (-1)
		attval.value = unsafe { &res.null_field[0] }
	} else if len <= 0 {
		attval.len = 0
		attval.value = unsafe { &res.null_field[0] }
	} else {
		attval.value = &i8(pq_result_alloc_vdup0(res, usize(len) + usize(1), (1 != 0)))
		if isnil(attval.value) {
			unsafe {
				goto fail
			}
		}
		attval.len = len
		C.c2v_memcpy(voidptr(attval.value), voidptr(value), u64(len))
		attval.value[len] = i8(`\0`)
	}
	return 1
	fail:
	if isnil(errmsg) {
		errmsg = unsafe { &c'out of memory'[0] }
	}
	pq_internal_notice(&res.noticeHooks, c'%s', voidptr(errmsg))
	return 0
}

@[export: 'PQresultAlloc']
@[markused]
pub fn pq_result_alloc(res &PGresult, n_bytes usize) voidptr {
	if isnil(res) || usize(&PGresult(res)) == usize(&libpq_fe_exec_oom_result) {
		return unsafe { nil }
	}
	return pq_result_alloc_vdup0(res, n_bytes, (1 != 0))
}

@[export: 'pqResultAlloc']
@[markused]
pub fn pq_result_alloc_vdup0(res &PGresult, n_bytes usize, is_binary bool) voidptr {
	space := &i8(0)
	block := &PGresult_data(0)
	if isnil(res) {
		return unsafe { nil }
	}
	if n_bytes <= usize(0) {
		return unsafe { &res.null_field[0] }
	}
	if is_binary {
		offset := res.curOffset % 8
		if offset {
			res.curOffset += 8 - offset
			res.spaceLeft -= 8 - offset
		}
	}
	if n_bytes <= usize(res.spaceLeft) {
		space = unsafe { &res.curBlock.space[0] } + res.curOffset
		res.curOffset += n_bytes
		res.spaceLeft -= n_bytes
		return space
	}
	if n_bytes >= usize((2048 / 2)) {
		alloc_size := usize(0)
		if n_bytes > u64(18446744073709551615) - (if (sizeof(PGresult_data)) > u64(8) {
			(sizeof(PGresult_data))
		} else {
			u64(8)
		}) {
			return unsafe { nil }
		}
		alloc_size = n_bytes + (if (sizeof(PGresult_data)) > u64(8) {
			(sizeof(PGresult_data))
		} else {
			u64(8)
		})
		block = &PGresult_data(C.c2v_malloc(alloc_size))
		if isnil(block) {
			return unsafe { nil }
		}
		res.memorySize += alloc_size
		space = unsafe { &block.space[0] } + (if (sizeof(PGresult_data)) > u64(8) {
			(sizeof(PGresult_data))
		} else {
			u64(8)
		})
		if res.curBlock {
			block.next = res.curBlock.next
			res.curBlock.next = block
		} else {
			block.next = unsafe { nil }
			res.curBlock = block
			res.spaceLeft = 0
		}
		return space
	}
	block = &PGresult_data(C.c2v_malloc(u64(2048)))
	if isnil(block) {
		return unsafe { nil }
	}
	res.memorySize += usize(2048)
	block.next = res.curBlock
	res.curBlock = block
	if is_binary {
		res.curOffset = i32((if (sizeof(PGresult_data)) > u64(8) {
			(sizeof(PGresult_data))
		} else {
			u64(8)
		}))
		res.spaceLeft = i32(u64(2048) - (if (sizeof(PGresult_data)) > u64(8) {
			(sizeof(PGresult_data))
		} else {
			u64(8)
		}))
	} else {
		res.curOffset = i32(sizeof(PGresult_data))
		res.spaceLeft = i32(u64(2048) - sizeof(PGresult_data))
	}
	space = unsafe { &block.space[0] } + res.curOffset
	res.curOffset += n_bytes
	res.spaceLeft -= n_bytes
	return space
}

@[export: 'PQresultMemorySize']
@[markused]
pub fn pq_result_memory_size(res &PGresult) usize {
	if isnil(res) {
		return usize(0)
	}
	return usize(res.memorySize)
}

@[export: 'pqResultStrdup']
@[markused]
pub fn pq_result_strdup(res &PGresult, str &i8) &i8 {
	space := &i8(pq_result_alloc_vdup0(res, C.c2v_strlen(str) + u64(1), (0 != 0)))
	if space {
		C.c2v_strcpy(space, str)
	}
	return space
}

@[export: 'pqSetResultError']
@[markused]
pub fn pq_set_result_error(res &PGresult, error_message PQExpBuffer, offset i32) {
	msg := &i8(0)
	if isnil(res) {
		return
	}
	if !(usize(voidptr(error_message)) == usize(voidptr((voidptr(0)))) || error_message.maxlen == usize(0)) {
		msg = pq_result_strdup(res, error_message.data + offset)
	} else {
		msg = unsafe { nil }
	}
	if msg {
		res.errMsg = msg
	} else {
		res.errMsg = unsafe { &c'out of memory\n'[0] }
	}
}

@[export: 'PQclear']
@[markused]
pub fn pq_clear(res &PGresult) {
	block := &PGresult_data(0)
	i := i32(0)
	if isnil(res) {
		return
	}
	if usize(&PGresult(res)) == usize(&libpq_fe_exec_oom_result) {
		return
	}
	for i = 0; i < res.nEvents; i++ {
		if res.events[i].resultInitialized {
			evt := PGEventResultDestroy{}
			evt.result = res
			res.events[i].proc(PGEventId(PGEventId.pgevt_resultdestroy), voidptr(&evt), voidptr(res.events[i].passThrough))
		}
		C.c2v_free(voidptr(res.events[i].name))
	}
	C.c2v_free(voidptr(res.events))
	for {
		block = res.curBlock
		if !(usize(block) != usize((voidptr(0)))) {
			break
		}
		res.curBlock = block.next
		C.c2v_free(voidptr(block))
	}
	C.c2v_free(voidptr(res.tuples))
	res.attDescs = unsafe { nil }
	res.tuples = unsafe { nil }
	res.paramDescs = unsafe { nil }
	res.errFields = unsafe { nil }
	res.events = unsafe { nil }
	res.nEvents = 0
	C.c2v_free(voidptr(res))
}

@[export: 'pqClearAsyncResult']
@[markused]
pub fn pq_clear_async_result(conn &PGconn) {
	pq_clear(conn.result)
	conn.result = unsafe { nil }
	conn.error_result = (0 != 0)
	pq_clear(conn.saved_result)
	conn.saved_result = unsafe { nil }
}

@[export: 'pqSaveErrorResult']
@[markused]
pub fn pq_save_error_result(conn &PGconn) {
	pq_clear_async_result(conn)
	conn.error_result = (1 != 0)
}

@[markused]
pub fn pq_save_write_error(conn &PGconn) {
	if conn.write_err_msg {
		append_pq_exp_buffer_str(&conn.errorMessage, conn.write_err_msg)
		conn.write_err_msg[0] = i8(`\0`)
	} else {
		libpq_append_conn_error(conn, c'write to server failed')
	}
	pq_save_error_result(conn)
}

@[export: 'pqPrepareAsyncResult']
@[markused]
pub fn pq_prepare_async_result(conn &PGconn) &PGresult {
	res := &PGresult(0)
	res = conn.result
	if res {
		if u32(res.resultStatus) == u32(ExecStatusType.pgres_fatal_error) {
			conn.errorReported = i32(conn.errorMessage.len)
		}
	} else {
		if !conn.error_result {
			libpq_append_conn_error(conn, c'no error text available')
		}
		if conn.errorReported < 0 || usize(conn.errorReported) >= conn.errorMessage.len {
			conn.errorReported = 0
		}
		res = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_empty_query))
		if res {
			res.resultStatus = ExecStatusType.pgres_fatal_error
			pq_set_result_error(res, &conn.errorMessage, conn.errorReported)
			conn.errorReported = i32(conn.errorMessage.len)
		} else {
			res = (if true {
				&PGresult((&libpq_fe_exec_oom_result))
			} else {
				unsafe { nil }
			})
		}
	}
	conn.result = conn.saved_result
	conn.error_result = (0 != 0)
	conn.saved_result = unsafe { nil }
	return res
}

@[c: 'pqInternalNotice']
@[c2v_variadic; markused]
pub fn pq_internal_notice(hooks &PGNoticeHooks, fmt &i8, ...) {
	msg_buf := [1024]i8{}
	args := C.va_list{}
	res := &PGresult(0)
	if hooks.noticeRec == (voidptr(0)) {
		return
	}
	C.c2v_va_start(args, fmt)
	pg_vsnprintf(unsafe { &i8(&msg_buf[0]) }, sizeof([1024]i8), fmt, args)
	C.c2v_va_end(args)
	msg_buf[sizeof([1024]i8) - u64(1)] = i8(`\0`)
	res = pq_make_empty_pg_result((voidptr(0)), ExecStatusType(ExecStatusType.pgres_nonfatal_error))
	if isnil(res) {
		return
	}
	res.noticeHooks = unsafe { *hooks }
	pq_save_message_field(res, i8(`M`), unsafe { &i8(&msg_buf[0]) })
	pq_save_message_field(res, i8(`S`), unsafe { &i8(&c'NOTICE'[0]) })
	pq_save_message_field(res, i8(`V`), c'NOTICE')
	res.errMsg = &i8(pq_result_alloc_vdup0(res, C.c2v_strlen(unsafe { &i8(&msg_buf[0]) }) + u64(2), (0 != 0)))
	if res.errMsg {
		pg_sprintf(res.errMsg, c'%s\n', unsafe { voidptr(&msg_buf[0]) })
	} else {
		res.errMsg = unsafe { &c'out of memory\n'[0] }
	}
	res.noticeHooks.noticeRec(voidptr(res.noticeHooks.noticeRecArg), res)
	pq_clear(res)
}

@[markused]
pub fn pq_add_tuple(res &PGresult, tup &PGresAttValue, errmsgp &&u8) bool {
	if res.ntups >= res.tupArrSize {
		new_size := i32(0)
		new_tuples := &&PGresAttValue(0)
		if res.tupArrSize <= 2147483647 / 2 {
			new_size = if (res.tupArrSize > 0) { res.tupArrSize * 2 } else { 128 }
		} else if res.tupArrSize < 2147483647 {
			new_size = 2147483647
		} else {
			unsafe { *errmsgp = &c'PGresult cannot support more than INT_MAX tuples'[0] }
			return false != 0
		}
		if usize(res.tuples) == usize((voidptr(0))) {
			new_tuples = &&PGresAttValue(C.c2v_malloc(u64(new_size) * sizeof(voidptr)))
		} else {
			new_tuples = &&PGresAttValue(C.c2v_realloc(voidptr(res.tuples), u64(new_size) * sizeof(voidptr)))
		}
		if isnil(new_tuples) {
			return false != 0
		}
		res.memorySize += u64((new_size - res.tupArrSize)) * sizeof(voidptr)
		res.tupArrSize = new_size
		res.tuples = new_tuples
	}
	res.tuples[res.ntups] = tup
	res.ntups++
	return true != 0
}

@[export: 'pqSaveMessageField']
@[markused]
pub fn pq_save_message_field(res &PGresult, code i8, value &i8) {
	pfield := &PGMessageField(0)
	pfield = &PGMessageField(pq_result_alloc_vdup0(res, (u64(usize(__offsetof(PGMessageField, contents)))) + C.c2v_strlen(value) + u64(1), (1 != 0)))
	if isnil(pfield) {
		return
	}
	pfield.code = code
	C.c2v_strcpy(unsafe { &i8(&pfield.contents[0]) }, value)
	pfield.next = res.errFields
	res.errFields = pfield
}

@[export: 'pqSaveParameterStatus']
@[markused]
pub fn pq_save_parameter_status(conn &PGconn, name &i8, value &i8) i32 {
	pstatus := &PgParameterStatus(0)
	prev := &PgParameterStatus(0)
	pstatus = conn.pstatus
	for prev = (voidptr(0)); usize(pstatus) != usize((voidptr(0)));  {
		if C.c2v_strcmp(pstatus.name, name) == 0 {
			if prev {
				prev.next = pstatus.next
			} else {
				conn.pstatus = pstatus.next
			}
			C.c2v_free(voidptr(pstatus))
			break
		}
		prev = pstatus
		pstatus = pstatus.next
	}
	pstatus = &PgParameterStatus(C.c2v_malloc(sizeof(PgParameterStatus) + C.c2v_strlen(name) + C.c2v_strlen(value) + u64(2)))
	if pstatus {
		ptr := &i8(0)
		ptr = (&i8(voidptr(pstatus))) + sizeof(PgParameterStatus)
		pstatus.name = ptr
		C.c2v_strcpy(ptr, name)
		c2v_pointer_prefix(voidptr(&ptr), ptr, isize(C.c2v_strlen(name) + u64(1)))
		pstatus.value = ptr
		C.c2v_strcpy(ptr, value)
		pstatus.next = conn.pstatus
		conn.pstatus = pstatus
	} else {
		return 0
	}
	if C.c2v_strcmp(name, c'client_encoding') == 0 {
		conn.client_encoding = pg_char_to_encoding(value)
		if conn.client_encoding < 0 {
			conn.client_encoding = Pg_enc.pg_sql_ascii
		}
		libpq_fe_exec_static_client_encoding = conn.client_encoding
	} else if C.c2v_strcmp(name, c'standard_conforming_strings') == 0 {
		conn.std_strings = ((C.c2v_strcmp(value, c'on') == 0) != 0)
		libpq_fe_exec_static_std_strings = conn.std_strings
	} else if C.c2v_strcmp(name, c'server_version') == 0 {
		cnt := i32(0)
		vmaj := i32(0)
		vmin := i32(0)
		vrev := i32(0)

		cnt = C.c2v_sscanf(value, c'%d.%d.%d', &vmaj, &vmin, &vrev)
		if cnt == 3 {
			conn.sversion = (100 * vmaj + vmin) * 100 + vrev
		} else if cnt == 2 {
			if vmaj >= 10 {
				conn.sversion = 100 * 100 * vmaj + vmin
			} else {
				conn.sversion = (100 * vmaj + vmin) * 100
			}
		} else if cnt == 1 {
			conn.sversion = 100 * 100 * vmaj
		} else {
			conn.sversion = 0
		}
	} else if C.c2v_strcmp(name, c'default_transaction_read_only') == 0 {
		conn.default_transaction_read_only = if (C.c2v_strcmp(value, c'on') == 0) {
			PGTernaryBool.pg_bool_yes
		} else {
			PGTernaryBool.pg_bool_no
		}
	} else if C.c2v_strcmp(name, c'in_hot_standby') == 0 {
		conn.in_hot_standby = if (C.c2v_strcmp(value, c'on') == 0) {
			PGTernaryBool.pg_bool_yes
		} else {
			PGTernaryBool.pg_bool_no
		}
	} else if C.c2v_strcmp(name, c'scram_iterations') == 0 {
		conn.scram_sha_256_iterations = C.c2v_atoi(value)
	}
	return 1
}

@[export: 'pqRowProcessor']
@[markused]
pub fn pq_row_processor(conn &PGconn, errmsgp &&u8) i32 {
	res := conn.result
	nfields := res.numAttributes
	columns := conn.rowBuf
	mut tup := &PGresAttValue(0)
	i := i32(0)
	if i32(conn.partialResMode) && usize(conn.saved_result) == usize((voidptr(0))) {
		res = pq_copy_result(res, 1 | 4 | 8)
		if isnil(res) {
			return 0
		}
		res.resultStatus = (if i32(conn.singleRowMode) {
			ExecStatusType.pgres_single_tuple
		} else {
			ExecStatusType.pgres_tuples_chunk
		})
		conn.saved_result = conn.result
		conn.result = res
	}
	tup = &PGresAttValue(pq_result_alloc_vdup0(res, u64(nfields) * sizeof(PGresAttValue), (1 != 0)))
	if usize(tup) == usize((voidptr(0))) {
		return 0
	}
	for i = 0; i < nfields; i++ {
		clen := columns[i].len
		if clen < 0 {
			tup[i].len = (-1)
			tup[i].value = unsafe { &res.null_field[0] }
		} else {
			isbinary := ((res.attDescs[i].format != 0) != 0)
			val := &i8(0)
			val = &i8(pq_result_alloc_vdup0(res, usize(clen) + usize(1), isbinary))
			if usize(val) == usize((voidptr(0))) {
				return 0
			}
			C.c2v_memcpy(voidptr(val), voidptr(columns[i].value), u64(clen))
			val[clen] = i8(`\0`)
			tup[i].len = clen
			tup[i].value = val
		}
	}
	if !pq_add_tuple(res, tup, errmsgp) {
		return 0
	}
	if i32(conn.partialResMode) && res.ntups >= conn.maxChunkSize {
		conn.asyncStatus = PGAsyncStatusType.pgasync_ready_more
	}
	return 1
}

@[markused]
pub fn pq_alloc_cmd_queue_entry(conn &PGconn) &PGcmdQueueEntry {
	entry := &PGcmdQueueEntry(0)
	if usize(conn.cmd_queue_recycle) == usize((voidptr(0))) {
		entry = &PGcmdQueueEntry(C.c2v_malloc(sizeof(PGcmdQueueEntry)))
		if usize(entry) == usize((voidptr(0))) {
			libpq_append_conn_error(conn, c'out of memory')
			return unsafe { nil }
		}
	} else {
		entry = conn.cmd_queue_recycle
		conn.cmd_queue_recycle = entry.next
	}
	entry.next = unsafe { nil }
	entry.query = unsafe { nil }
	return entry
}

@[markused]
pub fn pq_append_cmd_queue_entry(conn &PGconn, entry &PGcmdQueueEntry) {
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		conn.cmd_queue_head = entry
	} else {
		conn.cmd_queue_tail.next = entry
	}
	conn.cmd_queue_tail = entry
	match conn.pipelineStatus {
		.pq_pipeline_off, .pq_pipeline_on {
			if u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_idle) {
				conn.asyncStatus = PGAsyncStatusType.pgasync_busy
			}
		}
		.pq_pipeline_aborted {
			if u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_idle) || u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_pipeline_idle) {
				pq_pipeline_process_queue(conn)
			}
		}
		else {}
	}
}

@[markused]
pub fn pq_recycle_cmd_queue_entry(conn &PGconn, entry &PGcmdQueueEntry) {
	if usize(entry) == usize((voidptr(0))) {
		return
	}

	if entry.query {
		C.c2v_free(voidptr(entry.query))
		entry.query = unsafe { nil }
	}
	entry.next = conn.cmd_queue_recycle
	conn.cmd_queue_recycle = entry
}

@[export: 'PQsendQuery']
@[markused]
pub fn pq_send_query(conn &PGconn, query &i8) i32 {
	return pq_send_query_internal(conn, query, (1 != 0))
}

@[export: 'PQsendQueryContinue']
@[markused]
pub fn pq_send_query_continue(conn &PGconn, query &i8) i32 {
	return pq_send_query_internal(conn, query, (0 != 0))
}

@[markused]
pub fn pq_send_query_internal(conn &PGconn, query &i8, new_query bool) i32 {
	entry := unsafe { &PGcmdQueueEntry(nil) }
	if !pq_send_query_start(conn, new_query) {
		return 0
	}
	if isnil(query) {
		libpq_append_conn_error(conn, c'command string is a null pointer')
		return 0
	}
	if u32(conn.pipelineStatus) != u32(PGpipelineStatus.pq_pipeline_off) {
		libpq_append_conn_error(conn, c'%s not allowed in pipeline mode', voidptr(c'PQsendQuery'))
		return 0
	}
	entry = pq_alloc_cmd_queue_entry(conn)
	if usize(entry) == usize((voidptr(0))) {
		return 0
	}
	if pq_put_msg_start(i8(`Q`), conn) < 0 || pq_puts(query, conn) < 0 || pq_put_msg_end(conn) < 0 {
		pq_recycle_cmd_queue_entry(conn, entry)
		return 0
	}
	entry.queryclass = PGQueryClass.pgquery_simple
	entry.query = C.c2v_strdup(query)
	if pq_flush_vdup1(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	pq_append_cmd_queue_entry(conn, entry)
	return 1
	sendFailed:
	pq_recycle_cmd_queue_entry(conn, entry)
	return 0
}

@[export: 'PQsendQueryParams']
@[markused]
pub fn pq_send_query_params(conn &PGconn, command &i8, n_params i32, param_types &Oid, param_values &&u8, param_lengths &i32, param_formats &i32, result_format i32) i32 {
	if !pq_send_query_start(conn, (1 != 0)) {
		return 0
	}
	if isnil(command) {
		libpq_append_conn_error(conn, c'command string is a null pointer')
		return 0
	}
	if n_params < 0 || n_params > 65535 {
		libpq_append_conn_error(conn, c'number of parameters must be between 0 and %d', 65535)
		return 0
	}
	return pq_send_query_guts(conn, command, c'', n_params, param_types, param_values, param_lengths, param_formats, result_format)
}

@[export: 'PQsendPrepare']
@[markused]
pub fn pq_send_prepare(conn &PGconn, stmt_name &i8, query &i8, n_params i32, param_types &Oid) i32 {
	entry := unsafe { &PGcmdQueueEntry(nil) }
	if !pq_send_query_start(conn, (1 != 0)) {
		return 0
	}
	if isnil(stmt_name) {
		libpq_append_conn_error(conn, c'statement name is a null pointer')
		return 0
	}
	if isnil(query) {
		libpq_append_conn_error(conn, c'command string is a null pointer')
		return 0
	}
	if n_params < 0 || n_params > 65535 {
		libpq_append_conn_error(conn, c'number of parameters must be between 0 and %d', 65535)
		return 0
	}
	entry = pq_alloc_cmd_queue_entry(conn)
	if usize(entry) == usize((voidptr(0))) {
		return 0
	}
	if pq_put_msg_start(i8(`P`), conn) < 0 || pq_puts(stmt_name, conn) < 0 || pq_puts(query, conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	if n_params > 0 && !isnil(param_types) {
		i := i32(0)
		if pq_put_int(n_params, usize(2), conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
		for i = 0; i < n_params; i++ {
			if pq_put_int(i32(param_types[i]), usize(4), conn) < 0 {
				unsafe {
					goto sendFailed
				}
			}
		}
	} else {
		if pq_put_int(0, usize(2), conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
	}
	if pq_put_msg_end(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	if u32(conn.pipelineStatus) == u32(PGpipelineStatus.pq_pipeline_off) {
		if pq_put_msg_start(i8(`S`), conn) < 0 || pq_put_msg_end(conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
	}
	entry.queryclass = PGQueryClass.pgquery_prepare
	entry.query = C.c2v_strdup(query)
	if pq_pipeline_flush(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	pq_append_cmd_queue_entry(conn, entry)
	return 1
	sendFailed:
	pq_recycle_cmd_queue_entry(conn, entry)
	return 0
}

@[export: 'PQsendQueryPrepared']
@[markused]
pub fn pq_send_query_prepared(conn &PGconn, stmt_name &i8, n_params i32, param_values &&u8, param_lengths &i32, param_formats &i32, result_format i32) i32 {
	if !pq_send_query_start(conn, (1 != 0)) {
		return 0
	}
	if isnil(stmt_name) {
		libpq_append_conn_error(conn, c'statement name is a null pointer')
		return 0
	}
	if n_params < 0 || n_params > 65535 {
		libpq_append_conn_error(conn, c'number of parameters must be between 0 and %d', 65535)
		return 0
	}
	return pq_send_query_guts(conn, (voidptr(0)), stmt_name, n_params, (voidptr(0)), param_values, param_lengths, param_formats, result_format)
}

@[markused]
pub fn pq_send_query_start(conn &PGconn, new_query bool) bool {
	if isnil(conn) {
		return false != 0
	}
	if i32(new_query) && usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		reset_pq_exp_buffer(&conn.errorMessage)
		conn.errorReported = 0
	}
	if u32(conn.status) != u32(ConnStatusType.connection_ok) {
		libpq_append_conn_error(conn, c'no connection to the server')
		return false != 0
	}
	if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_idle) && u32(conn.pipelineStatus) == u32(PGpipelineStatus.pq_pipeline_off) {
		libpq_append_conn_error(conn, c'another command is already in progress')
		return false != 0
	}
	if u32(conn.pipelineStatus) != u32(PGpipelineStatus.pq_pipeline_off) {
		match conn.asyncStatus {
			.pgasync_idle, .pgasync_pipeline_idle, .pgasync_ready, .pgasync_ready_more, .pgasync_busy {
			}
			.pgasync_copy_in, .pgasync_copy_out, .pgasync_copy_both {
				libpq_append_conn_error(conn, c'cannot queue commands during COPY')
				return false != 0
			}
			else {}
		}
	} else {
		pq_clear_async_result(conn)
		conn.partialResMode = (0 != 0)
		conn.singleRowMode = (0 != 0)
		conn.maxChunkSize = 0
	}
	return true != 0
}

@[markused]
pub fn pq_send_query_guts(conn &PGconn, command &i8, stmt_name &i8, n_params i32, param_types &Oid, param_values &&u8, param_lengths &i32, param_formats &i32, result_format i32) i32 {
	i := i32(0)
	entry := &PGcmdQueueEntry(0)
	entry = pq_alloc_cmd_queue_entry(conn)
	if usize(entry) == usize((voidptr(0))) {
		return 0
	}
	if command {
		if pq_put_msg_start(i8(`P`), conn) < 0 || pq_puts(stmt_name, conn) < 0 || pq_puts(command, conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
		if n_params > 0 && !isnil(param_types) {
			if pq_put_int(n_params, usize(2), conn) < 0 {
				unsafe {
					goto sendFailed
				}
			}
			for i = 0; i < n_params; i++ {
				if pq_put_int(i32(param_types[i]), usize(4), conn) < 0 {
					unsafe {
						goto sendFailed
					}
				}
			}
		} else {
			if pq_put_int(0, usize(2), conn) < 0 {
				unsafe {
					goto sendFailed
				}
			}
		}
		if pq_put_msg_end(conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
	}
	if pq_put_msg_start(i8(`B`), conn) < 0 || pq_puts(c'', conn) < 0 || pq_puts(stmt_name, conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	if n_params > 0 && !isnil(param_formats) {
		if pq_put_int(n_params, usize(2), conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
		for i = 0; i < n_params; i++ {
			if pq_put_int(param_formats[i], usize(2), conn) < 0 {
				unsafe {
					goto sendFailed
				}
			}
		}
	} else {
		if pq_put_int(0, usize(2), conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
	}
	if pq_put_int(n_params, usize(2), conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	for i = 0; i < n_params; i++ {
		if !isnil(param_values) && !isnil(param_values[i]) {
			nbytes := i32(0)
			if !isnil(param_formats) && param_formats[i] != 0 {
				if param_lengths {
					nbytes = param_lengths[i]
				} else {
					libpq_append_conn_error(conn, c'length must be given for binary parameter')
					unsafe {
						goto sendFailed
					}
				}
			} else {
				nbytes = i32(C.c2v_strlen(param_values[i]))
			}
			if pq_put_int(nbytes, usize(4), conn) < 0 || pq_putnchar(voidptr(param_values[i]), usize(nbytes), conn) < 0 {
				unsafe {
					goto sendFailed
				}
			}
		} else {
			if pq_put_int(-1, usize(4), conn) < 0 {
				unsafe {
					goto sendFailed
				}
			}
		}
	}
	if pq_put_int(1, usize(2), conn) < 0 || pq_put_int(result_format, usize(2), conn) {
		unsafe {
			goto sendFailed
		}
	}
	if pq_put_msg_end(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	if pq_put_msg_start(i8(`D`), conn) < 0 || pq_putc(i8(`P`), conn) < 0 || pq_puts(c'', conn) < 0 || pq_put_msg_end(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	if pq_put_msg_start(i8(`E`), conn) < 0 || pq_puts(c'', conn) < 0 || pq_put_int(0, usize(4), conn) < 0 || pq_put_msg_end(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	if u32(conn.pipelineStatus) == u32(PGpipelineStatus.pq_pipeline_off) {
		if pq_put_msg_start(i8(`S`), conn) < 0 || pq_put_msg_end(conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
	}
	entry.queryclass = PGQueryClass.pgquery_extended
	if command {
		entry.query = C.c2v_strdup(command)
	}
	if pq_pipeline_flush(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	pq_append_cmd_queue_entry(conn, entry)
	return 1
	sendFailed:
	pq_recycle_cmd_queue_entry(conn, entry)
	return 0
}

@[markused]
pub fn can_change_result_mode(conn &PGconn) bool {
	if isnil(conn) {
		return false != 0
	}
	if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_busy) {
		return false != 0
	}
	if isnil(conn.cmd_queue_head) || (u32(conn.cmd_queue_head.queryclass) != u32(PGQueryClass.pgquery_simple) && u32(conn.cmd_queue_head.queryclass) != u32(PGQueryClass.pgquery_extended)) {
		return false != 0
	}
	if (usize(conn.result) != usize((voidptr(0))) || i32(conn.error_result)) {
		return false != 0
	}
	return true != 0
}

@[export: 'PQsetSingleRowMode']
@[markused]
pub fn pq_set_single_row_mode(conn &PGconn) i32 {
	if can_change_result_mode(conn) {
		conn.partialResMode = (1 != 0)
		conn.singleRowMode = (1 != 0)
		conn.maxChunkSize = 1
		return 1
	} else {
		return 0
	}
}

@[export: 'PQsetChunkedRowsMode']
@[markused]
pub fn pq_set_chunked_rows_mode(conn &PGconn, chunk_size i32) i32 {
	if chunk_size > 0 && i32(can_change_result_mode(conn)) {
		conn.partialResMode = (1 != 0)
		conn.singleRowMode = (0 != 0)
		conn.maxChunkSize = chunk_size
		return 1
	} else {
		return 0
	}
}

@[export: 'PQconsumeInput']
@[markused]
pub fn pq_consume_input(conn &PGconn) i32 {
	if isnil(conn) {
		return 0
	}
	if conn.nonblocking {
		if pq_flush_vdup1(conn) < 0 {
			return 0
		}
	}
	if pq_read_data(conn) < 0 {
		return 0
	}
	return 1
}

@[markused]
pub fn parse_input(conn &PGconn) {
	pq_parse_input3(conn)
}

@[export: 'PQisBusy']
@[markused]
pub fn pq_is_busy(conn &PGconn) i32 {
	if isnil(conn) {
		return 0
	}
	parse_input(conn)
	return i32(u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_busy) && u32(conn.status) != u32(ConnStatusType.connection_bad))
}

@[export: 'PQgetResult']
@[markused]
pub fn pq_get_result(conn &PGconn) &PGresult {
	res := &PGresult(0)
	if isnil(conn) {
		return unsafe { nil }
	}
	parse_input(conn)
	for u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_busy) {
		flush_result := i32(0)
		for {
			flush_result = pq_flush_vdup1(conn)
			if !(flush_result > 0) {
				break
			}
			if pq_wait(0, 1, conn) {
				flush_result = -1
				break
			}
		}
		if flush_result || pq_wait(1, 0, conn) || pq_read_data(conn) < 0 {
			pq_save_error_result(conn)
			conn.asyncStatus = PGAsyncStatusType.pgasync_idle
			return pq_prepare_async_result(conn)
		}
		parse_input(conn)
		if i32(conn.write_failed) && u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_busy) {
			pq_save_write_error(conn)
			conn.asyncStatus = PGAsyncStatusType.pgasync_idle
			return pq_prepare_async_result(conn)
		}
	}
	match conn.asyncStatus {
		.pgasync_idle {
			res = unsafe { nil }
		}
		.pgasync_pipeline_idle {
			pq_pipeline_process_queue(conn)
			res = unsafe { nil }
		}
		.pgasync_ready {
			res = pq_prepare_async_result(conn)
			if conn.result {
				unsafe {
					goto c2v_switch_end_19
				}
			}
			pq_command_queue_advance(conn, (0 != 0), (u32(res.resultStatus) == u32(ExecStatusType.pgres_pipeline_sync)))
			if u32(conn.pipelineStatus) != u32(PGpipelineStatus.pq_pipeline_off) {
				conn.asyncStatus = PGAsyncStatusType.pgasync_pipeline_idle
				if u32(res.resultStatus) == u32(ExecStatusType.pgres_pipeline_sync) {
					pq_pipeline_process_queue(conn)
				}
			} else {
				conn.asyncStatus = PGAsyncStatusType.pgasync_busy
			}
		}
		.pgasync_ready_more {
			res = pq_prepare_async_result(conn)
			conn.asyncStatus = PGAsyncStatusType.pgasync_busy
		}
		.pgasync_copy_in {
			res = get_copy_result(conn, ExecStatusType(ExecStatusType.pgres_copy_in))
		}
		.pgasync_copy_out {
			res = get_copy_result(conn, ExecStatusType(ExecStatusType.pgres_copy_out))
		}
		.pgasync_copy_both {
			res = get_copy_result(conn, ExecStatusType(ExecStatusType.pgres_copy_both))
		}
		else {
			libpq_append_conn_error(conn, c'unexpected asyncStatus: %d', i32(conn.asyncStatus))
			pq_save_error_result(conn)
			conn.asyncStatus = PGAsyncStatusType.pgasync_idle
			res = pq_prepare_async_result(conn)
		}
	}
	c2v_switch_end_19:

	if !isnil(res) && res.nEvents > 0 {
		pq_fire_result_create_events(conn, res)
	}
	return res
}

@[markused]
pub fn get_copy_result(conn &PGconn, copytype ExecStatusType) &PGresult {
	if u32(conn.status) != u32(ConnStatusType.connection_ok) {
		pq_save_error_result(conn)
		conn.asyncStatus = PGAsyncStatusType.pgasync_idle
		return pq_prepare_async_result(conn)
	}
	if !isnil(conn.result) && u32(conn.result.resultStatus) == u32(copytype) {
		return pq_prepare_async_result(conn)
	}
	return pq_make_empty_pg_result(conn, copytype)
}

@[export: 'PQexec']
@[markused]
pub fn pq_exec(conn &PGconn, query &i8) &PGresult {
	if !pq_exec_start(conn) {
		return unsafe { nil }
	}
	if !pq_send_query(conn, query) {
		return unsafe { nil }
	}
	return pq_exec_finish(conn)
}

@[export: 'PQexecParams']
@[markused]
pub fn pq_exec_params(conn &PGconn, command &i8, n_params i32, param_types &Oid, param_values &&u8, param_lengths &i32, param_formats &i32, result_format i32) &PGresult {
	if !pq_exec_start(conn) {
		return unsafe { nil }
	}
	if !pq_send_query_params(conn, command, n_params, param_types, param_values, param_lengths, param_formats, result_format) {
		return unsafe { nil }
	}
	return pq_exec_finish(conn)
}

@[export: 'PQprepare']
@[markused]
pub fn pq_prepare(conn &PGconn, stmt_name &i8, query &i8, n_params i32, param_types &Oid) &PGresult {
	if !pq_exec_start(conn) {
		return unsafe { nil }
	}
	if !pq_send_prepare(conn, stmt_name, query, n_params, param_types) {
		return unsafe { nil }
	}
	return pq_exec_finish(conn)
}

@[export: 'PQexecPrepared']
@[markused]
pub fn pq_exec_prepared(conn &PGconn, stmt_name &i8, n_params i32, param_values &&u8, param_lengths &i32, param_formats &i32, result_format i32) &PGresult {
	if !pq_exec_start(conn) {
		return unsafe { nil }
	}
	if !pq_send_query_prepared(conn, stmt_name, n_params, param_values, param_lengths, param_formats, result_format) {
		return unsafe { nil }
	}
	return pq_exec_finish(conn)
}

@[markused]
pub fn pq_exec_start(conn &PGconn) bool {
	result := &PGresult(0)
	if isnil(conn) {
		return false != 0
	}
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		reset_pq_exp_buffer(&conn.errorMessage)
		conn.errorReported = 0
	}
	if u32(conn.pipelineStatus) != u32(PGpipelineStatus.pq_pipeline_off) {
		libpq_append_conn_error(conn, c'synchronous command execution functions are not allowed in pipeline mode')
		return false != 0
	}
	for {
		result = pq_get_result(conn)
		if !(usize(result) != usize((voidptr(0)))) {
			break
		}
		result_status := result.resultStatus
		pq_clear(result)
		if u32(result_status) == u32(ExecStatusType.pgres_copy_in) {
			if pq_put_copy_end(conn, unsafe { &i8(&c'COPY terminated by new PQexec'[0]) }) < 0 {
				return false != 0
			}
		} else if u32(result_status) == u32(ExecStatusType.pgres_copy_out) {
			conn.asyncStatus = PGAsyncStatusType.pgasync_busy
		} else if u32(result_status) == u32(ExecStatusType.pgres_copy_both) {
			libpq_append_conn_error(conn, c'PQexec not allowed during COPY BOTH')
			return false != 0
		}
		if u32(conn.status) == u32(ConnStatusType.connection_bad) {
			return false != 0
		}
	}
	return true != 0
}

@[markused]
pub fn pq_exec_finish(conn &PGconn) &PGresult {
	result := &PGresult(0)
	last_result := &PGresult(0)
	last_result = unsafe { nil }
	for {
		result = pq_get_result(conn)
		if !(usize(result) != usize((voidptr(0)))) {
			break
		}
		pq_clear(last_result)
		last_result = result
		mut __c2v_condition_0 := false
		mut __c2v_condition_1 := false
		__c2v_condition_1 = u32(result.resultStatus) == u32(ExecStatusType.pgres_copy_in)
		__c2v_condition_0 = __c2v_condition_1
		if !__c2v_condition_0 {
			mut __c2v_condition_2 := false
			__c2v_condition_2 = u32(result.resultStatus) == u32(ExecStatusType.pgres_copy_out)
			__c2v_condition_0 = __c2v_condition_2
		}
		if !__c2v_condition_0 {
			mut __c2v_condition_3 := false
			__c2v_condition_3 = u32(result.resultStatus) == u32(ExecStatusType.pgres_copy_both)
			__c2v_condition_0 = __c2v_condition_3
		}
		if !__c2v_condition_0 {
			mut __c2v_condition_4 := false
			__c2v_condition_4 = u32(conn.status) == u32(ConnStatusType.connection_bad)
			__c2v_condition_0 = __c2v_condition_4
		}
		if __c2v_condition_0 {
			break
		}
	}
	return last_result
}

@[export: 'PQdescribePrepared']
@[markused]
pub fn pq_describe_prepared(conn &PGconn, stmt &i8) &PGresult {
	if !pq_exec_start(conn) {
		return unsafe { nil }
	}
	if !pq_send_typed_command(conn, i8(`D`), i8(`S`), stmt) {
		return unsafe { nil }
	}
	return pq_exec_finish(conn)
}

@[export: 'PQdescribePortal']
@[markused]
pub fn pq_describe_portal(conn &PGconn, portal &i8) &PGresult {
	if !pq_exec_start(conn) {
		return unsafe { nil }
	}
	if !pq_send_typed_command(conn, i8(`D`), i8(`P`), portal) {
		return unsafe { nil }
	}
	return pq_exec_finish(conn)
}

@[export: 'PQsendDescribePrepared']
@[markused]
pub fn pq_send_describe_prepared(conn &PGconn, stmt &i8) i32 {
	return pq_send_typed_command(conn, i8(`D`), i8(`S`), stmt)
}

@[export: 'PQsendDescribePortal']
@[markused]
pub fn pq_send_describe_portal(conn &PGconn, portal &i8) i32 {
	return pq_send_typed_command(conn, i8(`D`), i8(`P`), portal)
}

@[export: 'PQclosePrepared']
@[markused]
pub fn pq_close_prepared(conn &PGconn, stmt &i8) &PGresult {
	if !pq_exec_start(conn) {
		return unsafe { nil }
	}
	if !pq_send_typed_command(conn, i8(`C`), i8(`S`), stmt) {
		return unsafe { nil }
	}
	return pq_exec_finish(conn)
}

@[export: 'PQclosePortal']
@[markused]
pub fn pq_close_portal(conn &PGconn, portal &i8) &PGresult {
	if !pq_exec_start(conn) {
		return unsafe { nil }
	}
	if !pq_send_typed_command(conn, i8(`C`), i8(`P`), portal) {
		return unsafe { nil }
	}
	return pq_exec_finish(conn)
}

@[export: 'PQsendClosePrepared']
@[markused]
pub fn pq_send_close_prepared(conn &PGconn, stmt &i8) i32 {
	return pq_send_typed_command(conn, i8(`C`), i8(`S`), stmt)
}

@[export: 'PQsendClosePortal']
@[markused]
pub fn pq_send_close_portal(conn &PGconn, portal &i8) i32 {
	return pq_send_typed_command(conn, i8(`C`), i8(`P`), portal)
}

@[markused]
pub fn pq_send_typed_command(conn &PGconn, command i8, type_ i8, target &i8) i32 {
	entry := unsafe { &PGcmdQueueEntry(nil) }
	if isnil(target) {
		target = c''
	}
	if !pq_send_query_start(conn, (1 != 0)) {
		return 0
	}
	entry = pq_alloc_cmd_queue_entry(conn)
	if usize(entry) == usize((voidptr(0))) {
		return 0
	}
	if pq_put_msg_start(i8(command), conn) < 0 || pq_putc(i8(type_), conn) < 0 || pq_puts(target, conn) < 0 || pq_put_msg_end(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	if u32(conn.pipelineStatus) == u32(PGpipelineStatus.pq_pipeline_off) {
		if pq_put_msg_start(i8(`S`), conn) < 0 || pq_put_msg_end(conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
	}
	if i32(command) == i8(`C`) {
		entry.queryclass = PGQueryClass.pgquery_close
	} else if i32(command) == i8(`D`) {
		entry.queryclass = PGQueryClass.pgquery_describe
	} else {
		libpq_append_conn_error(conn, c'unrecognized message type "%c"', i32(command))
		unsafe {
			goto sendFailed
		}
	}
	if pq_pipeline_flush(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	pq_append_cmd_queue_entry(conn, entry)
	return 1
	sendFailed:
	pq_recycle_cmd_queue_entry(conn, entry)
	return 0
}

@[export: 'PQnotifies']
@[markused]
pub fn pq_notifies(conn &PGconn) &PGnotify {
	event := &PGnotify(0)
	if isnil(conn) {
		return unsafe { nil }
	}
	parse_input(conn)
	event = conn.notifyHead
	if event {
		conn.notifyHead = event.next
		if isnil(conn.notifyHead) {
			conn.notifyTail = unsafe { nil }
		}
		event.next = unsafe { nil }
	}
	return event
}

@[export: 'PQputCopyData']
@[markused]
pub fn pq_put_copy_data(conn &PGconn, buffer &i8, nbytes i32) i32 {
	if isnil(conn) {
		return -1
	}
	if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_in) && u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_both) {
		libpq_append_conn_error(conn, c'no COPY in progress')
		return -1
	}
	parse_input(conn)
	if nbytes > 0 {
		if (conn.outBufSize - conn.outCount - 5) < nbytes {
			if pq_flush_vdup1(conn) < 0 {
				return -1
			}
			if pq_check_out_buffer_space(usize(conn.outCount + 5) + usize(nbytes), conn) {
				return if i32(conn.nonblocking) { 0 } else { -1 }
			}
		}
		if pq_put_msg_start(i8(`d`), conn) < 0 || pq_putnchar(voidptr(buffer), usize(nbytes), conn) < 0 || pq_put_msg_end(conn) < 0 {
			return -1
		}
	}
	return 1
}

@[export: 'PQputCopyEnd']
@[markused]
pub fn pq_put_copy_end(conn &PGconn, errormsg &i8) i32 {
	if isnil(conn) {
		return -1
	}
	if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_in) && u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_both) {
		libpq_append_conn_error(conn, c'no COPY in progress')
		return -1
	}
	if errormsg {
		if pq_put_msg_start(i8(`f`), conn) < 0 || pq_puts(errormsg, conn) < 0 || pq_put_msg_end(conn) < 0 {
			return -1
		}
	} else {
		if pq_put_msg_start(i8(`c`), conn) < 0 || pq_put_msg_end(conn) < 0 {
			return -1
		}
	}
	if !isnil(conn.cmd_queue_head) && u32(conn.cmd_queue_head.queryclass) != u32(PGQueryClass.pgquery_simple) {
		if pq_put_msg_start(i8(`S`), conn) < 0 || pq_put_msg_end(conn) < 0 {
			return -1
		}
	}
	if u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_copy_both) {
		conn.asyncStatus = PGAsyncStatusType.pgasync_copy_out
	} else {
		conn.asyncStatus = PGAsyncStatusType.pgasync_busy
	}
	if pq_flush_vdup1(conn) < 0 {
		return -1
	}
	return 1
}

@[export: 'PQgetCopyData']
@[markused]
pub fn pq_get_copy_data(conn &PGconn, buffer &&u8, async i32) i32 {
	unsafe { *buffer = nil }
	if isnil(conn) {
		return -2
	}
	if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_out) && u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_copy_both) {
		libpq_append_conn_error(conn, c'no COPY in progress')
		return -2
	}
	return pq_get_copy_data3(conn, buffer, async)
}

@[export: 'PQgetline']
@[markused]
pub fn pq_getline(conn &PGconn, buffer &i8, length i32) i32 {
	if isnil(buffer) || length <= 0 {
		return -1
	}
	unsafe { *buffer = i8(`\0`) }
	if length < 3 {
		return -1
	}
	if isnil(conn) {
		return -1
	}
	return pq_getline3(conn, buffer, length)
}

@[export: 'PQgetlineAsync']
@[markused]
pub fn pq_getline_async(conn &PGconn, buffer &i8, bufsize i32) i32 {
	if isnil(conn) {
		return -1
	}
	return pq_getline_async3(conn, buffer, bufsize)
}

@[export: 'PQputline']
@[markused]
pub fn pq_putline(conn &PGconn, string_ &i8) i32 {
	return pq_putnbytes(conn, string_, i32(C.c2v_strlen(string_)))
}

@[export: 'PQputnbytes']
@[markused]
pub fn pq_putnbytes(conn &PGconn, buffer &i8, nbytes i32) i32 {
	if pq_put_copy_data(conn, buffer, nbytes) > 0 {
		return 0
	} else {
		return -1
	}
}

@[export: 'PQendcopy']
@[markused]
pub fn pq_endcopy(conn &PGconn) i32 {
	if isnil(conn) {
		return 0
	}
	return pq_endcopy3(conn)
}

@[export: 'PQfn']
@[markused]
pub fn pq_fn(conn &PGconn, fnid i32, result_buf &i32, result_len &i32, result_is_int i32, args &PQArgBlock, nargs i32) &PGresult {
	return pq_nfn(conn, fnid, result_buf, -1, result_len, result_is_int, args, nargs)
}

@[export: 'PQnfn']
@[markused]
pub fn pq_nfn(conn &PGconn, fnid i32, result_buf &i32, buf_size i32, result_len &i32, result_is_int i32, args &PQArgBlock, nargs i32) &PGresult {
	unsafe { *result_len = 0 }
	if isnil(conn) {
		return unsafe { nil }
	}
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		reset_pq_exp_buffer(&conn.errorMessage)
		conn.errorReported = 0
	}
	if u32(conn.pipelineStatus) != u32(PGpipelineStatus.pq_pipeline_off) {
		libpq_append_conn_error(conn, c'%s not allowed in pipeline mode', voidptr(c'PQfn'))
		return unsafe { nil }
	}
	if conn.sock == (-1) || u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_idle) || (usize(conn.result) != usize((voidptr(0))) || i32(conn.error_result)) {
		libpq_append_conn_error(conn, c'connection in wrong state')
		return unsafe { nil }
	}
	return pq_function_call3(conn, Oid(fnid), result_buf, buf_size, result_len, result_is_int, args, nargs)
}

@[export: 'PQenterPipelineMode']
@[markused]
pub fn pq_enter_pipeline_mode(conn &PGconn) i32 {
	if isnil(conn) {
		return 0
	}
	if u32(conn.pipelineStatus) != u32(PGpipelineStatus.pq_pipeline_off) {
		return 1
	}
	if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_idle) {
		libpq_append_conn_error(conn, c'cannot enter pipeline mode, connection not idle')
		return 0
	}
	conn.pipelineStatus = PGpipelineStatus.pq_pipeline_on
	return 1
}

@[export: 'PQexitPipelineMode']
@[markused]
pub fn pq_exit_pipeline_mode(conn &PGconn) i32 {
	if isnil(conn) {
		return 0
	}
	mut __c2v_condition_5 := false
	mut __c2v_condition_6 := false
	__c2v_condition_6 = u32(conn.pipelineStatus) == u32(PGpipelineStatus.pq_pipeline_off)
	if __c2v_condition_6 {
		__c2v_condition_6 = (u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_idle) || u32(conn.asyncStatus) == u32(PGAsyncStatusType.pgasync_pipeline_idle))
	}
	if __c2v_condition_6 {
		__c2v_condition_6 = usize(conn.cmd_queue_head) == usize((voidptr(0)))
	}
	__c2v_condition_5 = __c2v_condition_6
	if __c2v_condition_5 {
		return 1
	}
	match conn.asyncStatus {
		.pgasync_ready, .pgasync_ready_more {
			libpq_append_conn_error(conn, c'cannot exit pipeline mode with uncollected results')
			return 0
		}
		.pgasync_busy {
			libpq_append_conn_error(conn, c'cannot exit pipeline mode while busy')
			return 0
		}
		.pgasync_idle, .pgasync_pipeline_idle {
		}
		.pgasync_copy_in, .pgasync_copy_out, .pgasync_copy_both {
			libpq_append_conn_error(conn, c'cannot exit pipeline mode while in COPY')
		}
		else {}
	}

	if usize(conn.cmd_queue_head) != usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'cannot exit pipeline mode with uncollected results')
		return 0
	}
	conn.pipelineStatus = PGpipelineStatus.pq_pipeline_off
	conn.asyncStatus = PGAsyncStatusType.pgasync_idle
	if pq_flush_vdup1(conn) < 0 {
		return 0
	}
	return 1
}

@[export: 'pqCommandQueueAdvance']
@[markused]
pub fn pq_command_queue_advance(conn &PGconn, is_ready_for_query bool, got_sync bool) {
	prevquery := &PGcmdQueueEntry(0)
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		return
	}
	if u32(conn.cmd_queue_head.queryclass) == u32(PGQueryClass.pgquery_simple) && !is_ready_for_query {
		return
	}
	if u32(conn.cmd_queue_head.queryclass) == u32(PGQueryClass.pgquery_sync) && !got_sync {
		return
	}
	prevquery = conn.cmd_queue_head
	conn.cmd_queue_head = conn.cmd_queue_head.next
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		conn.cmd_queue_tail = unsafe { nil }
	}
	prevquery.next = unsafe { nil }
	pq_recycle_cmd_queue_entry(conn, prevquery)
}

@[markused]
pub fn pq_pipeline_process_queue(conn &PGconn) {
	match conn.asyncStatus {
		.pgasync_copy_in, .pgasync_copy_out, .pgasync_copy_both, .pgasync_ready, .pgasync_ready_more, .pgasync_busy {
			return
		}
		.pgasync_idle {
			if usize(conn.cmd_queue_head) != usize((voidptr(0))) {
				conn.asyncStatus = PGAsyncStatusType.pgasync_pipeline_idle
				unsafe {
					goto c2v_switch_end_21
				}
			}
			return
		}
		.pgasync_pipeline_idle {
		}
		else {}
	}
	c2v_switch_end_21:

	conn.partialResMode = (0 != 0)
	conn.singleRowMode = (0 != 0)
	conn.maxChunkSize = 0
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		conn.asyncStatus = PGAsyncStatusType.pgasync_idle
		return
	}
	reset_pq_exp_buffer(&conn.errorMessage)
	conn.errorReported = 0
	pq_clear_async_result(conn)
	if u32(conn.pipelineStatus) == u32(PGpipelineStatus.pq_pipeline_aborted) && u32(conn.cmd_queue_head.queryclass) != u32(PGQueryClass.pgquery_sync) {
		conn.result = pq_make_empty_pg_result(conn, ExecStatusType(ExecStatusType.pgres_pipeline_aborted))
		if isnil(conn.result) {
			libpq_append_conn_error(conn, c'out of memory')
			pq_save_error_result(conn)
			return
		}
		conn.asyncStatus = PGAsyncStatusType.pgasync_ready
	} else {
		conn.asyncStatus = PGAsyncStatusType.pgasync_busy
	}
}

@[export: 'PQpipelineSync']
@[markused]
pub fn pq_pipeline_sync(conn &PGconn) i32 {
	return pq_pipeline_sync_internal(conn, (1 != 0))
}

@[export: 'PQsendPipelineSync']
@[markused]
pub fn pq_send_pipeline_sync(conn &PGconn) i32 {
	return pq_pipeline_sync_internal(conn, (0 != 0))
}

@[markused]
pub fn pq_pipeline_sync_internal(conn &PGconn, immediate_flush bool) i32 {
	entry := &PGcmdQueueEntry(0)
	if isnil(conn) {
		return 0
	}
	if u32(conn.pipelineStatus) == u32(PGpipelineStatus.pq_pipeline_off) {
		libpq_append_conn_error(conn, c'cannot send pipeline when not in pipeline mode')
		return 0
	}
	match conn.asyncStatus {
		.pgasync_copy_in, .pgasync_copy_out, .pgasync_copy_both {
			append_pq_exp_buffer_str(&conn.errorMessage, c'internal error: cannot send pipeline while in COPY\n')
			return 0
		}
		.pgasync_ready, .pgasync_ready_more, .pgasync_busy, .pgasync_idle, .pgasync_pipeline_idle {
		}
		else {}
	}

	entry = pq_alloc_cmd_queue_entry(conn)
	if usize(entry) == usize((voidptr(0))) {
		return 0
	}
	entry.queryclass = PGQueryClass.pgquery_sync
	entry.query = unsafe { nil }
	if pq_put_msg_start(i8(`S`), conn) < 0 || pq_put_msg_end(conn) < 0 {
		unsafe {
			goto sendFailed
		}
	}
	if immediate_flush {
		if pq_flush_vdup1(conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
	} else {
		if pq_pipeline_flush(conn) < 0 {
			unsafe {
				goto sendFailed
			}
		}
	}
	pq_append_cmd_queue_entry(conn, entry)
	return 1
	sendFailed:
	pq_recycle_cmd_queue_entry(conn, entry)
	return 0
}

@[export: 'PQsendFlushRequest']
@[markused]
pub fn pq_send_flush_request(conn &PGconn) i32 {
	if isnil(conn) {
		return 0
	}
	if u32(conn.status) != u32(ConnStatusType.connection_ok) {
		libpq_append_conn_error(conn, c'no connection to the server')
		return 0
	}
	if u32(conn.asyncStatus) != u32(PGAsyncStatusType.pgasync_idle) && u32(conn.pipelineStatus) == u32(PGpipelineStatus.pq_pipeline_off) {
		libpq_append_conn_error(conn, c'another command is already in progress')
		return 0
	}
	if pq_put_msg_start(i8(`H`), conn) < 0 || pq_put_msg_end(conn) < 0 {
		return 0
	}
	if pq_pipeline_flush(conn) < 0 {
		return 0
	}
	return 1
}

@[export: 'PQresultStatus']
@[markused]
pub fn pq_result_status(res &PGresult) ExecStatusType {
	if isnil(res) {
		return ExecStatusType.pgres_fatal_error
	}
	return res.resultStatus
}

@[export: 'PQresStatus']
@[markused]
pub fn pq_res_status(status ExecStatusType) &i8 {
	if u64(u32(status)) >= 13 {
		return unsafe { &i8(&c'invalid ExecStatusType code'[0]) }
	}
	return pgres_status[status]
}

@[export: 'PQresultErrorMessage']
@[markused]
pub fn pq_result_error_message(res &PGresult) &i8 {
	if isnil(res) || isnil(res.errMsg) {
		return unsafe { &i8(&c''[0]) }
	}
	return res.errMsg
}

@[export: 'PQresultVerboseErrorMessage']
@[markused]
pub fn pq_result_verbose_error_message(res &PGresult, verbosity PGVerbosity, show_context PGContextVisibility) &i8 {
	work_buf := PQExpBufferData{}
	if isnil(res) || (u32(res.resultStatus) != u32(ExecStatusType.pgres_fatal_error) && u32(res.resultStatus) != u32(ExecStatusType.pgres_nonfatal_error)) {
		return C.c2v_strdup(unsafe { &i8(&c'PGresult is not an error result\n'[0]) })
	}
	init_pq_exp_buffer(&work_buf)
	pq_build_error_message3(&work_buf, res, verbosity, show_context)
	if (work_buf.maxlen == usize(0)) {
		term_pq_exp_buffer(&work_buf)
		return C.c2v_strdup(unsafe { &i8(&c'out of memory\n'[0]) })
	}
	return work_buf.data
}

@[export: 'PQresultErrorField']
@[markused]
pub fn pq_result_error_field(res &PGresult, fieldcode i32) &i8 {
	pfield := &PGMessageField(0)
	if isnil(res) {
		return unsafe { nil }
	}
	for pfield = res.errFields; usize(pfield) != usize((voidptr(0))); pfield = pfield.next {
		if i32(pfield.code) == fieldcode {
			return unsafe { &i8(&pfield.contents[0]) }
		}
	}
	return unsafe { nil }
}

@[export: 'PQntuples']
@[markused]
pub fn pq_ntuples(res &PGresult) i32 {
	if isnil(res) {
		return 0
	}
	return res.ntups
}

@[export: 'PQnfields']
@[markused]
pub fn pq_nfields(res &PGresult) i32 {
	if isnil(res) {
		return 0
	}
	return res.numAttributes
}

@[export: 'PQbinaryTuples']
@[markused]
pub fn pq_binary_tuples(res &PGresult) i32 {
	if isnil(res) {
		return 0
	}
	return res.binary
}

@[markused]
pub fn check_field_number(res &PGresult, field_num i32) i32 {
	if isnil(res) {
		return 0
	}
	if field_num < 0 || field_num >= res.numAttributes {
		pq_internal_notice(&res.noticeHooks, c'column number %d is out of range 0..%d', field_num, res.numAttributes - 1)
		return 0
	}
	return 1
}

@[markused]
pub fn check_tuple_field_number(res &PGresult, tup_num i32, field_num i32) i32 {
	if isnil(res) {
		return 0
	}
	if tup_num < 0 || tup_num >= res.ntups {
		pq_internal_notice(&res.noticeHooks, c'row number %d is out of range 0..%d', tup_num, res.ntups - 1)
		return 0
	}
	if field_num < 0 || field_num >= res.numAttributes {
		pq_internal_notice(&res.noticeHooks, c'column number %d is out of range 0..%d', field_num, res.numAttributes - 1)
		return 0
	}
	return 1
}

@[markused]
pub fn check_param_number(res &PGresult, param_num i32) i32 {
	if isnil(res) {
		return 0
	}
	if param_num < 0 || param_num >= res.numParameters {
		pq_internal_notice(&res.noticeHooks, c'parameter number %d is out of range 0..%d', param_num, res.numParameters - 1)
		return 0
	}
	return 1
}

@[export: 'PQfname']
@[markused]
pub fn pq_fname(res &PGresult, field_num i32) &i8 {
	if !check_field_number(res, field_num) {
		return unsafe { nil }
	}
	if res.attDescs {
		return res.attDescs[field_num].name
	} else {
		return unsafe { nil }
	}
}

@[export: 'PQfnumber']
@[markused]
pub fn pq_fnumber(res &PGresult, field_name &i8) i32 {
	field_case := &i8(0)
	in_quotes := false
	all_lower := (1 != 0)
	iptr := &i8(0)
	optr := &i8(0)
	i := i32(0)
	if isnil(res) {
		return -1
	}
	if usize(field_name) == usize((voidptr(0))) || i32(field_name[0]) == i8(`\0`) || usize(res.attDescs) == usize((voidptr(0))) {
		return -1
	}
	for iptr = field_name; (unsafe { *iptr }); iptr = unsafe { iptr + 1 } {
		c := (unsafe { *iptr })
		if i32(c) == i8(`\"`) || i32(c) != i32(pg_tolower(u8(c))) {
			all_lower = (0 != 0)
			break
		}
	}
	if all_lower {
		for i = 0; i < res.numAttributes; i++ {
			if C.c2v_strcmp(field_name, res.attDescs[i].name) == 0 {
				return i
			}
		}
	}
	field_case = C.c2v_strdup(field_name)
	if usize(field_case) == usize((voidptr(0))) {
		return -1
	}
	in_quotes = (0 != 0)
	optr = field_case
	for iptr = field_case; (unsafe { *iptr }); iptr = unsafe { iptr + 1 } {
		c := (unsafe { *iptr })
		if in_quotes {
			if i32(c) == i8(`\"`) {
				if i32(iptr[1]) == i8(`\"`) {
					mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_postfix(voidptr(&optr), optr, isize(1)) }
					unsafe { *__c2v_lhs_tmp_0 = i8(`\"`) }
					c2v_pointer_postfix(voidptr(&iptr), iptr, isize(1))
				} else {
					in_quotes = (0 != 0)
				}
			} else {
				mut __c2v_lhs_tmp_1 := unsafe { c2v_pointer_postfix(voidptr(&optr), optr, isize(1)) }
				unsafe { *__c2v_lhs_tmp_1 = c }
			}
		} else if i32(c) == i8(`\"`) {
			in_quotes = (1 != 0)
		} else {
			c = i8(pg_tolower(u8(c)))
			mut __c2v_lhs_tmp_2 := unsafe { c2v_pointer_postfix(voidptr(&optr), optr, isize(1)) }
			unsafe { *__c2v_lhs_tmp_2 = c }
		}
	}
	unsafe { *optr = i8(`\0`) }
	for i = 0; i < res.numAttributes; i++ {
		if C.c2v_strcmp(field_case, res.attDescs[i].name) == 0 {
			C.c2v_free(voidptr(field_case))
			return i
		}
	}
	C.c2v_free(voidptr(field_case))
	return -1
}

@[export: 'PQftable']
@[markused]
pub fn pq_ftable(res &PGresult, field_num i32) Oid {
	if !check_field_number(res, field_num) {
		return Oid(0)
	}
	if res.attDescs {
		return res.attDescs[field_num].tableid
	} else {
		return Oid(0)
	}
}

@[export: 'PQftablecol']
@[markused]
pub fn pq_ftablecol(res &PGresult, field_num i32) i32 {
	if !check_field_number(res, field_num) {
		return 0
	}
	if res.attDescs {
		return res.attDescs[field_num].columnid
	} else {
		return 0
	}
}

@[export: 'PQfformat']
@[markused]
pub fn pq_fformat(res &PGresult, field_num i32) i32 {
	if !check_field_number(res, field_num) {
		return 0
	}
	if res.attDescs {
		return res.attDescs[field_num].format
	} else {
		return 0
	}
}

@[export: 'PQftype']
@[markused]
pub fn pq_ftype(res &PGresult, field_num i32) Oid {
	if !check_field_number(res, field_num) {
		return Oid(0)
	}
	if res.attDescs {
		return res.attDescs[field_num].typid
	} else {
		return Oid(0)
	}
}

@[export: 'PQfsize']
@[markused]
pub fn pq_fsize(res &PGresult, field_num i32) i32 {
	if !check_field_number(res, field_num) {
		return 0
	}
	if res.attDescs {
		return res.attDescs[field_num].typlen
	} else {
		return 0
	}
}

@[export: 'PQfmod']
@[markused]
pub fn pq_fmod(res &PGresult, field_num i32) i32 {
	if !check_field_number(res, field_num) {
		return 0
	}
	if res.attDescs {
		return res.attDescs[field_num].atttypmod
	} else {
		return 0
	}
}

@[export: 'PQcmdStatus']
@[markused]
pub fn pq_cmd_status(res &PGresult) &i8 {
	if isnil(res) {
		return unsafe { nil }
	}
	return unsafe { &i8(&res.cmdStatus[0]) }
}

@[export: 'PQoidStatus']
@[markused]
pub fn pq_oid_status(res &PGresult) &i8 {
	len := usize(0)
	if isnil(res) || C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'INSERT ', u64(7)) != 0 {
		return unsafe { &i8(&c''[0]) }
	}
	len = C.c2v_strspn(unsafe { &res.cmdStatus[0] } + 7, c'0123456789')
	if len > sizeof([24]i8) - u64(1) {
		len = sizeof([24]i8) - u64(1)
	}
	C.c2v_memcpy(voidptr(unsafe { &pq_oid_status_buf[0] }), voidptr(unsafe { &res.cmdStatus[0] } + 7), len)
	pq_oid_status_buf[len] = i8(`\0`)
	return unsafe { &i8(&pq_oid_status_buf[0]) }
}

@[export: 'PQoidValue']
@[markused]
pub fn pq_oid_value(res &PGresult) Oid {
	endptr := unsafe { &i8(nil) }
	result := u64(0)
	if isnil(res) || C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'INSERT ', u64(7)) != 0 || i32(res.cmdStatus[7]) < i8(`0`) || i32(res.cmdStatus[7]) > i8(`9`) {
		return Oid(0)
	}
	result = C.c2v_strtoul(unsafe { &res.cmdStatus[0] } + 7, &&u8(&&i8(c2v_address_of(&endptr))), 10)
	if isnil(endptr) || (i32((unsafe { *endptr })) != i8(` `) && i32((unsafe { *endptr })) != i8(`\0`)) {
		return Oid(0)
	} else {
		return Oid(result)
	}
}

@[export: 'PQcmdTuples']
@[markused]
pub fn pq_cmd_tuples(res &PGresult) &i8 {
	p := &i8(0)
	c := &i8(0)

	if isnil(res) {
		return unsafe { &i8(&c''[0]) }
	}
	if C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'INSERT ', u64(7)) == 0 {
		p = unsafe { &res.cmdStatus[0] } + 7
		for i32((unsafe { *p })) && i32((unsafe { *p })) != i8(` `) {
			c2v_pointer_postfix(voidptr(&p), p, isize(1))
		}
		if i32((unsafe { *p })) == 0 {
			unsafe {
				goto interpret_error
			}
		}
		c2v_pointer_postfix(voidptr(&p), p, isize(1))
	} else if C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'SELECT ', u64(7)) == 0 || C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'DELETE ', u64(7)) == 0 || C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'UPDATE ', u64(7)) == 0 {
		p = unsafe { &res.cmdStatus[0] } + 7
	} else if C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'FETCH ', u64(6)) == 0 || C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'MERGE ', u64(6)) == 0 {
		p = unsafe { &res.cmdStatus[0] } + 6
	} else if C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'MOVE ', u64(5)) == 0 || C.c2v_strncmp(unsafe { &i8(&res.cmdStatus[0]) }, c'COPY ', u64(5)) == 0 {
		p = unsafe { &res.cmdStatus[0] } + 5
	} else {
		return unsafe { &i8(&c''[0]) }
	}
	for c = p; (unsafe { *c }); c = unsafe { c + 1 } {
		if !C.c2v_isdigit(i32(u8((unsafe { *c })))) {
			unsafe {
				goto interpret_error
			}
		}
	}
	if usize(c) == usize(p) {
		unsafe {
			goto interpret_error
		}
	}
	return p
	interpret_error:
	pq_internal_notice(&res.noticeHooks, c'could not interpret result from server: %s', unsafe { voidptr(&res.cmdStatus[0]) })
	return unsafe { &i8(&c''[0]) }
}

@[export: 'PQgetvalue']
@[markused]
pub fn pq_getvalue(res &PGresult, tup_num i32, field_num i32) &i8 {
	if !check_tuple_field_number(res, tup_num, field_num) {
		return unsafe { nil }
	}
	return res.tuples[tup_num][field_num].value
}

@[export: 'PQgetlength']
@[markused]
pub fn pq_getlength(res &PGresult, tup_num i32, field_num i32) i32 {
	if !check_tuple_field_number(res, tup_num, field_num) {
		return 0
	}
	if res.tuples[tup_num][field_num].len != (-1) {
		return res.tuples[tup_num][field_num].len
	} else {
		return 0
	}
}

@[export: 'PQgetisnull']
@[markused]
pub fn pq_getisnull(res &PGresult, tup_num i32, field_num i32) i32 {
	if !check_tuple_field_number(res, tup_num, field_num) {
		return 1
	}
	if res.tuples[tup_num][field_num].len == (-1) {
		return 1
	} else {
		return 0
	}
}

@[export: 'PQnparams']
@[markused]
pub fn pq_nparams(res &PGresult) i32 {
	if isnil(res) {
		return 0
	}
	return res.numParameters
}

@[export: 'PQparamtype']
@[markused]
pub fn pq_paramtype(res &PGresult, param_num i32) Oid {
	if !check_param_number(res, param_num) {
		return Oid(0)
	}
	if res.paramDescs {
		return res.paramDescs[param_num].typid
	} else {
		return Oid(0)
	}
}

@[export: 'PQsetnonblocking']
@[markused]
pub fn pq_setnonblocking(conn &PGconn, arg i32) i32 {
	barg := false
	if isnil(conn) || u32(conn.status) == u32(ConnStatusType.connection_bad) {
		return -1
	}
	barg = ((if arg { 1 } else { 0 }) != 0)
	if i32(barg) == i32(conn.nonblocking) {
		return 0
	}
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		reset_pq_exp_buffer(&conn.errorMessage)
		conn.errorReported = 0
	}
	if pq_flush_vdup1(conn) {
		return -1
	}
	conn.nonblocking = barg
	return 0
}

@[export: 'PQisnonblocking']
@[markused]
pub fn pq_isnonblocking(conn &PGconn) i32 {
	if isnil(conn) || u32(conn.status) == u32(ConnStatusType.connection_bad) {
		return 0
	}
	return i32(conn.nonblocking)
}

@[export: 'PQisthreadsafe']
@[markused]
pub fn pq_isthreadsafe() i32 {
	return 1
}

@[export: 'PQflush']
@[markused]
pub fn pq_flush(conn &PGconn) i32 {
	if isnil(conn) || u32(conn.status) == u32(ConnStatusType.connection_bad) {
		return -1
	}
	return pq_flush_vdup1(conn)
}

@[markused]
pub fn pq_pipeline_flush(conn &PGconn) i32 {
	if (u32(conn.pipelineStatus) != u32(PGpipelineStatus.pq_pipeline_on)) || (conn.outCount >= 65536) {
		return pq_flush_vdup1(conn)
	}
	return 0
}

@[export: 'PQfreemem']
@[markused]
pub fn pq_freemem(ptr voidptr) {
	C.c2v_free(voidptr(ptr))
}

@[export: 'PQfreeNotify']
@[markused]
pub fn pq_free_notify(notify &PGnotify) {
	pq_freemem(voidptr(notify))
}

@[markused]
pub fn pq_escape_string_internal(conn &PGconn, to &i8, from &i8, length usize, error_ &i32, encoding i32, std_strings bool) usize {
	source := from
	target := to
	remaining := C.c2v_strnlen(from, length)
	already_complained := (0 != 0)
	if error_ {
		unsafe { *error_ = 0 }
	}
	for remaining > usize(0) {
		c := (unsafe { *source })
		charlen := i32(0)
		i := i32(0)
		if !(i32(u8(c)) & 128) {
			if (i32(c) == i8(`\'`) || (i32(c) == i8(`\\`) && (!std_strings))) {
				mut __c2v_lhs_tmp_3 := unsafe { c2v_pointer_postfix(voidptr(&target), target, isize(1)) }
				unsafe { *__c2v_lhs_tmp_3 = c }
			}
			mut __c2v_lhs_tmp_4 := unsafe { c2v_pointer_postfix(voidptr(&target), target, isize(1)) }
			unsafe { *__c2v_lhs_tmp_4 = c }
			c2v_pointer_postfix(voidptr(&source), source, isize(1))
			remaining--
			continue
		}
		charlen = pg_encoding_mblen_or_incomplete(encoding, source, remaining)
		if remaining < usize(charlen) || pg_encoding_verifymbchar(encoding, source, charlen) == -1 {
			if error_ {
				unsafe { *error_ = 1 }
			}
			if !isnil(conn) && !already_complained {
				if remaining < usize(charlen) {
					libpq_append_conn_error(conn, c'incomplete multibyte character')
				} else {
					libpq_append_conn_error(conn, c'invalid multibyte character')
				}
				already_complained = (1 != 0)
			}
			pg_encoding_set_invalid(encoding, target)
			c2v_pointer_prefix(voidptr(&target), target, isize(2))
			c2v_pointer_postfix(voidptr(&source), source, isize(1))
			remaining--
		} else {
			for i = 0; i < charlen; i++ {
				mut __c2v_lhs_tmp_5 := unsafe { c2v_pointer_postfix(voidptr(&target), target, isize(1)) }
				unsafe { *__c2v_lhs_tmp_5 = *c2v_pointer_postfix(voidptr(&source), source, isize(1)) }
				remaining--
			}
		}
	}
	unsafe { *target = i8(`\0`) }
	return usize(i64((isize(target) - isize(to)) / isize(sizeof(i8))))
}

@[export: 'PQescapeStringConn']
@[markused]
pub fn pq_escape_string_conn(conn &PGconn, to &i8, from &i8, length usize, error_ &i32) usize {
	if isnil(conn) {
		unsafe { *to = i8(`\0`) }
		if error_ {
			unsafe { *error_ = 1 }
		}
		return usize(0)
	}
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		reset_pq_exp_buffer(&conn.errorMessage)
		conn.errorReported = 0
	}
	return usize(pq_escape_string_internal(conn, to, from, length, error_, conn.client_encoding, conn.std_strings))
}

@[export: 'PQescapeString']
@[markused]
pub fn pq_escape_string(to &i8, from &i8, length usize) usize {
	return usize(pq_escape_string_internal((voidptr(0)), to, from, length, (voidptr(0)), libpq_fe_exec_static_client_encoding, libpq_fe_exec_static_std_strings))
}

@[markused]
pub fn pq_escape_internal(conn &PGconn, str &i8, len usize, as_ident bool) &i8 {
	s := &i8(0)
	result := &i8(0)
	rp := &i8(0)
	num_quotes := usize(0)
	num_backslashes := usize(0)
	input_len := C.c2v_strnlen(str, len)
	result_size := usize(0)
	quote_char := i8(if i32(as_ident) { `\"` } else { `\'` })
	validated_mb := (0 != 0)
	if isnil(conn) {
		return unsafe { nil }
	}
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		reset_pq_exp_buffer(&conn.errorMessage)
		conn.errorReported = 0
	}
	s = str
	for remaining := input_len; remaining > usize(0); remaining-- {
		if i32((unsafe { *s })) == i32(quote_char) {
			num_quotes++
		} else if i32((unsafe { *s })) == i8(`\\`) {
			num_backslashes++
		} else if (i32(u8((unsafe { *s }))) & 128) {
			charlen := i32(0)
			charlen = pg_encoding_mblen_or_incomplete(conn.client_encoding, s, remaining)
			if usize(charlen) > remaining {
				libpq_append_conn_error(conn, c'incomplete multibyte character')
				return unsafe { nil }
			}
			if !validated_mb {
				if usize(pg_encoding_verifymbstr(conn.client_encoding, s, i32(remaining))) != remaining {
					libpq_append_conn_error(conn, c'invalid multibyte character')
					return unsafe { nil }
				}
				validated_mb = (1 != 0)
			}
			c2v_pointer_prefix(voidptr(&s), s, isize(charlen - 1))
			remaining -= usize(charlen - 1)
		}
		c2v_pointer_postfix(voidptr(&s), s, isize(1))
	}
	if i32(pg_add_size_overflow(input_len, num_quotes, &result_size)) || i32(pg_add_size_overflow(result_size, usize(3), &result_size)) {
		unsafe {
			goto overflow
		}
	}
	if !as_ident && num_backslashes > usize(0) {
		if i32(pg_add_size_overflow(result_size, num_backslashes, &result_size)) || i32(pg_add_size_overflow(result_size, usize(2), &result_size)) {
			unsafe {
				goto overflow
			}
		}
	}
	rp = &i8(C.c2v_malloc(result_size))
	result = rp
	if usize(rp) == usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'out of memory')
		return unsafe { nil }
	}
	if !as_ident && num_backslashes > usize(0) {
		mut __c2v_lhs_tmp_6 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
		unsafe { *__c2v_lhs_tmp_6 = i8(` `) }
		mut __c2v_lhs_tmp_7 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
		unsafe { *__c2v_lhs_tmp_7 = i8(`E`) }
	}
	mut __c2v_lhs_tmp_8 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
	unsafe { *__c2v_lhs_tmp_8 = quote_char }
	if num_quotes == usize(0) && (num_backslashes == usize(0) || i32(as_ident)) {
		C.c2v_memcpy(voidptr(rp), voidptr(str), input_len)
		c2v_pointer_prefix(voidptr(&rp), rp, isize(input_len))
	} else {
		s = str
		for remaining := input_len; remaining > usize(0); remaining-- {
			if i32((unsafe { *s })) == i32(quote_char) || (!as_ident && i32((unsafe { *s })) == i8(`\\`)) {
				mut __c2v_lhs_tmp_9 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
				unsafe { *__c2v_lhs_tmp_9 = *s }
				mut __c2v_lhs_tmp_10 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
				unsafe { *__c2v_lhs_tmp_10 = *s }
			} else if !(i32(u8((unsafe { *s }))) & 128) {
				mut __c2v_lhs_tmp_11 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
				unsafe { *__c2v_lhs_tmp_11 = *s }
			} else {
				i := pg_encoding_mblen(conn.client_encoding, s)
				for {
					mut __c2v_lhs_tmp_12 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
					unsafe { *__c2v_lhs_tmp_12 = *s }
					i--
					if i == 0 {
						break
					}
					remaining--
					c2v_pointer_prefix(voidptr(&s), s, isize(1))
				}
			}
			c2v_pointer_postfix(voidptr(&s), s, isize(1))
		}
	}
	mut __c2v_lhs_tmp_13 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
	unsafe { *__c2v_lhs_tmp_13 = quote_char }
	unsafe { *rp = i8(`\0`) }
	return result
	overflow:
	libpq_append_conn_error(conn, c'escaped string size exceeds the maximum allowed (%zu)', u64(18446744073709551615))
	return unsafe { nil }
}

@[export: 'PQescapeLiteral']
@[markused]
pub fn pq_escape_literal(conn &PGconn, str &i8, len usize) &i8 {
	return pq_escape_internal(conn, str, len, (0 != 0))
}

@[export: 'PQescapeIdentifier']
@[markused]
pub fn pq_escape_identifier(conn &PGconn, str &i8, len usize) &i8 {
	return pq_escape_internal(conn, str, len, (1 != 0))
}

@[markused]
pub fn get_hex(c i8) i8 {
	res := i32(-1)
	if i32(c) > 0 && i32(c) < 127 {
		res = i32(libpq_fe_exec_hexlookup[u8(c)])
	}
	return i8(res)
}

@[markused]
pub fn pq_escape_bytea_internal(conn &PGconn, from &u8, from_length usize, to_length &usize, std_strings bool, use_hex bool) &u8 {
	vp := &u8(0)
	rp := &u8(0)
	result := &u8(0)
	i := usize(0)
	len := usize(0)
	bslash_len := usize((if i32(std_strings) { 1 } else { 2 }))
	len = usize(1)
	if use_hex {
		if i32(pg_add_size_overflow(len, bslash_len + usize(1), &len)) || i32(pg_add_size_overflow(len, from_length, &len)) || i32(pg_add_size_overflow(len, from_length, &len)) {
			unsafe {
				goto overflow
			}
		}
	} else {
		vp = from
		for i = from_length; i > usize(0); i-- {
			if i32((unsafe { *vp })) < 32 || i32((unsafe { *vp })) > 126 {
				if pg_add_size_overflow(len, bslash_len + usize(3), &len) {
					unsafe {
						goto overflow
					}
				}
			} else if i32((unsafe { *vp })) == `\'` {
				if pg_add_size_overflow(len, usize(2), &len) {
					unsafe {
						goto overflow
					}
				}
			} else if i32((unsafe { *vp })) == `\\` {
				if pg_add_size_overflow(len, bslash_len * usize(2), &len) {
					unsafe {
						goto overflow
					}
				}
			} else {
				if pg_add_size_overflow(len, usize(1), &len) {
					unsafe {
						goto overflow
					}
				}
			}
			c2v_pointer_postfix(voidptr(&vp), vp, isize(1))
		}
	}
	unsafe { *to_length = len }
	result = &u8(C.c2v_malloc(len))
	rp = result
	if usize(rp) == usize((voidptr(0))) {
		if conn {
			libpq_append_conn_error(conn, c'out of memory')
		}
		return unsafe { nil }
	}
	if use_hex {
		if !std_strings {
			mut __c2v_lhs_tmp_14 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_14 = u8(`\\`) }
		}
		mut __c2v_lhs_tmp_15 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
		unsafe { *__c2v_lhs_tmp_15 = u8(`\\`) }
		mut __c2v_lhs_tmp_16 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
		unsafe { *__c2v_lhs_tmp_16 = u8(`x`) }
	}
	vp = from
	for i = from_length; i > usize(0); i-- {
		c := (unsafe { *vp })
		if use_hex {
			mut __c2v_lhs_tmp_17 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_17 = u8(libpq_fe_exec_hextbl[(i32(c) >> 4) & 15]) }
			mut __c2v_lhs_tmp_18 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_18 = u8(libpq_fe_exec_hextbl[i32(c) & 15]) }
		} else if i32(c) < 32 || i32(c) > 126 {
			if !std_strings {
				mut __c2v_lhs_tmp_19 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
				unsafe { *__c2v_lhs_tmp_19 = u8(`\\`) }
			}
			mut __c2v_lhs_tmp_20 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_20 = u8(`\\`) }
			mut __c2v_lhs_tmp_21 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_21 = u8((i32(c) >> 6) + i32(`0`)) }
			mut __c2v_lhs_tmp_22 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_22 = u8(((i32(c) >> 3) & 7) + i32(`0`)) }
			mut __c2v_lhs_tmp_23 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_23 = u8((i32(c) & 7) + i32(`0`)) }
		} else if i32(c) == `\'` {
			mut __c2v_lhs_tmp_24 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_24 = u8(`\'`) }
			mut __c2v_lhs_tmp_25 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_25 = u8(`\'`) }
		} else if i32(c) == `\\` {
			if !std_strings {
				mut __c2v_lhs_tmp_26 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
				unsafe { *__c2v_lhs_tmp_26 = u8(`\\`) }
				mut __c2v_lhs_tmp_27 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
				unsafe { *__c2v_lhs_tmp_27 = u8(`\\`) }
			}
			mut __c2v_lhs_tmp_28 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_28 = u8(`\\`) }
			mut __c2v_lhs_tmp_29 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_29 = u8(`\\`) }
		} else {
			mut __c2v_lhs_tmp_30 := unsafe { c2v_pointer_postfix(voidptr(&rp), rp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_30 = c }
		}
		c2v_pointer_postfix(voidptr(&vp), vp, isize(1))
	}
	unsafe { *rp = u8(`\0`) }
	return result
	overflow:
	if conn {
		libpq_append_conn_error(conn, c'escaped bytea size exceeds the maximum allowed (%zu)', u64(18446744073709551615))
	}
	return unsafe { nil }
}

@[export: 'PQescapeByteaConn']
@[markused]
pub fn pq_escape_bytea_conn(conn &PGconn, from &u8, from_length usize, to_length &usize) &u8 {
	if isnil(conn) {
		return unsafe { nil }
	}
	if usize(conn.cmd_queue_head) == usize((voidptr(0))) {
		reset_pq_exp_buffer(&conn.errorMessage)
		conn.errorReported = 0
	}
	return pq_escape_bytea_internal(conn, from, from_length, to_length, conn.std_strings, ((conn.sversion >= 90000) != 0))
}

@[export: 'PQescapeBytea']
@[markused]
pub fn pq_escape_bytea(from &u8, from_length usize, to_length &usize) &u8 {
	return pq_escape_bytea_internal((voidptr(0)), from, from_length, to_length, libpq_fe_exec_static_std_strings, (0 != 0))
}

@[export: 'PQunescapeBytea']
@[markused]
pub fn pq_unescape_bytea(strtext &u8, retbuflen &usize) &u8 {
	strtextlen := usize(0)
	buflen := usize(0)

	buffer := &u8(0)
	tmpbuf := &u8(0)

	i := usize(0)
	j := usize(0)

	if usize(strtext) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	strtextlen = C.c2v_strlen(&i8(voidptr(strtext)))
	if i32(strtext[0]) == `\\` && i32(strtext[1]) == `x` {
		s := &u8(0)
		p := &u8(0)
		buflen = (strtextlen - usize(2)) / usize(2)
		buffer = &u8(C.c2v_malloc(if buflen > usize(0) { buflen } else { usize(1) }))
		if usize(buffer) == usize((voidptr(0))) {
			return unsafe { nil }
		}
		s = strtext + 2
		p = buffer
		for (unsafe { *s }) {
			v1 := i8(0)
			v2 := i8(0)

			v1 = get_hex(i8((unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) })))
			if !(unsafe { *s }) || i32(v1) == i32(i8(-1)) {
				continue
			}
			v2 = get_hex(i8((unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) })))
			if i32(v2) != i32(i8(-1)) {
				mut __c2v_lhs_tmp_31 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
				unsafe { *__c2v_lhs_tmp_31 = u8((i32(v1) << 4) | i32(v2)) }
			}
		}
		buflen = usize(i64((isize(p) - isize(buffer)) / isize(sizeof(u8))))
	} else {
		buffer = &u8(C.c2v_malloc(strtextlen + usize(1)))
		if usize(buffer) == usize((voidptr(0))) {
			return unsafe { nil }
		}
		j = usize(0)
		for i = usize(0); i < strtextlen;  {
			match i32(strtext[i]) {
				i32(`\\`) {
					i++
					if i32(strtext[i]) == `\\` {
						buffer[j++] = strtext[i++]
					} else {
						mut __c2v_condition_7 := false
						mut __c2v_condition_8 := false
						__c2v_condition_8 = (i32(strtext[i]) >= `0` && i32(strtext[i]) <= `3`)
						if __c2v_condition_8 {
							__c2v_condition_8 = (i32(strtext[i + usize(1)]) >= `0` && i32(strtext[i + usize(1)]) <= `7`)
						}
						if __c2v_condition_8 {
							__c2v_condition_8 = (i32(strtext[i + usize(2)]) >= `0` && i32(strtext[i + usize(2)]) <= `7`)
						}
						__c2v_condition_7 = __c2v_condition_8
						if __c2v_condition_7 {
							byte_ := i32(0)
							byte_ = (i32(strtext[i++]) - i32(`0`))
							byte_ = (byte_ << 3) + (i32(strtext[i++]) - i32(`0`))
							byte_ = (byte_ << 3) + (i32(strtext[i++]) - i32(`0`))
							buffer[j++] = u8(byte_)
						}
					}
				}
				else {
					buffer[j++] = strtext[i++]
				}
			}
		}
		buflen = j
	}
	tmpbuf = &u8(C.c2v_realloc(voidptr(buffer), buflen + usize(1)))
	if isnil(tmpbuf) {
		C.c2v_free(voidptr(buffer))
		return unsafe { nil }
	}
	unsafe { *retbuflen = buflen }
	return tmpbuf
}
