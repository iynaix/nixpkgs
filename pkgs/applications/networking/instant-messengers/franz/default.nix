{
  lib,
  mkFranzDerivation,
  fetchurl,
}:

mkFranzDerivation rec {
  pname = "franz";
  name = "Franz";
  version = "5.11.0";
  src = fetchurl {
    url = "https://github.com/meetfranz/franz/releases/download/v${version}/franz_${version}_amd64.deb";
    sha256 = "sha256-4+HeH9lY5/2fswSwzMPM1Idllj01zU7nmlLOMYfcSsU=";
  };
  meta = with lib; {
    description = "Free messaging app that combines chat & messaging services into one application";
    homepage = "https://meetfranz.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.free;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
