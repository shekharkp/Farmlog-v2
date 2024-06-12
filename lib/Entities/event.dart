class FarmEvents
{
  String eventId;
  String userId;
  String title;
  String imagePath;
  String location;
  String content;
  String date;
  String direction;

  FarmEvents(this.eventId, this.userId, this.title, this.imagePath, this.location,
      this.content, this.date, this.direction);

  toJson()
  {
    return
        {
          "eventId" : eventId,
          "userId" : userId,
          "title" : title,
          "imagePath" : imagePath,
          "Location" : location,
          "content" : content,
          "dateTime" : date,
          "direction" : direction
        };
  }

}