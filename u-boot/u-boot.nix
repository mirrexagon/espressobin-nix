# Reference:
# https://gitlab.denx.de/u-boot/u-boot/-/blob/master/doc/README.marvell

{ lib, buildUBoot, fetchurl }:

buildUBoot rec {
  version = "2024.10";

  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
    sha256 = "sha256-so2vSsF+QxVjYweL9RApdYQTf231D87ZsS3zT2GpL7A=";
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
