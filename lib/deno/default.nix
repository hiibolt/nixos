{ pkgs ? import <nixpkgs> { } }:
let 
  rust_overlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  pkgs = import <nixpkgs> { overlays = [ rust_overlay ]; };

  rustVersion = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  rustPlatform = pkgs.makeRustPlatform {
    cargo = rustVersion;
    rustc = rustVersion;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "deno";
  version = "2.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "denoland";
    repo = pname;
    rev = "v${version}";
    sha256 = "07l1ipayj3037x67080dh6nbwyxxwlgc22l8754hqnmkgn7c1xyw";
  };

  cargoSha256 = "3r5B9yWXKO/8ah+Etflws8RnlRTAdaaC5HZMlZduyHE=";

  postPatch = ''
    # upstream uses lld on aarch64-darwin for faster builds
    # within nix lld looks for CoreFoundation rather than CoreFoundation.tbd and fails
    substituteInPlace .cargo/config.toml --replace "-fuse-ld=lld " ""
  '';

  # uses zlib-ng but can't dynamically link yet
  # https://github.com/rust-lang/libz-sys/issues/158
  nativeBuildInputs = with pkgs; [
    # required by libz-ng-sys crate
    cmake
    # required by deno_kv crate
    protobuf
    installShellFiles
  ];

  # work around "error: unknown warning group '-Wunused-but-set-parameter'"
  env.NIX_CFLAGS_COMPILE = pkgs.lib.optionalString pkgs.stdenv.cc.isClang "-Wno-unknown-warning-option";

  buildAndTestSubdir = "cli";

  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  RUSTY_V8_ARCHIVE = pkgs.callPackage ./librusty_v8.nix { };

  # Tests have some inconsistencies between runs with output integration tests
  # Skipping until resolved
  doCheck = false;

  preInstall = ''
    find ./target -name libswc_common${pkgs.stdenv.hostPlatform.extensions.sharedLibrary} -delete
  '';

  postInstall = ''
    installShellCompletion --cmd deno \
      --bash <($out/bin/deno completions bash) \
      --fish <($out/bin/deno completions fish) \
      --zsh <($out/bin/deno completions zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    runHook postInstallCheck
  '';
}
