/// Unsupported Implementation of [PlatformHelper]
class PlatformHelper {
  /// Throws [UnsupportedError].
  bool get isMobile {
    throw UnsupportedError('isMobile is not supported on the current platform');
  }

  bool get isRunningOnLocalhost {
    throw UnsupportedError(
      'isRunningOnLocalhost is not supported on the current platform',
    );
  }
}
