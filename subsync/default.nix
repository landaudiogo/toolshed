{ pkgs, lib, stdenv, rustPlatform }:
let 
    alassSrc = pkgs.fetchFromGitHub {
        owner = "kaegi";
        repo = "alass";
        rev = "874f02d9577182752a0f969b6d6b98fd65bdf1fc";
        hash = "sha256-fi4kpJEaD9v6wWl6fRfMP5myL8c9mNyxxtS/0IhWzM8=";
    };
    alass = rustPlatform.buildRustPackage {
        name = "alass-cli";
        src = alassSrc;

        cargoLock = {
            lockFile = "${alassSrc}/Cargo.lock";
        };
        doCheck = false;
    };
    runtimeDeps = with pkgs; [
        ffmpeg 
        alass 
        findutils
    ];
in
rec {
    devShell = pkgs.mkShell {
        packages = runtimeDeps;
    };

    package = stdenv.mkDerivation {
        name = "subsync";
        buildInputs = [ pkgs.makeWrapper ];

        dontUnpack = true;
        installPhase = ''
            install -Dm555 ${./subsync.sh} $out/bin/subsync
        '';
        postFixup = ''
            wrapProgram $out/bin/subsync \
                --set PATH ${lib.makeBinPath runtimeDeps}
        '';

    };

    app = {
        type = "app";
        program = "${package}/bin/subsync";
    };
}
