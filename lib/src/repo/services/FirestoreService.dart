import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchUIConfig() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('ui_config').doc('config_1').get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception('UI Config not found');
      }
    } catch (e) {
      print("Error fetching UI Config: $e");
      throw e;
    }
  }
}
