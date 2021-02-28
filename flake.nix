{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  outputs = { self, nixpkgs }: {
    nixosConfigurations.poincare = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./poincare.nix
        { nix.registry.nixpkgs.flake = nixpkgs; }
      ];
    };
    nixosConfigurations.hilbert = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hilbert.nix
        { nix.registry.nixpkgs.flake = nixpkgs; }
      ];
    };
  };
}
