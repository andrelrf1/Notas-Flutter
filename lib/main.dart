import 'package:Notas/info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notas',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  var texts = [
    {
      'bar1': 'Notes',
      'bar2': 'Create',
      'load': 'Loading...',
      'add': 'Add',
      'barbutton': 'Translate',
      'title': 'Title',
      'note': 'Note',
      'about': 'About',
    },
    {
      'bar1': 'Notas',
      'bar2': 'Criar',
      'load': 'Carregando...',
      'add': 'Adicionar',
      'barbutton': 'Traduzir',
      'title': 'Título',
      'note': 'Nota',
      'about': 'Sobre'
    },
  ];
  int language = 0;

  void translate() {
    if (this.language == 1) {
      this.language = 0;
    } else {
      this.language = 1;
    }
  }

  void _newNota(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Create(
          texts: this.texts[this.language],
        ),
      ),
    );
  }

  void _editNota(BuildContext context, DocumentSnapshot note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Create(
          texts: this.texts[this.language],
          note: note,
        ),
      ),
    );
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.texts[widget.language]['bar1']),
        actions: <Widget>[
          IconButton(
            tooltip: widget.texts[widget.language]['about'],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Info(
                    language: widget.language,
                  ),
                ),
              );
            },
            icon: Icon(Icons.info_outline),
          ),
          IconButton(
            tooltip: widget.texts[widget.language]['barbutton'],
            onPressed: () {
              setState(() {
                widget.translate();
              });
            },
            icon: Icon(Icons.translate),
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('notes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Align(
              alignment: Alignment.center,
              child: Text(
                widget.texts[widget.language]['load'],
              ),
            );

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot note = snapshot.data.documents[index];
              return Padding(
                padding: EdgeInsets.all(1.0),
                child: Card(
                  child: Container(
                    height: 270,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            note['title'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          height: 150,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                note['note'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                note.reference.delete();
                              },
                              icon: Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {
                                widget._editNota(context, note);
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget._newNota(context);
        },
        tooltip: widget.texts[widget.language]['add'],
        child: Icon(Icons.add),
      ),
    );
  }
}

class Create extends StatefulWidget {
  var texts;
  DocumentSnapshot note;

  Create({
    Key key,
    @required this.texts,
    this.note,
  }) : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  var titleCtrl = TextEditingController();
  var noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleCtrl = new TextEditingController(text: widget.note['title']);
      noteCtrl = new TextEditingController(text: widget.note['note']);
    }
  }

  void _returnScrenn(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.texts['bar2']),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (widget.note != null) {
                widget.note.reference.updateData(
                  {
                    'title': titleCtrl.text,
                    'note': noteCtrl.text,
                  },
                );
              } else {
                Firestore.instance.collection('notes').add(
                  {
                    'title': titleCtrl.text,
                    'note': noteCtrl.text,
                  },
                );
              }
              _returnScrenn(context);
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    hintText: widget.texts['title'],
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Card(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: noteCtrl,
                  decoration: InputDecoration(
                    hintText: widget.texts['note'],
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 30,
                  maxLines: 30,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
