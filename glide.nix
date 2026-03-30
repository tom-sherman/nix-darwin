{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:
stdenvNoCC.mkDerivation rec {
  pname = "glide";
  version = "0.2.12";

  src = fetchurl {
    url = "https://github.com/glide-wm/glide/releases/download/v${version}/Glide_${version}_aarch64.dmg";
    sha256 = "sha256-x6V79ntvA7RKT7KLPW8IZn4i3hKkatP4WtCL6MIUN3s=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Glide.app $out/Applications/

    mkdir -p $out/bin
    ln -s $out/Applications/Glide.app/Contents/MacOS/glide $out/bin/glide

    runHook postInstall
  '';

  meta = {
    description = "Tiling window manager for macOS";
    homepage = "https://glidewm.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "glide";
  };
}
