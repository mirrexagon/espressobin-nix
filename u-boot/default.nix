{ lib, buildUBoot, fetchFromGitHub }:

buildUBoot rec {
  version = "2017.03";

  src = fetchFromGitHub {
    owner = "MarvellEmbeddedProcessors";
    repo = "u-boot-marvell";

    # From http://wiki.espressobin.net/tiki-index.php?page=Build+From+Source+-+Bootloader#Build_U-Boot
    rev = "6a6581a21ec5d6405f30fd41ee5040d64893651b";
    sha256 = "1hqr80hgk6j1pnvhi5sfb9q3j0gx1wx81nzbhnhsw5afkw855jd9";

    # From 'u-boot-2018.03-armada-18.12' branch.
    #rev = "c9aa92ce70d16b3d6c6291c6be69f42783a4ebc0";
    #sha256 = "0m0k8ivzhmg9y4x0k7fz7y71pgblzxy81m6x32iivz5kjnxdnv4i";
  };

  extraPatches = [
    # From http://wiki.espressobin.net/tiki-index.php?page=Build+From+Source+-+Bootloader#Build_U-Boot
    ./0001-git-add-some-temporary-files-into-git-ignore-list.patch
    ./0002-dts-espressobin-add-emmc-device-support.patch
    ./0003-mtd-add-issi-is25wp032d-spi-flash-support.patch
    ./0004-mtd-add-macronix-mx25u3235f-spi-flash-support.patch
    ./0005-mtd-add-gigadevice-gd25lq32d-spi-flash-support.patch

    # Mine.
    ./0001-fdt-make-compatible-with-dtc-1.4.6.patch
    ./0002-Remove-duplicate-const.patch
  ];

  extraMakeFlags = [ "DEVICE_TREE=armada-3720-espressobin" ];

  defconfig = "mvebu_espressobin-88f3720_defconfig";
  filesToInstall = [ "u-boot.bin" ];

  extraMeta = with lib; {
    maintainers = [ maintainers.mirrexagon ];
    platforms = [ "aarch64-linux" ];
    # ?
    license = licenses.unfreeRedistributableFirmware;
  };
}
