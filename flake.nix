{ 
  outputs = {...} : {
    templates = {
      vscode = {
        description = "VSCode with default extensions";
        path = ./vscode;
      };
      julia = {
        description = "Dev-shell with unpatched Julia binary.";
        url = "github:manuelbb-upb/nix-matlab-ld?dir=templates/julia";
      };
    };
  };
}
