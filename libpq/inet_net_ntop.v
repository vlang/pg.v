@[translated]
module libpq

pub struct AnonStruct_189 {
pub mut:
	base i32
	len  i32
}

@[export: 'pg_inet_net_ntop']
@[markused]
pub fn pg_inet_net_ntop(af i32, src voidptr, bits i32, dst &i8, size usize) &i8 {
	match af {
		(2 + 0) {
			return inet_net_ntop_ipv4(&u8(src), bits, dst, size)
		}
		(2 + 1), 30 {
			return inet_net_ntop_ipv6(&u8(src), bits, dst, size)
		}
		else {
			{
				c2v_target := C.c2v___error()
				unsafe { *c2v_target = 47 }
			}
			return unsafe { nil }
		}
	}
	return unsafe { nil }
}

@[markused]
pub fn inet_net_ntop_ipv4(src &u8, bits i32, dst &i8, size usize) &i8 {
	odst := dst
	t := &i8(0)
	len := i32(4)
	b := i32(0)
	if bits < 0 || bits > 32 {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = 22 }
		}
		return unsafe { nil }
	}
	for b = len; b > 0; b-- {
		if size <= sizeof([5]i8) {
			unsafe {
				goto emsgsize
			}
		}
		t = dst
		if usize(dst) != usize(odst) {
			mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_postfix(voidptr(&dst), dst, isize(1)) }
			unsafe { *__c2v_lhs_tmp_0 = i8(`.`) }
		}
		c2v_pointer_prefix(voidptr(&dst), dst, isize((usize(pg_sprintf(dst, c'%u', i32((unsafe { *c2v_pointer_postfix(voidptr(&src), src, isize(1)) })))))))
		size -= usize((i64((isize(dst) - isize(t)) / isize(sizeof(i8)))))
	}
	if bits != 32 {
		if size <= sizeof([4]i8) {
			unsafe {
				goto emsgsize
			}
		}
		c2v_pointer_prefix(voidptr(&dst), dst, isize((usize(pg_sprintf(dst, c'/%u', bits)))))
	}
	return odst
	emsgsize:
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = 40 }
	}
	return unsafe { nil }
}

@[markused]
pub fn decoct(src &u8, bytes i32, dst &i8, size usize) i32 {
	odst := dst
	t := &i8(0)
	b := i32(0)
	for b = 1; b <= bytes; b++ {
		if size <= sizeof([5]i8) {
			return 0
		}
		t = dst
		c2v_pointer_prefix(voidptr(&dst), dst, isize((usize(pg_sprintf(dst, c'%u', i32((unsafe { *c2v_pointer_postfix(voidptr(&src), src, isize(1)) })))))))
		if b != bytes {
			mut __c2v_lhs_tmp_1 := unsafe { c2v_pointer_postfix(voidptr(&dst), dst, isize(1)) }
			unsafe { *__c2v_lhs_tmp_1 = i8(`.`) }
			unsafe { *dst = i8(`\0`) }
		}
		size -= usize((i64((isize(dst) - isize(t)) / isize(sizeof(i8)))))
	}
	return i32((i64((isize(dst) - isize(odst)) / isize(sizeof(i8)))))
}

@[markused]
pub fn inet_net_ntop_ipv6(src &u8, bits i32, dst &i8, size usize) &i8 {
	tmp := [50]i8{}
	tp := &i8(0)
	best := AnonStruct_189{}
	cur := AnonStruct_189{}

	words := [8]u32{}
	i := i32(0)
	if (bits < -1) || (bits > 128) {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = 22 }
		}
		return unsafe { nil }
	}
	C.c2v_memset(voidptr(unsafe { &words[0] }), `\0`, sizeof([8]u32))
	for i = 0; i < 16; i++ {
		words[i / 2] |= u32((i32(src[i]) << ((1 - (i % 2)) << 3)))
	}
	best.base = -1
	cur.base = -1
	best.len = 0
	cur.len = 0
	for i = 0; i < (16 / 2); i++ {
		if words[i] == u32(0) {
			if cur.base == -1 {
				cur.base = i
				cur.len = 1
			} else {
				cur.len++
			}
		} else {
			if cur.base != -1 {
				if best.base == -1 || cur.len > best.len {
					best = cur
				}
				cur.base = -1
			}
		}
	}
	if cur.base != -1 {
		if best.base == -1 || cur.len > best.len {
			best = cur
		}
	}
	if best.base != -1 && best.len < 2 {
		best.base = -1
	}
	tp = unsafe { &tmp[0] }
	for i = 0; i < (16 / 2); i++ {
		if best.base != -1 && i >= best.base && i < (best.base + best.len) {
			if i == best.base {
				mut __c2v_lhs_tmp_2 := unsafe { c2v_pointer_postfix(voidptr(&tp), tp, isize(1)) }
				unsafe { *__c2v_lhs_tmp_2 = i8(`:`) }
			}
			continue
		}
		if i != 0 {
			mut __c2v_lhs_tmp_3 := unsafe { c2v_pointer_postfix(voidptr(&tp), tp, isize(1)) }
			unsafe { *__c2v_lhs_tmp_3 = i8(`:`) }
		}
		if i == 6 && best.base == 0 && (best.len == 6 || (best.len == 7 && words[7] != u32(1)) || (best.len == 5 && words[5] == u32(65535))) {
			n := i32(0)
			n = decoct(src + 12, 4, tp, sizeof([50]i8) - u64((i64((isize(tp) - isize(unsafe { &tmp[0] })) / isize(sizeof(i8))))))
			if n == 0 {
				{
					c2v_target := C.c2v___error()
					unsafe { *c2v_target = 40 }
				}
				return unsafe { nil }
			}
			c2v_pointer_prefix(voidptr(&tp), tp, isize(C.c2v_strlen(tp)))
			break
		}
		c2v_pointer_prefix(voidptr(&tp), tp, isize((usize(pg_sprintf(tp, c'%x', words[i])))))
	}
	if best.base != -1 && (best.base + best.len) == (16 / 2) {
		mut __c2v_lhs_tmp_4 := unsafe { c2v_pointer_postfix(voidptr(&tp), tp, isize(1)) }
		unsafe { *__c2v_lhs_tmp_4 = i8(`:`) }
	}
	unsafe { *tp = i8(`\0`) }
	if bits != -1 && bits != 128 {
		c2v_pointer_prefix(voidptr(&tp), tp, isize((usize(pg_sprintf(tp, c'/%u', bits)))))
	}
	if usize((i64((isize(tp) - isize(unsafe { &tmp[0] })) / isize(sizeof(i8))))) > size {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = 40 }
		}
		return unsafe { nil }
	}
	C.c2v_strcpy(dst, unsafe { &i8(&tmp[0]) })
	return dst
}
