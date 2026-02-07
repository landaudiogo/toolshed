{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/25.05";

        pyproject-nix = {
            url = "github:pyproject-nix/pyproject.nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        uv2nix = {
            url = "github:pyproject-nix/uv2nix";
            inputs.pyproject-nix.follows = "pyproject-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        pyproject-build-systems = {
            url = "github:pyproject-nix/build-system-pkgs";
            inputs.pyproject-nix.follows = "pyproject-nix";
            inputs.uv2nix.follows = "uv2nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = { self, nixpkgs, uv2nix, pyproject-nix, pyproject-build-systems, ... }@inputs: 
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            inherit (nixpkgs) lib;

            workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./webcam; };
            overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

            # webcam
            python = pkgs.python312;
            pythonSet = (pkgs.callPackage pyproject-nix.build.packages { inherit python; }).overrideScope
                (
                    lib.composeManyExtensions [
                        pyproject-build-systems.overlays.default
                        overlay
                    ]
                );
            venv = pythonSet.mkVirtualEnv "webcam" workspace.deps.default;

            pdnsctl = (pkgs.callPackage (import ./pdnsctl) {});
        in 
        {
            devShells.${system} = {
                webcam = import ./webcam { inherit pkgs; };
                pdnsctl = pdnsctl.devShell;
            };
            
            packages.${system} = {
                webcam = pkgs.writeShellScriptBin "webcam" ''
                    export PATH=${lib.makeBinPath [ pkgs.motion ]}:$PATH
                    source ${venv}/bin/activate
                    ${venv}/bin/webcam "$@"
                '';
                pdnsctl = pdnsctl.package;
            };

            images.${system} = {
                webcam = 
                    pkgs.dockerTools.buildImage {
                        name = "jvf-webcam";
                        tag = "latest";
                        copyToRoot = [ 
                            pkgs.coreutils
                            self.packages.${system}.webcam
                        ];
                        config = {
                            Entrypoint = [ "/bin/webcam" ];
                        };
                    };
            };
        };
}
