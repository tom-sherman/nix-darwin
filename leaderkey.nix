{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "leaderkey";
  version = "1.17.3";

  src = fetchurl {
    url = "https://github.com/mikker/LeaderKey/releases/download/v${version}/Leader.Key.app.zip";
    sha256 = "sha256-B/q+70oHBLdWjzIzibUJ0/9fed9vi1nyer7BF0iGNG8=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "Leader Key.app" $out/Applications/

    mkdir -p $out/bin
    ln -s "$out/Applications/Leader Key.app/Contents/MacOS/Leader Key" "$out/bin/leaderkey"

    runHook postInstall
  '';

  meta = {
    description = "The fastest way to launch anything on your Mac";
    homepage = "https://github.com/mikker/LeaderKey";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "leaderkey";
  };
}
