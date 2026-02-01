import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turismo_app/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Conexión con Firebase', (tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final firestore = FirebaseFirestore.instance;

    await firestore
        .collection('integration_test')
        .doc('connection')
        .set({'status': 'ok'});

    final snapshot = await firestore
        .collection('integration_test')
        .doc('connection')
        .get();

    expect(snapshot.exists, true);
    expect(snapshot['status'], 'ok');
  });
}
