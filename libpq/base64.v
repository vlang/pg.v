@[translated]
module libpq

pub struct C2vU128 {
pub mut:
	lo u64
	hi u64
}

pub fn c2v_u128(v u64) C2vU128 {
	return C2vU128{
		lo: v
	}
}

pub fn c2v_i128(v i64) C2vU128 {
	return C2vU128{
		lo: u64(v)
		hi: if v < 0 { max_u64 } else { 0 }
	}
}

pub fn c2v_u128_add(a C2vU128, b C2vU128) C2vU128 {
	lo := a.lo + b.lo
	return C2vU128{
		lo: lo
		hi: a.hi + b.hi + (if lo < a.lo { u64(1) } else { u64(0) })
	}
}

pub fn c2v_u128_sub(a C2vU128, b C2vU128) C2vU128 {
	return C2vU128{
		lo: a.lo - b.lo
		hi: a.hi - b.hi - (if a.lo < b.lo { u64(1) } else { u64(0) })
	}
}

pub fn c2v_mul_64(x u64, y u64) C2vU128 {
	x0 := x & 0xffffffff
	x1 := x >> 32
	y0 := y & 0xffffffff
	y1 := y >> 32
	w0 := x0 * y0
	t := x1 * y0 + (w0 >> 32)
	w1 := (t & 0xffffffff) + x0 * y1
	return C2vU128{
		lo: x * y
		hi: x1 * y1 + (t >> 32) + (w1 >> 32)
	}
}

pub fn c2v_u128_mul(a C2vU128, b C2vU128) C2vU128 {
	p := c2v_mul_64(a.lo, b.lo)
	return C2vU128{
		lo: p.lo
		hi: p.hi + a.lo * b.hi + a.hi * b.lo
	}
}

pub fn c2v_u128_and(a C2vU128, b C2vU128) C2vU128 {
	return C2vU128{
		lo: a.lo & b.lo
		hi: a.hi & b.hi
	}
}

pub fn c2v_u128_or(a C2vU128, b C2vU128) C2vU128 {
	return C2vU128{
		lo: a.lo | b.lo
		hi: a.hi | b.hi
	}
}

pub fn c2v_u128_xor(a C2vU128, b C2vU128) C2vU128 {
	return C2vU128{
		lo: a.lo ^ b.lo
		hi: a.hi ^ b.hi
	}
}

pub fn c2v_u128_not(a C2vU128) C2vU128 {
	return C2vU128{
		lo: ~a.lo
		hi: ~a.hi
	}
}

pub fn c2v_u128_neg(a C2vU128) C2vU128 {
	return c2v_u128_add(c2v_u128_not(a), c2v_u128(1))
}

pub fn c2v_u128_shl(a C2vU128, n int) C2vU128 {
	s := n & 127
	if s == 0 {
		return a
	}
	if s >= 64 {
		return C2vU128{
			hi: a.lo << (s - 64)
		}
	}
	return C2vU128{
		lo: a.lo << s
		hi: (a.hi << s) | (a.lo >> (64 - s))
	}
}

pub fn c2v_u128_shr(a C2vU128, n int) C2vU128 {
	s := n & 127
	if s == 0 {
		return a
	}
	if s >= 64 {
		return C2vU128{
			lo: a.hi >> (s - 64)
		}
	}
	return C2vU128{
		lo: (a.lo >> s) | (a.hi << (64 - s))
		hi: a.hi >> s
	}
}

pub fn c2v_i128_shr(a C2vU128, n int) C2vU128 {
	s := n & 127
	if s == 0 {
		return a
	}
	sign_bits := if i64(a.hi) < 0 { max_u64 } else { u64(0) }
	if s >= 64 {
		return C2vU128{
			lo: u64(i64(a.hi) >> (s - 64))
			hi: sign_bits
		}
	}
	return C2vU128{
		lo: (a.lo >> s) | (a.hi << (64 - s))
		hi: u64(i64(a.hi) >> s)
	}
}

pub fn c2v_u128_cmp(a C2vU128, b C2vU128) int {
	if a.hi != b.hi {
		return if a.hi < b.hi { -1 } else { 1 }
	}
	if a.lo != b.lo {
		return if a.lo < b.lo { -1 } else { 1 }
	}
	return 0
}

pub fn c2v_i128_cmp(a C2vU128, b C2vU128) int {
	if a.hi != b.hi {
		return if i64(a.hi) < i64(b.hi) { -1 } else { 1 }
	}
	if a.lo != b.lo {
		return if a.lo < b.lo { -1 } else { 1 }
	}
	return 0
}

pub fn c2v_u128_is_zero(a C2vU128) bool {
	return a.lo == 0 && a.hi == 0
}

pub fn c2v_u128_to_f64(a C2vU128) f64 {
	return f64(a.hi) * 18446744073709551616.0 + f64(a.lo)
}

pub fn c2v_i128_to_f64(a C2vU128) f64 {
	if i64(a.hi) < 0 {
		return -c2v_u128_to_f64(c2v_u128_neg(a))
	}
	return c2v_u128_to_f64(a)
}

pub type Oid = u32

pub type Pg_int64 = i64

pub type Pg_funcptr_t = fn ()

pub type Pointer = &i8

pub type Int8 = i8

pub type Int16 = i16

pub type Int32 = i32

pub type Int64 = i64

pub type Uint8 = u8

pub type Uint16 = u16

pub type Uint32 = u32

pub type Uint64 = u64

pub type Bits8 = u8

pub type Bits16 = u16

pub type Bits32 = u32

pub type Int128 = C2vU128

pub type Uint128 = C2vU128

pub type Size = usize

pub type Index = u32

pub type Offset = i32

pub type Float4 = f32

pub type Float8 = f64

pub type Regproc = u32

pub type RegProcedure = u32

pub type TransactionId = u32

pub type LocalTransactionId = u32

pub type SubTransactionId = u32

pub type MultiXactId = u32

pub type MultiXactOffset = u32

pub type CommandId = u32

pub struct Bytea {
pub mut:
	vl_len_ [4]i8
	vl_dat  [1]i8
}

pub type Text = Bytea

pub type BpChar = Bytea

pub type VarChar = Bytea

pub struct Int2vector {
pub mut:
	vl_len_    Int32
	ndim       i32
	dataoffset Int32
	elemtype   Oid
	dim1       i32
	lbound1    i32
	values     [1]Int16
}

pub struct Oidvector {
pub mut:
	vl_len_    Int32
	ndim       i32
	dataoffset Int32
	elemtype   Oid
	dim1       i32
	lbound1    i32
	values     [1]Oid
}

pub struct NameData {
pub mut:
	data [64]i8
}

pub type Name = &NameData

pub union PGAlignedBlock {
pub mut:
	data            [8192]i8
	force_align_d   f64
	force_align_i64 Int64
}

pub union PGIOAlignedBlock {
pub mut:
	data            [8192]i8
	force_align_d   f64
	force_align_i64 Int64
}

pub union PGAlignedXLogBlock {
pub mut:
	data            [8192]i8
	force_align_d   f64
	force_align_i64 Int64
}

pub fn fdatasync(fildes i32) i32

pub type Pgsocket = i32

pub fn has_drive_prefix(path &i8) bool

pub fn first_dir_separator(filename &i8) &i8

pub fn last_dir_separator(filename &i8) &i8

pub fn first_path_var_separator(pathlist &i8) &i8

pub fn join_path_components(ret_path &i8, head &i8, tail &i8)

pub fn canonicalize_path(path &i8)

pub fn canonicalize_path_enc(path &i8, encoding i32)

pub fn make_native_path(filename &i8)

pub fn cleanup_path(path &i8)

pub fn path_contains_parent_reference(path &i8) bool

pub fn path_is_relative_and_below_cwd(path &i8) bool

pub fn path_is_safe_for_extraction(path &i8) bool

pub fn path_is_prefix_of_path(path1 &i8, path2 &i8) bool

pub fn make_absolute_path(path &i8) &i8

pub fn get_progname(argv0 &i8) &i8

pub fn get_share_path(my_exec_path &i8, ret_path &i8)

pub fn get_etc_path(my_exec_path &i8, ret_path &i8)

pub fn get_include_path(my_exec_path &i8, ret_path &i8)

pub fn get_pkginclude_path(my_exec_path &i8, ret_path &i8)

pub fn get_includeserver_path(my_exec_path &i8, ret_path &i8)

pub fn get_lib_path(my_exec_path &i8, ret_path &i8)

pub fn get_pkglib_path(my_exec_path &i8, ret_path &i8)

pub fn get_locale_path(my_exec_path &i8, ret_path &i8)

pub fn get_doc_path(my_exec_path &i8, ret_path &i8)

pub fn get_html_path(my_exec_path &i8, ret_path &i8)

pub fn get_man_path(my_exec_path &i8, ret_path &i8)

pub fn get_home_path(ret_path &i8) bool

pub fn get_parent_directory(path &i8)

pub fn pgfnames(path &i8) &&u8

pub fn pgfnames_cleanup(filenames &&u8)

pub fn set_pglocale_pgservice(argv0 &i8, app &i8)

pub fn validate_exec(path &i8) i32

pub fn find_my_exec(argv0 &i8, retpath &i8) i32

pub fn find_other_exec(argv0 &i8, target &i8, versionstr &i8, retpath &i8) i32

pub fn pipe_read_line(cmd &i8) &i8

pub fn pg_usleep(microsec i64)

pub fn pg_strsignal(signum i32) &i8

pub fn pclose_check(stream &C.FILE) i32

pub fn rmtree(path &i8, rmtopdir bool) bool

pub fn pg_qsort(base voidptr, nel usize, elsize usize, cmp fn (voidptr, voidptr) i32)

pub fn pg_qsort_strcmp(a voidptr, b voidptr) i32

pub type Qsort_arg_comparator = fn (voidptr, voidptr, voidptr) i32

pub fn qsort_arg(base voidptr, nel usize, elsize usize, cmp Qsort_arg_comparator, arg voidptr)

pub fn qsort_interruptible(base voidptr, nel usize, elsize usize, cmp Qsort_arg_comparator, arg voidptr)

pub fn bsearch_arg(key voidptr, base0 voidptr, nmemb usize, size usize, compar fn (voidptr, voidptr, voidptr) i32, arg voidptr) voidptr

pub fn pg_localeconv_r(lc_monetary &i8, lc_numeric &i8, output &C.lconv) i32

pub fn pg_localeconv_free(lconv &C.lconv)

pub fn pg_check_dir(dir &i8) i32

pub fn pg_mkdir_p(path &i8, omode i32) i32

pub type Pqsigfunc = fn (i32)

pub fn pqsignal_fe(signo i32, func Pqsigfunc)

pub fn escape_single_quotes_ascii(src &i8) &i8

pub fn wait_result_to_str(exitstatus i32) &i8

pub fn wait_result_is_signal(exit_status i32, signum i32) bool

pub fn wait_result_is_any_signal(exit_status i32, include_command_not_found bool) bool

pub fn wait_result_to_exit_code(exit_status i32) i32

pub fn pg_malloc(size usize) voidptr

pub fn pg_malloc0(size usize) voidptr

pub fn pg_malloc_extended(size usize, flags i32) voidptr

pub fn pg_realloc(ptr voidptr, size usize) voidptr

pub fn pg_free(ptr voidptr)

pub fn add_size(s1 Size, s2 Size) Size

pub fn mul_size(s1 Size, s2 Size) Size

pub fn pg_malloc_mul(s1 Size, s2 Size) voidptr

pub fn pg_malloc0_mul(s1 Size, s2 Size) voidptr

pub fn pg_malloc_mul_extended(s1 Size, s2 Size, flags i32) voidptr

pub fn pg_realloc_mul(p voidptr, s1 Size, s2 Size) voidptr

pub fn pstrdup(in_ &i8) &i8

pub fn pnstrdup(in_ &i8, size Size) &i8

pub fn palloc(size Size) voidptr

pub fn palloc0(size Size) voidptr

pub fn palloc_extended(size Size, flags i32) voidptr

pub fn repalloc(pointer voidptr, size Size) voidptr

pub fn pfree(pointer voidptr)

pub fn palloc_mul(s1 Size, s2 Size) voidptr

pub fn palloc0_mul(s1 Size, s2 Size) voidptr

pub fn palloc_mul_extended(s1 Size, s2 Size, flags i32) voidptr

pub fn repalloc_mul(p voidptr, s1 Size, s2 Size) voidptr

@[export: 'pg_b64_encode']
@[markused]
pub fn pg_b64_encode(src &Uint8, len i32, dst &i8, dstlen i32) i32 {
	p := &i8(0)
	s := &Uint8(0)
	end := src + len

	pos := i32(2)
	buf := Uint32(0)
	s = src
	p = dst
	for usize(s) < usize(end) {
		buf |= Uint32(i32((unsafe { *s })) << (pos << 3))
		pos--
		c2v_pointer_postfix(voidptr(&s), s, isize(1))
		if pos < 0 {
			if (i64((isize(p) - isize(dst)) / isize(sizeof(i8))) + i64(4)) > i64(dstlen) {
				unsafe {
					goto error
				}
			}
			mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
			unsafe { *__c2v_lhs_tmp_0 = libpq_base64__base64[(buf >> 18) & Uint32(63)] }
			mut __c2v_lhs_tmp_1 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
			unsafe { *__c2v_lhs_tmp_1 = libpq_base64__base64[(buf >> 12) & Uint32(63)] }
			mut __c2v_lhs_tmp_2 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
			unsafe { *__c2v_lhs_tmp_2 = libpq_base64__base64[(buf >> 6) & Uint32(63)] }
			mut __c2v_lhs_tmp_3 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
			unsafe { *__c2v_lhs_tmp_3 = libpq_base64__base64[buf & Uint32(63)] }
			pos = 2
			buf = Uint32(0)
		}
	}
	if pos != 2 {
		if (i64((isize(p) - isize(dst)) / isize(sizeof(i8))) + i64(4)) > i64(dstlen) {
			unsafe {
				goto error
			}
		}
		mut __c2v_lhs_tmp_4 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
		unsafe { *__c2v_lhs_tmp_4 = libpq_base64__base64[(buf >> 18) & Uint32(63)] }
		mut __c2v_lhs_tmp_5 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
		unsafe { *__c2v_lhs_tmp_5 = libpq_base64__base64[(buf >> 12) & Uint32(63)] }
		mut __c2v_lhs_tmp_6 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
		unsafe {
			*__c2v_lhs_tmp_6 = i8(if (pos == 0) {
				i32(libpq_base64__base64[(buf >> 6) & Uint32(63)])
			} else {
				`=`
			})
		}
		mut __c2v_lhs_tmp_7 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
		unsafe { *__c2v_lhs_tmp_7 = i8(`=`) }
	}

	return i32(i64((isize(p) - isize(dst)) / isize(sizeof(i8))))
	error:
	C.c2v_memset(voidptr(dst), 0, u64(dstlen))
	return -1
}

@[export: 'pg_b64_decode']
@[markused]
pub fn pg_b64_decode(src &i8, len i32, dst &Uint8, dstlen i32) i32 {
	srcend := src + len
	s := src

	p := dst
	c := i8(0)
	b := i32(0)
	buf := Uint32(0)
	pos := i32(0)
	end := i32(0)

	for usize(s) < usize(srcend) {
		c = unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) }
		if i32(c) == i8(` `) || i32(c) == i8(`\t`) || i32(c) == i8(`\n`) || i32(c) == i8(`\r`) {
			unsafe {
				goto error
			}
		}
		if i32(c) == i8(`=`) {
			if !end {
				if pos == 2 {
					end = 1
				} else if pos == 3 {
					end = 2
				} else {
					unsafe {
						goto error
					}
				}
			}
			b = 0
		} else {
			b = -1
			if i32(c) > 0 && i32(c) < 127 {
				b = i32(libpq_base64_b64lookup[u8(c)])
			}
			if b < 0 {
				unsafe {
					goto error
				}
			}
		}
		buf = (buf << 6) + Uint32(b)
		pos++
		if pos == 4 {
			if (i64((isize(p) - isize(dst)) / isize(sizeof(Uint8))) + i64(1)) > i64(dstlen) {
				unsafe {
					goto error
				}
			}
			mut __c2v_lhs_tmp_8 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
			unsafe { *__c2v_lhs_tmp_8 = Uint8((buf >> 16) & Uint32(255)) }
			if end == 0 || end > 1 {
				if (i64((isize(p) - isize(dst)) / isize(sizeof(Uint8))) + i64(1)) > i64(dstlen) {
					unsafe {
						goto error
					}
				}
				mut __c2v_lhs_tmp_9 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
				unsafe { *__c2v_lhs_tmp_9 = Uint8((buf >> 8) & Uint32(255)) }
			}
			if end == 0 || end > 2 {
				if (i64((isize(p) - isize(dst)) / isize(sizeof(Uint8))) + i64(1)) > i64(dstlen) {
					unsafe {
						goto error
					}
				}
				mut __c2v_lhs_tmp_10 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
				unsafe { *__c2v_lhs_tmp_10 = Uint8(buf & Uint32(255)) }
			}
			buf = Uint32(0)
			pos = 0
		}
	}
	if pos != 0 {
		unsafe {
			goto error
		}
	}

	return i32(i64((isize(p) - isize(dst)) / isize(sizeof(Uint8))))
	error:
	C.c2v_memset(voidptr(dst), 0, u64(dstlen))
	return -1
}

@[export: 'pg_b64_enc_len']
@[markused]
pub fn pg_b64_enc_len(srclen i32) i32 {
	return (srclen + 2) / 3 * 4
}

@[export: 'pg_b64_dec_len']
@[markused]
pub fn pg_b64_dec_len(srclen i32) i32 {
	return (srclen * 3) >> 2
}
