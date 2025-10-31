{ 
    pkgs ? import <nixpkgs> {}
}: 
let
    python = pkgs.python312;
    lib = pkgs.lib;
in pkgs.mkShell {
    packages = [
        python
        pkgs.uv
        pkgs.motion
    ];
    env =
        {
            UV_PYTHON_DOWNLOADS = "never";
            UV_PYTHON = python.interpreter;
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux {
            LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
        };
    shellHook = ''
        unset PYTHONPATH
    '';
}
