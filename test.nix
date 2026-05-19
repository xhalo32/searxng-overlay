{sources ? import ./npins, pkgs ? import sources.nixpkgs {}}: pkgs.mkShell {buildInputs=[pkgs.lolcat];}
