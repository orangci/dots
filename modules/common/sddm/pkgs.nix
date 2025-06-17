{
  stdenv,
  fetchFromGitHub,
}:
{
  sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "v1.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-dark
    '';
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
  };
  tokyo-night = stdenv.mkDerivation rec {
    pname = "sddm-tokyo-night-theme";
    version = "320c8e74ade1e94f640708eee0b9a75a395697c6";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/tokyo-night
    '';
    src = fetchFromGitHub {
      owner = "siddrs";
      repo = "tokyo-night-sddm";
      rev = "${version}";
      sha256 = "1gf074ypgc4r8pgljd8lydy0l5fajrl2pi2avn5ivacz4z7ma595";
    };
  };
  stray = stdenv.mkDerivation rec {
    pname = "sddm-stray";
    version = "8c7759d9a05ad44f71209914b7223cebf845ccd9";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/theme $out/share/sddm/themes/stray
    '';
    src = fetchFromGitHub {
      owner = "Bqrry4";
      repo = "sddm-stray";
      rev = "${version}";
      sha256 = "sha256-3wsQFbo545SXwfV5P4+S4/wTme/n/yunfeVpmcEmKz4=";
    };
  };
}
