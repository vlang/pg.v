@[translated]
module libpq

@[export: 'pg_strerror']
@[markused]
pub fn pg_strerror(errnum int) &i8 {
	return pg_strerror_r(errnum, unsafe { &i8(&pg_strerror_errorstr_buf[0]) }, sizeof([256]i8))
}

@[export: 'pg_strerror_r']
@[markused]
pub fn pg_strerror_r(errnum int, buf &i8, buflen usize) &i8 {
	str := &i8(0)
	str = gnuish_strerror_r(errnum, buf, buflen)
	if usize(str) == usize((voidptr(0))) || int((unsafe { *str })) == i8(`\0`) || int((unsafe { *str })) == i8(`?`) {
		str = get_errno_symbol(errnum)
	}
	if usize(str) == usize((voidptr(0))) {
		pg_snprintf(buf, buflen, unsafe { &i8(&c'operating system error %d'[0]) }, errnum)
		str = buf
	}
	return str
}

@[markused]
pub fn gnuish_strerror_r(errnum int, buf &i8, buflen usize) &i8 {
	if C.c2v_strerror_r(errnum, buf, buflen) == 0 {
		return buf
	}
	return unsafe { nil }
}

@[markused]
pub fn get_errno_symbol(errnum int) &i8 {
	match errnum {
		7 {
			return unsafe { &i8(&c'E2BIG'[0]) }
		}
		13 {
			return unsafe { &i8(&c'EACCES'[0]) }
		}
		48 {
			return unsafe { &i8(&c'EADDRINUSE'[0]) }
		}
		49 {
			return unsafe { &i8(&c'EADDRNOTAVAIL'[0]) }
		}
		47 {
			return unsafe { &i8(&c'EAFNOSUPPORT'[0]) }
		}
		35 {
			return unsafe { &i8(&c'EAGAIN'[0]) }
		}
		37 {
			return unsafe { &i8(&c'EALREADY'[0]) }
		}
		9 {
			return unsafe { &i8(&c'EBADF'[0]) }
		}
		94 {
			return unsafe { &i8(&c'EBADMSG'[0]) }
		}
		16 {
			return unsafe { &i8(&c'EBUSY'[0]) }
		}
		10 {
			return unsafe { &i8(&c'ECHILD'[0]) }
		}
		53 {
			return unsafe { &i8(&c'ECONNABORTED'[0]) }
		}
		61 {
			return unsafe { &i8(&c'ECONNREFUSED'[0]) }
		}
		54 {
			return unsafe { &i8(&c'ECONNRESET'[0]) }
		}
		11 {
			return unsafe { &i8(&c'EDEADLK'[0]) }
		}
		33 {
			return unsafe { &i8(&c'EDOM'[0]) }
		}
		17 {
			return unsafe { &i8(&c'EEXIST'[0]) }
		}
		14 {
			return unsafe { &i8(&c'EFAULT'[0]) }
		}
		27 {
			return unsafe { &i8(&c'EFBIG'[0]) }
		}
		64 {
			return unsafe { &i8(&c'EHOSTDOWN'[0]) }
		}
		65 {
			return unsafe { &i8(&c'EHOSTUNREACH'[0]) }
		}
		90 {
			return unsafe { &i8(&c'EIDRM'[0]) }
		}
		36 {
			return unsafe { &i8(&c'EINPROGRESS'[0]) }
		}
		4 {
			return unsafe { &i8(&c'EINTR'[0]) }
		}
		22 {
			return unsafe { &i8(&c'EINVAL'[0]) }
		}
		5 {
			return unsafe { &i8(&c'EIO'[0]) }
		}
		56 {
			return unsafe { &i8(&c'EISCONN'[0]) }
		}
		21 {
			return unsafe { &i8(&c'EISDIR'[0]) }
		}
		62 {
			return unsafe { &i8(&c'ELOOP'[0]) }
		}
		24 {
			return unsafe { &i8(&c'EMFILE'[0]) }
		}
		31 {
			return unsafe { &i8(&c'EMLINK'[0]) }
		}
		40 {
			return unsafe { &i8(&c'EMSGSIZE'[0]) }
		}
		63 {
			return unsafe { &i8(&c'ENAMETOOLONG'[0]) }
		}
		50 {
			return unsafe { &i8(&c'ENETDOWN'[0]) }
		}
		52 {
			return unsafe { &i8(&c'ENETRESET'[0]) }
		}
		51 {
			return unsafe { &i8(&c'ENETUNREACH'[0]) }
		}
		23 {
			return unsafe { &i8(&c'ENFILE'[0]) }
		}
		55 {
			return unsafe { &i8(&c'ENOBUFS'[0]) }
		}
		19 {
			return unsafe { &i8(&c'ENODEV'[0]) }
		}
		2 {
			return unsafe { &i8(&c'ENOENT'[0]) }
		}
		8 {
			return unsafe { &i8(&c'ENOEXEC'[0]) }
		}
		12 {
			return unsafe { &i8(&c'ENOMEM'[0]) }
		}
		28 {
			return unsafe { &i8(&c'ENOSPC'[0]) }
		}
		78 {
			return unsafe { &i8(&c'ENOSYS'[0]) }
		}
		57 {
			return unsafe { &i8(&c'ENOTCONN'[0]) }
		}
		20 {
			return unsafe { &i8(&c'ENOTDIR'[0]) }
		}
		66 {
			return unsafe { &i8(&c'ENOTEMPTY'[0]) }
		}
		38 {
			return unsafe { &i8(&c'ENOTSOCK'[0]) }
		}
		45 {
			return unsafe { &i8(&c'ENOTSUP'[0]) }
		}
		25 {
			return unsafe { &i8(&c'ENOTTY'[0]) }
		}
		6 {
			return unsafe { &i8(&c'ENXIO'[0]) }
		}
		102 {
			return unsafe { &i8(&c'EOPNOTSUPP'[0]) }
		}
		84 {
			return unsafe { &i8(&c'EOVERFLOW'[0]) }
		}
		1 {
			return unsafe { &i8(&c'EPERM'[0]) }
		}
		32 {
			return unsafe { &i8(&c'EPIPE'[0]) }
		}
		43 {
			return unsafe { &i8(&c'EPROTONOSUPPORT'[0]) }
		}
		34 {
			return unsafe { &i8(&c'ERANGE'[0]) }
		}
		30 {
			return unsafe { &i8(&c'EROFS'[0]) }
		}
		3 {
			return unsafe { &i8(&c'ESRCH'[0]) }
		}
		60 {
			return unsafe { &i8(&c'ETIMEDOUT'[0]) }
		}
		26 {
			return unsafe { &i8(&c'ETXTBSY'[0]) }
		}
		18 {
			return unsafe { &i8(&c'EXDEV'[0]) }
		}
		else {}
	}

	return unsafe { nil }
}
