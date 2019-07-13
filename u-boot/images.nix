# Needs to be built on x86-64 host, due to some build tools being checked-in x86-64 binaries...

{ stdenv, ubootEspressobin, armTrustedFirmwareEspressobin, a3700UtilsEspressobin, buildPackages }:

stdenv.mkDerivation {
  name = "espressobin-u-boot-images";

  phases = [ "buildPhase" "installPhase" ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
    buildPackages.openssl
    buildPackages.which
  ];

  buildPhase = ''
    export BL33=${ubootEspressobin}/u-boot.bin

    cp -r ${armTrustedFirmwareEspressobin} atf-marvell
    cp -r ${a3700UtilsEspressobin} A3700-utils-marvell

    chmod -R 755 atf-marvell A3700-utils-marvell

    # A3700-utils has some scripts it wants to run.
    patchShebangs A3700-utils-marvell

    # But a Perl script doesn't get patched.
    # Also it assumes cp is in /bin/cp, which is wrong on NixOS.
    substituteInPlace A3700-utils-marvell/ddr/tim_ddr/ddrparser.pl \
      --replace "/usr/bin/perl" "${buildPackages.perl}/bin/perl" \
      --replace "/bin/cp" "cp"

    # There are some binary tools in there that we have to patch.
    # Since we're cross-compiling on x86-86 to aarch64, we need to use the host's
    # CC to get the interpreter (can't use NIX_CC because its aarch64).
    ${buildPackages.patchelf}/bin/patchelf --set-interpreter $(cat ${buildPackages.stdenv.cc}/nix-support/dynamic-linker) \
      A3700-utils-marvell/ddr/tim_ddr/ddr3_tool
    ${buildPackages.patchelf}/bin/patchelf --set-interpreter $(cat ${buildPackages.stdenv.cc}/nix-support/dynamic-linker) \
      A3700-utils-marvell/ddr/tim_ddr/ddr4_tool

    cd atf-marvell

    export CROSS_COMPILE=aarch64-unknown-linux-gnu-

    # Can't link something without this.
    export CFLAGS=-fno-stack-protector

    # Needed to build WTMI binary, see
    # http://wiki.espressobin.net/tiki-index.php?page=Build+From+Source+-+Bootloader#Build_U-Boot
    export CROSS_CM3=${buildPackages.gcc-arm-embedded}/bin/arm-none-eabi-

    # SPINOR ESPRESSObin DDR4 1CS 1GB
    make DEBUG=1 USE_COHERENT_MEM=0 LOG_LEVEL=20 SECURE=0 CLOCKSPRESET=CPU_1000_DDR_800 DDR_TOPOLOGY=5 BOOTDEV=SPINOR PARTNUM=0 WTP=../A3700-utils-marvell PLAT=a3700 all fip
  '';

  installPhase = ''
    mkdir -p $out
    cp -r build/a3700/debug/{flash-image.bin,uart-images} $out
  '';

  meta = with stdenv.lib; {
    maintainers = [ maintainers.mirrexagon ];
    # ?
    license = licenses.unfreeRedistributableFirmware;
  };
}
