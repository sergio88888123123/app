import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CatalogoPeliculasApp());
}

class CatalogoPeliculasApp extends StatelessWidget {
  const CatalogoPeliculasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo de Películas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FirebaseHomeScreen(),
    );
  }
}

class FirebaseHomeScreen extends StatefulWidget {
  const FirebaseHomeScreen({super.key});

  @override
  State<FirebaseHomeScreen> createState() => _FirebaseHomeScreenState();
}

class _FirebaseHomeScreenState extends State<FirebaseHomeScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();

  final CollectionReference<Map<String, dynamic>> _peliculasCollection =
      FirebaseFirestore.instance.collection('peliculas_favoritas');

  bool _guardando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _generoController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _agregarPelicula() async {
    final titulo = _tituloController.text.trim();
    final genero = _generoController.text.trim();
    final comentario = _comentarioController.text.trim();

    if (titulo.isEmpty || genero.isEmpty || comentario.isEmpty) {
      _mostrarMensaje('Completa todos los campos antes de guardar.');
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      await _peliculasCollection.add({
        'titulo': titulo,
        'genero': genero,
        'comentario': comentario,
        'fechaRegistro': FieldValue.serverTimestamp(),
      });

      _tituloController.clear();
      _generoController.clear();
      _comentarioController.clear();

      _mostrarMensaje('Película agregada correctamente en Firebase.');
    } catch (error) {
      _mostrarMensaje('No se pudo guardar el registro: $error');
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  void _mostrarMensaje(String texto) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _obtenerPeliculas() {
    return _peliculasCollection
        .orderBy('fechaRegistro', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Películas'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              _buildFormulario(),
              const SizedBox(height: 24),
              const Text(
                'Registros guardados en Firebase',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildListado(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.cloud_done_outlined,
            color: Colors.white,
            size: 70,
          ),
          SizedBox(height: 14),
          Text(
            'Integración de Firebase',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Esta pantalla permite agregar datos a Cloud Firestore desde una aplicación Flutter.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulario() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Agregar película',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título de la película',
                prefixIcon: Icon(Icons.movie_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _generoController,
              decoration: const InputDecoration(
                labelText: 'Género',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _comentarioController,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Comentario',
                prefixIcon: Icon(Icons.comment_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _guardando ? null : _agregarPelicula,
              icon: _guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_guardando ? 'Guardando...' : 'Guardar en Firebase'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListado() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _obtenerPeliculas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error al leer datos de Firebase: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final documentos = snapshot.data?.docs ?? [];

        if (documentos.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Aún no hay películas registradas. Agrega una desde el formulario.',
              ),
            ),
          );
        }

        return Column(
          children: documentos.map((documento) {
            final datos = documento.data();
            final titulo = datos['titulo'] ?? 'Sin título';
            final genero = datos['genero'] ?? 'Sin género';
            final comentario = datos['comentario'] ?? 'Sin comentario';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.local_movies_outlined),
                ),
                title: Text(
                  titulo.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Género: $genero\nComentario: $comentario'),
                isThreeLine: true,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
