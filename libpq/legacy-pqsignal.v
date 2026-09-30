@[translated]
module libpq

pub fn c2v_fn_sigaction(a0 int, a1 &C.sigaction, a2 &C.sigaction) int {
	return C.c2v_sigaction(a0, a1, a2)
}

pub type C2vFn_666e2028696e7429 = fn (int)

@[export: 'pqsignal']
@[markused]
pub fn pqsignal(signo int, func Pqsigfunc) Pqsigfunc {
	act := C.sigaction{}
	oact := C.sigaction{}

	act.__sigaction_u.__sa_handler = func
	mut __c2v_lhs_tmp_0 := unsafe { &act.sa_mask }
	unsafe { *__c2v_lhs_tmp_0 = u32(0) }
	0
	act.sa_flags = 0
	if signo != 14 {
		act.sa_flags |= 2
	}
	if signo == 20 {
		act.sa_flags |= 8
	}
	if c2v_fn_sigaction(signo, &act, &oact) < 0 {
		return C2vFn_666e2028696e7429(voidptr(-1))
	}
	return oact.__sigaction_u.__sa_handler
}
