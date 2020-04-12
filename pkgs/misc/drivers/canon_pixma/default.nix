{ stdenv, fetchFromGitHub,
gettext, pkgconfig, glib, autoconf, automake, autoreconfHook, autoconf-archive,
gtk2, sane-backends, libusb1, libjpeg, libtool}:

stdenv.mkDerivation rec {
  pname = "canon_pixma";
  version = "3.90";

  src = fetchFromGitHub{
    owner = "Ordissimo";
    repo = "scangearmp2";
    rev = "8936d155b70b5db2a26e4bba12358b8638eee1d6";
    sha256 = "1zx8nh4s8a6cc9qgxg2nmxvlczj92rhm3dx3qj3af2cn316a6dk1";
  };

  nativeBuildInputs = [
    glib
    autoconf
    automake
    autoreconfHook
    gettext
    autoconf-archive
    pkgconfig
    libtool
  ];

  buildInputs = [
    gtk2
    sane-backends
    libusb1.dev
    libjpeg.dev
  ];

  sourceRoot = "source/scangearmp2";

   autoreconfPhase = ''
     ./autogen.sh
   '';

  preBuild = ''
    mkdir -p $out/lib/
    cp ../com/libs_bin64/* $out/lib/
  '';

  NIX_LDFLAGS = "-L$out/lib/";

  installFlags = [ "SANE_BACKENDDIR=${placeholder "out"}/lib/sane" ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  meta = with stdenv.lib; {
    description = "SANE canon_pixma backend CANON Inkjet/Scanner multi-purpose devices";
    longDescription = ''
      SANE backend for CANON Inkjet/Scanner multi-purpose devices
      To use the SANE backend, in
      <literal>/etc/nixos/configuration.nix</literal>:

      <literal>
      hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.canon_pixma ];
      };
      </literal>
    '';

    homepage = "https://github.com/Ordissimo/scangearmp2";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dwagenk ];
    platforms = platforms.linux;
  };
}
