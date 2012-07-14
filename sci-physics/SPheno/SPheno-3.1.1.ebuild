# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit toolchain-funcs eutils

MY_P="${PN}${PV}"
S="${WORKDIR}/${MY_P}"

MY_WEBROOT="http://www.physik.uni-wuerzburg.de/~porod/"

DESCRIPTION="SUSY spectrum and decay calculator"
HOMEPAGE="${MY_WEBROOT}${PN}.html"
SRC_URI="${MY_WEBROOT}code/${MY_P}.tar.gz
		doc? ( ${MY_WEBROOT}doc/${PN}.pdf
				${MY_WEBROOT}doc/${PN}3.pdf )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	tc-getFC || die "Fortran compiler is required"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}_gfortran.patch"
}


src_compile() {
	emake || die "emake failed"
}


src_install() {
	dobin bin/SPheno
	dodoc README
	if use doc; then
		dodoc "${DISTDIR}/${PN}.pdf"
		dodoc "${DISTDIR}/${PN}3.pdf"
	fi
}
