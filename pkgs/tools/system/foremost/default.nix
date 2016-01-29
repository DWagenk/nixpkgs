{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "foremost-${version}";
  version = "1.5.7";

  src = fetchurl {
    sha256 = "0d2zxw0ijg8cd3ksgm8cf8jg128zr5x7z779jar90g9f47pm882h";
    url = "http://foremost.sourceforge.net/pkg/${name}.tar.gz";
  };

  patches = [ ./makefile.patch ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/{bin,share/man/man8}
  '';

  meta = with stdenv.lib; {
    description = "Recover files based on their contents";
    longDescription = ''
      Foremost is a console program to recover files based on their headers,
      footers, and internal data structures. Foremost can work on image files, such
      as those generated by dd, Safeback, Encase, etc, or directly on a drive.
      The headers and footers can be specified by a configuration file or you can
      use command line switches to specify built-in file types. These built-in types
      look at the data structures of a given file format allowing for a more
      reliable and faster recovery.
    '';
    homepage = http://foremost.sourceforge.net/;
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
