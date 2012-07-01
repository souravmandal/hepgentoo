# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit toolchain-funcs eutils

MY_PN="Herwig++"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Event generator based on ThePEG, writen in C++."
HOMEPAGE="http://projects.hepforge.org/herwig/"
SRC_URI="http://www.hepforge.org/archive/herwig/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc latex"

# Include fastjet when there' an ebuild?
DEPEND="dev-lang/perl
		sci-libs/gsl
		>=sci-physics/ThePEG-1.7.0
		doc? ( >=app-doc/doxygen-1.7.3[latex?] )"
RDEPEND="${DEPEND}"

pkg_setup() {
	tc-getFC || die "gfortran is required"
}

src_prepare() {
	epatch "${FILESDIR}/${P}_PDF-destdir-fix.patch"
}

src_configure() {
	econf --with-thepeg=/usr || die "econf failed"
}

src_compile() {
	emake || die "emake failed"

	# Docs
	if use doc; then
		cd Doc
		make html || die "failed to make HTML manual"
		if use latex; then
			make pdf || die "failed to make PDF manual"
		fi
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog GUIDELINES NEWS README
}


