
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PokemonHttpScreen(),
    );
  }
}

class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String imageUrl;
  final String types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;
    final other = sprites['other'] as Map<String, dynamic>?;
    final officialArtwork =
        other?['official-artwork'] as Map<String, dynamic>?;

    final imageUrl = officialArtwork?['front_default'] as String? ??
        sprites['front_default'] as String? ??
        '';

    final pokemonTypes = (json['types'] as List<dynamic>)
        .map((item) => item['type']['name'].toString())
        .join(', ');

    return Pokemon(
      id: json['id'] as int,
      name: json['name'].toString(),
      height: json['height'] as int,
      weight: json['weight'] as int,
      imageUrl: imageUrl,
      types: pokemonTypes,
    );
  }
}

Future<Pokemon> fetchPokemon(String pokemonName) async {
  final cleanName = pokemonName.trim().toLowerCase();

  if (cleanName.isEmpty) {
    throw Exception('Escribe el nombre de un Pokémon.');
  }

  final uri = Uri.https('pokeapi.co', '/api/v2/pokemon/$cleanName');

  final response = await http.get(
    uri,
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Pokemon.fromJson(data);
  }

  if (response.statusCode == 404) {
    throw Exception('No se encontró el Pokémon solicitado.');
  }

  throw Exception('Error al consultar la API. Código: ${response.statusCode}');
}

class PokemonHttpScreen extends StatefulWidget {
  const PokemonHttpScreen({super.key});

  @override
  State<PokemonHttpScreen> createState() => _PokemonHttpScreenState();
}

class _PokemonHttpScreenState extends State<PokemonHttpScreen> {
  final TextEditingController _controller = TextEditingController(text: 'pikachu');
  late Future<Pokemon> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = fetchPokemon(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _buscarPokemon() {
    setState(() {
      _pokemonFuture = fetchPokemon(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peticiones HTTP'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fondo_home.png',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black54),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.public,
                    color: Colors.white,
                    size: 72,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Catálogo de Películas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Consulta de datos desde Internet usando HTTP y PokeAPI.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _buscarPokemon(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Nombre del Pokémon',
                      hintText: 'Ejemplo: pikachu, charizard, ditto',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _buscarPokemon,
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: const Text('Realizar petición HTTP'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FutureBuilder<Pokemon>(
                    future: _pokemonFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 54,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  snapshot.error.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final pokemon = snapshot.data!;

                      return Card(
                        color: Colors.white,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            children: [
                              Text(
                                '#${pokemon.id} ${pokemon.name.toUpperCase()}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 14),
                              if (pokemon.imageUrl.isNotEmpty)
                                Image.network(
                                  pokemon.imageUrl,
                                  height: 170,
                                  fit: BoxFit.contain,
                                )
                              else
                                const Icon(Icons.image_not_supported, size: 120),
                              const SizedBox(height: 18),
                              _InfoRow(
                                label: 'Tipo',
                                value: pokemon.types,
                              ),
                              _InfoRow(
                                label: 'Altura',
                                value: '${pokemon.height}',
                              ),
                              _InfoRow(
                                label: 'Peso',
                                value: '${pokemon.weight}',
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Datos obtenidos mediante una petición HTTP GET.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
