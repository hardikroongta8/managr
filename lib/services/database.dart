import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  final String uid;

  Database({required this.uid});

  void updateCategory({required String categoryName, required String newName})async{
    final collectionRef = FirebaseFirestore.instance.collection(uid);

    final categorySnapshot = await collectionRef.doc(categoryName).get();
    final categoryMap = categorySnapshot.data();

    categoryMap!['categoryName'] = newName;

    collectionRef.doc(categoryName).delete();

    await collectionRef.doc(newName).set(categoryMap);
  }

  void deleteCategory({required String categoryName})async{
    final collectionRef = FirebaseFirestore.instance.collection(uid);

    collectionRef.doc(categoryName).delete();
  }

  Future<Map> getStats({required String categoryName})async{
    final collectionRef = FirebaseFirestore.instance.collection(uid);

    final Map? document = (await collectionRef.doc(categoryName).get()).data();
    final List taskList = document!['taskList'];

    final now = DateTime.parse(DateTime.now().toLocal().toString().substring(0, 10));
    final int today = now.weekday;
    final lastMonday = now.subtract(Duration(days: today - 1));
    
    int notDone = document['notDone'];

    List stats = [0, 0, 0, 0, 0, 0, 0];

    for(int i = 0; i < taskList.length; i++){
      final lastUpdated = DateTime.parse(taskList[i]['lastUpdated']);
      if(taskList[i]['finished'] == true){
        if(lastUpdated.compareTo(lastMonday) >= 0){
          stats[lastUpdated.weekday - 1] += 1;
        }
      }
    }

    return {'notDone': notDone, 'stats': stats};
  }

  Future<Map> getStatsAll()async{
    final collectionRef = FirebaseFirestore.instance.collection(uid);
    final snapshots = await collectionRef.get();
    List docs = snapshots.docs;   

    List<Map> data = docs.map(
      (doc) => {
        'taskList': doc['taskList'],
        'notDone': doc['notDone']
      }
    ).toList();

    final now = DateTime.parse(DateTime.now().toLocal().toString().substring(0, 10));
    final int today = now.weekday;
    final lastMonday = now.subtract(Duration(days: today - 1));

    List stats = [0, 0, 0, 0, 0, 0, 0];
    int notDone = 0;

    for(int i = 0; i < data.length; i++){
      for(int j = 0; j < data[i]['taskList'].length; j++){
        final lastUpdated = DateTime.parse(data[i]['taskList'][j]['lastUpdated']);
        if(data[i]['taskList'][j]['finished'] == true){
          if(lastUpdated.compareTo(lastMonday) >= 0){
            stats[lastUpdated.weekday - 1] += 1;
          }
        }
      }
      int n = data[i]['notDone'];
      notDone += n;
    }

    return {'notDone': notDone, 'stats': stats};
  }

  Future<List<Map>> getProgress()async{
    final collectionRef = FirebaseFirestore.instance.collection(uid);
    final snapshot = await collectionRef.get();
    List docs = snapshot.docs;

    docs.sort((a, b) => a['time'].toString().compareTo(b['time'].toString()));

    List<Map> list = docs.map((doc) => {
      'categoryName': doc['categoryName'],
      'done': doc['done'],
      'notDone': doc['notDone']
    }).toList();

    return list;
  }

  void toggleFinished({required String category, required int index})async{
    final collectionRef = FirebaseFirestore.instance.collection(uid);

    final document = (await collectionRef.doc(category).get()).data();
    List taskList = document!['taskList'];

    int done, notDone;

    if(taskList[index]['finished'] == true){
      done = document['done'] - 1;
      notDone = document['notDone'] + 1;
    }
    else{
      done = document['done'] + 1;
      notDone = document['notDone'] - 1;
    }

    taskList[index]['finished'] = !taskList[index]['finished'];
    taskList[index]['lastUpdated'] = DateTime.now().toLocal().toString().substring(0, 10);

    await collectionRef.doc(category).update({
      'taskList': taskList,
      'done': done,
      'notDone': notDone
    });
  }

  void addCategory({required String category})async{
    final collectionRef = FirebaseFirestore.instance.collection(uid);
    await collectionRef.doc(category).set({
      'categoryName': category,
      'time': DateTime.now().toLocal().toString(),
      'done': 0,
      'notDone': 0,
      'taskList': <Map>[]
    });
  }

  Future getData()async{
    final collectionRef = FirebaseFirestore.instance.collection(uid);
    final snapshots = await collectionRef.get();
    List docs = snapshots.docs;   

    docs.sort((a, b) => a['time'].toString().compareTo(b['time'].toString()));
    List<String> categoryList = docs.map((doc) => doc['categoryName'].toString()).toList();
    List tasksList = docs.map((doc) => doc['taskList']).toList();
    return {'categoryList': categoryList, 'tasksList': tasksList};
  }

  void addTask({required String category, required String taskBody})async{
    final collectionRef = FirebaseFirestore.instance.collection(uid);

    final categorySnapshot = await collectionRef.doc(category).get();
    final categoryMap = categorySnapshot.data();
    
    int notDone = categoryMap!['notDone'] + 1;

    List tasks = categoryMap['taskList'];
    tasks.add({
      'finished': false,
      'body': taskBody,
      'lastUpdated': DateTime.now().toLocal().toString().substring(0, 10)
    });
    await collectionRef.doc(category).update({
      'taskList': tasks,
      'notDone': notDone
    });
  }
}