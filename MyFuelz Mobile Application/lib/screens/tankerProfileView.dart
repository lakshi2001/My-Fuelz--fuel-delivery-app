import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TankerProfileView extends StatefulWidget {
  final String tankerId;

  const TankerProfileView({Key? key, required this.tankerId}) : super(key: key);

  @override
  _TankerProfileViewState createState() => _TankerProfileViewState();
}

class _TankerProfileViewState extends State<TankerProfileView> {
  late DatabaseReference _databaseRef;
  Map<String, dynamic>? _tankerData;
  late CollectionReference<Map<String, dynamic>> _reviewsRef;

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.reference().child('users').child(widget.tankerId);
    _reviewsRef = FirebaseFirestore.instance.collection('reviews');
    _fetchTankerData();
  }

  void _fetchTankerData() {
    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _tankerData = Map<String, dynamic>.from(event.snapshot.value as Map);
        });
      } else {
        print('Tanker data not found');
      }
    }, onError: (error) {
      print('Error fetching tanker data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanker Profile'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _tankerData != null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(_tankerData!['imageURL'] ?? ''),
                  radius: 50,
                ),
                const SizedBox(height: 20),
                Text(
                  _tankerData!['name'] ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  _tankerData!['email'] ?? 'Email not available',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  _tankerData!['phone'] ?? 'Phone number not available',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
              ],
            )
                : const CircularProgressIndicator(),

            const Divider(thickness: 2,),
            const SizedBox(height: 30,),
            const Text(
              'Reviews & Ratings',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _reviewsRef.where('serviceProviderId', isEqualTo: widget.tankerId).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No reviews found');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var reviewData = snapshot.data!.docs[index].data();
                      return ListTile(
                        title: Text(reviewData['review']),
                        subtitle: Row(
                          children: [
                            RatingBar.builder(
                              initialRating: reviewData['rating']?.toDouble() ?? 0,
                              minRating: 0,
                              maxRating: 5,
                              itemSize: 20,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (rating) {},
                            ),
                            const SizedBox(width: 5),
                            Text('${reviewData['rating']}'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
