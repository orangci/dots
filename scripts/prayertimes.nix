{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    pkgs.python312Packages.requests
    pkgs.libnotify
  ];

  shellHook = ''
    echo "Running prayertimes.py..."
    python3 prayertimes.py
  '';
}
