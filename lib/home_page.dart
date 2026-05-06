import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'perfil_page.dart';
import 'tarefa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tarefa> _itens = [
    Tarefa(
      titulo: 'Flutter',
      descricao: 'Tarefa de Flutter',
      concluida: false,
    ),
    Tarefa(
      titulo: 'Dart',
      descricao: 'Prática de Dart',
      concluida: false,
    ),
    Tarefa(
      titulo: 'Projeto',
      descricao: 'Projeto Integrador',
      concluida: false,
    ),
  ];

  final TextEditingController _tituloController =
      TextEditingController();

  final TextEditingController _descricaoController =
      TextEditingController();

  static const String chaveTarefas = "lista_tarefas";

  bool _modoBusca = false;

  final TextEditingController _buscaController =
      TextEditingController();

  String _textoBusca = "";

  @override
  void initState() {
    super.initState();

    _carregarTarefas();

    _buscaController.addListener(() {
      setState(() {
        _textoBusca =
            _buscaController.text.toLowerCase();
      });
    });
  }

  Future<void> _salvarNoStorage() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> tarefasJson = _itens.map((tarefa) {
      return jsonEncode({
        "titulo": tarefa.titulo,
        "descricao": tarefa.descricao,
        "concluida": tarefa.concluida,
      });
    }).toList();

    await prefs.setStringList(
      chaveTarefas,
      tarefasJson,
    );
  }

  Future<void> _carregarTarefas() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? tarefasSalvas =
        prefs.getStringList(chaveTarefas);

    if (tarefasSalvas != null) {
      setState(() {
        _itens = tarefasSalvas.map((item) {
          final dados = jsonDecode(item);

          return Tarefa(
            titulo: dados["titulo"],
            descricao: dados["descricao"],
            concluida: dados["concluida"],
          );
        }).toList();
      });
    } else {
      _itens = [
        Tarefa(
          titulo: 'Flutter',
          descricao: 'Tarefa de Flutter',
          concluida: false,
        ),
        Tarefa(
          titulo: 'Dart',
          descricao: 'Prática de Dart',
          concluida: false,
        ),
        Tarefa(
          titulo: 'Projeto',
          descricao: 'Projeto Integrador',
          concluida: false,
        ),
      ];

      _salvarNoStorage();
    }
  }

  void _salvarTarefa(int? index) async {
    if (_tituloController.text.isEmpty ||
        _descricaoController.text.isEmpty) {
      return;
    }

    setState(() {
      if (index == null) {
        _itens.add(
          Tarefa(
            titulo: _tituloController.text,
            descricao: _descricaoController.text,
            concluida: false,
          ),
        );
      } else {
        _itens[index] = Tarefa(
          titulo: _tituloController.text,
          descricao: _descricaoController.text,
          concluida: _itens[index].concluida,
        );
      }
    });

    await _salvarNoStorage();

    _tituloController.clear();
    _descricaoController.clear();

    Navigator.pop(context);
  }

  void _excluirTarefa(int index) async {
    setState(() {
      _itens.removeAt(index);
    });

    await _salvarNoStorage();
  }

  void _mostrarFormulario([int? index]) {
    if (index != null) {
      _tituloController.text = _itens[index].titulo;
      _descricaoController.text =
          _itens[index].descricao;
    } else {
      _tituloController.clear();
      _descricaoController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          index == null
              ? 'Nova Tarefa'
              : 'Editar Tarefa',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () =>
                _salvarTarefa(index),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tarefasFiltradas = _itens.where((tarefa) {
      return tarefa.titulo
          .toLowerCase()
          .contains(_textoBusca);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: _modoBusca
            ? TextField(
                controller: _buscaController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar tarefa...',
                  border: InputBorder.none,
                ),
              )
            : const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(
              _modoBusca
                  ? Icons.close
                  : Icons.search,
            ),
            onPressed: () {
              setState(() {
                if (_modoBusca) {
                  _modoBusca = false;
                  _buscaController.clear();
                  _textoBusca = "";
                } else {
                  _modoBusca = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair do Sistema',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration:
                  BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Meu Perfil'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const PerfilPage(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: tarefasFiltradas.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma tarefa cadastrada.",
              ),
            )
          : ListView.builder(
              itemCount: tarefasFiltradas.length,
              itemBuilder: (context, index) {
                final tarefa =
                    tarefasFiltradas[index];

                final indexOriginal =
                    _itens.indexOf(tarefa);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      tarefa.titulo,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    subtitle:
                        Text(tarefa.descricao),
                    trailing: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: tarefa.concluida,
                          onChanged:
                              (value) async {
                            setState(() {
                              _itens[indexOriginal]
                                      .concluida =
                                  value ??
                                      false;
                            });

                            await _salvarNoStorage();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () =>
                              _mostrarFormulario(
                            indexOriginal,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              _excluirTarefa(
                            indexOriginal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () =>
            _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const PerfilPage(),
              ),
            );
          }
        },
      ),
    );
  }
}