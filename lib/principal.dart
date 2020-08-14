import 'package:aquahealthy/login.dart';
import 'package:flutter/material.dart';
import 'constantes.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:sprintf/sprintf.dart';
import 'dart:convert';

class PrincipalPage extends StatefulWidget{

  @override
  State createState() => PrincipalPageState();

}

class PrincipalPageState extends State<PrincipalPage> {

  List<Widget> _categorias = [];

  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  Future getPostsData() {
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(GestureDetector(
        onTap: () {

        },
        child: Container(
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Hero(
                tag: post["name"],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Text(
                          post["name"],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          post["brand"],
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "\¢ ${post["price"]}",
                          style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Image.asset(
                      "images/${post["image"]}",
                      height: double.infinity,
                    )
                  ],
                ),
              ),
            )),
      ));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();

    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;

    _buildItems();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constantes.colorPrimario,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                color: Colors.white,
                onPressed: () { Scaffold.of(context).openDrawer(); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
              },
            )
          ],
        ),
        body: Container(
          height: size.height,
          //color: Colors.grey.shade200,
          decoration: new BoxDecoration(
              color: Colors.white,
              image:  new DecorationImage(
                image: new AssetImage("images/dropsbackground.png"),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              )
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Categorías",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer?0:1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer?0:categoryHeight,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                          child: Row(
                            children: _categorias,
                          ),
                        ),
                      ),
                    )
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform:  Matrix4.identity()..scale(scale,scale),
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                heightFactor: 0.7,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }

  /*_buildItems(BuildContext context) {

    _categorias..addAll(_buildContext(context, 'wrap.png', 'Más\nFavoritos', "20"))
      ..addAll(_buildContext(context, 'sandwich.png', 'Newest', "15"))
      ..addAll(_buildContext(context, 'noodles.png', 'Super\nDescuentos', "18"));

  }*/

  Future _buildItems() async {

    List<Widget> children = [];

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapGetCategorias,
          "Host": Constantes.host
        },
        body: sprintf(Constantes.envelopeGetCategorias, [Constantes.idApp])).catchError((e) {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Consulta categorías"),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 24.0,),
                          new Text(sprintf("Error:%s", [e])),
                        ],
                      ),
                    ),
                  ),
                ]
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    });
    var _response = response.body;

    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.getCategoriasMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    if (!parsedJson["Error"])
    {

        List<Widget> _categoriasTMP = [];
        List<dynamic> responseList = parsedJson["Objeto"];
        responseList.forEach((post) {
          _categoriasTMP..addAll(_buildContext(context, sprintf(post["Imagen"].toString().replaceAll('~', '%s'), [Constantes.ulrSitio]), post["Descripcion"], ""));
        });

        setState(() {
          _categorias = _categoriasTMP;
        });
    } else
    {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Consulta categorías"),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 24.0,),
                          new Text(parsedJson["Mensaje"]),
                        ],
                      ),
                    ),
                  ),
                ]
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    }

  }

  List<Widget> _buildContext(BuildContext context, String image, String texto, String cantidad) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.30 - 50;

    return [
      Container(
        width: 150,
        margin: EdgeInsets.only(right: 20),
        height: categoryHeight,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 3
            ) ,
            image: DecorationImage(
                image: NetworkImage(image), // AssetImage("images/${image}"),
                fit: BoxFit.scaleDown,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.softLight)
            ) ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                texto,
                style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${cantidad}",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          ),
        ),
      )
    ];
  }
}
