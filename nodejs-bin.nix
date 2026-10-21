{
  lib,
  stdenvNoCC,
  fetchurl,
}:
# Temporary: official prebuilt Node binary so the eMudhra CA fix (26.12.1) can be
# installed before Hydra has cached pkgs.nodejs_26 for aarch64-darwin.
# Swap back to pkgs.nodejs_26 once it's in cache.nixos.org.
stdenvNoCC.mkDerivation rec {
  pname = "nodejs-bin";
  version = "26.12.1";

  src = fetchurl {
    url = "https://nodejs.org/dist/v${version}/node-v${version}-darwin-arm64.tar.gz";
    # From https://nodejs.org/dist/v26.12.1/SHASUMS256.txt
    sha256 = "1901d539912c02afa10d1cc126943a8855a7eedebe830119463470db5e6c59e8";
  };

  # The node binary is code-signed; stripping it would invalidate the signature
  # (fatal on arm64).
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin include lib share $out/

    runHook postInstall
  '';

  meta = {
    description = "Node.js JavaScript runtime (official prebuilt binary)";
    homepage = "https://nodejs.org/";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "node";
  };
}
