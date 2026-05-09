import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/http_movies_service.dart';
import '../services/movie_repository.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _anioController = TextEditingController();
  final _directorController = TextEditingController();
  final _generoController = TextEditingController();
  final _sinopsisController = TextEditingController();
  final _imagenUrlController = TextEditingController();

  final _repository = MovieRepository();
  final _httpService = HttpMoviesService();
  bool _saving = false;
  bool _importing = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _anioController.dispose();
    _directorController.dispose();
    _generoController.dispose();
    _sinopsisController.dispose();
    _imagenUrlController.dispose();
    _httpService.dispose();
    super.dispose();
  }

  Future<void> _saveMovie() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final movie = Movie(
        titulo: _tituloController.text.trim(),
        anio: _anioController.text.trim(),
        director: _directorController.text.trim(),
        genero: _generoController.text.trim(),
        sinopsis: _sinopsisController.text.trim(),
        imagenUrl: _imagenUrlController.text.trim(),
      );

      await _repository.addMovie(movie);
      _clearForm();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película guardada en Firebase.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $error')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _importFromHttpApi() async {
    setState(() => _importing = true);
    try {
      final movies = await _httpService.fetchMoviesFromApi();
      await _repository.importMovies(movies.take(8).toList());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Películas importadas desde API HTTP y guardadas en Firebase.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al importar desde HTTP: $error')),
      );
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  void _clearForm() {
    _tituloController.clear();
    _anioController.clear();
    _directorController.clear();
    _generoController.clear();
    _sinopsisController.clear();
    _imagenUrlController.clear();
  }

  Future<void> _deleteMovie(Movie movie) async {
    if (movie.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar película'),
        content: Text('¿Deseas eliminar "${movie.titulo}" del catálogo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    await _repository.deleteMovie(movie.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Película eliminada de Firebase.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Pantalla de administración',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Da de alta películas manualmente o importa registros desde una API HTTP. Todos los cambios se guardan en Cloud Firestore.',
                  ),
                  const SizedBox(height: 18),
                  _TextField(controller: _tituloController, label: 'Título'),
                  _TextField(controller: _anioController, label: 'Año'),
                  _TextField(controller: _directorController, label: 'Director'),
                  _TextField(controller: _generoController, label: 'Género'),
                  _TextField(controller: _imagenUrlController, label: 'URL de imagen'),
                  _TextField(
                    controller: _sinopsisController,
                    label: 'Sinopsis',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _saving ? null : _saveMovie,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: const Text('Guardar película en Firebase'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _importing ? null : _importFromHttpApi,
                    icon: _importing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_download_outlined),
                    label: const Text('Importar películas desde API HTTP'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Películas registradas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        StreamBuilder<List<Movie>>(
          stream: _repository.watchMovies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final movies = snapshot.data ?? [];
            if (movies.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('No hay películas registradas.'),
                ),
              );
            }

            return Column(
              children: movies.map((movie) {
                return Card(
                  child: ListTile(
                    leading: movie.imagenUrl.isEmpty
                        ? const Icon(Icons.movie_outlined)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie.imagenUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.movie_outlined),
                            ),
                          ),
                    title: Text(movie.titulo),
                    subtitle: Text('${movie.anio} • ${movie.director}'),
                    trailing: IconButton(
                      tooltip: 'Eliminar película',
                      onPressed: () => _deleteMovie(movie),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Campo requerido';
          }
          return null;
        },
      ),
    );
  }
}
