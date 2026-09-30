@[translated]
module libpq

@[markused]
pub fn libpq_fe_print_pg_sub_s16_overflow(a Int16, b Int16, result &Int16) bool {
	res := Int32(a) - Int32(b)
	if res > 32767 || res < -32768 {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_mul_s16_overflow(a Int16, b Int16, result &Int16) bool {
	res := Int32(a) * Int32(b)
	if res > 32767 || res < -32768 {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_neg_s16_overflow(a Int16, result &Int16) bool {
	if (i64((int(a) == -32768) != 0)) {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(-int(a)) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_abs_s16(a Int16) Uint16 {
	return Uint16(C.c2v_abs(Int32(a)))
}

@[markused]
pub fn libpq_fe_print_pg_add_s32_overflow(a Int32, b Int32, result &Int32) bool {
	res := Int64(a) + Int64(b)
	if res > Int64(2147483647) || res < Int64((-2147483647 - 1)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_sub_s32_overflow(a Int32, b Int32, result &Int32) bool {
	res := Int64(a) - Int64(b)
	if res > Int64(2147483647) || res < Int64((-2147483647 - 1)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_mul_s32_overflow(a Int32, b Int32, result &Int32) bool {
	res := Int64(a) * Int64(b)
	if res > Int64(2147483647) || res < Int64((-2147483647 - 1)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_neg_s32_overflow(a Int32, result &Int32) bool {
	if (i64((a == (-2147483647 - 1)) != 0)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = -a }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_abs_s32(a Int32) Uint32 {
	return Uint32((Int64(C.c2v_labs(i64(Int64(a))))))
}

@[markused]
pub fn libpq_fe_print_pg_add_s64_overflow(a Int64, b Int64, result &Int64) bool {
	res := c2v_u128_add(c2v_i128(i64(a)), c2v_i128(i64(b)))
	if c2v_i128_cmp(res, c2v_i128(i64(9223372036854775807))) > 0 || c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0 {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_sub_s64_overflow(a Int64, b Int64, result &Int64) bool {
	res := c2v_u128_sub(c2v_i128(i64(a)), c2v_i128(i64(b)))
	if c2v_i128_cmp(res, c2v_i128(i64(9223372036854775807))) > 0 || c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0 {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_mul_s64_overflow(a Int64, b Int64, result &Int64) bool {
	res := c2v_u128_mul(c2v_i128(i64(a)), c2v_i128(i64(b)))
	if c2v_i128_cmp(res, c2v_i128(i64(9223372036854775807))) > 0 || c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0 {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_neg_s64_overflow(a Int64, result &Int64) bool {
	if (i64((a == (-9223372036854775807 - i64(1))) != 0)) {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = -a }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_abs_s64(a Int64) Uint64 {
	if (i64((a == (-9223372036854775807 - i64(1))) != 0)) {
		return Uint64(9223372036854775807) + Uint64(1)
	}
	return Uint64((Int64(C.c2v_labs(i64(a)))))
}

@[markused]
pub fn libpq_fe_print_pg_add_u16_overflow(a Uint16, b Uint16, result &Uint16) bool {
	res := Uint16(int(a) + int(b))
	if int(res) < int(a) {
		unsafe { *result = Uint16(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_sub_u16_overflow(a Uint16, b Uint16, result &Uint16) bool {
	if int(b) > int(a) {
		unsafe { *result = Uint16(24301) }
		return true != 0
	}
	unsafe { *result = Uint16(int(a) - int(b)) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_mul_u16_overflow(a Uint16, b Uint16, result &Uint16) bool {
	res := Uint32(a) * Uint32(b)
	if res > Uint32(65535) {
		unsafe { *result = Uint16(24301) }
		return true != 0
	}
	unsafe { *result = Uint16(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_neg_u16_overflow(a Uint16, result &Int16) bool {
	res := -(Int32(a))
	if (i64((res < -32768) != 0)) {
		unsafe { *result = Int16(24301) }
		return true != 0
	}
	unsafe { *result = Int16(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_add_u32_overflow(a Uint32, b Uint32, result &Uint32) bool {
	res := a + b
	if res < a {
		unsafe { *result = Uint32(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_sub_u32_overflow(a Uint32, b Uint32, result &Uint32) bool {
	if b > a {
		unsafe { *result = Uint32(24301) }
		return true != 0
	}
	unsafe { *result = a - b }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_mul_u32_overflow(a Uint32, b Uint32, result &Uint32) bool {
	res := Uint64(a) * Uint64(b)
	if res > Uint64(u32(4294967295)) {
		unsafe { *result = Uint32(24301) }
		return true != 0
	}
	unsafe { *result = Uint32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_neg_u32_overflow(a Uint32, result &Int32) bool {
	res := -(Int64(a))
	if (i64((res < Int64((-2147483647 - 1))) != 0)) {
		unsafe { *result = 24301 }
		return true != 0
	}
	unsafe { *result = Int32(res) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_add_u64_overflow(a Uint64, b Uint64, result &Uint64) bool {
	res := a + b
	if res < a {
		unsafe { *result = Uint64(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_sub_u64_overflow(a Uint64, b Uint64, result &Uint64) bool {
	if b > a {
		unsafe { *result = Uint64(24301) }
		return true != 0
	}
	unsafe { *result = a - b }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_mul_u64_overflow(a Uint64, b Uint64, result &Uint64) bool {
	res := c2v_u128_mul(c2v_u128(u64(a)), c2v_u128(u64(b)))
	if c2v_u128_cmp(res, c2v_u128(u64(u64(18446744073709551615)))) > 0 {
		unsafe { *result = Uint64(24301) }
		return true != 0
	}
	unsafe { *result = Uint64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_neg_u64_overflow(a Uint64, result &Int64) bool {
	res := c2v_u128_neg((c2v_u128(u64(a))))
	if (i64((c2v_i128_cmp(res, c2v_i128(i64((-9223372036854775807 - i64(1))))) < 0) != 0)) {
		unsafe { *result = Int64(24301) }
		return true != 0
	}
	unsafe { *result = Int64(res.lo) }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_add_size_overflow(a usize, b usize, result &usize) bool {
	res := a + b
	if res < a {
		unsafe { *result = usize(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_sub_size_overflow(a usize, b usize, result &usize) bool {
	if b > a {
		unsafe { *result = usize(24301) }
		return true != 0
	}
	unsafe { *result = a - b }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_mul_size_overflow(a usize, b usize, result &usize) bool {
	res := a * b
	if a != usize(0) && b != res / a {
		unsafe { *result = usize(24301) }
		return true != 0
	}
	unsafe { *result = res }
	return false != 0
}

@[markused]
pub fn libpq_fe_print_pg_cmp_s16(a Int16, b Int16) int {
	return Int32(a) - Int32(b)
}

@[markused]
pub fn libpq_fe_print_pg_cmp_u16(a Uint16, b Uint16) int {
	return Int32(a) - Int32(b)
}

@[markused]
pub fn libpq_fe_print_pg_cmp_s32(a Int32, b Int32) int {
	return int((a > b)) - int((a < b))
}

@[markused]
pub fn libpq_fe_print_pg_cmp_u32(a Uint32, b Uint32) int {
	return int((a > b)) - int((a < b))
}

@[markused]
pub fn libpq_fe_print_pg_cmp_s64(a Int64, b Int64) int {
	return int((a > b)) - int((a < b))
}

@[markused]
pub fn libpq_fe_print_pg_cmp_u64(a Uint64, b Uint64) int {
	return int((a > b)) - int((a < b))
}

@[markused]
pub fn libpq_fe_print_pg_cmp_size(a usize, b usize) int {
	return int((a > b)) - int((a < b))
}

pub type PGcancelConn_fe_print = Pg_cancel_conn

pub type PGcancel_fe_print = Pg_cancel

@[markused]
pub fn libpq_fe_print_is_unixsock_path(path &i8) bool {
	return (int(path[false]) == i8(`/`)) || int(path[false]) == i8(`@`)
}

@[export: 'PQprint']
@[markused]
pub fn pq_print(fout &C.FILE, res &PGresult, po &PQprintOpt) {
	n_fields := 0
	n_fields = pq_nfields(res)
	if n_fields > 0 {
		i := 0
		j := 0

		n_tups := 0
		field_max := unsafe { &int(nil) }
		field_not_num := unsafe { &u8(nil) }
		border := unsafe { &i8(nil) }
		fields := unsafe { &&u8(nil) }
		field_names := unsafe { &&u8(nil) }
		field_max_len := 0
		num_field_name := 0
		fs_len := int(C.c2v_strlen(po.fieldSep))
		total_line_length := 0
		use_pipe := (0 != 0)
		pagerenv := &i8(0)
		osigset := u32(0)
		sigpipe_masked := (0 != 0)
		sigpipe_pending := false
		screen_size := C.winsize{}
		if u64(fs_len) < C.c2v_strlen(po.fieldSep) {
			pg_fprintf(C.stderr, unsafe { &i8(&c'overlong field separator\n'[0]) })
			unsafe {
				goto exit
			}
		}
		n_tups = pq_ntuples(res)
		field_names = &&u8(C.c2v_calloc(u64(n_fields), sizeof(voidptr)))
		field_not_num = &u8(C.c2v_calloc(u64(n_fields), u64(1)))
		field_max = &int(C.c2v_calloc(u64(n_fields), sizeof(int)))
		if isnil(field_names) || isnil(field_not_num) || isnil(field_max) {
			pg_fprintf(C.stderr, unsafe { &i8(&c'out of memory\n'[0]) })
			unsafe {
				goto exit
			}
		}
		for num_field_name = 0; !isnil(po.fieldName) && !isnil(po.fieldName[num_field_name]); num_field_name++ {
		}
		for j = 0; j < n_fields; j++ {
			len := 0
			s := if (j < num_field_name && int(po.fieldName[j][0])) {
				po.fieldName[j]
			} else {
				pq_fname(res, j)
			}
			field_names[j] = s
			len = int(if s { C.c2v_strlen(s) } else { u64(0) })
			field_max[j] = len
			len += fs_len
			if len > field_max_len {
				field_max_len = len
			}
			total_line_length += len
		}
		total_line_length += u64(n_fields) * C.c2v_strlen(po.fieldSep) + u64(1)
		if usize(fout) == usize((voidptr(0))) {
			fout = C.stdout
		}
		if int(po.pager) && usize(fout) == usize(C.stdout) && C.c2v_isatty(C.c2v_fileno(C.stdin)) && C.c2v_isatty(C.c2v_fileno(C.stdout)) {
			mut __c2v_condition_0 := false
			mut __c2v_condition_1 := false
			__c2v_condition_1 = C.c2v_ioctl(C.c2v_fileno(C.stdout), (u64(u32(1073741824)) | ((sizeof(C.winsize) & u64(8191)) << 16) | u64((`t` << 8)) | u64(104)), &screen_size) == -1
			__c2v_condition_0 = __c2v_condition_1
			if !__c2v_condition_0 {
				mut __c2v_condition_2 := false
				__c2v_condition_2 = int(screen_size.ws_col) == 0
				__c2v_condition_0 = __c2v_condition_2
			}
			if !__c2v_condition_0 {
				mut __c2v_condition_3 := false
				__c2v_condition_3 = int(screen_size.ws_row) == 0
				__c2v_condition_0 = __c2v_condition_3
			}
			if __c2v_condition_0 {
				screen_size.ws_row = u16(24)
				screen_size.ws_col = u16(80)
			}
			pagerenv = C.c2v_getenv(c'PAGER')
			mut __c2v_condition_4 := false
			mut __c2v_condition_5 := false
			__c2v_condition_5 = usize(pagerenv) != usize((voidptr(0)))
			if __c2v_condition_5 {
				__c2v_condition_5 = C.c2v_strspn(pagerenv, c' \t\r\n') != C.c2v_strlen(pagerenv)
			}
			if __c2v_condition_5 {
				__c2v_condition_5 = !po.html3
			}
			if __c2v_condition_5 {
				__c2v_condition_5 = ((int(po.expanded) && n_tups * (n_fields + 1) >= int(screen_size.ws_row)) || (!po.expanded && n_tups * (total_line_length / int(screen_size.ws_col) + 1) * (1 + int((int(po.standard) != 0))) >= int(screen_size.ws_row) - int((int(po.header) != 0)) * (total_line_length / int(screen_size.ws_col) + 1) * 2 - int((int(po.header) != 0)) * 2))
			}
			__c2v_condition_4 = __c2v_condition_5
			if __c2v_condition_4 {
				C.c2v_fflush((voidptr(0)))
				fout = C.c2v_popen(pagerenv, c'w')
				if fout {
					use_pipe = (1 != 0)
					if pq_block_sigpipe(&osigset, &sigpipe_pending) == 0 {
						sigpipe_masked = (1 != 0)
					}
				} else {
					fout = C.stdout
				}
			}
		}
		if !po.expanded && (int(po.align) || int(po.html3)) {
			fields = &&u8(C.c2v_calloc(usize(n_tups) + usize(1), u64(n_fields) * sizeof(voidptr)))
			if isnil(fields) {
				pg_fprintf(C.stderr, unsafe { &i8(&c'out of memory\n'[0]) })
				unsafe {
					goto exit
				}
			}
		} else if int(po.header) && !po.html3 {
			if po.expanded {
				if po.align {
					pg_fprintf(fout, unsafe { &i8(&c'%-*s%s Value\n'[0]) }, field_max_len - fs_len, voidptr(unsafe { &c'Field'[0] }), voidptr(po.fieldSep))
				} else {
					pg_fprintf(fout, unsafe { &i8(&c'%s%sValue\n'[0]) }, voidptr(unsafe { &c'Field'[0] }), voidptr(po.fieldSep))
				}
			} else {
				len := 0
				for j = 0; j < n_fields; j++ {
					s := field_names[j]
					C.c2v_fputs(s, fout)
					len += C.c2v_strlen(s) + u64(fs_len)
					if (j + 1) < n_fields {
						C.c2v_fputs(po.fieldSep, fout)
					}
				}
				C.c2v_fputc(`\n`, fout)
				len -= fs_len
				for len-- {
					C.c2v_fputc(`-`, fout)
				}
				C.c2v_fputc(`\n`, fout)
			}
		}
		if int(po.expanded) && int(po.html3) {
			if po.caption {
				pg_fprintf(fout, c'<center><h2>%s</h2></center>\n', voidptr(po.caption))
			} else {
				pg_fprintf(fout, c'<center><h2>Query retrieved %d rows * %d fields</h2></center>\n', n_tups, n_fields)
			}
		}
		for i = 0; i < n_tups; i++ {
			if po.expanded {
				if po.html3 {
					pg_fprintf(fout, c'<table %s><caption align="top">%d</caption>\n', voidptr(if po.tableOpt {
						po.tableOpt
					} else {
						c''
					}), i)
				} else {
					pg_fprintf(fout, unsafe { &i8(&c'-- RECORD %d --\n'[0]) }, i)
				}
			}
			for j = 0; j < n_fields; j++ {
				if !do_field(po, res, i, j, fs_len, fields, n_fields, field_names, field_not_num, field_max, field_max_len, fout) {
					unsafe {
						goto exit
					}
				}
			}
			if int(po.html3) && int(po.expanded) {
				C.c2v_fputs(c'</table>\n', fout)
			}
		}
		if !po.expanded && (int(po.align) || int(po.html3)) {
			if po.html3 {
				if po.header {
					if po.caption {
						pg_fprintf(fout, c'<table %s><caption align="top">%s</caption>\n', voidptr(if po.tableOpt {
							po.tableOpt
						} else {
							c''
						}), voidptr(po.caption))
					} else {
						pg_fprintf(fout, c'<table %s><caption align="top">Retrieved %d rows * %d fields</caption>\n', voidptr(if po.tableOpt {
							po.tableOpt
						} else {
							c''
						}), n_tups, n_fields)
					}
				} else {
					pg_fprintf(fout, c'<table %s>', voidptr(if po.tableOpt {
						po.tableOpt
					} else {
						c''
					}))
				}
			}
			if po.header {
				border = do_header(fout, po, n_fields, field_max, field_names, field_not_num, fs_len, res)
			}
			for i = 0; i < n_tups; i++ {
				output_row(fout, po, n_fields, fields, field_not_num, field_max, border, i)
			}
		}
		if int(po.header) && !po.html3 {
			pg_fprintf(fout, c'(%d row%s)\n\n', pq_ntuples(res), voidptr(if (pq_ntuples(res) == 1) {
				c''
			} else {
				c's'
			}))
		}
		if int(po.html3) && !po.expanded {
			C.c2v_fputs(c'</table>\n', fout)
		}
		exit:
		C.c2v_free(voidptr(field_max))
		C.c2v_free(voidptr(field_not_num))
		C.c2v_free(voidptr(border))
		if fields {
			numfields := (usize(n_tups) + usize(1)) * usize(n_fields)
			for numfields-- > usize(0) {
				C.c2v_free(voidptr(fields[numfields]))
			}
			C.c2v_free(voidptr(fields))
		}
		C.c2v_free(voidptr(field_names))
		if use_pipe {
			C.c2v_pclose(fout)
			if sigpipe_masked {
				pq_reset_sigpipe(&osigset, sigpipe_pending, (1 != 0))
			}
		}
	}
}

@[markused]
pub fn do_field(po &PQprintOpt, res &PGresult, i int, j int, fs_len int, fields &&u8, n_fields int, field_names &&u8, field_not_num &u8, field_max &int, field_max_len int, fout &C.FILE) bool {
	pval := &i8(0)
	p := &i8(0)

	plen := 0
	skipit := false
	plen = pq_getlength(res, i, j)
	pval = pq_getvalue(res, i, j)
	if plen < 1 || isnil(pval) || !(unsafe { *pval }) {
		if int(po.align) || int(po.expanded) {
			skipit = (1 != 0)
		} else {
			skipit = (0 != 0)
			unsafe {
				goto efield
			}
		}
	} else {
		skipit = (0 != 0)
	}
	if !skipit {
		if int(po.align) && !field_not_num[j] {
			ch := i8(`0`)
			for p = pval; (unsafe { *p }); p = unsafe { p + pq_mblen_bounded(p, res.client_encoding) } {
				ch = unsafe { *p }
				if !((int(ch) >= i8(`0`) && int(ch) <= i8(`9`)) || int(ch) == i8(`.`) || int(ch) == i8(`E`) || int(ch) == i8(`e`) || int(ch) == i8(` `) || int(ch) == i8(`-`)) {
					field_not_num[j] = u8(1)
					break
				}
			}
			if int((unsafe { *pval })) == i8(`E`) || int((unsafe { *pval })) == i8(`e`) || !(int(ch) >= i8(`0`) && int(ch) <= i8(`9`)) {
				field_not_num[j] = u8(1)
			}
		}
		if !po.expanded && (int(po.align) || int(po.html3)) {
			if plen > field_max[j] {
				field_max[j] = plen
			}
			fields[i * n_fields + j] = &i8(C.c2v_malloc(usize(plen) + usize(1)))
			if isnil(fields[i * n_fields + j]) {
				pg_fprintf(C.stderr, unsafe { &i8(&c'out of memory\n'[0]) })
				return false != 0
			}
			C.c2v_strcpy(fields[i * n_fields + j], pval)
		} else {
			if po.expanded {
				if po.html3 {
					pg_fprintf(fout, c'<tr><td align="left"><b>%s</b></td><td align="%s">%s</td></tr>\n', voidptr(field_names[j]), voidptr(if int(field_not_num[j]) {
						c'left'
					} else {
						c'right'
					}), voidptr(pval))
				} else {
					if po.align {
						pg_fprintf(fout, c'%-*s%s %s\n', field_max_len - fs_len, voidptr(field_names[j]), voidptr(po.fieldSep), voidptr(pval))
					} else {
						pg_fprintf(fout, c'%s%s%s\n', voidptr(field_names[j]), voidptr(po.fieldSep), voidptr(pval))
					}
				}
			} else {
				if !po.html3 {
					C.c2v_fputs(pval, fout)
					efield:
					if (j + 1) < n_fields {
						C.c2v_fputs(po.fieldSep, fout)
					} else {
						C.c2v_fputc(`\n`, fout)
					}
				}
			}
		}
	}
	return true != 0
}

@[markused]
pub fn do_header(fout &C.FILE, po &PQprintOpt, n_fields int, field_max &int, field_names &&u8, field_not_num &u8, fs_len int, res &PGresult) &i8 {
	j := 0
	border := unsafe { &i8(nil) }
	if po.html3 {
		C.c2v_fputs(c'<tr>', fout)
	} else {
		tot := usize(0)
		n := 0
		p := unsafe { &i8(nil) }
		for ; n < n_fields; n++ {
			mut __c2v_condition_6 := false
			mut __c2v_condition_7 := false
			__c2v_condition_7 = int(libpq_fe_print_pg_add_size_overflow(tot, usize(field_max[n]), &tot))
			__c2v_condition_6 = __c2v_condition_7
			if !__c2v_condition_6 {
				mut __c2v_condition_8 := false
				__c2v_condition_8 = int(libpq_fe_print_pg_add_size_overflow(tot, usize(fs_len), &tot))
				__c2v_condition_6 = __c2v_condition_8
			}
			if !__c2v_condition_6 {
				mut __c2v_condition_9 := false
				__c2v_condition_9 = (int(po.standard) && int(libpq_fe_print_pg_add_size_overflow(tot, usize(2), &tot)))
				__c2v_condition_6 = __c2v_condition_9
			}
			if __c2v_condition_6 {
				unsafe {
					goto overflow
				}
			}
		}
		if po.standard {
			mut __c2v_condition_10 := false
			mut __c2v_condition_11 := false
			__c2v_condition_11 = int(libpq_fe_print_pg_add_size_overflow(tot, usize(fs_len), &tot))
			__c2v_condition_10 = __c2v_condition_11
			if !__c2v_condition_10 {
				mut __c2v_condition_12 := false
				__c2v_condition_12 = int(libpq_fe_print_pg_add_size_overflow(tot, usize(fs_len), &tot))
				__c2v_condition_10 = __c2v_condition_12
			}
			if !__c2v_condition_10 {
				mut __c2v_condition_13 := false
				__c2v_condition_13 = int(libpq_fe_print_pg_add_size_overflow(tot, usize(2), &tot))
				__c2v_condition_10 = __c2v_condition_13
			}
			if __c2v_condition_10 {
				unsafe {
					goto overflow
				}
			}
		}
		if libpq_fe_print_pg_add_size_overflow(tot, usize(1), &tot) {
			unsafe {
				goto overflow
			}
		}
		border = &i8(C.c2v_malloc(tot))
		if isnil(border) {
			pg_fprintf(C.stderr, unsafe { &i8(&c'out of memory\n'[0]) })
			return unsafe { nil }
		}
		p = border
		if po.standard {
			fs := po.fieldSep
			for (unsafe { *c2v_pointer_postfix(voidptr(&fs), fs, isize(1)) }) {
				mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
				unsafe { *__c2v_lhs_tmp_0 = i8(`+`) }
			}
		}
		for j = 0; j < n_fields; j++ {
			len := 0
			len = field_max[j] + (if int(po.standard) { 2 } else { 0 })
			for len-- {
				mut __c2v_lhs_tmp_1 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
				unsafe { *__c2v_lhs_tmp_1 = i8(`-`) }
			}
			if int(po.standard) || (j + 1) < n_fields {
				fs := po.fieldSep
				for (unsafe { *c2v_pointer_postfix(voidptr(&fs), fs, isize(1)) }) {
					mut __c2v_lhs_tmp_2 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
					unsafe { *__c2v_lhs_tmp_2 = i8(`+`) }
				}
			}
		}
		unsafe { *p = i8(`\0`) }
		if po.standard {
			pg_fprintf(fout, c'%s\n', voidptr(border))
		}
	}
	if po.standard {
		C.c2v_fputs(po.fieldSep, fout)
	}
	for j = 0; j < n_fields; j++ {
		s := pq_fname(res, j)
		if po.html3 {
			pg_fprintf(fout, c'<th align="%s">%s</th>', voidptr(if int(field_not_num[j]) {
				c'left'
			} else {
				c'right'
			}), voidptr(field_names[j]))
		} else {
			n := int(C.c2v_strlen(s))
			if n > field_max[j] {
				field_max[j] = n
			}
			if po.standard {
				pg_fprintf(fout, unsafe { if int(field_not_num[j]) { c' %-*s ' } else { c' %*s ' } }, field_max[j], voidptr(s))
			} else {
				pg_fprintf(fout, unsafe { if int(field_not_num[j]) { c'%-*s' } else { c'%*s' } }, field_max[j], voidptr(s))
			}
			if int(po.standard) || (j + 1) < n_fields {
				C.c2v_fputs(po.fieldSep, fout)
			}
		}
	}
	if po.html3 {
		C.c2v_fputs(c'</tr>\n', fout)
	} else {
		pg_fprintf(fout, c'\n%s\n', voidptr(border))
	}
	return border
	overflow:
	pg_fprintf(C.stderr, unsafe { &i8(&c'header size exceeds the maximum allowed\n'[0]) })
	return unsafe { nil }
}

@[markused]
pub fn output_row(fout &C.FILE, po &PQprintOpt, n_fields int, fields &&u8, field_not_num &u8, field_max &int, border &i8, row_index int) {
	field_index := 0
	if po.html3 {
		C.c2v_fputs(c'<tr>', fout)
	} else if po.standard {
		C.c2v_fputs(po.fieldSep, fout)
	}
	for field_index = 0; field_index < n_fields; field_index++ {
		p := fields[row_index * n_fields + field_index]
		if po.html3 {
			pg_fprintf(fout, c'<td align="%s">%s</td>', voidptr(if int(field_not_num[field_index]) {
				c'left'
			} else {
				c'right'
			}), voidptr(if p { p } else { c'' }))
		} else {
			pg_fprintf(fout, unsafe {
				if int(field_not_num[field_index]) {
					if int(po.standard) { c' %-*s ' } else { c'%-*s' }
				} else {
					if int(po.standard) { c' %*s ' } else { c'%*s' }
				}
			}, field_max[field_index], voidptr(if p { p } else { c'' }))
			if int(po.standard) || field_index + 1 < n_fields {
				C.c2v_fputs(po.fieldSep, fout)
			}
		}
	}
	if po.html3 {
		C.c2v_fputs(c'</tr>', fout)
	} else if po.standard {
		pg_fprintf(fout, c'\n%s', voidptr(border))
	}
	C.c2v_fputc(`\n`, fout)
}

@[export: 'PQdisplayTuples']
@[markused]
pub fn pq_display_tuples(res &PGresult, fp &C.FILE, fill_align int, field_sep &i8, print_header int, quiet int) {
	i := 0
	j := 0

	n_fields := 0
	n_tuples := 0
	f_length := unsafe { &int(nil) }
	if usize(field_sep) == usize((voidptr(0))) {
		field_sep = c' '
	}
	n_fields = pq_nfields(res)
	n_tuples = pq_ntuples(res)
	if usize(fp) == usize((voidptr(0))) {
		fp = C.stdout
	}
	if fill_align {
		f_length = &int(C.c2v_malloc(u64(n_fields) * sizeof(int)))
		if isnil(f_length) {
			pg_fprintf(C.stderr, unsafe { &i8(&c'out of memory\n'[0]) })
			return
		}
		for j = 0; j < n_fields; j++ {
			f_length[j] = int(C.c2v_strlen(pq_fname(res, j)))
			for i = 0; i < n_tuples; i++ {
				flen := pq_getlength(res, i, j)
				if flen > f_length[j] {
					f_length[j] = flen
				}
			}
		}
	}
	if print_header {
		for i = 0; i < n_fields; i++ {
			C.c2v_fputs(pq_fname(res, i), fp)
			if fill_align {
				fill(int(C.c2v_strlen(pq_fname(res, i))), f_length[i], i8(` `), fp)
			}
			C.c2v_fputs(field_sep, fp)
		}
		pg_fprintf(fp, c'\n')
		for i = 0; i < n_fields; i++ {
			if fill_align {
				fill(0, f_length[i], i8(`-`), fp)
			}
			C.c2v_fputs(field_sep, fp)
		}
		pg_fprintf(fp, c'\n')
	}
	for i = 0; i < n_tuples; i++ {
		for j = 0; j < n_fields; j++ {
			pg_fprintf(fp, c'%s', voidptr(pq_getvalue(res, i, j)))
			if fill_align {
				fill(int(C.c2v_strlen(pq_getvalue(res, i, j))), f_length[j], i8(` `), fp)
			}
			C.c2v_fputs(field_sep, fp)
		}
		pg_fprintf(fp, c'\n')
	}
	if !quiet {
		pg_fprintf(fp, c'\nQuery returned %d row%s.\n', pq_ntuples(res), voidptr(if (pq_ntuples(res) == 1) {
			c''
		} else {
			c's'
		}))
	}
	C.c2v_fflush(fp)
	C.c2v_free(voidptr(f_length))
}

@[export: 'PQprintTuples']
@[markused]
pub fn pq_print_tuples(res &PGresult, fout &C.FILE, print_att_names int, terse_output int, col_width int) {
	n_fields := 0
	n_tups := 0
	i := 0
	j := 0

	format_string := [80]i8{}
	tborder := unsafe { &i8(nil) }
	n_fields = pq_nfields(res)
	n_tups = pq_ntuples(res)
	if col_width > 0 {
		pg_sprintf(unsafe { &i8(&format_string[0]) }, c'%%s %%-%ds', col_width)
	} else {
		pg_sprintf(unsafe { &i8(&format_string[0]) }, c'%%s %%s')
	}
	if n_fields > 0 {
		if !terse_output {
			width := 0
			width = n_fields * 14
			tborder = &i8(C.c2v_malloc(u64(width + 1)))
			if isnil(tborder) {
				pg_fprintf(C.stderr, unsafe { &i8(&c'out of memory\n'[0]) })
				return
			}
			for i = 0; i < width; i++ {
				tborder[i] = i8(`-`)
			}
			tborder[width] = i8(`\0`)
			pg_fprintf(fout, c'%s\n', voidptr(tborder))
		}
		for i = 0; i < n_fields; i++ {
			if print_att_names {
				pg_fprintf(fout, unsafe { &i8(&format_string[0]) }, voidptr(if terse_output {
					c''
				} else {
					c'|'
				}), voidptr(pq_fname(res, i)))
			}
		}
		if print_att_names {
			if terse_output {
				pg_fprintf(fout, c'\n')
			} else {
				pg_fprintf(fout, c'|\n%s\n', voidptr(tborder))
			}
		}
		for i = 0; i < n_tups; i++ {
			for j = 0; j < n_fields; j++ {
				pval := pq_getvalue(res, i, j)
				pg_fprintf(fout, unsafe { &i8(&format_string[0]) }, voidptr(if terse_output {
					c''
				} else {
					c'|'
				}), voidptr(if pval { pval } else { c'' }))
			}
			if terse_output {
				pg_fprintf(fout, c'\n')
			} else {
				pg_fprintf(fout, c'|\n%s\n', voidptr(tborder))
			}
		}
	}
	C.c2v_free(voidptr(tborder))
}

@[markused]
pub fn fill(length int, max int, filler i8, fp &C.FILE) {
	count := 0
	count = max - length
	for count-- >= 0 {
		C.c2v_putc(int(filler), fp)
	}
}
