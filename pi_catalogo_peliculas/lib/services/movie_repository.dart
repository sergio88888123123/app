import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/movie.dart';

class MovieRepository {
  MovieRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('peliculas');

  Stream<List<Movie>> watchMovies() {
    return _collection.orderBy('titulo').snapshots().map(
          (snapshot) => snapshot.docs.map(Movie.fromFirestore).toList(),
        );
  }

  Future<void> addMovie(Movie movie) async {
    await _collection.add(movie.toMap());
  }

  Future<void> deleteMovie(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> importMovies(List<Movie> movies) async {
    final batch = _firestore.batch();
    for (final movie in movies) {
      final doc = _collection.doc();
      batch.set(doc, movie.toMap());
    }
    await batch.commit();
  }
}
