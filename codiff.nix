{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "codiff";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/nkzw-tech/codiff/releases/download/v${version}/Codiff-darwin-arm64-${version}.zip";
    sha256 = "sha256-jT740GBNY5LqI95bvaMR3uogHatJ5pKW28OAt1gJxz4=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  # Electron bundle is code-signed; skip fixup so nix doesn't strip/rewrite the
  # nested framework binaries and invalidate the signature (fatal on arm64).
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Codiff.app $out/Applications/

    mkdir -p $out/bin
    # The launcher is a /bin/sh script that resolves its own symlinks and then
    # `open`s the .app relative to its real location, so a plain symlink works.
    ln -s $out/Applications/Codiff.app/Contents/Resources/app/bin/codiff-app $out/bin/codiff

    runHook postInstall
  '';

  meta = {
    description = "Visual diff tool for Git changes";
    homepage = "https://github.com/nkzw-tech/codiff";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "codiff";
  };
}
