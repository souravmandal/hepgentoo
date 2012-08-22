# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils 

DESCRIPTION="A numerical package for dark matter calculations in the MSSM."
HOMEPAGE="http://www.physto.se/~edsjo/darksusy/"
SRC_URI="${HOMEPAGE}/tars/${P}.tar.gz"

LICENSE="as-is GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="virtual/fortran
		dev-lang/perl
		doc? ( dev-texlive/texlive-latex
				dev-tex/latex2html[png] )"
RDEPEND=""

src_unpack() {
	unpack "${A}"
	epatch "${FILESDIR}/${P}-galprop_includes.patch"
	epatch "${FILESDIR}/${P}-higgsbounds_tables.patch"
}

# Compilers supported by darksusy:
# gfortran g77 ifc
src_compile() {
	# Determine compiler to be used, set options, and configure
	# (options read from compiler-specific configure scripts)
	FC=${FC:-gfortran}
	case "${FC}" in 
		gfortran)
			einfo "Using gfortran"
			./configure --prefix="/usr" \
				F77="gfortran" FFLAGS="" FOPT="-O -ffixed-line-length-none"
			;;
		g77)
			einfo "Using g77"
			./configure --prefix="/usr"
			;;
		ifc)
			einfo "Using ifort"
			./configure --prefix="/usr" \
				F77="ifort" FFLAGS="" FOPT="-O -extend_source"
			;;
		*)
			die "No supported Fortran compiler installed!"
			;;
	esac
	# Make
	emake || die emake failed
	if use doc; then
		emake pdf-manual || die emake pdf-manual failed
		emake html-manual || die emake html-manual failed
	fi
}

src_install() {
	emake DS_INSTALL="${D}/usr" install || die "emake install failed"
	dodoc HISTORY README.* 
	if use doc; then
		cp -rv ./test "${D}/usr/share/doc/${P}/"
		cp -v docs/Manual.pdf "${D}/usr/share/doc/${P}/"
		cp -rv docs/Manual "${D}/usr/share/doc/${P}/"
	fi
}
