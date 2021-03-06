# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

PV_STRING="$(ver_cut 4-6)"
MY_PV="$(ver_cut 1-3)"
MY_PN="PhpStorm"

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/idea"
SRC_URI="https://download.jetbrains.com/webide/${MY_PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror splitdebug"
IUSE="+jbr"

DEPEND="!dev-util/${PN}:14
	!dev-util/${PN}:15"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.7:*"

S="${WORKDIR}/${MY_PN}-${PV_STRING}"

QA_PREBUILT="opt/${PN}-${MY_PV}/*"

src_prepare() {
	default

	if ! use arm ; then
		rm -v bin/fsnotifier-arm || die
	fi
	if ! use ppc64 ; then
		rm -rv lib/pty4j-native/linux/ppc64le || die
	fi
	if ! use jbr ; then
		rm -rv jbr || die
	fi
}

src_install() {
	local dir="/opt/${PN}-${MY_PV}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,inspect.sh,phpstorm.sh,printenv.py,restart.py,fsnotifier{,64}}

	if use jbr ; then
		JRE_BINARIES="jaotc java javac jdb jjs jrunscript keytool pack200 rmid rmiregistry serialver unpack200"

		if [[ -d jbr ]]; then
			for jrebin in $JRE_BINARIES; do
				fperms 755 "${dir}/jbr/bin/${jrebin}"
			done
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "PhpStorm" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
