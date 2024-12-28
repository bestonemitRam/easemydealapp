import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Stream<String> getThemeStream() {
   
    CollectionReference myCollection =
        FirebaseFirestore.instance.collection('settings');

    
    return myCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty)
       {
      
        String descriptions = snapshot.docs
            .map((doc) => doc['theme'].toString())
            .join(
                ', '); 
      
        return descriptions;
      }
      return ''; 
    });
  }

}
