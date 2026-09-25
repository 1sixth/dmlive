{
  lib,
  rustPlatform,
  makeWrapper,
  pkg-config,
  openssl,
  ffmpeg,
  mpv,
}:

rustPlatform.buildRustPackage {
  pname = "dmlive";

  version = (fromTOML (builtins.readFile ./Cargo.toml)).package.version;

  src = ./.;

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  postInstall = ''
    wrapProgram $out/bin/dmlive \
      --suffix PATH : "${
        lib.makeBinPath [
          ffmpeg
          mpv
        ]
      }"
  '';

  meta = {
    description = "Live stream player and recorder";
    license = lib.licenses.mit;
    mainProgram = "dmlive";
  };
}
