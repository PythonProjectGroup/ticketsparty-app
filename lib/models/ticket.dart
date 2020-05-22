class Ticket {
  int id;
  int eventID;
  String hash;
  String personName;
  int numberOfPeople;
  bool used;

  Ticket(
      {this.personName, this.numberOfPeople, this.used, this.hash, this.id, this.eventID});
}
