# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Package for calculating one-loop integrals"
HOMEPAGE="http://www.feynarts.de/looptools/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare(){
	epatch "${FILESDIR}/${P}_destdir.patch" 
}

src_configure() {
	./configure --prefix=/usr
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc manual/*.pdf
	
	# Keep revdep-rebuild from complaining about missing Mathematica lib
	insinto /etc/revdep-rebuild && doins "${FILESDIR}/99LoopTools"
}
