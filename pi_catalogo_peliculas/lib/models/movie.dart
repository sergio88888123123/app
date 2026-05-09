import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  const Movie({
    this.id,
    required this.titulo,
    required this.anio,
    required this.director,
    required this.genero,
    required this.sinopsis,
    required this.imagenUrl,
  });

  final String? id;
  final String titulo;
  final String anio;
  final String director;
  final String genero;
  final String sinopsis;
  final String imagenUrl;

  factory Movie.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Movie(
      id: doc.id,
      titulo: data['titulo'] as String? ?? 'Sin título',
      anio: data['anio'] as String? ?? 'Sin año',
      director: data['director'] as String? ?? 'Sin director',
      genero: data['genero'] as String? ?? 'Sin género',
      sinopsis: data['sinopsis'] as String? ?? 'Sin sinopsis disponible.',
      imagenUrl: data['imagenUrl'] as String? ?? '',
    );
  }

  factory Movie.fromStudioGhibliApi(Map<String, dynamic> json) {
    return Movie(
      titulo: json['title'] as String? ?? 'Sin título',
      anio: json['release_date'] as String? ?? 'Sin año',
      director: json['director'] as String? ?? 'Sin director',
      genero: 'Animación / Aventura',
      sinopsis: json['description'] as String? ?? 'Sin sinopsis disponible.',
      imagenUrl: json['image'] as String? ?? json['movie_banner'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'anio': anio,
      'director': director,
      'genero': genero,
      'sinopsis': sinopsis,
      'imagenUrl': imagenUrl,
      'fechaActualizacion': FieldValue.serverTimestamp(),
    };
  }
}
