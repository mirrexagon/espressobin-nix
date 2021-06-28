# References:
# https://github.com/dhewg/openwrt/blob/d31783329b7ccf23d1c084873f1ff084267df4c3/package/boot/arm-trusted-firmware-mvebu/Makefile
# https://github.com/ARM-software/arm-trusted-firmware/blob/v2.4/docs/plat/marvell/armada/build.rst

{ stdenv, lib, fetchFromGitHub, ubootEspressobin, buildPackages }:

let
  arm-trusted-firmware = fetchFromGitHub {
    # License: BSD 3-clause
    owner = "Arm-software";
    repo = "arm-trusted-firmware";
    rev = "v2.4";
    sha256 = "sha256-o9/UZ8ZTPbPlFcQ3Ay0AdhIQ6boTBc3xb8uUINOxYIo=";
  };

  a3700-utils-marvell = fetchFromGitHub {
    # License: BSD 3-clause
    owner = "MarvellEmbeddedProcessors";
    repo = "A3700-utils-marvell";
    rev = "096797908ddd69a679fd55595c41fc02809829a9";
    sha256 = "sha256-LZLOJ/TjWxQmxiepWh8YZrV3LTXEEEzW15B9m2OuvZM=";
  };

  mv-ddr-marvell = fetchFromGitHub {
    # License: GPL 2 or later
    owner = "MarvellEmbeddedProcessors";
    repo = "mv-ddr-marvell";
    rev = "6fb99002be5dec9c7f5375b074f53148dbc0739c";
    sha256 = "sha256-uyBmj5X8jL9dIV7ALt5+EdgbJET94owlShcU0kdM5Rc=";
  };
in
stdenv.mkDerivation rec {
  name = "espressobin-u-boot-images-${version}";
  version = "2021.04";

  phases = [ "buildPhase" "installPhase" ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
    buildPackages.openssl
    buildPackages.which
    buildPackages.cryptopp
  ];


  buildPhase = ''
    # The build process modifies these directories so we make copies of them
    # and make them writable.
    cp -r ${arm-trusted-firmware} arm-trusted-firmware
    cp -r ${a3700-utils-marvell} A3700-utils-marvell
    cp -r ${mv-ddr-marvell} mv-ddr-marvell
    chmod -R 755 arm-trusted-firmware A3700-utils-marvell mv-ddr-marvell

    # A3700-utils has some scripts the build process will run.
    patchShebangs A3700-utils-marvell

    # But Perl scripts don't get patched, so we do it manually.
    substituteInPlace A3700-utils-marvell/script/tim2img.pl \
      --replace "/usr/bin/perl" "${buildPackages.perl}/bin/perl"

    # There are some tools we can build, one of which we need in the build.
    # There are already checked-in binaries, but let's not use them.
    pushd A3700-utils-marvell/wtptp/src/TBB_Linux >/dev/null
      make -j$NIX_BUILD_CORES -f TBB_linux.mak LIBDIR=${buildPackages.cryptopp}/include/cryptopp
      cp release/TBB_linux ../../linux/tbb_linux
    popd >/dev/null

    pushd A3700-utils-marvell/wtptp/src/Wtpdownloader_Linux >/dev/null
      make -j$NIX_BUILD_CORES -f makefile.mk
      cp WtpDownload_linux ../../linux
    popd >/dev/null

    # Now for the actual boot image build.
    pushd arm-trusted-firmware >/dev/null

      # Can't link something without this.
      export CFLAGS=-fno-stack-protector

      # DDR_TOPOLOGY=5 is DDR4 1CS 1GB.
      # TODO: Try CPU_1000_DDR_800
      make \
        CROSS_COMPILE=aarch64-unknown-linux-gnu- \
        CROSS_CM3=${buildPackages.gcc-arm-embedded}/bin/arm-none-eabi- \
        BL33=${ubootEspressobin}/u-boot.bin \
        CLOCKSPRESET=CPU_1000_DDR_800 \
        DDR_TOPOLOGY=5 \
        PLAT=a3700 \
        WTP=$(pwd)/../A3700-utils-marvell \
        MV_DDR_PATH=$(pwd)/../mv-ddr-marvell \
        all mrvl_flash
    popd >/dev/null
  '';

  installPhase = ''
    mkdir $out
    cp -r arm-trusted-firmware/build/a3700/release/{flash-image.bin,uart-images} $out

    mkdir $out/bin
    cp A3700-utils-marvell/wtptp/linux/WtpDownload_linux $out/bin
  '';

  meta = with lib; {
    maintainers = [ maintainers.mirrexagon ];

    # TODO: Expects to be cross-compiled, given we set the CROSS_COMPILE variable.
    # Also uses 32-bit ARM gcc. What should the platforms be?
    platforms = [ "aarch64-linux" ];

    # TODO: Figure out if this should be something more free.
    license = licenses.unfreeRedistributableFirmware;
  };
}
