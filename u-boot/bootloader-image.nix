# References:
# https://github.com/dhewg/openwrt/blob/d31783329b7ccf23d1c084873f1ff084267df4c3/package/boot/arm-trusted-firmware-mvebu/Makefile
# https://github.com/ARM-software/arm-trusted-firmware/blob/v2.4/docs/plat/marvell/armada/build.rst

# TODO:
# - https://github.com/dhewg/openwrt/blob/master/package/boot/arm-trusted-firmware-mvebu/Makefile
# - https://github.com/turris-cz/mox-boot-builder

{ stdenv, lib, fetchFromGitHub, ubootEspressobin, buildPackages, boardName, ddrTopology }:

assert ddrTopology == 0 # ESPRESSObin 512 MB
  || ddrTopology == 2 # ESPRESSObin V3-V5 1 GB, two memory chips (2CS)
  || ddrTopology == 4 # ESPRESSObin V3-V5 1 GB, single memory chip (1CS)
  || ddrTopology == 5 # ESPRESSObin V7 1 GB
  || ddrTopology == 6 # ESPRESSObin V7 2 GB
  || ddrTopology == 7; # ESPRESSObin V3-V5 2 GB

let
  arm-trusted-firmware = fetchFromGitHub {
    # License: BSD 3-clause
    owner = "Arm-software";
    repo = "arm-trusted-firmware";
    rev = "v2.11.0";
    sha256 = "sha256-sXJkpJ/uJ1esCv7zMP3mu9DrMb1jHJg6xd0dnD/CB84=";
  };

  a3700-utils-marvell = fetchFromGitHub {
    # License: BSD 3-clause
    owner = "MarvellEmbeddedProcessors";
    repo = "A3700-utils-marvell";
    rev = "a3e1c67bb378e1d8a938e1b826cb602af83628d2";
    sha256 = "sha256-pidCdPllGrkpQuyy+96kcjFwi6N7974AyHnqAljXLBs=";
  };

  mv-ddr-marvell = fetchFromGitHub {
    # License: GPL 2 or later
    owner = "MarvellEmbeddedProcessors";
    repo = "mv-ddr-marvell";
    rev = "4a3dc0909b64fac119d4ffa77840267b540b17ba";
    sha256 = "sha256-atsj0FCEkMLfnABsaJZGHKO0ZKad19jsKAkz39fIcFY=";
  };
in
stdenv.mkDerivation rec {
  name = "espressobin-u-boot-images-${version}-${boardName}";
  version = ubootEspressobin.version;

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

      make \
        CROSS_CM3=${buildPackages.gcc-arm-embedded}/bin/arm-none-eabi- \
        BL33=${ubootEspressobin}/u-boot.bin \
        CLOCKSPRESET=CPU_1000_DDR_800 \
        DDR_TOPOLOGY=${toString ddrTopology} \
        PLAT=a3700 \
        WTP=$(pwd)/../A3700-utils-marvell \
        MV_DDR_PATH=$(pwd)/../mv-ddr-marvell \
        all mrvl_flash mrvl_uart
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
    platforms = [ "aarch64-linux" ];

    # TODO: Figure out if this should be something more free.
    license = licenses.unfreeRedistributableFirmware;
  };
}
