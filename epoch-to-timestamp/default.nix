{ pkgs, ... }:
rec {
    package = pkgs.stdenv.mkDerivation {
        name = "epoch-to-timestamp";
        buildInputs = [ 
            (pkgs.python3.withPackages (py-pkgs: with py-pkgs; [
                click   
                pandas
            ]))
        ];
        dontUnpack = true;
        installPhase = ''
            install -Dm555 ${./main.py} $out/bin/epoch-to-timestamp
        '';
    };

    devShell = package.overrideAttr (prev: {
        buildInputs = [ ];
    });

    app = {
        type = "app";
        program = "${package}/bin/epoch-to-timestamp";
    };
}
