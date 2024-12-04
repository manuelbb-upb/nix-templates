{
  description = "VSCode with Default Extensions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { 
    self, 
    nixpkgs, 
    flake-utils, 
    nix-vscode-extensions 
  }@inputs: flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system}; 
      vs-marketplace-extensions = nix-vscode-extensions.extensions.${system}.vscode-marketplace;
      default-extensions =  with vs-marketplace-extensions; [
        # Spacemacs and Vim-Mode
        vspacecode.whichkey
        vspacecode.vspacecode
        vscodevim.vim
        # Random word generator
        thmsrynr.vscode-namegen
        # Catppuccin Theme
        catppuccin.catppuccin-vsc
        # Nix language extension
        jnoortheen.nix-ide
        # direnv chooser:
        mkhl.direnv
      ];
      vscodium-with-default-extensions = pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions = default-extensions; 
      };
    in
    {

      packages = {
        inherit vscodium-with-default-extensions;
      };

      devShells = {
        default = pkgs.mkShell {
          packages = (with pkgs; [
          ]) ++ [
            (vscodium-with-default-extensions.override ( prev: {
              vscodeExtensions = prev.vscodeExtensions ++ (with vs-marketplace-extensions; [
              ]);
            }))
          ];
        };
      }; 
    }
  );
}
