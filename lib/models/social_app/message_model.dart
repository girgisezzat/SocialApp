class MessageModel {
  String? senderID;
  String? receiverID;
  String? dateTime;
  String? text;


  MessageModel({
    this.senderID,
    this.receiverID,
    this.dateTime,
    this.text,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
  {
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'senderID':senderID,
      'receiverID':receiverID,
      'dateTime':dateTime,
      'text':text,
    };
  }
}