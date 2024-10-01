import 'package:flutter/material.dart';

void main() {
  runApp(AppBancario());
}

class AppBancario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação Bancária',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaListaContas(),
    );
  }
}

class Conta {
  String nome;
  String saldo;

  Conta({required this.nome, required this.saldo});
}

class TelaListaContas extends StatefulWidget {
  @override
  _TelaListaContasState createState() => _TelaListaContasState();
}

class _TelaListaContasState extends State<TelaListaContas> {
  List<Conta> contas = [];

  void _adicionarConta(Conta conta) {
    setState(() {
      contas.add(conta);
    });
  }

  void _deletarConta(int index) {
    setState(() {
      contas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contas'),
      ),
      body: contas.isEmpty
          ? Center(child: Text('Nenhuma conta cadastrada.'))
          : ListView.builder(
              itemCount: contas.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.account_balance),
                    title: Text(contas[index].nome),
                    subtitle: Text('Saldo: R\$ ${contas[index].saldo}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deletarConta(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaConta = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaFormulario()),
          );
          if (novaConta != null) {
            _adicionarConta(novaConta);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TelaFormulario extends StatefulWidget {
  @override
  _TelaFormularioState createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _controladorNome = TextEditingController();
  final _controladorSaldo = TextEditingController();

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorSaldo.dispose();
    super.dispose();
  }

  void _salvarConta() {
    if (_formKey.currentState!.validate()) {
      final conta = Conta(
        nome: _controladorNome.text,
        saldo: _controladorSaldo.text,
      );
      Navigator.pop(context, conta);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controladorNome,
                decoration: InputDecoration(labelText: 'Nome da Conta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome da conta';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controladorSaldo,
                decoration: InputDecoration(labelText: 'Saldo Inicial'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o saldo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarConta,
                child: Text('Salvar Conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
