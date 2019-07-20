{ lib, buildUBoot, fetchFromGitHub }:

buildUBoot rec {
  version = "2018.03";

  src = fetchFromGitHub {
    owner = "MarvellEmbeddedProcessors";
    repo = "u-boot-marvell";

    # Marvell release 18.12
    # See https://forum.armbian.com/topic/9142-marvell-issued-armada-lsp-release-1812-to-general-public/
    rev = "u-boot-2018.03-armada-18.12";
    sha256 = "0g7nry9zpjxdk9dclvwkq64719cdfmcj22ybv6lhfqm7d0xqgpkn";
  };

  extraMakeFlags = [ "DEVICE_TREE=armada-3720-espressobin" ];

  defconfig = "mvebu_espressobin-88f3720_defconfig";
  filesToInstall = [ "u-boot.bin" ];

  extraMeta = with lib; {
    maintainers = [ maintainers.mirrexagon ];
    platforms = [ "aarch64-linux" ];
    license = licenses.gpl2;
  };
}
