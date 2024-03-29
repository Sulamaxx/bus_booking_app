// import 'package:cloud_firestore/cloud_firestore.dart';
//
// Future<void> getRoutes()async{
//   try{
//     QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection('routes').get();
//
//
//     for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
//       Object? data = documentSnapshot.data();
//       print('Route ID: ${documentSnapshot.id}');
//       print('Route Name: ${data['routeName']}');
//       print('Route Number: ${data['routeNumber']}');
//       print('Origin: ${data['origin']}');
//       print('Destination: ${data['destination']}');
//     }
//   }catch(e){
//     print("Error : $e");
//   }
// }
//
// Future<void> getBusesForRoute(String routeId) async {
//   try {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('routes')
//         .doc(routeId)
//         .collection('buses')
//         .get();
//
//     for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
//       Object? data = documentSnapshot.data();
//       print('Bus ID: ${documentSnapshot.id}');
//       print('Bus Name: ${documentSnapshot['busName']}');
//       print('Bus Number: ${documentSnapshot['busNumber']}');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }
