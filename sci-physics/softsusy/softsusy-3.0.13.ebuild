# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Provides a SUSY spectrum in the MSSM."
HOMEPAGE="http://projects.hepforge.org/softsusy/"
SRC_URI="http://www.hepforge.org/archive/${PN}/${P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README outputTest rpvOutputTest 
	dodoc lesHouchesInput lesHouchesOutput 
	dodoc rpvHouchesInput rpvHouchesOutput
	dodoc slha2Input slha2Output 
}

pkg_postinst() {
	einfo "For twoloophiggs, install a fortran compiler and rebuild."
	einfo ""
	einfo "For usage documentation, see homepage."
	einfo ""
}

