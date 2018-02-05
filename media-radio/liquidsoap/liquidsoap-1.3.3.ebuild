# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools findlib python-single-r1 systemd tmpfiles user

DESCRIPTION="A swiss-army knife for multimedia streaming, used for netradios and webtvs"
HOMEPAGE="http://liquidsoap.fm/"
SRC_URI="https://github.com/savonet/liquidsoap/releases/download/${PV}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa ao camlimages +camlp4 debug dssi faad fdk festival ffmpeg flac frei0r gavl \
	gd graphics gstreamer gui inotify jack json ladspa lame lastfm libsamplerate \
	mad magic +ocamlopt ogg osc opus oss portaudio profiling pulseaudio sdl shine \
	shout soundtouch speex ssl systemd taglib theora +unicode vorbis xml"
RDEPEND="app-admin/logrotate
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/ocaml-dtools:=[ocamlopt?]
	dev-ml/ocaml-duppy:=[camlp4?,ocamlopt?]
	dev-ml/ocaml-mm:=[ocamlopt?]
	dev-ml/pcre-ocaml:=[ocamlopt?]
	net-misc/curl
	alsa? ( dev-ml/ocaml-alsa:=[ocamlopt?] )
	ao? ( dev-ml/ocaml-ao:=[ocamlopt?] )
	camlimages? ( dev-ml/camlimages:= )
	camlp4? ( dev-ml/camlp4:= )
	dssi? ( dev-ml/ocaml-dssi:=[ocamlopt?] )
	faad? ( dev-ml/ocaml-faad:=[ocamlopt?] )
	fdk? ( dev-ml/ocaml-fdkaac:=[ocamlopt?] )
	festival? ( app-accessibility/festival:= )
	ffmpeg? ( dev-ml/ocmal-ffmpeg:=[ocamlopt?] )
	flac? ( dev-ml/ocaml-flac:=[ocamlopt?,ogg?] )
	frei0r? ( dev-ml/ocaml-frei0r:=[ocamlopt?] )
	gavl? ( dev-ml/ocaml-gavl:=[ocamlopt?] )
	gd? ( dev-ml/gd4o:=[ocamlopt?]
		media-fonts/dejavu )
	gstreamer? ( dev-ml/ocaml-gstreamer:=[ocamlopt?] )
	gui? ( dev-python/pygtk:2[${PYTHON_USEDEP}] )
	inotify? ( dev-ml/ocaml-inotify:=[ocamlopt?] )
	jack? ( dev-ml/ocaml-bjack:=[ocamlopt?] )
	json? ( dev-ml/yojson:= )
	ladspa? ( dev-ml/ocaml-ladspa:=[ocamlopt?] )
	lame? ( dev-ml/ocaml-lame:=[ocamlopt?] )
	lastfm? ( dev-ml/ocaml-lastfm:=[ocamlopt?] )
	libsamplerate? ( dev-ml/ocaml-samplerate:=[ocamlopt?] )
	mad? ( dev-ml/ocaml-mad:=[ocamlopt?] )
	magic? ( dev-ml/ocaml-magic:= )
	ogg? ( dev-ml/ocaml-ogg:=[ocamlopt?] )
	opus? ( dev-ml/ocaml-opus:=[ocamlopt?] )
	osc? ( dev-ml/ocaml-lo:=[ocamlopt?] )
	portaudio? ( dev-ml/ocaml-portaudio:=[ocamlopt?] )
	pulseaudio? ( dev-ml/ocaml-pulseaudio:=[ocamlopt?] )
	sdl? ( dev-ml/ocamlsdl:=[ocamlopt?]
		media-fonts/dejavu )
	shine? ( dev-ml/ocaml-shine:=[ocamlopt?] )
	shout? ( dev-ml/ocaml-cry:=[ocamlopt?] )
	soundtouch? ( dev-ml/ocaml-soundtouch:=[ocamlopt?] )
	speex? ( dev-ml/ocaml-speex:=[ocamlopt?] )
	ssl? ( dev-ml/ocaml-ssl:= )
	taglib? ( dev-ml/ocaml-taglib:=[ocamlopt?] )
	theora? ( dev-ml/ocaml-theora:=[ocamlopt?] )
	unicode? ( dev-ml/camomile:=[ocamlopt?] )
	vorbis? ( dev-ml/ocaml-vorbis:=[ocamlopt?] )
	xml? ( dev-ml/ocaml-xmlplaylist:=[ocamlopt?] )"
DEPEND="${RDEPEND}
	dev-ml/findlib
	virtual/pkgconfig"
DOCS=( CHANGES README )
REQUIRED_USE="flac? ( ogg ) lastfm? ( xml ) opus? ( ogg ) speex? ( ogg ) theora? ( ogg ) vorbis? ( ogg ) ${PYTHON_REQUIRED_USE}"
PATCHES=( "${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-makefile-defs.patch )

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_prepare() {
	default

	sed -i 's/AC_CHECK_TOOL_STRICT/AC_CHECK_TOOL/g' m4/ocaml.m4 \
		|| die "sed failed for m4/ocaml.m4"
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf --disable-optimize \
		--with-default-font=/usr/share/fonts/dejavu/DejaVuSans.ttf \
		--disable-osx-secure-transport \
		--disable-winsvc \
		$(use_enable alsa) \
		$(use_enable ao) \
		$(use_enable camlimages) \
		$(use_enable camlp4) \
		$(use_enable debug debugging) \
		$(use_enable dssi) \
		$(use_enable faad) \
		$(use_enable fdk fdkaac) \
		$(use_enable ffmpeg) \
		$(use_enable flac) \
		$(use_enable frei0r) \
		$(use_enable gavl) \
		$(use_enable gd) \
		$(use_enable graphics) \
		$(use_enable gstreamer) \
		$(use_enable gui) \
		$(use_enable inotify) \
		$(use_enable jack bjack) \
		$(use_enable json yojson) \
		$(use_enable ladspa) \
		$(use_enable lame) \
		$(use_enable lastfm) \
		$(use_enable libsamplerate samplerate) \
		$(use_enable mad) \
		$(use_enable magic) \
		$(use_enable ocamlopt nativecode) \
		$(use_enable ogg) \
		$(use_enable opus) \
		$(use_enable osc lo) \
		$(use_enable oss) \
		$(use_enable portaudio) \
		$(use_enable pulseaudio) \
		$(use_enable profiling) \
		$(use_enable sdl) \
		$(use_enable shine) \
		$(use_enable shout cry) \
		$(use_enable soundtouch) \
		$(use_enable speex) \
		$(use_enable ssl) \
		$(use_enable taglib) \
		$(use_enable theora) \
		$(use_enable unicode camomile) \
		$(use_enable vorbis) \
		$(use_enable xml xmlplaylist)
}

src_install() {
	findlib_src_install

	newtmpfiles "${FILESDIR}"/${PN}.tmpfile ${PN}.conf
	use systemd || newinitd "${FILESDIR}"/${PN}.initd ${PN}
	use systemd && systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf

	elog "You have to create an init script for each stream:"
	elog "ln -s liquidsoap /etc/init.d/liquidsoap.<stream>"
	elog "where script refers to /etc/liquidsoap/<stream>.liq"
}
