{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "arm-trusted-firmware-espressobin";

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  src = fetchFromGitHub {
    owner = "MarvellEmbeddedProcessors";
    repo = "atf-marvell";
    rev = "43965481990fd92e9666cf9371a8cf478055ec7c";
    sha256 = "152rs8bilxhzfrjqggckvq493bnjqn7lg23fbs5bsfvjy29s0z2a";
  };

  patches = [
    ./atf-patches/0001-build-build-and-combine-primary-and-secondary-bootlo.patch
    ./atf-patches/0002-build-add-compile-option-to-build-secondary-boot-ima.patch
  ];

  # We just want the contents of the repo.
  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
  '';

  meta = with stdenv.lib; {
    maintainers = [ maintainers.mirrexagon ];
    # ?
    license = licenses.unfreeRedistributableFirmware;
  };
}
