import 'package:flutter/material.dart';
import 'login_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // Nome atual do usuário
  String nomeUsuario = 'Professor de Flutter';

  // Controller
  final TextEditingController _perfilController =
      TextEditingController();

  // SALVAR EDIÇÃO
  void _salvarEdicao() {
    if (_perfilController.text.isEmpty) return;

    setState(() {
      // Substitui o nome antigo pelo novo
      nomeUsuario = _perfilController.text;
    });

    _perfilController.clear();

    Navigator.pop(context);
  }


  @override
  void dispose() {
    _perfilController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil'),
    ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                nomeUsuario,
                style: const TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold
                ),
              ),

              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _perfilController.text = nomeUsuario;

                   showModalBottomSheet(
                    context: context,

                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(16.0),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Editar Perfil', 
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold
                              )
                            ),

                          const SizedBox(height: 10),

                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Nome'
                            ),
                            controller: _perfilController,
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: _salvarEdicao,
                            child: const Text('Salvar'),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
      
            const Text('professor@email.com'),
            const SizedBox(height: 40),

            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar para a home'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(200, 45)),
            ),
            const SizedBox(height: 15),
          
            ElevatedButton.icon(
               onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmar saída"),
                      content: const Text("Deseja realmente sair do sistema?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Fecha o dialog
                          },
                          child: const Text("Cancelar"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Sair"),
                      ),
                      ],
                    );
                  },
                );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sair do sistema'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 45),
              ),
            ),
          ]
        )
      )
    );
  }
}