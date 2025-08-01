{
  description = "A Terraria world parser in Rust";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      naersk,
    }:
    let
      cargoToml = (builtins.fromTOML (builtins.readFile ./Cargo.toml));
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlay = final: prev: {
        "${cargoToml.package.name}" = final.callPackage ./. {
          inherit naersk;
        };
      };

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
            ];
          };
        in
        {
          "${cargoToml.package.name}" = pkgs."${cargoToml.package.name}";
        }
      );

      defaultPackage = forAllSystems (
        system:
        (import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        })."${cargoToml.package.name}"
      );

      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
            ];
          };
        in
        {
          format =
            pkgs.runCommand "check-format"
              {
                buildInputs = with pkgs; [
                  rustfmt
                  cargo
                ];
              }
              ''
                ${pkgs.rustfmt}/bin/cargo-fmt fmt --manifest-path ${./.}/Cargo.toml -- --check
                ${pkgs.nixfmt}/bin/nixfmt --check ${./.}
                touch $out # it worked!
              '';
          "${cargoToml.package.name}" = pkgs."${cargoToml.package.name}";
        }
      );
      devShell = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          };
        in
        pkgs.mkShell {
          inputsFrom = [
            pkgs."${cargoToml.package.name}"
          ];
          buildInputs = with pkgs; [
            rustfmt
            nixpkgs-fmt
            rustPackages.clippy
            mdbook
          ];
          LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
        }
      );
    };
}
