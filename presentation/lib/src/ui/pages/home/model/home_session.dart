class HomeSession {
  final String name;
  final int members;
  final String state;
  final void Function() onClick;

  const HomeSession(this.name, this.members, this.state, this.onClick);
}