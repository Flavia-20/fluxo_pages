import 'package:flutter/material.dart';
import 'login_page.dart';
import 'perfil_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final List<String> _itens = [
    'Tarefa Flutter',
    'Tarefa app',
    'tarefa desenvolvimento',
  ];

  //controle do que vai estar sendo colocado dentro da lista da home
  final TextEditingController _controller = TextEditingController();

  void _salvarTarefa(int? index){
    if(_controller.text.isEmpty) return ;

    setState(() {
      if(index == null) {
        _itens.add(_controller.text);
      } else {
        _itens[index] = _controller.text; 
      }
    });
    _controller.clear();
    Navigator.pop(context);//verificar a informação que ta na pilha para remover
  }

  void excluirTarefa(int index){
    setState(() {
      _itens.removeAt(index);
    });
  }

  void _mostrarFormulario([int? index]){
    if (index != null)_controller.text = _itens[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Adicionar Tarefa' : 'Editar Tarefa'),
        content: TextField(controller: _controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Concelar'),
            ),
          ElevatedButton(
            onPressed: () => _salvarTarefa(index),
            child: const Text('Salvar'),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Sair do sistema",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) =>  false,
                );
            },
          ),
        ],
      ),

      drawer:  Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text(
                'Menu', 
                style: TextStyle(color: Colors.white70, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Menu Perfil'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => const PerfilPage()),
              ),
            )
          ],
        )
      ),
      body:
      _itens.isEmpty
      ? const Center(child: Text('Nenhuma tarefa cadastrada'))
      : ListView.builder(
          itemCount:_itens.length,
          itemBuilder: (context, index){
            return Card (
              margin: const EdgeInsets.symmetric(
                horizontal: 15, 
                vertical: 6
                ),

                child: ListTile(
                  title: Text(_itens[index]),
                  trailing: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.cyan),
                        onPressed: () => _mostrarFormulario(index), 
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.deepOrange),
                          onPressed: () => excluirTarefa(index), 
                        )
                    ],
                  ),
                ),
            );
          }
        ),

         floatingActionButton: FloatingActionButton(
          onPressed: () => _mostrarFormulario(),
          child: const Icon(Icons.add),
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            items: const[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            ],
            onTap: (index){
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => const PerfilPage()),
                );
              }
            },
          ),
    );
  }
}