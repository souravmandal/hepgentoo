# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

MY_P="Delphes_V_${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A framework for fast simulation of a generic collider experiment."
HOMEPAGE="https://server06.fynu.ucl.ac.be/projects/delphes/wiki"
SRC_URI="https://server06.fynu.ucl.ac.be/projects/delphes/raw-attachment/wiki/WikiStart/${MY_P}.tar.gz"
RESTRICT="fetch"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

COMMON_DEPEND="sci-physics/root
			sci-physics/clhep
			sci-physics/fastjet[plugins]
			sci-physics/hepmc"
DEPEND="dev-lang/tcl
		${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

pkg_nofetch() {
	einfo "Must use HTTPS URL, and wget cannot check server's certificate"
	einfo "locally.  Therefore, please fetch source package yourself:"
	einfo
	einfo "  ${SRC_URI}"
	einfo
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-isolation.patch"
	epatch "${FILESDIR}/${PN}-dphi.patch"
	epatch "${FILESDIR}/${PN}-systemlibs.patch"
	epatch "${FILESDIR}/${PN}-subjets.patch"
	# Weird build system
	./genMakefile.tcl >| Makefile
	cp "${FILESDIR}/Makefile.arch" .
	cp Makefile Makefile.bck
	cat > Makefile << END
-include ./Makefile.arch
END
	cat Makefile.bck >> Makefile
}

src_configure() {
	true
}

src_compile() {
	cd "${S}"
	make || die "make failed"
}

src_test() {
	true
}

# TODO: compile/install FROG

src_install() {
	dobin Analysis_Ex Convertors_Only Delphes LHCO_Only Resolutions Resolutions_ATLAS Trigger_Only
	newlib.so lib/libUtilities.so libDelphesUtilities.so
	INCDIR="${D}/usr/include/Delphes"
	mkdir -pv "${INCDIR}"
	cp -rv interface "${INCDIR}/"  # This is horrible
	rm -rf "${INCDIR}/interface/.svn"  # This also sucks
	mkdir -pv "${INCDIR}/ExRootAnalysis"
	cp -v Utilities/ExRootAnalysis/interface/* "${INCDIR}/ExRootAnalysis"
	dodoc CHANGELOG CREDITS FAQ
	DOCDIR="${D}/usr/share/doc/${P}"
	cp -rv data "${DOCDIR}"
	if use examples; then
		cp -rv Examples "${DOCDIR}"
	fi
	rm -rv $(find ${DOCDIR} -name .svn -printf "%p ")
}

# Robotic downloads from arxiv.org are forbidden
# so inform user how to get manual himself
pkg_postinst() {
	einfo "Download manual here:"
	einfo "http://arxiv.org/abs/0903.2225v3"
	einfo
	einfo "Cross-ref manual with bugs here:"
	einfo
	einfo "https://server06.fynu.ucl.ac.be/projects/delphes/report"
}
