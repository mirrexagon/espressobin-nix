# Reference:
# https://gitlab.denx.de/u-boot/u-boot/-/blob/master/doc/README.marvell

{ lib, buildUBoot, fetchurl }:

buildUBoot rec {
  version = "2020.10";

  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
    sha256 = "08m6f1bh4pdcqbxf983qdb66ccd5vak5cbzc114yf3jwq2yinj0d";
  };

  defconfig = "mvebu_espressobin-88f3720_defconfig";

  # https://github.com/openwrt/openwrt/pull/3360
  # TODO: Remove when these are upstreamed
  extraPatches = [
    ./patches/131-arm64-dts-armada-3720-espressobin-use-Linux-model-co.patch
    ./patches/132-arm64-dts-armada-3720-espressobin-split-common-parts.patch
    ./patches/133-arm64-dts-a3720-add-support-for-boards-with-populate.patch
  ];

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
