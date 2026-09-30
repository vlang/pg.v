@[translated]
module libpq

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <stdarg.h>
#include <strings.h>
#include <sys/types.h>
#include <errno.h>
#include <locale.h>
#include <xlocale.h>
#include <stdbool.h>
#include <ctype.h>
#include <math.h>
#include <langinfo.h>
#include <sys/param.h>
#include <unistd.h>
#include <dlfcn.h>
#include <netdb.h>
#include <time.h>
#include <sys/time.h>
#include <pthread/pthread.h>
#include <signal.h>
#include <sys/un.h>
#include <fcntl.h>
#include <limits.h>
#include <pwd.h>
#include <sys/socket.h>
#include <sys/ucred.h>
#include <sys/stat.h>
#include <netinet/tcp.h>
#include <poll.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/file.h>

struct C.winsize {
pub mut:
	ws_row u16
	ws_col u16
	ws_xpixel u16
	ws_ypixel u16
}

struct C.tm {
pub mut:
	tm_sec int
	tm_min int
	tm_hour int
	tm_mday int
	tm_mon int
	tm_year int
	tm_wday int
	tm_yday int
	tm_isdst int
	tm_gmtoff i64
	tm_zone &i8
}

struct C.timeval {
pub mut:
	tv_sec i64
	tv_usec int
}

struct C.stat {
pub mut:
	st_dev u64
	st_mode u32
	st_nlink u16
	st_ino u64
	st_uid u32
	st_gid u32
	st_rdev u64
	st_atimespec Timespec
	st_mtimespec Timespec
	st_ctimespec Timespec
	st_birthtimespec Timespec
	st_size i64
	st_blocks i64
	st_blksize int
	st_flags u32
	st_gen u32
	st_lspare int
	st_qspare [2]i64
}

struct C.sockaddr_un {
pub mut:
	sun_len u8
	sun_family u8
	sun_path [104]i8
}

struct C.sockaddr_storage {
pub mut:
	ss_len u8
	ss_family u8
	__ss_pad1 [6]i8
	__ss_align i64
	__ss_pad2 [112]i8
}

struct C.sockaddr_in6 {
pub mut:
	sin6_len u8
	sin6_family u8
	sin6_port u16
	sin6_flowinfo u32
	sin6_addr C.in6_addr
	sin6_scope_id u32
}

struct C.in6_addr {
pub mut:
	__u6_addr C.C2vSys_in6_addr___u6_addr
}

union C.C2vSys_in6_addr___u6_addr {
pub mut:
	__u6_addr8 [16]u8
	__u6_addr16 [8]u16
	__u6_addr32 [4]u32
}

struct C.sockaddr_in {
pub mut:
	sin_len u8
	sin_family u8
	sin_port u16
	sin_addr C.in_addr
	sin_zero [8]i8
}

struct C.in_addr {
pub mut:
	s_addr u32
}

struct C.sockaddr {
pub mut:
	sa_len u8
	sa_family u8
	sa_data [14]i8
}

struct C.sigaction {
pub mut:
	__sigaction_u C.__sigaction_u
	sa_mask u32
	sa_flags int
}

union C.__sigaction_u {
pub mut:
	__sa_handler fn (int)
	__sa_sigaction fn (int, voidptr, voidptr)
}

@[typedef]
struct C.pthread_mutex_t {
pub mut:
	__sig i64
	__opaque [56]i8
}

struct C.pollfd {
pub mut:
	fd int
	events i16
	revents i16
}

struct C.passwd {
pub mut:
	pw_name &i8
	pw_passwd &i8
	pw_uid u32
	pw_gid u32
	pw_change i64
	pw_class &i8
	pw_gecos &i8
	pw_dir &i8
	pw_shell &i8
	pw_expire i64
}

struct C.lconv {
pub mut:
	decimal_point &i8
	thousands_sep &i8
	grouping &i8
	int_curr_symbol &i8
	currency_symbol &i8
	mon_decimal_point &i8
	mon_thousands_sep &i8
	mon_grouping &i8
	positive_sign &i8
	negative_sign &i8
	int_frac_digits i8
	frac_digits i8
	p_cs_precedes i8
	p_sep_by_space i8
	n_cs_precedes i8
	n_sep_by_space i8
	p_sign_posn i8
	n_sign_posn i8
	int_p_cs_precedes i8
	int_n_cs_precedes i8
	int_p_sep_by_space i8
	int_n_sep_by_space i8
	int_p_sign_posn i8
	int_n_sign_posn i8
}

struct C.addrinfo {
pub mut:
	ai_flags int
	ai_family int
	ai_socktype int
	ai_protocol int
	ai_addrlen u32
	ai_canonname &i8
	ai_addr &C.sockaddr
	ai_next &C.addrinfo
}

