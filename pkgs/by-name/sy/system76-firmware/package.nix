{
  rustPlatform,
  lib,
  fetchFromGitHub,
  xz,
  pkg-config,
  openssl,
  dbus,
  efibootmgr,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "system76-firmware";
  # Check Makefile when updating, make sure postInstall matches make install
  version = "1.0.69";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-firmware";
    rev = version;
    sha256 = "sha256-+0I4XZ9qpDIz3Yv83//JnPDfw6zHcT6UrZEeqUhc7TI=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    xz
    openssl
    dbus
  ];

  cargoBuildFlags = [ "--workspace" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-j3Gw46nK3fe6CKboyi9FFHnc8IytVJP9wnJ2iwEblP8=";

  # Purposefully don't install systemd unit file, that's for NixOS
  postInstall = ''
    install -D -m -0644 data/system76-firmware-daemon.conf $out/etc/dbus-1/system.d/system76-firmware-daemon.conf

    for bin in $out/bin/system76-firmware-*
    do
      wrapProgram $bin --prefix PATH : "${efibootmgr}/bin"
    done
  '';

  meta = with lib; {
    description = "Tools for managing firmware updates for system76 devices";
    homepage = "https://github.com/pop-os/system76-firmware";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ shlevy ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
