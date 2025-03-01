let
  nixpkgs = builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
  hugo-theme = builtins.fetchTarball {
    name = "hugo-theme-m10c";
    url = "https://github.com/vaga/hugo-theme-m10c/archive/8295ee808a8166a7302b781895f018d9cba20157.tar.gz";
    sha256 = "12jvbikznzqjj9vjd1hiisb5lhw4hra6f0gkq1q84s0yq7axjgaw";
  };
in
  {pkgs ? import nixpkgs {}}:
    pkgs.stdenv.mkDerivation {
      name = "my-hugo-site";

      # Source directory containing your Hugo project
      src = ./.;

      # Build dependencies
      nativeBuildInputs = [pkgs.hugo];

      # Copy in theme before building website
      preBuildPhase = ''
        mkdir -p themes/default
        cp -r ${hugo-theme}/* themes/default/
      '';

      # Build phase - run Hugo to generate the site
      buildPhase = ''
        hugo
      '';

      # Install phase - copy the public directory to the output
      installPhase = ''
        mkdir -p $out
        cp -r public/* $out/
      '';
    }
