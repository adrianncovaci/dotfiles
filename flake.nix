{
  description = "adrian's CLI toolbox (install: nix profile add ~/dotfiles)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAll = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAll (pkgs: {
        default = pkgs.buildEnv {
          name = "dotfiles";
          paths = with pkgs; [
            # shell + session
            tmux sesh gum zoxide starship fzf

            # editor and what its plugins / mason shell out to
            neovim git delta ripgrep fd tree-sitter
            gnumake unzip curl wget
            nodejs_22 go python3

            # misc
            jq htop gh
          ] ++ lib.optionals stdenv.isLinux [
            gcc # treesitter compiles parsers; macOS uses the Xcode clang
          ];
        };
      });
    };
}
