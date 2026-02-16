{ pkgs, rustPlatform }:
{
    devShell = pkgs.mkShell {
        packages = with pkgs; [
            cargo 
            rustc
            rust-analyzer
            rustfmt
        ];
    };
    package = rustPlatform.buildRustPackage {
        name = "percentile-ps";
        src = ./.;
        cargoHash = "sha256-8hG6hcBVK9Q5NyI0JuM4kKZCB3k/AuBaccV9obHxUK8=";
    };
}
