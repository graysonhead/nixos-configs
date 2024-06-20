{ nixpkgs, inputs, pkgs, config, ... }:
let
  # overlay = final: prev: {
  #   xr-hardware = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.xr-hardware;
  # };
  monado_source = pkgs.fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "monado";
    rev = "1e047b5b6d1b206623965680cf4d776fa134f875";
    sha256 = "sha256-yCh1Ob7ZOYOJDDO/V0hDQJ0iaJ2XSyo48fayhVhQIbo=";
  };

  custom-basalt = pkgs.stdenv.mkDerivation rec {
    pname = "basalt";
    version = "36d49117";
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "mateosss";
      repo = "basalt";
      rev = "36d49117f2d5066a638d74d5f53c738240727286";
      sha256 = "sha256-Rwhg5L7VnZXfDAcNUb1ERRHtHSGblJQqf26KS4dgfSk=";
      fetchSubmodules = true;
    };
    buildInputs = with pkgs; [ boost bzip2 opencv eigen lz4 tbb glew ccache fmt llvm doxygen libepoxy ];
    nativeBuildInputs = with pkgs; [ cmake ninja pkg-config ];
    cmakeFlags = [
      "-DEIGEN3_INCLUDE_DIR=${pkgs.eigen}/include/eigen3"
      "-DCMAKE_BUILD_TYPE=Release"
    ];
    postUnpack = ''export HOME=$TMP'';
    # buildPhase = ''
    #   cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DBASALT_BUILD_SHARED_LIBRARY_ONLY=on
    # '';
    # installPhase = ''cmake --build build --target install'';
  };
in
{
  # nixpkgs.overlays = [ overlay ];
  # imports = [
  #   "${inputs.nixpkgs-unstable}/nixos/modules/services/hardware/monado.nix"
  # ];
  environment.systemPackages = [ custom-basalt pkgs.xrgears ];
  services.monado = {
    enable = true;
    package = pkgs.unstable.monado;
    # package = pkgs.monado.overrideAttrs
    #   (prev: {
    #     src = monado_source;
    #     version = "custom";
    #     patches = [ ];
    #     buildInputs = prev.buildInputs ++ [ custom-basalt ];
    #   });
    highPriority = true;
    defaultRuntime = true;
  };
}
