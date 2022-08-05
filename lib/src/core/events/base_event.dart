abstract class DomainEvent {
  final String name = "Event";

  @override
  String toString() {
    return name;
  }
}
