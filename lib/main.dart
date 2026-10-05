import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF673AB7), // Roxo moderno
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F5FF), // Fundo suave levemente arroxeado
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const TelaLista(),
    );
  }
}

// Modelo Item
class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  final List<Item> itens = [];

  void abrirTelaAdicionar() async {
    final Item? novoItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAdicionarItem(),
      ),
    );

    if (novoItem != null) {
      setState(() {
        itens.add(novoItem);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('${novoItem.nome} adicionado!'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void removerItem(int indice) {
    final itemRemovido = itens[indice];
    setState(() {
      itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${itemRemovido.nome} removido da lista'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int compradosCount = itens.where((item) => item.comprado).length;
    double progresso = itens.isEmpty ? 0 : compradosCount / itens.length;
    bool tudoComprado = itens.isNotEmpty && compradosCount == itens.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          'Lista de Compras',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: Colors.deepPurple.shade700,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$compradosCount de ${itens.length} comprados',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${(progresso * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progresso,
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: itens.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 72,
                      color: Colors.deepPurple.shade300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'A sua lista está vazia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione os itens que precisa de comprar.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                if (tudoComprado)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.green.shade700),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Parabéns! Todos os itens foram comprados.',
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: itens.length,
                    itemBuilder: (context, indice) {
                      final item = itens[indice];
                      return Card(
                        elevation: item.comprado ? 0 : 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: item.comprado
                                ? Colors.grey.shade300
                                : Colors.deepPurple.shade100,
                            width: 1,
                          ),
                        ),
                        color: item.comprado ? Colors.grey.shade100 : Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            setState(() {
                              item.comprado = !item.comprado;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  activeColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  value: item.comprado,
                                  onChanged: (valor) {
                                    setState(() {
                                      item.comprado = valor ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nome,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          decoration: item.comprado
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: item.comprado
                                              ? Colors.grey.shade500
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item.comprado
                                              ? Colors.grey.shade200
                                              : Colors.deepPurple.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Qtd: ${item.quantidade}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: item.comprado
                                                ? Colors.grey.shade600
                                                : Colors.deepPurple.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.redAccent.shade200,
                                  onPressed: () => removerItem(indice),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirTelaAdicionar,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text(
          'Novo Item',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  void salvar() {
    String nome = nomeController.text.trim();
    String quantidadeTexto = quantidadeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Por favor, introduza o nome do item.'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    int quantidade = int.tryParse(quantidadeTexto) ?? 1;

    Item novoItem = Item(
      nome: nome,
      quantidade: quantidade,
    );

    Navigator.pop(context, novoItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Item'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.deepPurple.shade100),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: nomeController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Nome do item',
                        hintText: 'Ex: Arroz, Feijão, Leite...',
                        prefixIcon: const Icon(Icons.shopping_bag_outlined, color: Colors.deepPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: quantidadeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Quantidade',
                        hintText: 'Ex: 1, 2, 3...',
                        prefixIcon: const Icon(Icons.format_list_numbered, color: Colors.deepPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: salvar,
              icon: const Icon(Icons.check),
              label: const Text(
                'Salvar Item',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}