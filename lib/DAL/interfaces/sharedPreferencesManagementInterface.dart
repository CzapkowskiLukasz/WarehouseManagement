abstract class SharedPreferencesManagementInterface {
  Future<int?> getAssingmentId();

  Future<bool> setAssingmentId(int id);

  Future<bool> removeAssingmentId();
}
