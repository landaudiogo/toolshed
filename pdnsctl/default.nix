{ pkgs, lib }:
let 
    runtimeDeps = with pkgs; [ bash curl ];
in
rec {
    package = pkgs.stdenv.mkDerivation {
        name = "pdnsctl";
        buildInputs = [ runtimeDeps ] ++ [ pkgs.makeWrapper ];
        dontUnpack = true;
        installPhase = ''
            install -Dm755 ${./get-rrset.sh} $out/bin/get-rrset
            install -Dm755 ${./create-rrset.sh} $out/bin/create-rrset
            install -Dm755 ${./delete-rrset.sh} $out/bin/delete-rrset

            wrapProgram $out/bin/get-rrset --prefix PATH : ${lib.makeBinPath runtimeDeps}
            wrapProgram $out/bin/create-rrset --prefix PATH : ${lib.makeBinPath runtimeDeps}
            wrapProgram $out/bin/delete-rrset --prefix PATH : ${lib.makeBinPath runtimeDeps}
        '';
    };
    devShell = package.overrideAttrs ( prev: { 
        buildInputs = prev.buildInputs ++ [ pkgs.jq ];
    });
}

