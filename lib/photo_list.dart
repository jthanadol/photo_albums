class PhotoList{
  int userId;
  int id;
  String title;

  PhotoList(this.userId, this.id, this.title);

  factory PhotoList.fromJson(Map<String , dynamic> json){
    return PhotoList(json['userId'], json['id'], json['title']);
  }
}