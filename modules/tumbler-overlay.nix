# Overlay to patch tumbler and remove unnecessary webkitgtk dependency
self: super: {
  tumbler = super.tumbler.overrideAttrs (oldAttrs: {
    buildInputs = super.lib.filter (dep: dep.pname or "" != "webkitgtk") (oldAttrs.buildInputs or []);
    nativeBuildInputs = super.lib.filter (dep: dep.pname or "" != "webkitgtk") (oldAttrs.nativeBuildInputs or []);
    propagatedBuildInputs = super.lib.filter (dep: dep.pname or "" != "webkitgtk") (oldAttrs.propagatedBuildInputs or []);
  });
}
