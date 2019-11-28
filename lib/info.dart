import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  var texts = [
    {
      'about': '''
      
      
      Developed by:


      André Luiz - 201703731
      Aryane Ferreira - 201706986
      Paulo Lucas - 201700777
      
      
      
      
      
      
      
      Technologies used:
      ''',
      'title': 'About',
      'name': 'Notes',
    },
    {
      'about': '''
      
      
      Desenvolvido por:


      André Luiz - 201703731
      Aryane Ferreira - 201706986
      Paulo Lucas - 201700777
      
      
      
      
      
      
      
      Tecnologias usadas:
      ''',
      'title': 'Sobre',
      'name': 'Notas',
    },
  ];
  int language = 0;

  Info({this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(texts[language]['title']),
      ),
      body: ListView(
        children: <Widget>[
          Image(
              image: AssetImage('images/icon.png'),
              alignment: Alignment.center,
            ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                texts[language]['about'],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Image(
              image: AssetImage('images/logos.png'),
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }
}
