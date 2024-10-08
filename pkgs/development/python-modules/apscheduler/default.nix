{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  gevent,
  pytest-asyncio,
  pytest-tornado,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools,
  setuptools-scm,
  six,
  tornado,
  twisted,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "apscheduler";
  version = "3.10.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "APScheduler";
    inherit version;
    hash = "sha256-5t8HGyfZvomOSGvHlAp75QtK8unafAjwdEqW1L1M70o=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pytz
    setuptools
    six
    tzlocal
  ];

  nativeCheckInputs = [
    gevent
    pytest-asyncio
    pytest-tornado
    pytestCheckHook
    tornado
    twisted
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail " --cov --tb=short" ""
  '';

  disabledTests =
    [
      "test_broken_pool"
      # gevent tests have issue on newer Python releases
      "test_add_live_job"
      "test_add_pending_job"
      "test_shutdown"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "test_submit_job"
      "test_max_instances"
    ];

  pythonImportsCheck = [ "apscheduler" ];

  meta = with lib; {
    description = "Library that lets you schedule your Python code to be executed";
    homepage = "https://github.com/agronholm/apscheduler";
    license = licenses.mit;
    maintainers = [ ];
  };
}
