{ stdenv, fetchFromGitHub, ubootEspressobin, buildPackages }:

let
  arm-trusted-firmware = fetchFromGitHub {
    # License: BSD 3-clause
    owner = "Arm-software";
    repo = "arm-trusted-firmware";
    rev = "v2.3";
    sha256 = "0ldiak6x7agdfqkx0x8zz96653kg9pjsahjnxl3159xa66b4fn2l";
  };

  a3700-utils-marvell = fetchFromGitHub {
    # License: BSD 3-clause
    owner = "MarvellEmbeddedProcessors";
    repo = "A3700-utils-marvell";
    rev = "096797908ddd69a679fd55595c41fc02809829a9";
    sha256 = "0z783ycy8h3vvlr5w5vi39fk608ljnik647ipj0s4z8klqllpyan";
  };

  mv-ddr-marvell = fetchFromGitHub {
    # License: GPL 2 or later
    owner = "MarvellEmbeddedProcessors";
    repo = "mv-ddr-marvell";
    rev = "a881467ef0f0185e6570dd0483023fde93cbb5f5";
    sha256 = "0zj4xg6cmlq13yy2h68z4jxsq6vr7wz5ljm15f26g3cawq7545xq";
  };
in stdenv.mkDerivation rec {
  name = "espressobin-u-boot-images-${version}";
  version = "2020.10-rc4";

  phases = [ "buildPhase" "installPhase" ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
    buildPackages.openssl
    buildPackages.which
    buildPackages.cryptopp
  ];

  # https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/plat/marvell/armada/build.rst
  # https://github.com/dhewg/openwrt/blob/3686395eadc12457d9555b3f03e5672a56997120/package/boot/arm-trusted-firmware-mvebu/Makefile
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
      # TODO: Remove -j16
      make -j16  -f TBB_linux.mak LIBDIR=${buildPackages.cryptopp}/include/cryptopp
      cp release/TBB_linux ../../linux/tbb_linux
    popd >/dev/null

    pushd A3700-utils-marvell/wtptp/src/Wtpdownloader_Linux >/dev/null
      # TODO: Remove -j16
      make -j16 -f makefile.mk
      cp WtpDownload_linux ../../linux
    popd >/dev/null

    # Now for the actual boot image build.
    pushd arm-trusted-firmware >/dev/null
      export CROSS_COMPILE=aarch64-unknown-linux-gnu-
      export BL33=${ubootEspressobin}/u-boot.bin

      # Can't link something without this.
      export CFLAGS=-fno-stack-protector

      # Needed to build WTMI binary.
      export CROSS_CM3=${buildPackages.gcc-arm-embedded}/bin/arm-none-eabi-

      # DDR_TOPOLOGY=5 is DDR4 1CS 1GB.
      make \
        DEBUG=1 \
        USE_COHERENT_MEM=0 \
        LOG_LEVEL=50 \
        SECURE=0 \
        CLOCKSPRESET=CPU_800_DDR_800 \
        DDR_TOPOLOGY=5 \
        BOOTDEV=SPINOR \
        PARTNUM=0 \
        PLAT=a3700 \
        WTP=$(pwd)/../A3700-utils-marvell \
        MV_DDR_PATH=$(pwd)/../mv-ddr-marvell \
        all fip
    popd >/dev/null
  '';

  installPhase = ''
    mkdir $out
    cp -r arm-trusted-firmware/build/a3700/debug/{flash-image.bin,uart-images} $out

    mkdir $out/bin
    cp A3700-utils-marvell/wtptp/linux/WtpDownload_linux $out/bin
  '';

  meta = with stdenv.lib; {
    maintainers = [ maintainers.mirrexagon ];

    # TODO: Expects to be cross-compiled, given we set the CROSS_COMPILE variable.
    # Also uses 32-bit ARM gcc. What should the platforms be?
    platforms = [ "aarch64-linux" ];

    # TODO: Figure out if this should be something more free.
    license = licenses.unfreeRedistributableFirmware;
  };
}
