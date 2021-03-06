# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit vcs-snapshot java-pkg-2 java-pkg-simple

DESCRIPTION="Native JNI component for dev-java/jansi"
HOMEPAGE="http://jansi.fusesource.org/"
SRC_URI="https://github.com/fusesource/${PN}/tarball/${P} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

CDEPEND="dev-java/hawtjni-runtime:0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8"

S="${WORKDIR}/${P}/src"

JAVA_SRC_DIR="main/java"
JAVA_GENTOO_CLASSPATH="hawtjni-runtime"

src_install() {
	java-pkg-simple_src_install

	dodoc ../{changelog,readme}.md
}
