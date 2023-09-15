class Post {    //model class the parse the JSON
  String id;
  String title;
  String description;

  Post(
      {required this.id,
      required this.title,
      required this.description}); //un-named generative constructor

  factory Post.fromJson(Map<String, dynamic> json) => //create new Post obj
      Post(id: json['userId'].toString(), title: json['title'], description: json['body']);   //named constructor
}

// // {
//   "userId": 1,
//   "id": 1,
//   "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
//   "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
// }
