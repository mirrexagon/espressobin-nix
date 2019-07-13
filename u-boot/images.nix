{ stdenv, ubootEspressobin, armTrustedFirmwareEspressobin, a3700UtilsEspressobin }:

stdenv.mkDerivation {
  name = "espressobin-u-boot-images";

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    cp -r $armTrustedFirmwareEspressobin atf-marvell
    cp -r $a3700UtilsEspressobin a3700-utils-marvell

    cd atf-marvell

    # SPINOR ESPRESSObin DDR4 1CS 1GB
    make DEBUG=1 USE_COHERENT_MEM=0 LOG_LEVEL=20 SECURE=0 CLOCKSPRESET=CPU_1000_DDR_800 DDR_TOPOLOGY=5 BOOTDEV=SPINOR PARTNUM=0 WTP=../A3700-utils-marvell/ PLAT=a3700 all fip
  '';

  installPhase = ''
    cp -r build/a3700/debug/{flash-image.bin,uart-images} $out
  '';

  meta = with stdenv.lib; {
    maintainers = [ maintainers.mirrexagon ];
    platforms = [ "aarch64-linux" ];
    # ?
    license = licenses.unfreeRedistributableFirmware;
  };
}
