class ClientRepository {
  String? clientID;
  String? firstName;

  void updateCredentials(
      {required String clientID, required String firstName}) {
    this.clientID = clientID;
    this.firstName = firstName;
  }
}
