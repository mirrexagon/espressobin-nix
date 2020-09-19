# Reference:
# https://gitlab.denx.de/u-boot/u-boot/-/blob/master/doc/README.marvell
# https://github.com/openwrt/openwrt/pull/3360

{ lib, buildUBoot, fetchurl }:

buildUBoot rec {
  version = "2020.10-rc4";
  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
    sha256 = "0q7jpca26hf756g54dg9mbgsl5yrgwkz7z1h4yplvhgjglndsyqa";
  };

  defconfig = "mvebu_espressobin-88f3720_defconfig";
  filesToInstall = [ "u-boot.bin" ];

  extraMeta = with lib; {
    maintainers = [ maintainers.mirrexagon ];
    platforms = [ "aarch64-linux" ];
    license = licenses.gpl2;
  };
}
