# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Toolkit for High Energy Physics Event Generation"
HOMEPAGE="http://home.thep.lu.se/~leif/ThePEG/"
SRC_URI="http://www.hepforge.org/archive/thepeg/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc +hepmc java latex +lhapdf unitchecks +zlib"

# sys-process/time used in testing
# Do we need AIDA dependencies?
DEPEND="dev-lang/perl
		sci-libs/gsl
		sys-process/time
		doc? ( >=app-doc/doxygen-1.7.3[latex?] sci-physics/hepmc )
		hepmc? ( sci-physics/hepmc )
		java? ( virtual/jre )
		lhapdf? ( sci-physics/lhapdf )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch ${FILESDIR}/${P}_cstddef.patch
	epatch ${FILESDIR}/${P}_zlib.patch
}

# Enable Rivet in the future when there's an ebuild
src_configure() {
	econf \
		--without-rivet \
		"$(use_with java javagui )" \
		"$(use_with lhapdf LHAPDF )" \
		"$(use_enable unitchecks )" \
		"$(use_with zlib )" \
		|| die "econf failed"
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

src_test() {
	# If LHAPDF is enabled, ThePEG requires certain PDFs during testing
	# LHAPDF requires that these be installed manually
	if use lhapdf; then
		local PDFPATH="${ROOT}$(lhapdf-config --pdfsets-path)"
		local PDFS="cteq6ll cteq5l GRV98nlo MRST2001nlo"
		for pdf in ${PDFS}; do
			if [ ! -f "${PDFPATH}/${pdf}.LHgrid" -a ! -f "${PDFPATH}/${pdf}.LHpdf" ]; then
				eerror "PDF set ${pdf} not found"
				eerror "Need the sets: ${PDFS}"
				eerror "Run as root:"
				eerror "${ROOT}usr/bin/lhapdf-getdata --dest=${PDFPATH} ${PDFS}"
				die "Testing failed"
			fi
		done
	fi
	emake -j1 check
}

