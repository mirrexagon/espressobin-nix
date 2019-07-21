{ lib, buildUBoot, fetchFromGitHub }:

buildUBoot rec {
  version = "2018.03-armada-18.12";

  src = fetchFromGitHub {
    owner = "MarvellEmbeddedProcessors";
    repo = "u-boot-marvell";

    rev = "u-boot-2018.03-armada-18.12";
    sha256 = "0g7nry9zpjxdk9dclvwkq64719cdfmcj22ybv6lhfqm7d0xqgpkn";
  };

  extraPatches = [
    ./0001-Enable-distro-boot-config.patch
    ./0002-Modify-armada-common-environment-for-distro-boot.patch
  ];

  extraMakeFlags = [ "DEVICE_TREE=armada-3720-espressobin" ];

  defconfig = "mvebu_espressobin-88f3720_defconfig";
  filesToInstall = [ "u-boot.bin" ];

  extraMeta = with lib; {
    maintainers = [ maintainers.mirrexagon ];
    platforms = [ "aarch64-linux" ];
    license = licenses.gpl2;
  };
}
