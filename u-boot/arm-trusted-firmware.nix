{ stdenv }:

stdenv.mkDerivation {
  src = fetchFromGitHub {
    owner = "MarvellEmbeddedProcessors";
    repo = "atf-marvell";
    rev = "43965481990fd92e9666cf9371a8cf478055ec7c";
    sha256 = "0hqr80hgk6j1pnvhi5sfb9q3j0gx1wx81nzbhnhsw5afkw855jd9"
  };

  patches = [
    ./atf-patches/0001-build-build-and-combine-primary-and-secondary-bootlo.patch
    ./atf-patches/0002-build-add-compile-option-to-build-secondary-boot-ima.patch
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
