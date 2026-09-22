{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.dev.go;
in
{
  options.hmModules.dev.go.enable = mkEnableOption "Enable Go development environment";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go # i wonder what this could possibly be bro
      gopls # lsp
      go-tools # a collection of Go static-analysis tools
      golangci-lint # linting
      delve # debugger
      air # live reload for webservers
    ];

    hmModules.cli.shell.extraAliases = {
      gor = "go run .";
      gob = "go build";
      got = "go test ./...";
      gof = "gofmt -w .";
      gov = "go vet ./...";
      gom = "go mod tidy";
    };
  };
}
