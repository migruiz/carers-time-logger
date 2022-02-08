class OverlapHistoryEntry{
  final String carerName;
  final bool isMe;
  final DateTime date;

  OverlapHistoryEntry({required this.carerName,required this.isMe,required this.date});
}
class OverlapInterval{
  final OverlapHistoryEntry entry1;
  final OverlapHistoryEntry entry2;
  final OverlapHistoryEntry entry3;
  final OverlapHistoryEntry entry4;

  OverlapInterval({required this.entry1, required this.entry2,required  this.entry3,required  this.entry4});
}