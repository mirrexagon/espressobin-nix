# Reference:
# https://gitlab.denx.de/u-boot/u-boot/-/blob/master/doc/README.marvell

{ lib, buildUBoot, fetchurl }:

buildUBoot rec {
  version = "2020.10-rc4";
  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
    sha256 = "0q7jpca26hf756g54dg9mbgsl5yrgwkz7z1h4yplvhgjglndsyqa";
  };

  # https://github.com/openwrt/openwrt/pull/3360
  # TODO: Remove when these are upstreamed, hopefully into the full 2020.10 release.
  extraPatches = [
    ./patches/100-add_support_for_macronix_mx25u12835f.patch
    ./patches/120-mvebu_armada-37xx.h_increase_max_gunzip_size.patch
    ./patches/130-mmc-xenon_sdhci-Add-missing-common-host-capabilities.patch
    ./patches/131-arm64-dts-armada-3720-espressobin-use-Linux-model-co.patch
    ./patches/132-arm64-dts-armada-3720-espressobin-split-common-parts.patch
    ./patches/133-arm64-dts-a3720-add-support-for-boards-with-populate.patch
    ./patches/134-arm-mvebu-Espressobin-Set-environment-variable-fdtfi.patch
  ];

  defconfig = "mvebu_espressobin-88f3720_defconfig";
  filesToInstall = [ "u-boot.bin" ];

  extraMeta = with lib; {
    maintainers = [ maintainers.mirrexagon ];
    platforms = [ "aarch64-linux" ];
    license = licenses.gpl2;
  };
}
