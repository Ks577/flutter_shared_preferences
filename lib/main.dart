import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week6_dart_ideal_list/widgets/background.dart';
import 'package:week6_dart_ideal_list/widgets/custom_text_field.dart';
import 'model.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    scrollBehavior: const ScrollBehavior(),
    routes: {
      '/': (context) => const Home(),
      '/Idea': (context) => const IdeaScreen(),
    },
    initialRoute: '/',
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _listIdeas = [];
  final TextEditingController _ideaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ideas = prefs.getStringList('ideas') ?? [];
    setState(() {
      _listIdeas = ideas;
    });
  }

  Future<void> _saveIdeas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('ideas', _listIdeas);
  }

  void addIdea(String idea) {
    setState(() {
      _listIdeas.add(idea);
      _saveIdeas();
    });
  }

  void deleteIdea(int indexIdea) {
    setState(() {
      _listIdeas.remove(_listIdeas.elementAt(indexIdea));
      _saveIdeas();
    });
  }

  void editIdea(String newIdea, int indexIdea) {
    setState(() {
      _listIdeas[indexIdea] = newIdea;
      _saveIdeas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent.shade700,
          title: const Text('My unique ideas'),
          centerTitle: true,
        ),
        body: Stack(children: [
          background(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 45, horizontal: 20),
            child: Column(children: [
              customTextField(
                  hintText: 'write an idea',
                  controller: _ideaController,
                  onSubmitted: ((value) {
                    setState(() {
                      if (_ideaController.text.isNotEmpty) {
                        setState(() {
                          addIdea(value);
                        });
                      }
                    });
                  })),
              const SizedBox(height: 20),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _listIdeas.length, //длинна списка
                      itemBuilder: (context, index) {
                        return Card(
                            elevation: 8,
                            color: Colors.white54,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Column(children: [
                              ListTile(
                                tileColor: Colors.deepPurpleAccent[600],
                                title: Text(_listIdeas[index]),
                                trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => deleteIdea(index)),
                                onTap: () {
                                  Navigator.pushNamed(context, '/Idea',
                                      arguments: Idea(
                                        valueIdea: _listIdeas.elementAt(index),
                                        indexIdea: index,
                                        editIdea: editIdea,
                                        deleteIdea: deleteIdea,
                                      ));
                                  const SizedBox(height: 8);
                                },
                              )
                            ]));
                      }))
            ]),
          )
        ]));
  }
}

class IdeaScreen extends StatefulWidget {
  const IdeaScreen({Key? key}) : super(key: key);

  @override
  State<IdeaScreen> createState() => _IdeaScreenState();
}

class _IdeaScreenState extends State<IdeaScreen> {
  @override
  Widget build(BuildContext context) {
    var argument = ModalRoute.of(context)?.settings.arguments as Idea;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text(argument.valueIdea),
            actions: [
              IconButton(
                onPressed: () {
                  argument.deleteIdea(argument.indexIdea);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete_rounded),
              )
            ]),
        body: Stack(children: [
          background(),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
              child: customTextField(
                controller: TextEditingController(),
                hintText: 'editor idea',
                onSubmitted: ((value) {
                  argument.editIdea(value, argument.indexIdea);
                  Navigator.of(context).pop();
                }),
              ),
            ),
          )
        ]));
  }
}
