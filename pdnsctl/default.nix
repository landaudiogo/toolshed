{ pkgs }:

rec {
    package = pkgs.stdenv.mkDerivation {
        name = "pdnsctl";
        buildInputs = with pkgs; [ 
            bash 
            curl 
        ];
        dontUnpack = true;
        installPhase = ''
            install -Dm755 ${./get-rrset.sh} $out/bin/get-rrset
            install -Dm755 ${./create-rrset.sh} $out/bin/create-rrset
            install -Dm755 ${./delete-rrset.sh} $out/bin/delete-rrset
        '';
    };
    devShell = package.overrideAttrs ( prev: { 
        buildInputs = prev.buildInputs ++ [ pkgs.jq ];
    });
}

