{
  description = "Hugo Website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    hugo-theme = builtins.fetchTarball {
      name = "hugo-theme-m10c";
      url = "https://github.com/vaga/hugo-theme-m10c/archive/8295ee808a8166a7302b781895f018d9cba20157.tar.gz";
      sha256 = "12jvbikznzqjj9vjd1hiisb5lhw4hra6f0gkq1q84s0yq7axjgaw";
    };
  in {
    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = [
        pkgs.hugo
        pkgs.just
      ];

      shellHook = ''
        mkdir -p themes
        ln -snf "${hugo-theme}" themes/default
      '';
    };

    nixosModules.nginx-virtualhost = {...}: {
      security.acme = {
        acceptTerms = true;
        defaults.email = "john.doe@example.org";
      };

      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts."example.org" = {
          # forceSSL = true;   # deploy without this first
          # enableACME = true; # deploy without this first
          root = "/var/www/example.org/public";
        };
      };
    };
  };
}
