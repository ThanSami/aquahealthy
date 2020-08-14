import 'package:aquahealthy/Clientes/registro.dart';
import 'package:aquahealthy/constantes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class LoginPage extends StatefulWidget{

  @override
  State createState() => LoginPageState();


}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{

  AnimationController _iconAnimationControler;
  Animation<double> _iconAnimation;

  @override
  void initState(){
    super.initState();
    _iconAnimationControler = new AnimationController(
        vsync: this,
      duration: new Duration(milliseconds: 500)
    );
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationControler,
        curve: Curves.bounceOut
    );
    _iconAnimation.addListener(()=> this.setState(() { }));
    _iconAnimationControler.forward();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
            color: Colors.black26,
            colorBlendMode: BlendMode.softLight,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image(
                image: new AssetImage("images/logooscuro.png"),
                width: _iconAnimation.value * 300,
              ),
              new Form(
                child: new Theme(
                  data: new ThemeData(
                    brightness: Brightness.light,
                      primarySwatch: Colors.teal,
                    inputDecorationTheme: new InputDecorationTheme(
                      labelStyle: new TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                      filled: true,
                      fillColor: Colors.black12,
                      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15.7),
                      )
                    )
                  ),
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(
                              labelText: "Usuario"
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        new TextFormField(
                          decoration: new InputDecoration(
                              labelText: "Contraseña"
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                onPressed: () {},
                                color: Constantes.colorSecundario,
                                child: Text("Ingresar", style: TextStyle(color: Colors.white),),
                                padding: const EdgeInsets.only(right: 3.0),
                              ),

                            ),
                            Expanded(
                              child: RaisedButton(
                                child: Text("Registrarme", style: TextStyle(color: Colors.white)),
                                color: Constantes.colorPrimario,
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegistroPage()),
                                  )
                                },
                                padding: const EdgeInsets.only(left: 3.0),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );

  }

}