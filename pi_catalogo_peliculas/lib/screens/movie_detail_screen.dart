import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.titulo)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: movie.imagenUrl.isEmpty
                ? Container(
                    height: 280,
                    color: Colors.deepPurple.shade50,
                    child: const Icon(Icons.image_not_supported_outlined, size: 70),
                  )
                : Image.network(
                    movie.imagenUrl,
                    height: 320,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 280,
                      color: Colors.deepPurple.shade50,
                      child: const Icon(Icons.broken_image_outlined, size: 70),
                    ),
                  ),
          ),
          const SizedBox(height: 22),
          Text(
            movie.titulo,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 14),
          _InfoRow(label: 'Año', value: movie.anio),
          _InfoRow(label: 'Director', value: movie.director),
          _InfoRow(label: 'Género', value: movie.genero),
          const SizedBox(height: 18),
          const Text(
            'Sinopsis',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            movie.sinopsis,
            style: const TextStyle(fontSize: 16, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
