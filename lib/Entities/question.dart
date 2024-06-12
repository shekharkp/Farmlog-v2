class Question
{
  String userId;
  String questionId;
  String title;
  String description;
  int answerCount;

  Question(this.questionId,this.userId,this.title,this.description,this.answerCount);


  toJson()
  {
    return
        {
          "userid" : userId,
          "questionid" : questionId,
          "title" : title,
          "description" : description,
          "answerCount" : answerCount,
        };
  }
}