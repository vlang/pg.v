@[translated]
module libpq

@[export: 'pg_str_endswith']
@[markused]
pub fn pg_str_endswith(str &i8, end &i8) bool {
	slen := C.c2v_strlen(str)
	elen := C.c2v_strlen(end)
	if elen > slen {
		return false != 0
	}
	c2v_pointer_prefix(voidptr(&str), str, isize(slen - elen))
	return C.c2v_strcmp(str, end) == false
}

@[export: 'strtoint']
@[markused]
pub fn strtoint(str &i8, endptr &&u8, base i32) i32 {
	val := i64(0)
	val = C.c2v_strtol(str, endptr, base)
	if val != i64(i32(val)) {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = 34 }
		}
	}
	return i32(val)
}

@[export: 'pg_clean_ascii']
@[markused]
pub fn pg_clean_ascii(str &i8, alloc_flags i32) &i8 {
	dstlen := usize(0)
	dst := &i8(0)
	p := &i8(0)
	i := usize(0)
	dstlen = C.c2v_strlen(str) * u64(4) + u64(1)
	dst = &i8(C.c2v_malloc(dstlen))
	if isnil(dst) {
		return unsafe { nil }
	}
	for p = str; i32((unsafe { *p })) != i8(`\0`); p = unsafe { p + 1 } {
		if i32((unsafe { *p })) < 32 || i32((unsafe { *p })) > 126 {
			pg_snprintf(unsafe { dst + i }, dstlen - i, c'\\x%02x', i32(u8((unsafe { *p }))))
			i += usize(4)
		} else {
			dst[i] = unsafe { *p }
			i++
		}
	}

	dst[i] = i8(`\0`)
	return dst
}

@[export: 'pg_is_ascii']
@[markused]
pub fn pg_is_ascii(str &i8) bool {
	for (unsafe { *str }) {
		if (i32(u8((unsafe { *str }))) & 128) {
			return false != 0
		}
		c2v_pointer_postfix(voidptr(&str), str, isize(1))
	}
	return true != 0
}

@[export: 'pg_strip_crlf']
@[markused]
pub fn pg_strip_crlf(str &i8) i32 {
	len := i32(C.c2v_strlen(str))
	for len > 0 && (i32(str[len - 1]) == i8(`\n`) || i32(str[len - 1]) == i8(`\r`)) {
		str[c2v_prefix_add(unsafe { &len }, i32(-1))] = i8(`\0`)
	}
	return len
}
