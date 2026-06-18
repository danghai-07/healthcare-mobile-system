/// Bridges Dio 401 handling to session refresh without circular DI.
class UnauthorizedNotifier {
  Future<void> Function()? onUnauthorized;

  Future<void> notify() async {
    await onUnauthorized?.call();
  }
}
