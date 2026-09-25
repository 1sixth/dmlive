{
  description = "dmlive, a live stream player and recorder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs =
    { nixpkgs, systems, ... }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          dmlive = pkgs.callPackage ./package.nix { };
        in
        {
          inherit dmlive;
          default = dmlive;
        }
      );
    };
}
