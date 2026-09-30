@[translated]
module libpq

pub fn c2v_isinf(x f64) int {
	return if x != 0 && x * 2 == x { 1 } else { 0 }
}

pub fn c2v_isnan(x f64) int {
	return if x != x { 1 } else { 0 }
}

pub fn c2v_isfinite(x f64) int {
	return if x - x == 0 { 1 } else { 0 }
}

pub struct PrintfTarget {
pub mut:
	bufptr   &i8
	bufstart &i8
	bufend   &i8
	stream   &C.FILE
	nchars   i32
	failed   bool
}

pub enum PrintfArgType {
	atype_none = 0
	atype_int
	atype_long
	atype_longlong
	atype_double
	atype_charptr
}

pub union PrintfArgValue {
pub mut:
	i    i32
	l    i64
	ll   i64
	d    f64
	cptr &i8
}

@[export: 'pg_vsnprintf']
@[markused]
pub fn pg_vsnprintf(str &i8, count usize, fmt &i8, args C.va_list) i32 {
	target := PrintfTarget{}
	onebyte := [1]i8{}
	if count == usize(0) {
		str = unsafe { &onebyte[0] }
		count = usize(1)
	}
	target.bufptr = str
	target.bufstart = target.bufptr
	target.bufend = str + count - 1
	target.stream = unsafe { nil }
	target.nchars = 0
	target.failed = (0 != 0)
	dopr(&target, fmt, args)
	unsafe { *target.bufptr = i8(`\0`) }
	return i32(if i32(target.failed) {
		i64(-1)
	} else {
		(i64((isize(target.bufptr) - isize(target.bufstart)) / isize(sizeof(i8))) + i64(target.nchars))
	})
}

@[c: 'pg_snprintf']
@[c2v_variadic; markused]
pub fn pg_snprintf(str &i8, count usize, fmt &i8, ...) i32 {
	len := i32(0)
	args := C.va_list{}
	C.c2v_va_start(args, fmt)
	len = pg_vsnprintf(str, count, fmt, args)
	C.c2v_va_end(args)
	return len
}

@[export: 'pg_vsprintf']
@[markused]
pub fn pg_vsprintf(str &i8, fmt &i8, args C.va_list) i32 {
	target := PrintfTarget{}
	target.bufptr = str
	target.bufstart = target.bufptr
	target.bufend = unsafe { nil }
	target.stream = unsafe { nil }
	target.nchars = 0
	target.failed = (0 != 0)
	dopr(&target, fmt, args)
	unsafe { *target.bufptr = i8(`\0`) }
	return i32(if i32(target.failed) {
		i64(-1)
	} else {
		(i64((isize(target.bufptr) - isize(target.bufstart)) / isize(sizeof(i8))) + i64(target.nchars))
	})
}

@[c: 'pg_sprintf']
@[c2v_variadic; markused]
pub fn pg_sprintf(str &i8, fmt &i8, ...) i32 {
	len := i32(0)
	args := C.va_list{}
	C.c2v_va_start(args, fmt)
	len = pg_vsprintf(str, fmt, args)
	C.c2v_va_end(args)
	return len
}

@[export: 'pg_vfprintf']
@[markused]
pub fn pg_vfprintf(stream &C.FILE, fmt &i8, args C.va_list) i32 {
	target := PrintfTarget{}
	buffer := [1024]i8{}
	if usize(stream) == usize((voidptr(0))) {
		{
			c2v_target := C.c2v___error()
			unsafe { *c2v_target = 22 }
		}
		return -1
	}
	target.bufptr = unsafe { &buffer[0] }
	target.bufstart = target.bufptr
	target.bufend = unsafe { &buffer[0] } + sizeof([1024]i8)
	target.stream = stream
	target.nchars = 0
	target.failed = (0 != 0)
	dopr(&target, fmt, args)
	flushbuffer(&target)
	return if i32(target.failed) { -1 } else { target.nchars }
}

@[c: 'pg_fprintf']
@[c2v_variadic; markused]
pub fn pg_fprintf(stream &C.FILE, fmt &i8, ...) i32 {
	len := i32(0)
	args := C.va_list{}
	C.c2v_va_start(args, fmt)
	len = pg_vfprintf(stream, fmt, args)
	C.c2v_va_end(args)
	return len
}

@[export: 'pg_vprintf']
@[markused]
pub fn pg_vprintf(fmt &i8, args C.va_list) i32 {
	return pg_vfprintf(C.stdout, fmt, args)
}

@[c: 'pg_printf']
@[c2v_variadic; markused]
pub fn pg_printf(fmt &i8, ...) i32 {
	len := i32(0)
	args := C.va_list{}
	C.c2v_va_start(args, fmt)
	len = pg_vfprintf(C.stdout, fmt, args)
	C.c2v_va_end(args)
	return len
}

@[markused]
pub fn flushbuffer(target &PrintfTarget) {
	nc := usize(i64((isize(target.bufptr) - isize(target.bufstart)) / isize(sizeof(i8))))
	if !target.failed && nc > usize(0) {
		written := usize(0)
		written = C.c2v_fwrite(voidptr(target.bufstart), u64(1), nc, target.stream)
		target.nchars += written
		if written != nc {
			target.failed = (1 != 0)
		}
	}
	target.bufptr = target.bufstart
}

@[markused]
pub fn dopr(target &PrintfTarget, format &i8, args C.va_list) {
	save_errno := (unsafe { *C.c2v___error() })
	first_pct := unsafe { &i8(nil) }
	ch := i32(0)
	have_dollar := false
	have_star := false
	afterstar := false
	accum := i32(0)
	longlongflag := i32(0)
	longflag := i32(0)
	pointflag := i32(0)
	leftjust := i32(0)
	fieldwidth := i32(0)
	precision := i32(0)
	zpad := i32(0)
	forcesign := i32(0)
	fmtpos := i32(0)
	cvalue := i32(0)
	numvalue := i64(0)
	fvalue := 0.0
	strvalue := &i8(0)
	argvalues := [32]PrintfArgValue{}
	have_dollar = (0 != 0)
	for i32((unsafe { *format })) != i8(`\0`) {
		if i32((unsafe { *format })) != i8(`%`) {
			next_pct := C.c2v_strchrnul(format + 1, `%`)
			dostr(format, i32(i64((isize(next_pct) - isize(format)) / isize(sizeof(i8)))), target)
			if target.failed {
				break
			}
			if i32((unsafe { *next_pct })) == i8(`\0`) {
				break
			}
			format = next_pct
		}
		if usize(first_pct) == usize((voidptr(0))) {
			first_pct = format
		}
		c2v_pointer_postfix(voidptr(&format), format, isize(1))
		if i32((unsafe { *format })) == i8(`s`) {
			c2v_pointer_postfix(voidptr(&format), format, isize(1))
			strvalue = C.va_arg(&i8, args)
			if usize(strvalue) == usize((voidptr(0))) {
				strvalue = c'(null)'
			}
			dostr(strvalue, i32(C.c2v_strlen(strvalue)), target)
			if target.failed {
				break
			}
			continue
		}
		forcesign = 0
		leftjust = forcesign
		zpad = leftjust
		precision = zpad
		fieldwidth = precision
		pointflag = 0
		longlongflag = pointflag
		longflag = longlongflag
		accum = 0
		fmtpos = accum
		afterstar = (0 != 0)
		have_star = afterstar
		nextch2:
		ch = unsafe { *c2v_pointer_postfix(voidptr(&format), format, isize(1)) }
		match i32(ch) {
			i32(`-`) {
				leftjust = 1
				unsafe {
					goto nextch2
				}
			}
			i32(`+`) {
				forcesign = 1
				unsafe {
					goto nextch2
				}
			}
			i32(`0`) {
				if accum == 0 && !pointflag {
					zpad = `0`
				}
				unsafe {
					goto c2v_case_53_5
				}
			}
			i32(`1`), i32(`2`), i32(`3`), i32(`4`), i32(`5`), i32(`6`), i32(`7`), i32(`8`), i32(`9`) {
				c2v_case_53_5:
				accum = accum * 10 + (ch - i32(`0`))
				unsafe {
					goto nextch2
				}
			}
			i32(`.`) {
				if have_star {
					have_star = (0 != 0)
				} else {
					fieldwidth = accum
				}
				pointflag = 1
				accum = 0
				unsafe {
					goto nextch2
				}
			}
			i32(`*`) {
				if have_dollar {
					afterstar = (1 != 0)
				} else {
					starval := C.va_arg(i32, args)
					if pointflag {
						precision = starval
						if precision < 0 {
							precision = 0
							pointflag = 0
						}
					} else {
						fieldwidth = starval
						if fieldwidth < 0 {
							leftjust = 1
							fieldwidth = -fieldwidth
						}
					}
				}
				have_star = (1 != 0)
				accum = 0
				unsafe {
					goto nextch2
				}
			}
			i32(`$`) {
				if !have_dollar {
					if !find_arguments(first_pct, args, &argvalues[0]) {
						unsafe {
							goto bad_format
						}
					}
					have_dollar = (1 != 0)
				}
				if afterstar {
					starval := argvalues[accum].i
					if pointflag {
						precision = starval
						if precision < 0 {
							precision = 0
							pointflag = 0
						}
					} else {
						fieldwidth = starval
						if fieldwidth < 0 {
							leftjust = 1
							fieldwidth = -fieldwidth
						}
					}
					afterstar = (0 != 0)
				} else {
					fmtpos = accum
				}
				accum = 0
				unsafe {
					goto nextch2
				}
			}
			i32(`l`) {
				if longflag {
					longlongflag = 1
				} else {
					longflag = 1
				}
				unsafe {
					goto nextch2
				}
			}
			i32(`z`) {
				longflag = 1
				unsafe {
					goto nextch2
				}
			}
			i32(`h`), i32(`\'`) {
				unsafe {
					goto nextch2
				}
			}
			i32(`d`), i32(`i`) {
				if !have_star {
					if pointflag {
						precision = accum
					} else {
						fieldwidth = accum
					}
				}
				if have_dollar {
					if longlongflag {
						numvalue = argvalues[fmtpos].ll
					} else if longflag {
						numvalue = argvalues[fmtpos].l
					} else {
						numvalue = i64(argvalues[fmtpos].i)
					}
				} else {
					if longlongflag {
						numvalue = C.va_arg(i64, args)
					} else if longflag {
						numvalue = C.va_arg(i64, args)
					} else {
						numvalue = i64(C.va_arg(i32, args))
					}
				}
				fmtint(numvalue, i8(ch), forcesign, leftjust, fieldwidth, zpad, precision, pointflag, target)
			}
			i32(`o`), i32(`u`), i32(`x`), i32(`X`) {
				if !have_star {
					if pointflag {
						precision = accum
					} else {
						fieldwidth = accum
					}
				}
				if have_dollar {
					if longlongflag {
						numvalue = i64(u64(argvalues[fmtpos].ll))
					} else if longflag {
						numvalue = i64(u64(argvalues[fmtpos].l))
					} else {
						numvalue = i64(u32(argvalues[fmtpos].i))
					}
				} else {
					if longlongflag {
						numvalue = i64(u64(C.va_arg(i64, args)))
					} else if longflag {
						numvalue = i64(u64(C.va_arg(i64, args)))
					} else {
						numvalue = i64(u32(C.va_arg(i32, args)))
					}
				}
				fmtint(numvalue, i8(ch), forcesign, leftjust, fieldwidth, zpad, precision, pointflag, target)
			}
			i32(`c`) {
				if !have_star {
					if pointflag {
						precision = accum
					} else {
						fieldwidth = accum
					}
				}
				if have_dollar {
					cvalue = i32(u8(argvalues[fmtpos].i))
				} else {
					cvalue = i32(u8(C.va_arg(i32, args)))
				}
				fmtchar(cvalue, leftjust, fieldwidth, target)
			}
			i32(`s`) {
				if !have_star {
					if pointflag {
						precision = accum
					} else {
						fieldwidth = accum
					}
				}
				if have_dollar {
					strvalue = argvalues[fmtpos].cptr
				} else {
					strvalue = C.va_arg(&i8, args)
				}
				if usize(strvalue) == usize((voidptr(0))) {
					strvalue = c'(null)'
				}
				fmtstr(strvalue, leftjust, fieldwidth, precision, pointflag, target)
			}
			i32(`p`) {
				if have_dollar {
					strvalue = argvalues[fmtpos].cptr
				} else {
					strvalue = C.va_arg(&i8, args)
				}
				fmtptr(voidptr(strvalue), target)
			}
			i32(`e`), i32(`E`), i32(`f`), i32(`g`), i32(`G`) {
				if !have_star {
					if pointflag {
						precision = accum
					} else {
						fieldwidth = accum
					}
				}
				if have_dollar {
					fvalue = argvalues[fmtpos].d
				} else {
					fvalue = C.va_arg(f64, args)
				}
				fmtfloat(fvalue, i8(ch), forcesign, leftjust, fieldwidth, zpad, precision, pointflag, target)
			}
			i32(`m`) {
				errbuf := [256]i8{}
				errm := pg_strerror_r(save_errno, unsafe { &i8(&errbuf[0]) }, sizeof([256]i8))
				dostr(errm, i32(C.c2v_strlen(errm)), target)
			}
			i32(`%`) {
				dopr_outch(`%`, target)
			}
			else {
				unsafe {
					goto bad_format
				}
			}
		}

		if target.failed {
			break
		}
	}
	return
	bad_format:
	{
		c2v_target := C.c2v___error()
		unsafe { *c2v_target = 22 }
	}
	target.failed = (1 != 0)
}

@[markused]
pub fn find_arguments(format &i8, args C.va_list, argvalues &PrintfArgValue) bool {
	ch := i32(0)
	afterstar := false
	accum := i32(0)
	longlongflag := i32(0)
	longflag := i32(0)
	fmtpos := i32(0)
	i := i32(0)
	last_dollar := i32(0)
	argtypes := [32]PrintfArgType{}
	for i32((unsafe { *format })) != i8(`\0`) {
		if i32((unsafe { *format })) != i8(`%`) {
			format = C.c2v_strchr(format + 1, `%`)
			if usize(format) == usize((voidptr(0))) {
				break
			}
		}
		c2v_pointer_postfix(voidptr(&format), format, isize(1))
		longlongflag = 0
		longflag = longlongflag
		accum = 0
		fmtpos = accum
		afterstar = (0 != 0)
		nextch1:
		ch = unsafe { *c2v_pointer_postfix(voidptr(&format), format, isize(1)) }
		match i32(ch) {
			i32(`-`), i32(`+`) {
				unsafe {
					goto nextch1
				}
			}
			i32(`0`), i32(`1`), i32(`2`), i32(`3`), i32(`4`), i32(`5`), i32(`6`), i32(`7`), i32(`8`), i32(`9`) {
				accum = accum * 10 + (ch - i32(`0`))
				unsafe {
					goto nextch1
				}
			}
			i32(`.`) {
				accum = 0
				unsafe {
					goto nextch1
				}
			}
			i32(`*`) {
				if afterstar {
					return false != 0
				}
				afterstar = (1 != 0)
				accum = 0
				unsafe {
					goto nextch1
				}
			}
			i32(`$`) {
				if accum <= 0 || accum > 31 {
					return false != 0
				}
				if afterstar {
					if u32(argtypes[accum]) && u32(argtypes[accum]) != u32(PrintfArgType.atype_int) {
						return false != 0
					}
					argtypes[accum] = PrintfArgType.atype_int
					last_dollar = (if last_dollar > accum { last_dollar } else { accum })
					afterstar = (0 != 0)
				} else {
					fmtpos = accum
				}
				accum = 0
				unsafe {
					goto nextch1
				}
			}
			i32(`l`) {
				if longflag {
					longlongflag = 1
				} else {
					longflag = 1
				}
				unsafe {
					goto nextch1
				}
			}
			i32(`z`) {
				longflag = 1
				unsafe {
					goto nextch1
				}
			}
			i32(`h`), i32(`\'`) {
				unsafe {
					goto nextch1
				}
			}
			i32(`d`), i32(`i`), i32(`o`), i32(`u`), i32(`x`), i32(`X`) {
				if fmtpos {
					atype := PrintfArgType{}
					if longlongflag {
						atype = PrintfArgType.atype_longlong
					} else if longflag {
						atype = PrintfArgType.atype_long
					} else {
						atype = PrintfArgType.atype_int
					}
					if u32(argtypes[fmtpos]) && u32(argtypes[fmtpos]) != u32(atype) {
						return false != 0
					}
					argtypes[fmtpos] = atype
					last_dollar = (if last_dollar > fmtpos { last_dollar } else { fmtpos })
				} else {
					return false != 0
				}
			}
			i32(`c`) {
				if fmtpos {
					if u32(argtypes[fmtpos]) && u32(argtypes[fmtpos]) != u32(PrintfArgType.atype_int) {
						return false != 0
					}
					argtypes[fmtpos] = PrintfArgType.atype_int
					last_dollar = (if last_dollar > fmtpos { last_dollar } else { fmtpos })
				} else {
					return false != 0
				}
			}
			i32(`s`), i32(`p`) {
				if fmtpos {
					if u32(argtypes[fmtpos]) && u32(argtypes[fmtpos]) != u32(PrintfArgType.atype_charptr) {
						return false != 0
					}
					argtypes[fmtpos] = PrintfArgType.atype_charptr
					last_dollar = (if last_dollar > fmtpos { last_dollar } else { fmtpos })
				} else {
					return false != 0
				}
			}
			i32(`e`), i32(`E`), i32(`f`), i32(`g`), i32(`G`) {
				if fmtpos {
					if u32(argtypes[fmtpos]) && u32(argtypes[fmtpos]) != u32(PrintfArgType.atype_double) {
						return false != 0
					}
					argtypes[fmtpos] = PrintfArgType.atype_double
					last_dollar = (if last_dollar > fmtpos { last_dollar } else { fmtpos })
				} else {
					return false != 0
				}
			}
			i32(`m`), i32(`%`) {
			}
			else {
				return false != 0
			}
		}

		if afterstar {
			return false != 0
		}
	}
	for i = 1; i <= last_dollar; i++ {
		match argtypes[i] {
			.atype_none {
				return false != 0
			}
			.atype_int {
				argvalues[i].i = C.va_arg(i32, args)
			}
			.atype_long {
				argvalues[i].l = C.va_arg(i64, args)
			}
			.atype_longlong {
				argvalues[i].ll = C.va_arg(i64, args)
			}
			.atype_double {
				argvalues[i].d = C.va_arg(f64, args)
			}
			.atype_charptr {
				argvalues[i].cptr = C.va_arg(&i8, args)
			}
			else {}
		}
	}
	return true != 0
}

@[markused]
pub fn fmtstr(value &i8, leftjust i32, minlen i32, maxwidth i32, pointflag i32, target &PrintfTarget) {
	padlen := i32(0)
	vallen := i32(0)

	if pointflag {
		vallen = i32(C.c2v_strnlen(value, usize(maxwidth)))
	} else {
		vallen = i32(C.c2v_strlen(value))
	}
	padlen = compute_padlen(minlen, vallen, leftjust)
	if padlen > 0 {
		dopr_outchmulti(` `, padlen, target)
		padlen = 0
	}
	dostr(value, vallen, target)
	trailing_pad(padlen, target)
}

@[markused]
pub fn fmtptr(value voidptr, target &PrintfTarget) {
	vallen := i32(0)
	convert := [64]i8{}
	vallen = C.c2v_snprintf(&convert[0], sizeof([64]i8), c'%p', value)
	if vallen < 0 {
		target.failed = (1 != 0)
	} else {
		dostr(unsafe { &i8(&convert[0]) }, vallen, target)
	}
}

@[markused]
pub fn fmtint(value i64, type_ i8, forcesign i32, leftjust i32, minlen i32, zpad i32, precision i32, pointflag i32, target &PrintfTarget) {
	uvalue := u64(0)
	base := i32(0)
	dosign := i32(0)
	cvt := c'0123456789abcdef'
	signvalue := i32(0)
	convert := [64]i8{}
	vallen := i32(0)
	padlen := i32(0)
	zeropad := i32(0)
	match i32(type_) {
		i32(`d`), i32(`i`) {
			base = 10
			dosign = 1
		}
		i32(`o`) {
			base = 8
			dosign = 0
		}
		i32(`u`) {
			base = 10
			dosign = 0
		}
		i32(`x`) {
			base = 16
			dosign = 0
		}
		i32(`X`) {
			cvt = c'0123456789ABCDEF'
			base = 16
			dosign = 0
		}
		else {
			return
		}
	}

	if dosign && adjust_sign((value < i64(0)), forcesign, &signvalue) {
		uvalue = -u64(value)
	} else {
		uvalue = u64(value)
	}
	if value == i64(0) && pointflag && precision == 0 {
		vallen = 0
	} else {
		if base == 10 {
			for {
				convert[sizeof([64]i8) - u64((c2v_prefix_add(unsafe { &vallen }, i32(1))))] = cvt[uvalue % u64(10)]
				uvalue = uvalue / u64(10)
				if !uvalue {
					break
				}
			}
		} else if base == 16 {
			for {
				convert[sizeof([64]i8) - u64((c2v_prefix_add(unsafe { &vallen }, i32(1))))] = cvt[uvalue % u64(16)]
				uvalue = uvalue / u64(16)
				if !uvalue {
					break
				}
			}
		} else {
			for {
				convert[sizeof([64]i8) - u64((c2v_prefix_add(unsafe { &vallen }, i32(1))))] = cvt[uvalue % u64(8)]
				uvalue = uvalue / u64(8)
				if !uvalue {
					break
				}
			}
		}
	}
	zeropad = (if 0 > (precision - vallen) { 0 } else { (precision - vallen) })
	padlen = compute_padlen(minlen, vallen + zeropad, leftjust)
	leading_pad(zpad, signvalue, &padlen, target)
	if zeropad > 0 {
		dopr_outchmulti(`0`, zeropad, target)
	}
	dostr(unsafe { &convert[0] } + sizeof([64]i8) - vallen, vallen, target)
	trailing_pad(padlen, target)
}

@[markused]
pub fn fmtchar(value i32, leftjust i32, minlen i32, target &PrintfTarget) {
	padlen := i32(0)
	padlen = compute_padlen(minlen, 1, leftjust)
	if padlen > 0 {
		dopr_outchmulti(` `, padlen, target)
		padlen = 0
	}
	dopr_outch(value, target)
	trailing_pad(padlen, target)
}

@[markused]
pub fn fmtfloat(value f64, type_ i8, forcesign i32, leftjust i32, minlen i32, zpad i32, precision i32, pointflag i32, target &PrintfTarget) {
	signvalue := i32(0)
	prec := i32(0)
	vallen := i32(0)
	fmt := [8]i8{}
	convert := [1024]i8{}
	zeropadlen := i32(0)
	padlen := i32(0)
	if precision < 0 {
		precision = 0
	}
	prec = (if precision < 350 { precision } else { 350 })
	if (if sizeof(value) == sizeof(f32) {
		C.c2v___inline_isnanf(f32(value))
	} else {
		if sizeof(value) == sizeof(f64) {
			C.c2v___inline_isnand(f64(value))
		} else {
			C.c2v___inline_isnanl(f64(value))
		}
	}) {
		C.c2v_strcpy(unsafe { &i8(&convert[0]) }, c'NaN')
		vallen = 3
	} else {
		if !fmtfloat_dzero_inited {
			fmtfloat_dzero = 0.0
			fmtfloat_dzero_inited = true
		}

		if adjust_sign((value < 0.0 || (value == 0.0 && C.c2v_memcmp(voidptr(&value), voidptr(&fmtfloat_dzero), sizeof(f64)) != 0)), forcesign, &signvalue) {
			value = -value
		}
		if c2v_isinf(f64(value)) {
			C.c2v_strcpy(unsafe { &i8(&convert[0]) }, c'Infinity')
			vallen = 8
		} else if pointflag {
			zeropadlen = precision - prec
			fmt[0] = i8(`%`)
			fmt[1] = i8(`.`)
			fmt[2] = i8(`*`)
			fmt[3] = type_
			fmt[4] = i8(`\0`)
			vallen = C.c2v_snprintf(&convert[0], sizeof([1024]i8), unsafe { &fmt[0] }, prec, value)
		} else {
			fmt[0] = i8(`%`)
			fmt[1] = type_
			fmt[2] = i8(`\0`)
			vallen = C.c2v_snprintf(&convert[0], sizeof([1024]i8), unsafe { &fmt[0] }, value)
		}
		if vallen < 0 {
			unsafe {
				goto fail
			}
		}
	}
	padlen = compute_padlen(minlen, vallen + zeropadlen, leftjust)
	leading_pad(zpad, signvalue, &padlen, target)
	if zeropadlen > 0 {
		epos := C.c2v_strrchr(unsafe { &i8(&convert[0]) }, `e`)
		if isnil(epos) {
			epos = C.c2v_strrchr(unsafe { &i8(&convert[0]) }, `E`)
		}
		if epos {
			dostr(unsafe { &i8(&convert[0]) }, i32(i64((isize(epos) - isize(unsafe { &convert[0] })) / isize(sizeof(i8)))), target)
			dopr_outchmulti(`0`, zeropadlen, target)
			dostr(epos, i32(i64(vallen) - (i64((isize(epos) - isize(unsafe { &convert[0] })) / isize(sizeof(i8))))), target)
		} else {
			dostr(unsafe { &i8(&convert[0]) }, vallen, target)
			dopr_outchmulti(`0`, zeropadlen, target)
		}
	} else {
		dostr(unsafe { &i8(&convert[0]) }, vallen, target)
	}
	trailing_pad(padlen, target)
	return
	fail:
	target.failed = (1 != 0)
}

@[export: 'pg_strfromd']
@[markused]
pub fn pg_strfromd(str &i8, count usize, precision i32, value f64) i32 {
	target := PrintfTarget{}
	signvalue := i32(0)
	vallen := i32(0)
	fmt := [8]i8{}
	convert := [64]i8{}

	target.bufptr = str
	target.bufstart = target.bufptr
	target.bufend = str + count - 1
	target.stream = unsafe { nil }
	target.nchars = 0
	target.failed = (0 != 0)
	if precision < 1 {
		precision = 1
	} else if precision > 32 {
		precision = 32
	}
	if (if sizeof(value) == sizeof(f32) {
		C.c2v___inline_isnanf(f32(value))
	} else {
		if sizeof(value) == sizeof(f64) {
			C.c2v___inline_isnand(f64(value))
		} else {
			C.c2v___inline_isnanl(f64(value))
		}
	}) {
		C.c2v_strcpy(unsafe { &i8(&convert[0]) }, c'NaN')
		vallen = 3
	} else {
		if !pg_strfromd_dzero_inited {
			pg_strfromd_dzero = 0.0
			pg_strfromd_dzero_inited = true
		}

		if value < 0.0 || (value == 0.0 && C.c2v_memcmp(voidptr(&value), voidptr(&pg_strfromd_dzero), sizeof(f64)) != 0) {
			signvalue = `-`
			value = -value
		}
		if c2v_isinf(f64(value)) {
			C.c2v_strcpy(unsafe { &i8(&convert[0]) }, c'Infinity')
			vallen = 8
		} else {
			fmt[0] = i8(`%`)
			fmt[1] = i8(`.`)
			fmt[2] = i8(`*`)
			fmt[3] = i8(`g`)
			fmt[4] = i8(`\0`)
			vallen = C.c2v_snprintf(&convert[0], sizeof([64]i8), unsafe { &fmt[0] }, precision, value)
			if vallen < 0 {
				target.failed = (1 != 0)
				unsafe {
					goto fail
				}
			}
		}
	}
	if signvalue {
		dopr_outch(signvalue, &target)
	}
	dostr(unsafe { &i8(&convert[0]) }, vallen, &target)
	fail:
	unsafe { *target.bufptr = i8(`\0`) }
	return i32(if i32(target.failed) {
		i64(-1)
	} else {
		(i64((isize(target.bufptr) - isize(target.bufstart)) / isize(sizeof(i8))) + i64(target.nchars))
	})
}

@[markused]
pub fn dostr(str &i8, slen i32, target &PrintfTarget) {
	if slen == 1 {
		dopr_outch(i32((unsafe { *str })), target)
		return
	}
	for slen > 0 {
		avail := i32(0)
		if usize(target.bufend) != usize((voidptr(0))) {
			avail = i32(i64((isize(target.bufend) - isize(target.bufptr)) / isize(sizeof(i8))))
		} else {
			avail = slen
		}
		if avail <= 0 {
			if usize(target.stream) == usize((voidptr(0))) {
				target.nchars += slen
				return
			}
			flushbuffer(target)
			continue
		}
		avail = (if avail < slen { avail } else { slen })
		C.c2v_memmove(voidptr(target.bufptr), voidptr(str), u64(avail))
		c2v_pointer_prefix(voidptr(&target.bufptr), target.bufptr, isize(avail))
		c2v_pointer_prefix(voidptr(&str), str, isize(avail))
		slen -= avail
	}
}

@[markused]
pub fn dopr_outch(c i32, target &PrintfTarget) {
	if usize(target.bufend) != usize((voidptr(0))) && usize(target.bufptr) >= usize(target.bufend) {
		if usize(target.stream) == usize((voidptr(0))) {
			target.nchars++
			return
		}
		flushbuffer(target)
	}
	mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_postfix(voidptr(&target.bufptr), target.bufptr, isize(1)) }
	unsafe { *__c2v_lhs_tmp_0 = i8(c) }
}

@[markused]
pub fn dopr_outchmulti(c i32, slen i32, target &PrintfTarget) {
	if slen == 1 {
		dopr_outch(c, target)
		return
	}
	for slen > 0 {
		avail := i32(0)
		if usize(target.bufend) != usize((voidptr(0))) {
			avail = i32(i64((isize(target.bufend) - isize(target.bufptr)) / isize(sizeof(i8))))
		} else {
			avail = slen
		}
		if avail <= 0 {
			if usize(target.stream) == usize((voidptr(0))) {
				target.nchars += slen
				return
			}
			flushbuffer(target)
			continue
		}
		avail = (if avail < slen { avail } else { slen })
		C.c2v_memset(voidptr(target.bufptr), c, u64(avail))
		c2v_pointer_prefix(voidptr(&target.bufptr), target.bufptr, isize(avail))
		slen -= avail
	}
}

@[markused]
pub fn adjust_sign(is_negative i32, forcesign i32, signvalue &i32) i32 {
	if is_negative {
		unsafe { *signvalue = `-` }
		return 1
	} else if forcesign {
		unsafe { *signvalue = `+` }
	}
	return 0
}

@[markused]
pub fn compute_padlen(minlen i32, vallen i32, leftjust i32) i32 {
	padlen := i32(0)
	padlen = minlen - vallen
	if padlen < 0 {
		padlen = 0
	}
	if leftjust {
		padlen = -padlen
	}
	return padlen
}

@[markused]
pub fn leading_pad(zpad i32, signvalue i32, padlen &i32, target &PrintfTarget) {
	maxpad := i32(0)
	if (unsafe { *padlen }) > 0 && zpad {
		if signvalue {
			dopr_outch(signvalue, target)
			unsafe { (*padlen)-- }
			signvalue = 0
		}
		if (unsafe { *padlen }) > 0 {
			dopr_outchmulti(zpad, (unsafe { *padlen }), target)
			unsafe { *padlen = 0 }
		}
	}
	maxpad = (signvalue != 0)
	if (unsafe { *padlen }) > maxpad {
		dopr_outchmulti(` `, (unsafe { *padlen }) - maxpad, target)
		unsafe { *padlen = maxpad }
	}
	if signvalue {
		dopr_outch(signvalue, target)
		if (unsafe { *padlen }) > 0 {
			unsafe { (*padlen)-- }
		} else if (unsafe { *padlen }) < 0 {
			unsafe { (*padlen)++ }
		}
	}
}

@[markused]
pub fn trailing_pad(padlen i32, target &PrintfTarget) {
	if padlen < 0 {
		dopr_outchmulti(` `, -padlen, target)
	}
}
