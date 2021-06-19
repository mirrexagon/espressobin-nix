# Reference:
# https://gitlab.denx.de/u-boot/u-boot/-/blob/master/doc/README.marvell

{ lib, buildUBoot, fetchurl }:

buildUBoot rec {
  version = "2021.04";

  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
    sha256 = "sha256-DUOLG7XM61ehjqLeSg1R975bBbmHF98Fk4Y24Krf4Ro=";
  };

  defconfig = "mvebu_espressobin-88f3720_defconfig";

  preConfigure = ''
    # enable additional options beyond <device>_defconfig
    echo CONFIG_CMD_SETEXPR=y >> configs/${defconfig}
  '';

  filesToInstall = [ "u-boot.bin" ];

  extraMeta = with lib; {
    maintainers = [ maintainers.mirrexagon ];
    platforms = [ "aarch64-linux" ];
    license = licenses.gpl2;
  };
}
