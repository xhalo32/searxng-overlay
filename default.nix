{
  sources ? import ./npins,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs {
    inherit system;
    config = { };
    overlays = [ ];
  },
}:
rec {
  searxng-static = pkgs.buildNpmPackage (finalAttrs: {
    pname = "searxng-client";
    version = "master";
    src = sources.searxng;
    npmRoot = "client/simple";
    npmDeps = pkgs.fetchNpmDeps {
      src = "${sources.searxng}/client/simple";
      hash = "sha256-kSx2IvAMKHNoZeS1Tac1haDPKYz/yHUND1boqT4Fbto=";
    };
    # https://github.com/privau/searxng/blob/main/update.sh
    prePatch = ''
      cp -r ${sources.privau-searxng}/src/less/. client/simple/src/less
    '';
    # Why is this needed when `npmRoot` is set?
    preBuild = ''
      cd ${finalAttrs.npmRoot}
    '';
    installPhase = ''
      mkdir $out
      cp -r ../../searx/static/themes/simple/. $out
    '';

    meta = {
      license = pkgs.lib.licenses.agpl3Only;
    };
  });

  searxng = pkgs.searxng.overrideAttrs (oa: {
    src = sources.searxng;
    prePatch = ''
      cp -r ${searxng-static}/. searx/static/themes/simple/
      substituteInPlace searx/preferences.py \
        --replace-fail "'auto', 'light', 'dark', 'black']" "'auto', 'light', 'dark', 'black', 'paulgo', 'latte', 'frappe', 'macchiato', 'mocha', 'kagi', 'brave', 'moa', 'night', 'dracula', 'gruvbox', 'gruvboxmat', 'everforest', 'nord', 'matcha']"
      substituteInPlace searx/settings_defaults.py \
        --replace-fail "SIMPLE_STYLE = ('auto', 'light', 'dark', 'black')" "SIMPLE_STYLE = ('auto', 'light', 'dark', 'black', 'paulgo', 'latte', 'frappe', 'macchiato', 'mocha', 'kagi', 'brave', 'moa', 'night', 'dracula', 'gruvbox', 'gruvboxmat', 'everforest', 'nord', 'matcha')"
      substituteInPlace searx/templates/simple/preferences/theme.html \
        --replace-fail "{%- for name in ['auto', 'light', 'dark', 'black'] -%}" "{%- for name in ['auto', 'light', 'dark', 'black', 'paulgo', 'latte', 'frappe', 'macchiato', 'mocha', 'kagi', 'brave', 'moa', 'night', 'dracula', 'gruvbox', 'gruvboxmat', 'everforest', 'nord', 'matcha'] -%}"
    '';
  });
}
