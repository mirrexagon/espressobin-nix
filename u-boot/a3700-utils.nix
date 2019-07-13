{ stdenv }:

stdenv.mkDerivation {
  name = "a3700-utils-espressobin";

  src = fetchFromGitHub {
    owner = "MarvellEmbeddedProcessors";
    repo = "A3700-utils-marvell";
    rev = "34ce2160a1521dda9c7c68e06fcde83242dee94a";
    sha256 = "0hqr80hgk6j1pnvhi5sfb9q3j0gx1wx81nzbhnhsw5afkw855jd9"
  };

  patches = [
    ./a3700-utils-patches/0001-Added-tim-img-files-to-build-the-secondary-image.patch
    ./a3700-utils-patches/0002-buildtim-add-argument-for-build-primary-or-secondary.patch
    ./a3700-utils-patches/0003-git-add-clocks_ddr.txt-to-git-ignore-list.patch
    ./a3700-utils-patches/0004-parser-add-preset_ddr_conf-field-for-using-preset-dd.patch
    ./a3700-utils-patches/0005-add-.d-files-to-gitignore.patch
    ./a3700-utils-patches/0006-ddr-update-ddr-topology-for-ddr3-ddr4.patch
  ];

  # We just want the contents of the repo.
  installPhase = ''
    cp -r $src/* $out
  '';

  meta = with stdenv.lib; {
    maintainers = [ maintainers.mirrexagon ];
    platforms = [ "aarch64-linux" ];
    # ?
    license = licenses.unfreeRedistributableFirmware;
  };
}
