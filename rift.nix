{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "rift";
  version = "unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "acsandmann";
    repo = "rift";
    rev = "1c8882b8e94db71cb3e33e7632209d85f5f5c43a";
    hash = "sha256-4CExoT2fxx1YlZRxorpQIyvckaZvR8Y/wA0Fc5/bW8Y=";
  };

  cargoHash = "sha256-A0huWauj3Ltnw39jFft6pyYUVcNK+lu89ZlVQl/aRZg=";

  # Enable unstable Rust features (let_chains, stmt_expr_attributes)
  RUSTC_BOOTSTRAP = 1;

  # Disable tests - may require GUI/accessibility
  doCheck = false;

  meta = {
    description = "Tiling window manager for macOS";
    homepage = "https://github.com/acsandmann/rift";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "rift";
  };
}
