

abstract class TabServiceEvent  {
}

class UpdateTabList extends TabServiceEvent {
  final int tab;

  UpdateTabList(this.tab);
}
