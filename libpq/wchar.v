@[translated]
module libpq

@[markused]
pub fn libpq_wchar_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_wchar_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_wchar_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_wchar_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_wchar_utf8_to_unicode(c &u8) Pg_wchar {
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
pub fn libpq_wchar_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
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
pub fn libpq_wchar_unicode_utf8len(c Pg_wchar) int {
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

@[markused]
pub fn libpq_wchar_vector8_load(v &Vector8, s &Uint8) {
	C.c2v_memcpy(voidptr(v), voidptr(s), sizeof(Vector8))
}

@[markused]
pub fn libpq_wchar_vector8_broadcast(c Uint8) Vector8 {
	return ~0 / u64(255) * u64(c)
}

@[markused]
pub fn libpq_wchar_vector8_has(v Vector8, c Uint8) bool {
	result := false
	result = libpq_wchar_vector8_has_zero(v ^ libpq_wchar_vector8_broadcast(c))

	return result
}

@[markused]
pub fn libpq_wchar_vector8_has_zero(v Vector8) bool {
	return libpq_wchar_vector8_has_le(v, Uint8(0))
}

@[markused]
pub fn libpq_wchar_vector8_has_le(v Vector8, c Uint8) bool {
	result := (0 != 0)
	if Int64(v) >= Int64(0) && int(c) < 128 {
		result = ((v - libpq_wchar_vector8_broadcast(Uint8(int(c) + 1))) & ~v & libpq_wchar_vector8_broadcast(Uint8(128)) != 0)
	} else {
		for i := Size(0); i < sizeof(Vector8); i++ {
			if int((&Uint8(c2v_address_of(&v)))[i]) <= int(c) {
				result = (1 != 0)
				break
			}
		}
	}

	return result
}

@[markused]
pub fn libpq_wchar_vector8_is_highbit_set(v Vector8) bool {
	return v & libpq_wchar_vector8_broadcast(Uint8(128)) != 0
}

@[markused]
pub fn libpq_wchar_vector8_or(v1 Vector8, v2 Vector8) Vector8 {
	return v1 | v2
}

@[markused]
pub fn is_valid_ascii(s &u8, len int) bool {
	s_end := s + len
	chunk := Vector8(0)
	highbit_cum := libpq_wchar_vector8_broadcast(Uint8(0))
	zero_cum := libpq_wchar_vector8_broadcast(Uint8(128))

	for usize(s) < usize(s_end) {
		libpq_wchar_vector8_load(&chunk, unsafe { &Uint8(s) })
		zero_cum &= (chunk + libpq_wchar_vector8_broadcast(Uint8(127)))
		highbit_cum = libpq_wchar_vector8_or(highbit_cum, chunk)
		c2v_pointer_prefix(voidptr(&s), s, isize(sizeof(chunk)))
	}
	if libpq_wchar_vector8_is_highbit_set(highbit_cum) {
		return false != 0
	}
	if zero_cum != libpq_wchar_vector8_broadcast(Uint8(128)) {
		return false != 0
	}
	return true != 0
}

@[markused]
pub fn pg_ascii2wchar_with_len(from &u8, to &Pg_wchar, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	for len > 0 && int((unsafe { *from })) {
		mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
		unsafe { *__c2v_lhs_tmp_0 = *c2v_pointer_postfix(voidptr(&from), from, isize(1)) }
		len--
		cnt++
	}
	unsafe { *to = Pg_wchar(0) }
	return cnt
}

@[markused]
pub fn pg_ascii_mblen(s &u8) int {
	c2v_gc_register_thread()
	return 1
}

@[markused]
pub fn pg_ascii_dsplen(s &u8) int {
	c2v_gc_register_thread()
	if int((unsafe { *s })) == `\0` {
		return 0
	}
	if int((unsafe { *s })) < 32 || int((unsafe { *s })) == 127 {
		return -1
	}
	return 1
}

@[markused]
pub fn pg_euc2wchar_with_len(from &u8, to &Pg_wchar, len int) int {
	cnt := 0
	for len > 0 && int((unsafe { *from })) {
		if int((unsafe { *from })) == 142 {
			if len < 2 {
				break
			}
			c2v_pointer_postfix(voidptr(&from), from, isize(1))
			unsafe { *to = Pg_wchar((142 << 8) | int(*c2v_pointer_postfix(voidptr(&from), from, isize(1)))) }
			len -= 2
		} else if int((unsafe { *from })) == 143 {
			if len < 3 {
				break
			}
			c2v_pointer_postfix(voidptr(&from), from, isize(1))
			unsafe { *to = Pg_wchar((143 << 16) | (int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8)) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 3
		} else if (int(u8((unsafe { *from }))) & 128) {
			if len < 2 {
				break
			}
			unsafe { *to = Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 2
		} else {
			unsafe { *to = *c2v_pointer_postfix(voidptr(&from), from, isize(1)) }
			len--
		}
		c2v_pointer_postfix(voidptr(&to), to, isize(1))
		cnt++
	}
	unsafe { *to = Pg_wchar(0) }
	return cnt
}

@[markused]
pub fn pg_euc_mblen(s &u8) int {
	len := 0
	if int((unsafe { *s })) == 142 {
		len = 2
	} else if int((unsafe { *s })) == 143 {
		len = 3
	} else if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = 1
	}
	return len
}

@[markused]
pub fn pg_euc_dsplen(s &u8) int {
	len := 0
	if int((unsafe { *s })) == 142 {
		len = 2
	} else if int((unsafe { *s })) == 143 {
		len = 2
	} else if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = pg_ascii_dsplen(s)
	}
	return len
}

@[markused]
pub fn pg_eucjp2wchar_with_len(from &u8, to &Pg_wchar, len int) int {
	c2v_gc_register_thread()
	return pg_euc2wchar_with_len(from, to, len)
}

@[markused]
pub fn pg_eucjp_mblen(s &u8) int {
	c2v_gc_register_thread()
	return pg_euc_mblen(s)
}

@[markused]
pub fn pg_eucjp_dsplen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if int((unsafe { *s })) == 142 {
		len = 1
	} else if int((unsafe { *s })) == 143 {
		len = 2
	} else if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = pg_ascii_dsplen(s)
	}
	return len
}

@[markused]
pub fn pg_euckr2wchar_with_len(from &u8, to &Pg_wchar, len int) int {
	c2v_gc_register_thread()
	return pg_euc2wchar_with_len(from, to, len)
}

@[markused]
pub fn pg_euckr_mblen(s &u8) int {
	c2v_gc_register_thread()
	return pg_euc_mblen(s)
}

@[markused]
pub fn pg_euckr_dsplen(s &u8) int {
	c2v_gc_register_thread()
	return pg_euc_dsplen(s)
}

@[markused]
pub fn pg_euccn2wchar_with_len(from &u8, to &Pg_wchar, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	for len > 0 && int((unsafe { *from })) {
		if int((unsafe { *from })) == 142 {
			if len < 3 {
				break
			}
			c2v_pointer_postfix(voidptr(&from), from, isize(1))
			unsafe { *to = Pg_wchar((142 << 16) | (int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8)) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 3
		} else if int((unsafe { *from })) == 143 {
			if len < 3 {
				break
			}
			c2v_pointer_postfix(voidptr(&from), from, isize(1))
			unsafe { *to = Pg_wchar((143 << 16) | (int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8)) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 3
		} else if (int(u8((unsafe { *from }))) & 128) {
			if len < 2 {
				break
			}
			unsafe { *to = Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 2
		} else {
			unsafe { *to = *c2v_pointer_postfix(voidptr(&from), from, isize(1)) }
			len--
		}
		c2v_pointer_postfix(voidptr(&to), to, isize(1))
		cnt++
	}
	unsafe { *to = Pg_wchar(0) }
	return cnt
}

@[markused]
pub fn pg_euccn_mblen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if int((unsafe { *s })) == 142 {
		len = 3
	} else if int((unsafe { *s })) == 143 {
		len = 3
	} else if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = 1
	}
	return len
}

@[markused]
pub fn pg_euccn_dsplen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = pg_ascii_dsplen(s)
	}
	return len
}

@[markused]
pub fn pg_euctw2wchar_with_len(from &u8, to &Pg_wchar, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	for len > 0 && int((unsafe { *from })) {
		if int((unsafe { *from })) == 142 {
			if len < 4 {
				break
			}
			c2v_pointer_postfix(voidptr(&from), from, isize(1))
			unsafe { *to = ((Uint32(142)) << 24) | Uint32((int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 16)) }
			unsafe { *to |= Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 4
		} else if int((unsafe { *from })) == 143 {
			if len < 3 {
				break
			}
			c2v_pointer_postfix(voidptr(&from), from, isize(1))
			unsafe { *to = Pg_wchar((143 << 16) | (int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8)) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 3
		} else if (int(u8((unsafe { *from }))) & 128) {
			if len < 2 {
				break
			}
			unsafe { *to = Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 2
		} else {
			unsafe { *to = *c2v_pointer_postfix(voidptr(&from), from, isize(1)) }
			len--
		}
		c2v_pointer_postfix(voidptr(&to), to, isize(1))
		cnt++
	}
	unsafe { *to = Pg_wchar(0) }
	return cnt
}

@[markused]
pub fn pg_euctw_mblen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if int((unsafe { *s })) == 142 {
		len = 4
	} else if int((unsafe { *s })) == 143 {
		len = 3
	} else if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = 1
	}
	return len
}

@[markused]
pub fn pg_euctw_dsplen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if int((unsafe { *s })) == 142 {
		len = 2
	} else if int((unsafe { *s })) == 143 {
		len = 2
	} else if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = pg_ascii_dsplen(s)
	}
	return len
}

@[markused]
pub fn pg_wchar2euc_with_len(from &Pg_wchar, to &u8, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	for len > 0 && (unsafe { *from }) {
		c := u8(0)
		c = u8(((unsafe { *from }) >> 24))
		if c {
			mut __c2v_lhs_tmp_1 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_1 = c }
			mut __c2v_lhs_tmp_2 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_2 = u8((*from >> 16) & Pg_wchar(255)) }
			mut __c2v_lhs_tmp_3 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_3 = u8((*from >> 8) & Pg_wchar(255)) }
			mut __c2v_lhs_tmp_4 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_4 = u8(*from & Pg_wchar(255)) }
			cnt += 4
		} else {
			c = u8(((unsafe { *from }) >> 16))
			if c {
				mut __c2v_lhs_tmp_5 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
				unsafe { *__c2v_lhs_tmp_5 = c }
				mut __c2v_lhs_tmp_6 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
				unsafe { *__c2v_lhs_tmp_6 = u8((*from >> 8) & Pg_wchar(255)) }
				mut __c2v_lhs_tmp_7 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
				unsafe { *__c2v_lhs_tmp_7 = u8(*from & Pg_wchar(255)) }
				cnt += 3
			} else {
				c = u8(((unsafe { *from }) >> 8))
				if c {
					mut __c2v_lhs_tmp_8 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
					unsafe { *__c2v_lhs_tmp_8 = c }
					mut __c2v_lhs_tmp_9 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
					unsafe { *__c2v_lhs_tmp_9 = u8(*from & Pg_wchar(255)) }
					cnt += 2
				} else {
					mut __c2v_lhs_tmp_10 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
					unsafe { *__c2v_lhs_tmp_10 = *from }
					cnt++
				}
			}
		}
		c2v_pointer_postfix(voidptr(&from), from, isize(1))
		len--
	}
	unsafe { *to = u8(0) }
	return cnt
}

@[markused]
pub fn pg_johab_mblen(s &u8) int {
	c2v_gc_register_thread()
	return pg_euc_mblen(s)
}

@[markused]
pub fn pg_johab_dsplen(s &u8) int {
	c2v_gc_register_thread()
	return pg_euc_dsplen(s)
}

@[markused]
pub fn pg_utf2wchar_with_len(from &u8, to &Pg_wchar, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	c1 := Uint32(0)
	c2 := Uint32(0)
	c3 := Uint32(0)
	c4 := Uint32(0)

	for len > 0 && int((unsafe { *from })) {
		if (int((unsafe { *from })) & 128) == 0 {
			unsafe { *to = *c2v_pointer_postfix(voidptr(&from), from, isize(1)) }
			len--
		} else if (int((unsafe { *from })) & 224) == 192 {
			if len < 2 {
				break
			}
			c1 = Uint32(int((unsafe { *c2v_pointer_postfix(voidptr(&from), from, isize(1)) })) & 31)
			c2 = Uint32(int((unsafe { *c2v_pointer_postfix(voidptr(&from), from, isize(1)) })) & 63)
			unsafe { *to = (c1 << 6) | c2 }
			len -= 2
		} else if (int((unsafe { *from })) & 240) == 224 {
			if len < 3 {
				break
			}
			c1 = Uint32(int((unsafe { *c2v_pointer_postfix(voidptr(&from), from, isize(1)) })) & 15)
			c2 = Uint32(int((unsafe { *c2v_pointer_postfix(voidptr(&from), from, isize(1)) })) & 63)
			c3 = Uint32(int((unsafe { *c2v_pointer_postfix(voidptr(&from), from, isize(1)) })) & 63)
			unsafe { *to = (c1 << 12) | (c2 << 6) | c3 }
			len -= 3
		} else if (int((unsafe { *from })) & 248) == 240 {
			if len < 4 {
				break
			}
			c1 = Uint32(int((unsafe { *c2v_pointer_postfix(voidptr(&from), from, isize(1)) })) & 7)
			c2 = Uint32(int((unsafe { *c2v_pointer_postfix(voidptr(&from), from, isize(1)) })) & 63)
			c3 = Uint32(int((unsafe { *c2v_pointer_postfix(voidptr(&from), from, isize(1)) })) & 63)
			c4 = Uint32(int((unsafe { *c2v_pointer_postfix(voidptr(&from), from, isize(1)) })) & 63)
			unsafe { *to = (c1 << 18) | (c2 << 12) | (c3 << 6) | c4 }
			len -= 4
		} else {
			unsafe { *to = *c2v_pointer_postfix(voidptr(&from), from, isize(1)) }
			len--
		}
		c2v_pointer_postfix(voidptr(&to), to, isize(1))
		cnt++
	}
	unsafe { *to = Pg_wchar(0) }
	return cnt
}

@[markused]
pub fn pg_wchar2utf_with_len(from &Pg_wchar, to &u8, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	for len > 0 && (unsafe { *from }) {
		char_len := 0
		libpq_wchar_unicode_to_utf8((unsafe { *from }), to)
		char_len = pg_utf_mblen(to)
		cnt += char_len
		c2v_pointer_prefix(voidptr(&to), to, isize(char_len))
		c2v_pointer_postfix(voidptr(&from), from, isize(1))
		len--
	}
	unsafe { *to = u8(0) }
	return cnt
}

@[export: 'pg_utf_mblen']
@[markused]
pub fn pg_utf_mblen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int((unsafe { *s })) & 128) == 0 {
		len = 1
	} else if (int((unsafe { *s })) & 224) == 192 {
		len = 2
	} else if (int((unsafe { *s })) & 240) == 224 {
		len = 3
	} else if (int((unsafe { *s })) & 248) == 240 {
		len = 4
	} else {
		len = 1
	}
	return len
}

pub struct Mbinterval {
pub mut:
	first u32
	last  u32
}

@[markused]
pub fn mbbisearch(ucs Pg_wchar, table &Mbinterval, max int) int {
	min := 0
	mid := 0
	if ucs < table[0].first || ucs > table[max].last {
		return 0
	}
	for max >= min {
		mid = (min + max) / 2
		if ucs > table[mid].last {
			min = mid + 1
		} else if ucs < table[mid].first {
			max = mid - 1
		} else {
			return 1
		}
	}
	return 0
}

@[markused]
pub fn ucs_wcwidth(ucs Pg_wchar) int {
	if !ucs_wcwidth_nonspacing_inited {
		c2v_static_init := [Mbinterval{
			first: u32(173)
			last: u32(173)
		}, Mbinterval{
			first: u32(768)
			last: u32(879)
		}, Mbinterval{
			first: u32(1155)
			last: u32(1161)
		}, Mbinterval{
			first: u32(1425)
			last: u32(1469)
		}, Mbinterval{
			first: u32(1471)
			last: u32(1471)
		}, Mbinterval{
			first: u32(1473)
			last: u32(1474)
		}, Mbinterval{
			first: u32(1476)
			last: u32(1477)
		}, Mbinterval{
			first: u32(1479)
			last: u32(1479)
		}, Mbinterval{
			first: u32(1536)
			last: u32(1541)
		}, Mbinterval{
			first: u32(1552)
			last: u32(1562)
		}, Mbinterval{
			first: u32(1564)
			last: u32(1564)
		}, Mbinterval{
			first: u32(1611)
			last: u32(1631)
		}, Mbinterval{
			first: u32(1648)
			last: u32(1648)
		}, Mbinterval{
			first: u32(1750)
			last: u32(1757)
		}, Mbinterval{
			first: u32(1759)
			last: u32(1764)
		}, Mbinterval{
			first: u32(1767)
			last: u32(1768)
		}, Mbinterval{
			first: u32(1770)
			last: u32(1773)
		}, Mbinterval{
			first: u32(1807)
			last: u32(1807)
		}, Mbinterval{
			first: u32(1809)
			last: u32(1809)
		}, Mbinterval{
			first: u32(1840)
			last: u32(1866)
		}, Mbinterval{
			first: u32(1958)
			last: u32(1968)
		}, Mbinterval{
			first: u32(2027)
			last: u32(2035)
		}, Mbinterval{
			first: u32(2045)
			last: u32(2045)
		}, Mbinterval{
			first: u32(2070)
			last: u32(2073)
		}, Mbinterval{
			first: u32(2075)
			last: u32(2083)
		}, Mbinterval{
			first: u32(2085)
			last: u32(2087)
		}, Mbinterval{
			first: u32(2089)
			last: u32(2093)
		}, Mbinterval{
			first: u32(2137)
			last: u32(2139)
		}, Mbinterval{
			first: u32(2192)
			last: u32(2207)
		}, Mbinterval{
			first: u32(2250)
			last: u32(2306)
		}, Mbinterval{
			first: u32(2362)
			last: u32(2362)
		}, Mbinterval{
			first: u32(2364)
			last: u32(2364)
		}, Mbinterval{
			first: u32(2369)
			last: u32(2376)
		}, Mbinterval{
			first: u32(2381)
			last: u32(2381)
		}, Mbinterval{
			first: u32(2385)
			last: u32(2391)
		}, Mbinterval{
			first: u32(2402)
			last: u32(2403)
		}, Mbinterval{
			first: u32(2433)
			last: u32(2433)
		}, Mbinterval{
			first: u32(2492)
			last: u32(2492)
		}, Mbinterval{
			first: u32(2497)
			last: u32(2500)
		}, Mbinterval{
			first: u32(2509)
			last: u32(2509)
		}, Mbinterval{
			first: u32(2530)
			last: u32(2531)
		}, Mbinterval{
			first: u32(2558)
			last: u32(2562)
		}, Mbinterval{
			first: u32(2620)
			last: u32(2620)
		}, Mbinterval{
			first: u32(2625)
			last: u32(2641)
		}, Mbinterval{
			first: u32(2672)
			last: u32(2673)
		}, Mbinterval{
			first: u32(2677)
			last: u32(2677)
		}, Mbinterval{
			first: u32(2689)
			last: u32(2690)
		}, Mbinterval{
			first: u32(2748)
			last: u32(2748)
		}, Mbinterval{
			first: u32(2753)
			last: u32(2760)
		}, Mbinterval{
			first: u32(2765)
			last: u32(2765)
		}, Mbinterval{
			first: u32(2786)
			last: u32(2787)
		}, Mbinterval{
			first: u32(2810)
			last: u32(2817)
		}, Mbinterval{
			first: u32(2876)
			last: u32(2876)
		}, Mbinterval{
			first: u32(2879)
			last: u32(2879)
		}, Mbinterval{
			first: u32(2881)
			last: u32(2884)
		}, Mbinterval{
			first: u32(2893)
			last: u32(2902)
		}, Mbinterval{
			first: u32(2914)
			last: u32(2915)
		}, Mbinterval{
			first: u32(2946)
			last: u32(2946)
		}, Mbinterval{
			first: u32(3008)
			last: u32(3008)
		}, Mbinterval{
			first: u32(3021)
			last: u32(3021)
		}, Mbinterval{
			first: u32(3072)
			last: u32(3072)
		}, Mbinterval{
			first: u32(3076)
			last: u32(3076)
		}, Mbinterval{
			first: u32(3132)
			last: u32(3132)
		}, Mbinterval{
			first: u32(3134)
			last: u32(3136)
		}, Mbinterval{
			first: u32(3142)
			last: u32(3158)
		}, Mbinterval{
			first: u32(3170)
			last: u32(3171)
		}, Mbinterval{
			first: u32(3201)
			last: u32(3201)
		}, Mbinterval{
			first: u32(3260)
			last: u32(3260)
		}, Mbinterval{
			first: u32(3263)
			last: u32(3263)
		}, Mbinterval{
			first: u32(3270)
			last: u32(3270)
		}, Mbinterval{
			first: u32(3276)
			last: u32(3277)
		}, Mbinterval{
			first: u32(3298)
			last: u32(3299)
		}, Mbinterval{
			first: u32(3328)
			last: u32(3329)
		}, Mbinterval{
			first: u32(3387)
			last: u32(3388)
		}, Mbinterval{
			first: u32(3393)
			last: u32(3396)
		}, Mbinterval{
			first: u32(3405)
			last: u32(3405)
		}, Mbinterval{
			first: u32(3426)
			last: u32(3427)
		}, Mbinterval{
			first: u32(3457)
			last: u32(3457)
		}, Mbinterval{
			first: u32(3530)
			last: u32(3530)
		}, Mbinterval{
			first: u32(3538)
			last: u32(3542)
		}, Mbinterval{
			first: u32(3633)
			last: u32(3633)
		}, Mbinterval{
			first: u32(3636)
			last: u32(3642)
		}, Mbinterval{
			first: u32(3655)
			last: u32(3662)
		}, Mbinterval{
			first: u32(3761)
			last: u32(3761)
		}, Mbinterval{
			first: u32(3764)
			last: u32(3772)
		}, Mbinterval{
			first: u32(3784)
			last: u32(3790)
		}, Mbinterval{
			first: u32(3864)
			last: u32(3865)
		}, Mbinterval{
			first: u32(3893)
			last: u32(3893)
		}, Mbinterval{
			first: u32(3895)
			last: u32(3895)
		}, Mbinterval{
			first: u32(3897)
			last: u32(3897)
		}, Mbinterval{
			first: u32(3953)
			last: u32(3966)
		}, Mbinterval{
			first: u32(3968)
			last: u32(3972)
		}, Mbinterval{
			first: u32(3974)
			last: u32(3975)
		}, Mbinterval{
			first: u32(3981)
			last: u32(4028)
		}, Mbinterval{
			first: u32(4038)
			last: u32(4038)
		}, Mbinterval{
			first: u32(4141)
			last: u32(4144)
		}, Mbinterval{
			first: u32(4146)
			last: u32(4151)
		}, Mbinterval{
			first: u32(4153)
			last: u32(4154)
		}, Mbinterval{
			first: u32(4157)
			last: u32(4158)
		}, Mbinterval{
			first: u32(4184)
			last: u32(4185)
		}, Mbinterval{
			first: u32(4190)
			last: u32(4192)
		}, Mbinterval{
			first: u32(4209)
			last: u32(4212)
		}, Mbinterval{
			first: u32(4226)
			last: u32(4226)
		}, Mbinterval{
			first: u32(4229)
			last: u32(4230)
		}, Mbinterval{
			first: u32(4237)
			last: u32(4237)
		}, Mbinterval{
			first: u32(4253)
			last: u32(4253)
		}, Mbinterval{
			first: u32(4957)
			last: u32(4959)
		}, Mbinterval{
			first: u32(5906)
			last: u32(5908)
		}, Mbinterval{
			first: u32(5938)
			last: u32(5939)
		}, Mbinterval{
			first: u32(5970)
			last: u32(5971)
		}, Mbinterval{
			first: u32(6002)
			last: u32(6003)
		}, Mbinterval{
			first: u32(6068)
			last: u32(6069)
		}, Mbinterval{
			first: u32(6071)
			last: u32(6077)
		}, Mbinterval{
			first: u32(6086)
			last: u32(6086)
		}, Mbinterval{
			first: u32(6089)
			last: u32(6099)
		}, Mbinterval{
			first: u32(6109)
			last: u32(6109)
		}, Mbinterval{
			first: u32(6155)
			last: u32(6159)
		}, Mbinterval{
			first: u32(6277)
			last: u32(6278)
		}, Mbinterval{
			first: u32(6313)
			last: u32(6313)
		}, Mbinterval{
			first: u32(6432)
			last: u32(6434)
		}, Mbinterval{
			first: u32(6439)
			last: u32(6440)
		}, Mbinterval{
			first: u32(6450)
			last: u32(6450)
		}, Mbinterval{
			first: u32(6457)
			last: u32(6459)
		}, Mbinterval{
			first: u32(6679)
			last: u32(6680)
		}, Mbinterval{
			first: u32(6683)
			last: u32(6683)
		}, Mbinterval{
			first: u32(6742)
			last: u32(6742)
		}, Mbinterval{
			first: u32(6744)
			last: u32(6752)
		}, Mbinterval{
			first: u32(6754)
			last: u32(6754)
		}, Mbinterval{
			first: u32(6757)
			last: u32(6764)
		}, Mbinterval{
			first: u32(6771)
			last: u32(6783)
		}, Mbinterval{
			first: u32(6832)
			last: u32(6915)
		}, Mbinterval{
			first: u32(6964)
			last: u32(6964)
		}, Mbinterval{
			first: u32(6966)
			last: u32(6970)
		}, Mbinterval{
			first: u32(6972)
			last: u32(6972)
		}, Mbinterval{
			first: u32(6978)
			last: u32(6978)
		}, Mbinterval{
			first: u32(7019)
			last: u32(7027)
		}, Mbinterval{
			first: u32(7040)
			last: u32(7041)
		}, Mbinterval{
			first: u32(7074)
			last: u32(7077)
		}, Mbinterval{
			first: u32(7080)
			last: u32(7081)
		}, Mbinterval{
			first: u32(7083)
			last: u32(7085)
		}, Mbinterval{
			first: u32(7142)
			last: u32(7142)
		}, Mbinterval{
			first: u32(7144)
			last: u32(7145)
		}, Mbinterval{
			first: u32(7149)
			last: u32(7149)
		}, Mbinterval{
			first: u32(7151)
			last: u32(7153)
		}, Mbinterval{
			first: u32(7212)
			last: u32(7219)
		}, Mbinterval{
			first: u32(7222)
			last: u32(7223)
		}, Mbinterval{
			first: u32(7376)
			last: u32(7378)
		}, Mbinterval{
			first: u32(7380)
			last: u32(7392)
		}, Mbinterval{
			first: u32(7394)
			last: u32(7400)
		}, Mbinterval{
			first: u32(7405)
			last: u32(7405)
		}, Mbinterval{
			first: u32(7412)
			last: u32(7412)
		}, Mbinterval{
			first: u32(7416)
			last: u32(7417)
		}, Mbinterval{
			first: u32(7616)
			last: u32(7679)
		}, Mbinterval{
			first: u32(8203)
			last: u32(8207)
		}, Mbinterval{
			first: u32(8234)
			last: u32(8238)
		}, Mbinterval{
			first: u32(8288)
			last: u32(8303)
		}, Mbinterval{
			first: u32(8400)
			last: u32(8432)
		}, Mbinterval{
			first: u32(11503)
			last: u32(11505)
		}, Mbinterval{
			first: u32(11647)
			last: u32(11647)
		}, Mbinterval{
			first: u32(11744)
			last: u32(11775)
		}, Mbinterval{
			first: u32(12330)
			last: u32(12333)
		}, Mbinterval{
			first: u32(12441)
			last: u32(12442)
		}, Mbinterval{
			first: u32(42607)
			last: u32(42610)
		}, Mbinterval{
			first: u32(42612)
			last: u32(42621)
		}, Mbinterval{
			first: u32(42654)
			last: u32(42655)
		}, Mbinterval{
			first: u32(42736)
			last: u32(42737)
		}, Mbinterval{
			first: u32(43010)
			last: u32(43010)
		}, Mbinterval{
			first: u32(43014)
			last: u32(43014)
		}, Mbinterval{
			first: u32(43019)
			last: u32(43019)
		}, Mbinterval{
			first: u32(43045)
			last: u32(43046)
		}, Mbinterval{
			first: u32(43052)
			last: u32(43052)
		}, Mbinterval{
			first: u32(43204)
			last: u32(43205)
		}, Mbinterval{
			first: u32(43232)
			last: u32(43249)
		}, Mbinterval{
			first: u32(43263)
			last: u32(43263)
		}, Mbinterval{
			first: u32(43302)
			last: u32(43309)
		}, Mbinterval{
			first: u32(43335)
			last: u32(43345)
		}, Mbinterval{
			first: u32(43392)
			last: u32(43394)
		}, Mbinterval{
			first: u32(43443)
			last: u32(43443)
		}, Mbinterval{
			first: u32(43446)
			last: u32(43449)
		}, Mbinterval{
			first: u32(43452)
			last: u32(43453)
		}, Mbinterval{
			first: u32(43493)
			last: u32(43493)
		}, Mbinterval{
			first: u32(43561)
			last: u32(43566)
		}, Mbinterval{
			first: u32(43569)
			last: u32(43570)
		}, Mbinterval{
			first: u32(43573)
			last: u32(43574)
		}, Mbinterval{
			first: u32(43587)
			last: u32(43587)
		}, Mbinterval{
			first: u32(43596)
			last: u32(43596)
		}, Mbinterval{
			first: u32(43644)
			last: u32(43644)
		}, Mbinterval{
			first: u32(43696)
			last: u32(43696)
		}, Mbinterval{
			first: u32(43698)
			last: u32(43700)
		}, Mbinterval{
			first: u32(43703)
			last: u32(43704)
		}, Mbinterval{
			first: u32(43710)
			last: u32(43711)
		}, Mbinterval{
			first: u32(43713)
			last: u32(43713)
		}, Mbinterval{
			first: u32(43756)
			last: u32(43757)
		}, Mbinterval{
			first: u32(43766)
			last: u32(43766)
		}, Mbinterval{
			first: u32(44005)
			last: u32(44005)
		}, Mbinterval{
			first: u32(44008)
			last: u32(44008)
		}, Mbinterval{
			first: u32(44013)
			last: u32(44013)
		}, Mbinterval{
			first: u32(64286)
			last: u32(64286)
		}, Mbinterval{
			first: u32(65024)
			last: u32(65039)
		}, Mbinterval{
			first: u32(65056)
			last: u32(65071)
		}, Mbinterval{
			first: u32(65279)
			last: u32(65279)
		}, Mbinterval{
			first: u32(65529)
			last: u32(65531)
		}, Mbinterval{
			first: u32(66045)
			last: u32(66045)
		}, Mbinterval{
			first: u32(66272)
			last: u32(66272)
		}, Mbinterval{
			first: u32(66422)
			last: u32(66426)
		}, Mbinterval{
			first: u32(68097)
			last: u32(68111)
		}, Mbinterval{
			first: u32(68152)
			last: u32(68159)
		}, Mbinterval{
			first: u32(68325)
			last: u32(68326)
		}, Mbinterval{
			first: u32(68900)
			last: u32(68903)
		}, Mbinterval{
			first: u32(68969)
			last: u32(68973)
		}, Mbinterval{
			first: u32(69291)
			last: u32(69292)
		}, Mbinterval{
			first: u32(69372)
			last: u32(69375)
		}, Mbinterval{
			first: u32(69446)
			last: u32(69456)
		}, Mbinterval{
			first: u32(69506)
			last: u32(69509)
		}, Mbinterval{
			first: u32(69633)
			last: u32(69633)
		}, Mbinterval{
			first: u32(69688)
			last: u32(69702)
		}, Mbinterval{
			first: u32(69744)
			last: u32(69744)
		}, Mbinterval{
			first: u32(69747)
			last: u32(69748)
		}, Mbinterval{
			first: u32(69759)
			last: u32(69761)
		}, Mbinterval{
			first: u32(69811)
			last: u32(69814)
		}, Mbinterval{
			first: u32(69817)
			last: u32(69818)
		}, Mbinterval{
			first: u32(69821)
			last: u32(69821)
		}, Mbinterval{
			first: u32(69826)
			last: u32(69837)
		}, Mbinterval{
			first: u32(69888)
			last: u32(69890)
		}, Mbinterval{
			first: u32(69927)
			last: u32(69931)
		}, Mbinterval{
			first: u32(69933)
			last: u32(69940)
		}, Mbinterval{
			first: u32(70003)
			last: u32(70003)
		}, Mbinterval{
			first: u32(70016)
			last: u32(70017)
		}, Mbinterval{
			first: u32(70070)
			last: u32(70078)
		}, Mbinterval{
			first: u32(70089)
			last: u32(70092)
		}, Mbinterval{
			first: u32(70095)
			last: u32(70095)
		}, Mbinterval{
			first: u32(70191)
			last: u32(70193)
		}, Mbinterval{
			first: u32(70196)
			last: u32(70196)
		}, Mbinterval{
			first: u32(70198)
			last: u32(70199)
		}, Mbinterval{
			first: u32(70206)
			last: u32(70206)
		}, Mbinterval{
			first: u32(70209)
			last: u32(70209)
		}, Mbinterval{
			first: u32(70367)
			last: u32(70367)
		}, Mbinterval{
			first: u32(70371)
			last: u32(70378)
		}, Mbinterval{
			first: u32(70400)
			last: u32(70401)
		}, Mbinterval{
			first: u32(70459)
			last: u32(70460)
		}, Mbinterval{
			first: u32(70464)
			last: u32(70464)
		}, Mbinterval{
			first: u32(70502)
			last: u32(70516)
		}, Mbinterval{
			first: u32(70587)
			last: u32(70592)
		}, Mbinterval{
			first: u32(70606)
			last: u32(70606)
		}, Mbinterval{
			first: u32(70608)
			last: u32(70608)
		}, Mbinterval{
			first: u32(70610)
			last: u32(70610)
		}, Mbinterval{
			first: u32(70625)
			last: u32(70626)
		}, Mbinterval{
			first: u32(70712)
			last: u32(70719)
		}, Mbinterval{
			first: u32(70722)
			last: u32(70724)
		}, Mbinterval{
			first: u32(70726)
			last: u32(70726)
		}, Mbinterval{
			first: u32(70750)
			last: u32(70750)
		}, Mbinterval{
			first: u32(70835)
			last: u32(70840)
		}, Mbinterval{
			first: u32(70842)
			last: u32(70842)
		}, Mbinterval{
			first: u32(70847)
			last: u32(70848)
		}, Mbinterval{
			first: u32(70850)
			last: u32(70851)
		}, Mbinterval{
			first: u32(71090)
			last: u32(71093)
		}, Mbinterval{
			first: u32(71100)
			last: u32(71101)
		}, Mbinterval{
			first: u32(71103)
			last: u32(71104)
		}, Mbinterval{
			first: u32(71132)
			last: u32(71133)
		}, Mbinterval{
			first: u32(71219)
			last: u32(71226)
		}, Mbinterval{
			first: u32(71229)
			last: u32(71229)
		}, Mbinterval{
			first: u32(71231)
			last: u32(71232)
		}, Mbinterval{
			first: u32(71339)
			last: u32(71339)
		}, Mbinterval{
			first: u32(71341)
			last: u32(71341)
		}, Mbinterval{
			first: u32(71344)
			last: u32(71349)
		}, Mbinterval{
			first: u32(71351)
			last: u32(71351)
		}, Mbinterval{
			first: u32(71453)
			last: u32(71453)
		}, Mbinterval{
			first: u32(71455)
			last: u32(71455)
		}, Mbinterval{
			first: u32(71458)
			last: u32(71461)
		}, Mbinterval{
			first: u32(71463)
			last: u32(71467)
		}, Mbinterval{
			first: u32(71727)
			last: u32(71735)
		}, Mbinterval{
			first: u32(71737)
			last: u32(71738)
		}, Mbinterval{
			first: u32(71995)
			last: u32(71996)
		}, Mbinterval{
			first: u32(71998)
			last: u32(71998)
		}, Mbinterval{
			first: u32(72003)
			last: u32(72003)
		}, Mbinterval{
			first: u32(72148)
			last: u32(72155)
		}, Mbinterval{
			first: u32(72160)
			last: u32(72160)
		}, Mbinterval{
			first: u32(72193)
			last: u32(72202)
		}, Mbinterval{
			first: u32(72243)
			last: u32(72248)
		}, Mbinterval{
			first: u32(72251)
			last: u32(72254)
		}, Mbinterval{
			first: u32(72263)
			last: u32(72263)
		}, Mbinterval{
			first: u32(72273)
			last: u32(72278)
		}, Mbinterval{
			first: u32(72281)
			last: u32(72283)
		}, Mbinterval{
			first: u32(72330)
			last: u32(72342)
		}, Mbinterval{
			first: u32(72344)
			last: u32(72345)
		}, Mbinterval{
			first: u32(72752)
			last: u32(72765)
		}, Mbinterval{
			first: u32(72767)
			last: u32(72767)
		}, Mbinterval{
			first: u32(72850)
			last: u32(72871)
		}, Mbinterval{
			first: u32(72874)
			last: u32(72880)
		}, Mbinterval{
			first: u32(72882)
			last: u32(72883)
		}, Mbinterval{
			first: u32(72885)
			last: u32(72886)
		}, Mbinterval{
			first: u32(73009)
			last: u32(73029)
		}, Mbinterval{
			first: u32(73031)
			last: u32(73031)
		}, Mbinterval{
			first: u32(73104)
			last: u32(73105)
		}, Mbinterval{
			first: u32(73109)
			last: u32(73109)
		}, Mbinterval{
			first: u32(73111)
			last: u32(73111)
		}, Mbinterval{
			first: u32(73459)
			last: u32(73460)
		}, Mbinterval{
			first: u32(73472)
			last: u32(73473)
		}, Mbinterval{
			first: u32(73526)
			last: u32(73530)
		}, Mbinterval{
			first: u32(73536)
			last: u32(73536)
		}, Mbinterval{
			first: u32(73538)
			last: u32(73538)
		}, Mbinterval{
			first: u32(73562)
			last: u32(73562)
		}, Mbinterval{
			first: u32(78896)
			last: u32(78912)
		}, Mbinterval{
			first: u32(78919)
			last: u32(78933)
		}, Mbinterval{
			first: u32(90398)
			last: u32(90409)
		}, Mbinterval{
			first: u32(90413)
			last: u32(90415)
		}, Mbinterval{
			first: u32(92912)
			last: u32(92916)
		}, Mbinterval{
			first: u32(92976)
			last: u32(92982)
		}, Mbinterval{
			first: u32(94031)
			last: u32(94031)
		}, Mbinterval{
			first: u32(94095)
			last: u32(94098)
		}, Mbinterval{
			first: u32(94180)
			last: u32(94180)
		}, Mbinterval{
			first: u32(113821)
			last: u32(113822)
		}, Mbinterval{
			first: u32(113824)
			last: u32(113827)
		}, Mbinterval{
			first: u32(118528)
			last: u32(118598)
		}, Mbinterval{
			first: u32(119143)
			last: u32(119145)
		}, Mbinterval{
			first: u32(119155)
			last: u32(119170)
		}, Mbinterval{
			first: u32(119173)
			last: u32(119179)
		}, Mbinterval{
			first: u32(119210)
			last: u32(119213)
		}, Mbinterval{
			first: u32(119362)
			last: u32(119364)
		}, Mbinterval{
			first: u32(121344)
			last: u32(121398)
		}, Mbinterval{
			first: u32(121403)
			last: u32(121452)
		}, Mbinterval{
			first: u32(121461)
			last: u32(121461)
		}, Mbinterval{
			first: u32(121476)
			last: u32(121476)
		}, Mbinterval{
			first: u32(121499)
			last: u32(121519)
		}, Mbinterval{
			first: u32(122880)
			last: u32(122922)
		}, Mbinterval{
			first: u32(123023)
			last: u32(123023)
		}, Mbinterval{
			first: u32(123184)
			last: u32(123190)
		}, Mbinterval{
			first: u32(123566)
			last: u32(123566)
		}, Mbinterval{
			first: u32(123628)
			last: u32(123631)
		}, Mbinterval{
			first: u32(124140)
			last: u32(124143)
		}, Mbinterval{
			first: u32(124398)
			last: u32(124399)
		}, Mbinterval{
			first: u32(125136)
			last: u32(125142)
		}, Mbinterval{
			first: u32(125252)
			last: u32(125258)
		}, Mbinterval{
			first: u32(917505)
			last: u32(917999)
		}]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			ucs_wcwidth_nonspacing[c2v_i_0] = c2v_element_0
		}
		ucs_wcwidth_nonspacing_inited = true
	}

	if !ucs_wcwidth_east_asian_fw_inited {
		c2v_static_init := [Mbinterval{
			first: u32(4352)
			last: u32(4447)
		}, Mbinterval{
			first: u32(8986)
			last: u32(8987)
		}, Mbinterval{
			first: u32(9001)
			last: u32(9002)
		}, Mbinterval{
			first: u32(9193)
			last: u32(9196)
		}, Mbinterval{
			first: u32(9200)
			last: u32(9200)
		}, Mbinterval{
			first: u32(9203)
			last: u32(9203)
		}, Mbinterval{
			first: u32(9725)
			last: u32(9726)
		}, Mbinterval{
			first: u32(9748)
			last: u32(9749)
		}, Mbinterval{
			first: u32(9776)
			last: u32(9783)
		}, Mbinterval{
			first: u32(9800)
			last: u32(9811)
		}, Mbinterval{
			first: u32(9855)
			last: u32(9855)
		}, Mbinterval{
			first: u32(9866)
			last: u32(9871)
		}, Mbinterval{
			first: u32(9875)
			last: u32(9875)
		}, Mbinterval{
			first: u32(9889)
			last: u32(9889)
		}, Mbinterval{
			first: u32(9898)
			last: u32(9899)
		}, Mbinterval{
			first: u32(9917)
			last: u32(9918)
		}, Mbinterval{
			first: u32(9924)
			last: u32(9925)
		}, Mbinterval{
			first: u32(9934)
			last: u32(9934)
		}, Mbinterval{
			first: u32(9940)
			last: u32(9940)
		}, Mbinterval{
			first: u32(9962)
			last: u32(9962)
		}, Mbinterval{
			first: u32(9970)
			last: u32(9971)
		}, Mbinterval{
			first: u32(9973)
			last: u32(9973)
		}, Mbinterval{
			first: u32(9978)
			last: u32(9978)
		}, Mbinterval{
			first: u32(9981)
			last: u32(9981)
		}, Mbinterval{
			first: u32(9989)
			last: u32(9989)
		}, Mbinterval{
			first: u32(9994)
			last: u32(9995)
		}, Mbinterval{
			first: u32(10024)
			last: u32(10024)
		}, Mbinterval{
			first: u32(10060)
			last: u32(10060)
		}, Mbinterval{
			first: u32(10062)
			last: u32(10062)
		}, Mbinterval{
			first: u32(10067)
			last: u32(10069)
		}, Mbinterval{
			first: u32(10071)
			last: u32(10071)
		}, Mbinterval{
			first: u32(10133)
			last: u32(10135)
		}, Mbinterval{
			first: u32(10160)
			last: u32(10160)
		}, Mbinterval{
			first: u32(10175)
			last: u32(10175)
		}, Mbinterval{
			first: u32(11035)
			last: u32(11036)
		}, Mbinterval{
			first: u32(11088)
			last: u32(11088)
		}, Mbinterval{
			first: u32(11093)
			last: u32(11093)
		}, Mbinterval{
			first: u32(11904)
			last: u32(11929)
		}, Mbinterval{
			first: u32(11931)
			last: u32(12019)
		}, Mbinterval{
			first: u32(12032)
			last: u32(12245)
		}, Mbinterval{
			first: u32(12272)
			last: u32(12350)
		}, Mbinterval{
			first: u32(12353)
			last: u32(12438)
		}, Mbinterval{
			first: u32(12441)
			last: u32(12543)
		}, Mbinterval{
			first: u32(12549)
			last: u32(12591)
		}, Mbinterval{
			first: u32(12593)
			last: u32(12686)
		}, Mbinterval{
			first: u32(12688)
			last: u32(12773)
		}, Mbinterval{
			first: u32(12783)
			last: u32(12830)
		}, Mbinterval{
			first: u32(12832)
			last: u32(12871)
		}, Mbinterval{
			first: u32(12880)
			last: u32(42124)
		}, Mbinterval{
			first: u32(42128)
			last: u32(42182)
		}, Mbinterval{
			first: u32(43360)
			last: u32(43388)
		}, Mbinterval{
			first: u32(44032)
			last: u32(55203)
		}, Mbinterval{
			first: u32(63744)
			last: u32(64255)
		}, Mbinterval{
			first: u32(65040)
			last: u32(65049)
		}, Mbinterval{
			first: u32(65072)
			last: u32(65106)
		}, Mbinterval{
			first: u32(65108)
			last: u32(65126)
		}, Mbinterval{
			first: u32(65128)
			last: u32(65131)
		}, Mbinterval{
			first: u32(65281)
			last: u32(65376)
		}, Mbinterval{
			first: u32(65504)
			last: u32(65510)
		}, Mbinterval{
			first: u32(94176)
			last: u32(94180)
		}, Mbinterval{
			first: u32(94192)
			last: u32(94193)
		}, Mbinterval{
			first: u32(94208)
			last: u32(100343)
		}, Mbinterval{
			first: u32(100352)
			last: u32(101589)
		}, Mbinterval{
			first: u32(101631)
			last: u32(101640)
		}, Mbinterval{
			first: u32(110576)
			last: u32(110579)
		}, Mbinterval{
			first: u32(110581)
			last: u32(110587)
		}, Mbinterval{
			first: u32(110589)
			last: u32(110590)
		}, Mbinterval{
			first: u32(110592)
			last: u32(110882)
		}, Mbinterval{
			first: u32(110898)
			last: u32(110898)
		}, Mbinterval{
			first: u32(110928)
			last: u32(110930)
		}, Mbinterval{
			first: u32(110933)
			last: u32(110933)
		}, Mbinterval{
			first: u32(110948)
			last: u32(110951)
		}, Mbinterval{
			first: u32(110960)
			last: u32(111355)
		}, Mbinterval{
			first: u32(119552)
			last: u32(119638)
		}, Mbinterval{
			first: u32(119648)
			last: u32(119670)
		}, Mbinterval{
			first: u32(126980)
			last: u32(126980)
		}, Mbinterval{
			first: u32(127183)
			last: u32(127183)
		}, Mbinterval{
			first: u32(127374)
			last: u32(127374)
		}, Mbinterval{
			first: u32(127377)
			last: u32(127386)
		}, Mbinterval{
			first: u32(127488)
			last: u32(127490)
		}, Mbinterval{
			first: u32(127504)
			last: u32(127547)
		}, Mbinterval{
			first: u32(127552)
			last: u32(127560)
		}, Mbinterval{
			first: u32(127568)
			last: u32(127569)
		}, Mbinterval{
			first: u32(127584)
			last: u32(127589)
		}, Mbinterval{
			first: u32(127744)
			last: u32(127776)
		}, Mbinterval{
			first: u32(127789)
			last: u32(127797)
		}, Mbinterval{
			first: u32(127799)
			last: u32(127868)
		}, Mbinterval{
			first: u32(127870)
			last: u32(127891)
		}, Mbinterval{
			first: u32(127904)
			last: u32(127946)
		}, Mbinterval{
			first: u32(127951)
			last: u32(127955)
		}, Mbinterval{
			first: u32(127968)
			last: u32(127984)
		}, Mbinterval{
			first: u32(127988)
			last: u32(127988)
		}, Mbinterval{
			first: u32(127992)
			last: u32(128062)
		}, Mbinterval{
			first: u32(128064)
			last: u32(128064)
		}, Mbinterval{
			first: u32(128066)
			last: u32(128252)
		}, Mbinterval{
			first: u32(128255)
			last: u32(128317)
		}, Mbinterval{
			first: u32(128331)
			last: u32(128334)
		}, Mbinterval{
			first: u32(128336)
			last: u32(128359)
		}, Mbinterval{
			first: u32(128378)
			last: u32(128378)
		}, Mbinterval{
			first: u32(128405)
			last: u32(128406)
		}, Mbinterval{
			first: u32(128420)
			last: u32(128420)
		}, Mbinterval{
			first: u32(128507)
			last: u32(128591)
		}, Mbinterval{
			first: u32(128640)
			last: u32(128709)
		}, Mbinterval{
			first: u32(128716)
			last: u32(128716)
		}, Mbinterval{
			first: u32(128720)
			last: u32(128722)
		}, Mbinterval{
			first: u32(128725)
			last: u32(128727)
		}, Mbinterval{
			first: u32(128732)
			last: u32(128735)
		}, Mbinterval{
			first: u32(128747)
			last: u32(128748)
		}, Mbinterval{
			first: u32(128756)
			last: u32(128764)
		}, Mbinterval{
			first: u32(128992)
			last: u32(129003)
		}, Mbinterval{
			first: u32(129008)
			last: u32(129008)
		}, Mbinterval{
			first: u32(129292)
			last: u32(129338)
		}, Mbinterval{
			first: u32(129340)
			last: u32(129349)
		}, Mbinterval{
			first: u32(129351)
			last: u32(129535)
		}, Mbinterval{
			first: u32(129648)
			last: u32(129660)
		}, Mbinterval{
			first: u32(129664)
			last: u32(129673)
		}, Mbinterval{
			first: u32(129679)
			last: u32(129734)
		}, Mbinterval{
			first: u32(129742)
			last: u32(129756)
		}, Mbinterval{
			first: u32(129759)
			last: u32(129769)
		}, Mbinterval{
			first: u32(129776)
			last: u32(129784)
		}, Mbinterval{
			first: u32(131072)
			last: u32(196605)
		}, Mbinterval{
			first: u32(196608)
			last: u32(262141)
		}]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			ucs_wcwidth_east_asian_fw[c2v_i_0] = c2v_element_0
		}
		ucs_wcwidth_east_asian_fw_inited = true
	}

	if ucs == Pg_wchar(0) {
		return 0
	}
	if ucs < Pg_wchar(32) || (ucs >= Pg_wchar(127) && ucs < Pg_wchar(160)) || ucs > Pg_wchar(1114111) {
		return -1
	}
	if mbbisearch(ucs, &ucs_wcwidth_nonspacing[0], 333) {
		return 0
	}
	if mbbisearch(ucs, &ucs_wcwidth_east_asian_fw[0], 121) {
		return 2
	}
	return 1
}

@[markused]
pub fn pg_utf_dsplen(s &u8) int {
	c2v_gc_register_thread()
	return ucs_wcwidth(libpq_wchar_utf8_to_unicode(s))
}

@[markused]
pub fn pg_mule2wchar_with_len(from &u8, to &Pg_wchar, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	for len > 0 && int((unsafe { *from })) {
		if (int(u8((unsafe { *from }))) >= 129 && int(u8((unsafe { *from }))) <= 141) {
			if len < 2 {
				break
			}
			unsafe { *to = Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 16) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 2
		} else if (int(u8((unsafe { *from }))) == 154 || int(u8((unsafe { *from }))) == 155) {
			if len < 3 {
				break
			}
			c2v_pointer_postfix(voidptr(&from), from, isize(1))
			unsafe { *to = Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 16) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 3
		} else if (int(u8((unsafe { *from }))) >= 144 && int(u8((unsafe { *from }))) <= 153) {
			if len < 3 {
				break
			}
			unsafe { *to = Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 16) }
			unsafe { *to |= Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 3
		} else if (int(u8((unsafe { *from }))) == 156 || int(u8((unsafe { *from }))) == 157) {
			if len < 4 {
				break
			}
			c2v_pointer_postfix(voidptr(&from), from, isize(1))
			unsafe { *to = Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 16) }
			unsafe { *to |= Pg_wchar(int(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) << 8) }
			unsafe { *to |= Pg_wchar(*c2v_pointer_postfix(voidptr(&from), from, isize(1))) }
			len -= 4
		} else {
			unsafe { *to = *c2v_pointer_postfix(voidptr(&from), from, isize(1)) }
			len--
		}
		c2v_pointer_postfix(voidptr(&to), to, isize(1))
		cnt++
	}
	unsafe { *to = Pg_wchar(0) }
	return cnt
}

@[markused]
pub fn pg_wchar2mule_with_len(from &Pg_wchar, to &u8, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	for len > 0 && (unsafe { *from }) {
		lb := u8(0)
		lb = u8(((unsafe { *from }) >> 16) & Pg_wchar(255))
		if (int(u8(lb)) >= 129 && int(u8(lb)) <= 141) {
			mut __c2v_lhs_tmp_11 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_11 = lb }
			mut __c2v_lhs_tmp_12 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_12 = u8(*from & Pg_wchar(255)) }
			cnt += 2
		} else if (int(u8(lb)) >= 144 && int(u8(lb)) <= 153) {
			mut __c2v_lhs_tmp_13 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_13 = lb }
			mut __c2v_lhs_tmp_14 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_14 = u8((*from >> 8) & Pg_wchar(255)) }
			mut __c2v_lhs_tmp_15 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_15 = u8(*from & Pg_wchar(255)) }
			cnt += 3
		} else if (int(u8(lb)) >= 160 && int(u8(lb)) <= 223) {
			mut __c2v_lhs_tmp_16 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_16 = u8(154) }
			mut __c2v_lhs_tmp_17 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_17 = lb }
			mut __c2v_lhs_tmp_18 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_18 = u8(*from & Pg_wchar(255)) }
			cnt += 3
		} else if (int(u8(lb)) >= 224 && int(u8(lb)) <= 239) {
			mut __c2v_lhs_tmp_19 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_19 = u8(155) }
			mut __c2v_lhs_tmp_20 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_20 = lb }
			mut __c2v_lhs_tmp_21 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_21 = u8(*from & Pg_wchar(255)) }
			cnt += 3
		} else if (int(u8(lb)) >= 240 && int(u8(lb)) <= 244) {
			mut __c2v_lhs_tmp_22 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_22 = u8(156) }
			mut __c2v_lhs_tmp_23 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_23 = lb }
			mut __c2v_lhs_tmp_24 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_24 = u8((*from >> 8) & Pg_wchar(255)) }
			mut __c2v_lhs_tmp_25 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_25 = u8(*from & Pg_wchar(255)) }
			cnt += 4
		} else if (int(u8(lb)) >= 245 && int(u8(lb)) <= 254) {
			mut __c2v_lhs_tmp_26 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_26 = u8(157) }
			mut __c2v_lhs_tmp_27 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_27 = lb }
			mut __c2v_lhs_tmp_28 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_28 = u8((*from >> 8) & Pg_wchar(255)) }
			mut __c2v_lhs_tmp_29 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_29 = u8(*from & Pg_wchar(255)) }
			cnt += 4
		} else {
			mut __c2v_lhs_tmp_30 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
			unsafe { *__c2v_lhs_tmp_30 = u8(*from & Pg_wchar(255)) }
			cnt += 1
		}
		c2v_pointer_postfix(voidptr(&from), from, isize(1))
		len--
	}
	unsafe { *to = u8(0) }
	return cnt
}

@[export: 'pg_mule_mblen']
@[markused]
pub fn pg_mule_mblen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) >= 129 && int(u8((unsafe { *s }))) <= 141) {
		len = 2
	} else if (int(u8((unsafe { *s }))) == 154 || int(u8((unsafe { *s }))) == 155) {
		len = 3
	} else if (int(u8((unsafe { *s }))) >= 144 && int(u8((unsafe { *s }))) <= 153) {
		len = 3
	} else if (int(u8((unsafe { *s }))) == 156 || int(u8((unsafe { *s }))) == 157) {
		len = 4
	} else {
		len = 1
	}
	return len
}

@[markused]
pub fn pg_mule_dsplen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) >= 129 && int(u8((unsafe { *s }))) <= 141) {
		len = 1
	} else if (int(u8((unsafe { *s }))) == 154 || int(u8((unsafe { *s }))) == 155) {
		len = 1
	} else if (int(u8((unsafe { *s }))) >= 144 && int(u8((unsafe { *s }))) <= 153) {
		len = 2
	} else if (int(u8((unsafe { *s }))) == 156 || int(u8((unsafe { *s }))) == 157) {
		len = 2
	} else {
		len = 1
	}
	return len
}

@[markused]
pub fn pg_latin12wchar_with_len(from &u8, to &Pg_wchar, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	for len > 0 && int((unsafe { *from })) {
		mut __c2v_lhs_tmp_31 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
		unsafe { *__c2v_lhs_tmp_31 = *c2v_pointer_postfix(voidptr(&from), from, isize(1)) }
		len--
		cnt++
	}
	unsafe { *to = Pg_wchar(0) }
	return cnt
}

@[markused]
pub fn pg_wchar2single_with_len(from &Pg_wchar, to &u8, len int) int {
	c2v_gc_register_thread()
	cnt := 0
	for len > 0 && (unsafe { *from }) {
		mut __c2v_lhs_tmp_32 := unsafe { c2v_pointer_postfix(voidptr(&to), to, isize(1)) }
		unsafe { *__c2v_lhs_tmp_32 = *c2v_pointer_postfix(voidptr(&from), from, isize(1)) }
		len--
		cnt++
	}
	unsafe { *to = u8(0) }
	return cnt
}

@[markused]
pub fn pg_latin1_mblen(s &u8) int {
	c2v_gc_register_thread()
	return 1
}

@[markused]
pub fn pg_latin1_dsplen(s &u8) int {
	c2v_gc_register_thread()
	return pg_ascii_dsplen(s)
}

@[markused]
pub fn pg_sjis_mblen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if int((unsafe { *s })) >= 161 && int((unsafe { *s })) <= 223 {
		len = 1
	} else if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = 1
	}
	return len
}

@[markused]
pub fn pg_sjis_dsplen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if int((unsafe { *s })) >= 161 && int((unsafe { *s })) <= 223 {
		len = 1
	} else if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = pg_ascii_dsplen(s)
	}
	return len
}

@[markused]
pub fn pg_big5_mblen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = 1
	}
	return len
}

@[markused]
pub fn pg_big5_dsplen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = pg_ascii_dsplen(s)
	}
	return len
}

@[markused]
pub fn pg_gbk_mblen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = 1
	}
	return len
}

@[markused]
pub fn pg_gbk_dsplen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = pg_ascii_dsplen(s)
	}
	return len
}

@[markused]
pub fn pg_uhc_mblen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = 1
	}
	return len
}

@[markused]
pub fn pg_uhc_dsplen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = pg_ascii_dsplen(s)
	}
	return len
}

@[markused]
pub fn pg_gb18030_mblen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if !(int(u8((unsafe { *s }))) & 128) {
		len = 1
	} else if int((unsafe { *(s + 1) })) >= 48 && int((unsafe { *(s + 1) })) <= 57 {
		len = 4
	} else {
		len = 2
	}
	return len
}

@[markused]
pub fn pg_gb18030_dsplen(s &u8) int {
	c2v_gc_register_thread()
	len := 0
	if (int(u8((unsafe { *s }))) & 128) {
		len = 2
	} else {
		len = pg_ascii_dsplen(s)
	}
	return len
}

@[markused]
pub fn pg_ascii_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	return 1
}

@[markused]
pub fn pg_ascii_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	nullpos := &u8(C.c2v_memchr(voidptr(s), 0, u64(len)))
	if usize(nullpos) == usize((voidptr(0))) {
		return len
	} else {
		return int(i64((isize(nullpos) - isize(s)) / isize(sizeof(u8))))
	}
}

@[markused]
pub fn pg_eucjp_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	c1 := u8(0)
	c2 := u8(0)

	c1 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
	match int(c1) {
		142 {
			l = 2
			if l > len {
				return -1
			}
			c2 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
			if int(c2) < 161 || int(c2) > 223 {
				return -1
			}
		}
		143 {
			l = 3
			if l > len {
				return -1
			}
			c2 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
			if !(int(c2) >= 161 && int(c2) <= 254) {
				return -1
			}
			c2 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
			if !(int(c2) >= 161 && int(c2) <= 254) {
				return -1
			}
		}
		else {
			if (int(u8(c1)) & 128) {
				l = 2
				if l > len {
					return -1
				}
				if !(int(c1) >= 161 && int(c1) <= 254) {
					return -1
				}
				c2 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
				if !(int(c2) >= 161 && int(c2) <= 254) {
					return -1
				}
			} else {
				l = 1
			}
		}
	}

	return l
}

@[markused]
pub fn pg_eucjp_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_eucjp_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_euckr_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	c1 := u8(0)
	c2 := u8(0)

	c1 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
	if (int(u8(c1)) & 128) {
		l = 2
		if l > len {
			return -1
		}
		if !(int(c1) >= 161 && int(c1) <= 254) {
			return -1
		}
		c2 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
		if !(int(c2) >= 161 && int(c2) <= 254) {
			return -1
		}
	} else {
		l = 1
	}
	return l
}

@[markused]
pub fn pg_euckr_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_euckr_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_euctw_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	c1 := u8(0)
	c2 := u8(0)

	c1 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
	match int(c1) {
		142 {
			l = 4
			if l > len {
				return -1
			}
			c2 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
			if int(c2) < 161 || int(c2) > 167 {
				return -1
			}
			c2 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
			if !(int(c2) >= 161 && int(c2) <= 254) {
				return -1
			}
			c2 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
			if !(int(c2) >= 161 && int(c2) <= 254) {
				return -1
			}
		}
		143 {
			return -1
		}
		else {
			if (int(u8(c1)) & 128) {
				l = 2
				if l > len {
					return -1
				}
				c2 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
				if !(int(c2) >= 161 && int(c2) <= 254) {
					return -1
				}
			} else {
				l = 1
			}
		}
	}

	return l
}

@[markused]
pub fn pg_euctw_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_euctw_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_johab_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	mbl := 0

	c := u8(0)
	mbl = pg_johab_mblen(s)
	l = mbl
	if len < l {
		return -1
	}
	if !(int(u8((unsafe { *s }))) & 128) {
		return mbl
	}
	for {
		l--
		if !(l > 0) {
			break
		}
		c = unsafe { *c2v_pointer_prefix(voidptr(&s), s, isize(1)) }
		if !(int(c) >= 161 && int(c) <= 254) {
			return -1
		}
	}
	return mbl
}

@[markused]
pub fn pg_johab_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_johab_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_mule_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	mbl := 0

	c := u8(0)
	mbl = pg_mule_mblen(s)
	l = mbl
	if len < l {
		return -1
	}
	for {
		l--
		if !(l > 0) {
			break
		}
		c = unsafe { *c2v_pointer_prefix(voidptr(&s), s, isize(1)) }
		if !(int(u8(c)) & 128) {
			return -1
		}
	}
	return mbl
}

@[markused]
pub fn pg_mule_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_mule_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_latin1_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	return 1
}

@[markused]
pub fn pg_latin1_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	nullpos := &u8(C.c2v_memchr(voidptr(s), 0, u64(len)))
	if usize(nullpos) == usize((voidptr(0))) {
		return len
	} else {
		return int(i64((isize(nullpos) - isize(s)) / isize(sizeof(u8))))
	}
}

@[markused]
pub fn pg_sjis_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	mbl := 0

	c1 := u8(0)
	c2 := u8(0)

	mbl = pg_sjis_mblen(s)
	l = mbl
	if len < l {
		return -1
	}
	if l == 1 {
		return mbl
	}
	c1 = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
	c2 = unsafe { *s }
	if !((int(c1) >= 129 && int(c1) <= 159) || (int(c1) >= 224 && int(c1) <= 252)) || !((int(c2) >= 64 && int(c2) <= 126) || (int(c2) >= 128 && int(c2) <= 252)) {
		return -1
	}
	return mbl
}

@[markused]
pub fn pg_sjis_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_sjis_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_big5_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	mbl := 0

	mbl = pg_big5_mblen(s)
	l = mbl
	if len < l {
		return -1
	}
	if l == 2 && int(s[0]) == 141 && int(s[1]) == ` ` {
		return -1
	}
	for {
		l--
		if !(l > 0) {
			break
		}
		if int((unsafe { *c2v_pointer_prefix(voidptr(&s), s, isize(1)) })) == `\0` {
			return -1
		}
	}
	return mbl
}

@[markused]
pub fn pg_big5_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_big5_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_gbk_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	mbl := 0

	mbl = pg_gbk_mblen(s)
	l = mbl
	if len < l {
		return -1
	}
	if l == 2 && int(s[0]) == 141 && int(s[1]) == ` ` {
		return -1
	}
	for {
		l--
		if !(l > 0) {
			break
		}
		if int((unsafe { *c2v_pointer_prefix(voidptr(&s), s, isize(1)) })) == `\0` {
			return -1
		}
	}
	return mbl
}

@[markused]
pub fn pg_gbk_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_gbk_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_uhc_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	mbl := 0

	mbl = pg_uhc_mblen(s)
	l = mbl
	if len < l {
		return -1
	}
	if l == 2 && int(s[0]) == 141 && int(s[1]) == ` ` {
		return -1
	}
	for {
		l--
		if !(l > 0) {
			break
		}
		if int((unsafe { *c2v_pointer_prefix(voidptr(&s), s, isize(1)) })) == `\0` {
			return -1
		}
	}
	return mbl
}

@[markused]
pub fn pg_uhc_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_uhc_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_gb18030_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	if !(int(u8((unsafe { *s }))) & 128) {
		l = 1
	} else if len >= 4 && int((unsafe { *(s + 1) })) >= 48 && int((unsafe { *(s + 1) })) <= 57 {
		mut __c2v_condition_0 := false
		mut __c2v_condition_1 := false
		__c2v_condition_1 = int((unsafe { *s })) >= 129
		if __c2v_condition_1 {
			__c2v_condition_1 = int((unsafe { *s })) <= 254
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = int((unsafe { *(s + 2) })) >= 129
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = int((unsafe { *(s + 2) })) <= 254
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = int((unsafe { *(s + 3) })) >= 48
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = int((unsafe { *(s + 3) })) <= 57
		}
		__c2v_condition_0 = __c2v_condition_1
		if __c2v_condition_0 {
			l = 4
		} else {
			l = -1
		}
	} else if len >= 2 && int((unsafe { *s })) >= 129 && int((unsafe { *s })) <= 254 {
		if (int((unsafe { *(s + 1) })) >= 64 && int((unsafe { *(s + 1) })) <= 126) || (int((unsafe { *(s + 1) })) >= 128 && int((unsafe { *(s + 1) })) <= 254) {
			l = 2
		} else {
			l = -1
		}
	} else {
		l = -1
	}
	return l
}

@[markused]
pub fn pg_gb18030_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_gb18030_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[markused]
pub fn pg_utf8_verifychar(s &u8, len int) int {
	c2v_gc_register_thread()
	l := 0
	if (int((unsafe { *s })) & 128) == 0 {
		if int((unsafe { *s })) == `\0` {
			return -1
		}
		return 1
	} else if (int((unsafe { *s })) & 224) == 192 {
		l = 2
	} else if (int((unsafe { *s })) & 240) == 224 {
		l = 3
	} else if (int((unsafe { *s })) & 248) == 240 {
		l = 4
	} else {
		l = 1
	}
	if l > len {
		return -1
	}
	if !pg_utf8_islegal(s, l) {
		return -1
	}
	return l
}

@[markused]
pub fn utf8_advance(s &u8, state &Uint32, len int) {
	for len > 0 {
		unsafe { *state = libpq_wchar_utf8_transition[*c2v_pointer_postfix(voidptr(&s), s, isize(1))] >> u32((*state & Uint32(31))) }
		len--
	}
	unsafe { *state &= Uint32(31) }
}

@[markused]
pub fn pg_utf8_verifystr(s &u8, len int) int {
	c2v_gc_register_thread()
	start := s
	orig_len := len
	state := Uint32(11)
	if u64(len) >= (u64(2) * sizeof(Vector8)) {
		for u64(len) >= (u64(2) * sizeof(Vector8)) {
			if state != Uint32(11) || !is_valid_ascii(s, int((u64(2) * sizeof(Vector8)))) {
				utf8_advance(s, &state, int((u64(2) * sizeof(Vector8))))
			}
			c2v_pointer_prefix(voidptr(&s), s, isize((u64(2) * sizeof(Vector8))))
			len -= (u64(2) * sizeof(Vector8))
		}
		if state == Uint32(0) {
			len = orig_len
			s = start
		} else if state != Uint32(11) {
			for {
				c2v_pointer_postfix(voidptr(&s), s, isize(-1))
				len++

				if !(pg_utf_mblen(s) <= 1) {
					break
				}
			}
		}
	}
	for len > 0 {
		l := 0
		if !(int(u8((unsafe { *s }))) & 128) {
			if int((unsafe { *s })) == `\0` {
				break
			}
			l = 1
		} else {
			l = pg_utf8_verifychar(s, len)
			if l == -1 {
				break
			}
		}
		c2v_pointer_prefix(voidptr(&s), s, isize(l))
		len -= l
	}
	return int(i64((isize(s) - isize(start)) / isize(sizeof(u8))))
}

@[export: 'pg_utf8_islegal']
@[markused]
pub fn pg_utf8_islegal(source &u8, length int) bool {
	a := u8(0)
	match length {
		4 {
			a = source[3]
			if int(a) < 128 || int(a) > 191 {
				return false != 0
			}
			unsafe {
				goto c2v_case_60_3
			}
		}
		3 {
			c2v_case_60_3:
			a = source[2]
			if int(a) < 128 || int(a) > 191 {
				return false != 0
			}
			unsafe {
				goto c2v_case_60_5
			}
		}
		2 {
			c2v_case_60_5:
			a = source[1]
			match int((unsafe { *source })) {
				224 {
					if int(a) < 160 || int(a) > 191 {
						return false != 0
					}
				}
				237 {
					if int(a) < 128 || int(a) > 159 {
						return false != 0
					}
				}
				240 {
					if int(a) < 144 || int(a) > 191 {
						return false != 0
					}
				}
				244 {
					if int(a) < 128 || int(a) > 143 {
						return false != 0
					}
				}
				else {
					if int(a) < 128 || int(a) > 191 {
						return false != 0
					}
				}
			}
			unsafe {
				goto c2v_case_60_7
			}
		}
		1 {
			c2v_case_60_7:
			a = unsafe { *source }
			if int(a) >= 128 && int(a) < 194 {
				return false != 0
			}
			if int(a) > 244 {
				return false != 0
			}
		}
		else {
			return false != 0
		}
	}

	return true != 0
}

@[export: 'pg_encoding_set_invalid']
@[markused]
pub fn pg_encoding_set_invalid(encoding int, dst &i8) {
	dst[0] = i8((if encoding == Pg_enc.pg_utf8 { 192 } else { 141 }))
	dst[1] = i8(` `)
}

@[export: 'pg_encoding_mblen']
@[markused]
pub fn pg_encoding_mblen(encoding int, mbstr &i8) int {
	return if (encoding >= 0 && encoding < Pg_enc.pg_last_encoding_) {
		pg_wchar_table[encoding].mblen(&u8(voidptr(mbstr)))
	} else {
		pg_wchar_table[int(Pg_enc.pg_sql_ascii)].mblen(&u8(voidptr(mbstr)))
	}
}

@[export: 'pg_encoding_mblen_or_incomplete']
@[markused]
pub fn pg_encoding_mblen_or_incomplete(encoding int, mbstr &i8, remaining usize) int {
	if remaining < usize(1) || (encoding == Pg_enc.pg_gb18030 && (int(u8((unsafe { *mbstr }))) & 128) && remaining < usize(2)) {
		return 2147483647
	}
	return pg_encoding_mblen(encoding, mbstr)
}

@[export: 'pg_encoding_mblen_bounded']
@[markused]
pub fn pg_encoding_mblen_bounded(encoding int, mbstr &i8) int {
	return int(C.c2v_strnlen(mbstr, usize(pg_encoding_mblen(encoding, mbstr))))
}

@[export: 'pg_encoding_dsplen']
@[markused]
pub fn pg_encoding_dsplen(encoding int, mbstr &i8) int {
	return if (encoding >= 0 && encoding < Pg_enc.pg_last_encoding_) {
		pg_wchar_table[encoding].dsplen(&u8(voidptr(mbstr)))
	} else {
		pg_wchar_table[int(Pg_enc.pg_sql_ascii)].dsplen(&u8(voidptr(mbstr)))
	}
}

@[export: 'pg_encoding_verifymbchar']
@[markused]
pub fn pg_encoding_verifymbchar(encoding int, mbstr &i8, len int) int {
	return if (encoding >= 0 && encoding < Pg_enc.pg_last_encoding_) {
		pg_wchar_table[encoding].mbverifychar(&u8(voidptr(mbstr)), len)
	} else {
		pg_wchar_table[int(Pg_enc.pg_sql_ascii)].mbverifychar(&u8(voidptr(mbstr)), len)
	}
}

@[export: 'pg_encoding_verifymbstr']
@[markused]
pub fn pg_encoding_verifymbstr(encoding int, mbstr &i8, len int) int {
	return if (encoding >= 0 && encoding < Pg_enc.pg_last_encoding_) {
		pg_wchar_table[encoding].mbverifystr(&u8(voidptr(mbstr)), len)
	} else {
		pg_wchar_table[int(Pg_enc.pg_sql_ascii)].mbverifystr(&u8(voidptr(mbstr)), len)
	}
}

@[export: 'pg_encoding_max_length']
@[markused]
pub fn pg_encoding_max_length(encoding int) int {
	return if (encoding >= 0 && encoding < Pg_enc.pg_last_encoding_) {
		pg_wchar_table[encoding].maxmblen
	} else {
		pg_wchar_table[int(Pg_enc.pg_sql_ascii)].maxmblen
	}
}
