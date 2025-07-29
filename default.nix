# default.nix
{
  lib,
  naersk,
  # , stdenv
  # , clangStdenv
  # , hostPlatform
  targetPlatform,
  pkg-config,
  libiconv,
  rustfmt,
  cargo,
  rustc,
  rustPackages,
# , llvmPackages # Optional
# , protobuf     # Optional
}:

let
  cargoToml = (builtins.fromTOML (builtins.readFile ./Cargo.toml));
in

naersk.lib."${targetPlatform.system}".buildPackage {
  src = ./.;

  buildInputs = [
    rustfmt
    pkg-config
    cargo
    rustc
    rustPackages.clippy
    libiconv
  ];
  checkInputs = [
    cargo
    rustc
  ];

  doCheck = true;
  CARGO_BUILD_INCREMENTAL = "false";
  RUST_BACKTRACE = "full";
  copyLibs = true;

  # Optional things you might need:
  #
  # If you depend on `libclang`:
  # LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  #
  # If you depend on protobuf:
  # PROTOC = "${protobuf}/bin/protoc";
  # PROTOC_INCLUDE = "${protobuf}/include";

  name = cargoToml.package.name;
  version = cargoToml.package.version;

  meta = with lib; {
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ osbm ];
  };
}
