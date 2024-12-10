{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-matlab-ld = {
      url = "github:manuelbb-upb/nix-matlab-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-flake = {
      url = "./pkgs/vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
 
  outputs = {
    nixpkgs,
    nix-matlab-ld,
    vscode-flake,
    ...
  }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    inherit nix-matlab-ld;
    packages.${system} = rec {
      inherit (vscode-flake.packages.${system}) vscodium-with-default-extensions;
      vscodium-local = pkgs.callPackage ./pkgs/vscode/with-local-data.nix {
        vscodium = vscodium-with-default-extensions;
      };
    };
    templates = {
      vscode = {
        description = "VSCode with default extensions";
        path = ./vscode;
      };
      julia = {
        description = "Julia unpatched, whithout shell hook.";
        path = ./julia;
      };
      julia-ld = nix-matlab-ld.templates.julia;
      python-ld = nix-matlab-ld.templates.python;
      poetry-ld = nix-matlab-ld.templates.poetry;
    };
  };
}
