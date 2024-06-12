class Answer
{
  String answerId;
  String questionId;
  String otherUserId;
  String content;

  Answer(this.answerId,this.questionId,this.otherUserId,this.content);

  toJson()
  {
    return {
      "answerId" : answerId,
      "questionId" : questionId,
      "otherUserId" : otherUserId,
      "content" : content
    };
  }
}