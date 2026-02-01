{
  description = "BAML Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python312;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            python
            python.pkgs.pip
            python.pkgs.virtualenv
          ];
          BAML_VERSION="0.208.3";
          shellHook = ''
            # Create venv if it doesn't exist
            if [ ! -d .venv ]; then
              echo "Creating virtual environment..."
              ${python}/bin/python -m venv .venv
            fi

            source .venv/bin/activate

            # Install baml-py if not present
            if ! python -c "import baml_py" 2>/dev/null; then
              echo "Installing baml-py..."
              pip install baml-py==$BAML_VERSION
            fi

            echo "BAML Python dev environment ready!"
            echo "Run 'baml-cli init' to initialize a new project"
            echo "Run 'baml-cli generate' to generate client code"
          '';
        };
      }
    );
}
