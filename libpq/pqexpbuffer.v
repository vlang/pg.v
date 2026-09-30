@[translated]
module libpq

@[markused]
pub fn mark_pq_exp_buffer_broken(str PQExpBuffer) {
	if usize(str.data) != usize(unsafe { &libpq_pqexpbuffer_oom_buffer[0] }) {
		C.c2v_free(voidptr(str.data))
	}
	str.data = (if true {
		&i8(libpq_pqexpbuffer_oom_buffer_ptr)
	} else {
		unsafe { nil }
	})
	str.len = usize(0)
	str.maxlen = usize(0)
}

@[export: 'createPQExpBuffer']
@[markused]
pub fn create_pq_exp_buffer() PQExpBuffer {
	res := PQExpBuffer(unsafe { nil })
	res = PQExpBuffer(C.c2v_malloc(sizeof(PQExpBufferData)))
	if usize(voidptr(res)) != usize(voidptr((voidptr(0)))) {
		init_pq_exp_buffer(res)
	}
	return res
}

@[export: 'initPQExpBuffer']
@[markused]
pub fn init_pq_exp_buffer(str PQExpBuffer) {
	str.data = &i8(C.c2v_malloc(u64(256)))
	if usize(str.data) == usize((voidptr(0))) {
		str.data = (if true {
			&i8(libpq_pqexpbuffer_oom_buffer_ptr)
		} else {
			unsafe { nil }
		})
		str.maxlen = usize(0)
		str.len = usize(0)
	} else {
		str.maxlen = usize(256)
		str.len = usize(0)
		str.data[0] = i8(`\0`)
	}
}

@[export: 'destroyPQExpBuffer']
@[markused]
pub fn destroy_pq_exp_buffer(str PQExpBuffer) {
	if str {
		term_pq_exp_buffer(str)
		C.c2v_free(voidptr(str))
	}
}

@[export: 'termPQExpBuffer']
@[markused]
pub fn term_pq_exp_buffer(str PQExpBuffer) {
	if usize(str.data) != usize(unsafe { &libpq_pqexpbuffer_oom_buffer[0] }) {
		C.c2v_free(voidptr(str.data))
	}
	str.data = (if true {
		&i8(libpq_pqexpbuffer_oom_buffer_ptr)
	} else {
		unsafe { nil }
	})
	str.maxlen = usize(0)
	str.len = usize(0)
}

@[export: 'resetPQExpBuffer']
@[markused]
pub fn reset_pq_exp_buffer(str PQExpBuffer) {
	if str {
		if usize(str.data) != usize(unsafe { &libpq_pqexpbuffer_oom_buffer[0] }) {
			str.len = usize(0)
			str.data[0] = i8(`\0`)
		} else {
			init_pq_exp_buffer(str)
		}
	}
}

@[export: 'enlargePQExpBuffer']
@[markused]
pub fn enlarge_pq_exp_buffer(str PQExpBuffer, needed usize) int {
	newlen := usize(0)
	newdata := &i8(0)
	if (usize(voidptr(str)) == usize(voidptr((voidptr(0)))) || str.maxlen == usize(0)) {
		return 0
	}
	if needed >= (usize(2147483647) - str.len) {
		mark_pq_exp_buffer_broken(str)
		return 0
	}
	needed += str.len + usize(1)
	if needed <= str.maxlen {
		return 1
	}
	newlen = if (str.maxlen > usize(0)) { (usize(2) * str.maxlen) } else { usize(64) }
	for needed > newlen {
		newlen = usize(2) * newlen
	}
	if newlen > usize(2147483647) {
		newlen = usize(2147483647)
	}
	newdata = &i8(C.c2v_realloc(voidptr(str.data), newlen))
	if usize(newdata) != usize((voidptr(0))) {
		str.data = newdata
		str.maxlen = newlen
		return 1
	}
	mark_pq_exp_buffer_broken(str)
	return 0
}

@[c: 'printfPQExpBuffer']
@[c2v_variadic; markused]
pub fn printf_pq_exp_buffer(str PQExpBuffer, fmt &i8, ...) {
	save_errno := (unsafe { *C.c2v___error() })
	args := C.va_list{}
	done := false
	reset_pq_exp_buffer(str)
	if (usize(voidptr(str)) == usize(voidptr((voidptr(0)))) || str.maxlen == usize(0)) {
		return
	}
	for {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = save_errno }
		}
		C.c2v_va_start(args, fmt)
		done = append_pq_exp_buffer_va(str, fmt, args)
		C.c2v_va_end(args)
		if !(!done) {
			break
		}
	}
}

@[c: 'appendPQExpBuffer']
@[c2v_variadic; markused]
pub fn append_pq_exp_buffer(str PQExpBuffer, fmt &i8, ...) {
	save_errno := (unsafe { *C.c2v___error() })
	args := C.va_list{}
	done := false
	if (usize(voidptr(str)) == usize(voidptr((voidptr(0)))) || str.maxlen == usize(0)) {
		return
	}
	for {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = save_errno }
		}
		C.c2v_va_start(args, fmt)
		done = append_pq_exp_buffer_va(str, fmt, args)
		C.c2v_va_end(args)
		if !(!done) {
			break
		}
	}
}

@[export: 'appendPQExpBufferVA']
@[markused]
pub fn append_pq_exp_buffer_va(str PQExpBuffer, fmt &i8, args C.va_list) bool {
	avail := usize(0)
	needed := usize(0)
	nprinted := 0
	if str.maxlen > str.len + usize(16) {
		avail = str.maxlen - str.len
		nprinted = pg_vsnprintf(str.data + str.len, avail, fmt, args)
		if (i64((nprinted < 0) != 0)) {
			mark_pq_exp_buffer_broken(str)
			return true != 0
		}
		if usize(nprinted) < avail {
			str.len += usize(nprinted)
			return true != 0
		}
		if (i64((nprinted > 2147483647 - 1) != 0)) {
			mark_pq_exp_buffer_broken(str)
			return true != 0
		}
		needed = usize(nprinted + 1)
	} else {
		needed = usize(32)
	}
	if !enlarge_pq_exp_buffer(str, needed) {
		return true != 0
	}
	return false != 0
}

@[export: 'appendPQExpBufferStr']
@[markused]
pub fn append_pq_exp_buffer_str(str PQExpBuffer, data &i8) {
	append_binary_pq_exp_buffer(str, data, C.c2v_strlen(data))
}

@[export: 'appendPQExpBufferChar']
@[markused]
pub fn append_pq_exp_buffer_char(str PQExpBuffer, ch i8) {
	if !enlarge_pq_exp_buffer(str, usize(1)) {
		return
	}
	str.data[str.len] = ch
	str.len++
	str.data[str.len] = i8(`\0`)
}

@[export: 'appendBinaryPQExpBuffer']
@[markused]
pub fn append_binary_pq_exp_buffer(str PQExpBuffer, data &i8, datalen usize) {
	if !enlarge_pq_exp_buffer(str, datalen) {
		return
	}
	C.c2v_memcpy(voidptr(str.data + str.len), voidptr(data), datalen)
	str.len += datalen
	str.data[str.len] = i8(`\0`)
}
