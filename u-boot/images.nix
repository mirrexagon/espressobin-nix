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

    substituteInPlace A3700-utils-marvell/script/getddrparams.sh \
      --replace "/bin/bash" "${buildPackages.bash}/bin/bash"

    cd atf-marvell

    export CROSS_COMPILE=aarch64-unknown-linux-gnu-

    # Can't link bl1 without this.
    export CFLAGS=-fno-stack-protector

    # Needed to build WTMI binary, see
    # http://wiki.espressobin.net/tiki-index.php?page=Build+From+Source+-+Bootloader#Build_U-Boot
    export CROSS_CM3=${buildPackages.gcc-arm-embedded}/bin/arm-none-eabi-

    # SPINOR ESPRESSObin DDR4 1CS 1GB
    make DEBUG=1 USE_COHERENT_MEM=0 LOG_LEVEL=20 SECURE=0 CLOCKSPRESET=CPU_1000_DDR_800 DDR_TOPOLOGY=5 BOOTDEV=SPINOR PARTNUM=0 WTP=../A3700-utils-marvell/ PLAT=a3700 all fip
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
