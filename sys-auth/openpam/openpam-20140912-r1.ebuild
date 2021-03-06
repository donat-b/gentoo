# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

inherit multilib autotools-multilib

DESCRIPTION="Open source PAM library"
HOMEPAGE="https://www.openpam.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64-fbsd ~x86-fbsd"
IUSE="debug"

RDEPEND="!sys-libs/pam"
DEPEND="
	sys-devel/make
	dev-lang/perl"

PDEPEND="
	sys-auth/pambase"

PATCHES=(
	"${FILESDIR}/${PN}-20130907-gentoo.patch"
	"${FILESDIR}/${PN}-20130907-nbsd.patch"
	"${FILESDIR}/${PN}-20130907-module-dir.patch"
)

DOCS=( CREDITS HISTORY RELNOTES README )

src_prepare() {
	sed -i -e 's:-Werror::' "${S}/configure.ac"

	autotools-multilib_src_prepare
}

my_configure() {
	local myeconfargs=(
		--with-modules-dir=/$(get_libdir)/security
		)
	autotools-utils_src_configure
}

src_configure() {
	multilib_parallel_foreach_abi my_configure
}
