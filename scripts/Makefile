INSTALL ?= install

install: mount.snapshot umount.snapshot ovlsnapshot
	${INSTALL} -d ${DESTDIR}/sbin
	${INSTALL} -m 755 mount.snapshot ${DESTDIR}/sbin
	${INSTALL} -m 755 umount.snapshot ${DESTDIR}/sbin
	${INSTALL} -m 755 ovlsnapshot ${DESTDIR}/sbin

