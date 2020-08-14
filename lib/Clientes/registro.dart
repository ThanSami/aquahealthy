import 'package:aquahealthy/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sprintf/sprintf.dart';
import 'package:aquahealthy/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'package:aquahealthy/POCOs/tipoPersona.dart';
import 'package:aquahealthy/POCOs/frecuencia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:aquahealthy/POCOs/provincia.dart';
import 'package:aquahealthy/POCOs/canton.dart';
import 'package:aquahealthy/POCOs/distrito.dart';
import 'package:email_validator/email_validator.dart';

class RegistroPage extends StatefulWidget{

  @override
  State createState() => RegistroState();


}

class RegistroState extends State<RegistroPage> {

  final _formKey = GlobalKey<FormState>();

  var _keyScaffold = new GlobalKey<ScaffoldState>();

  final List<DropdownMenuItem> _condominios = [];

  TextEditingController _controladorNueva = new TextEditingController();
  TextEditingController _controladorConfirmacion = new TextEditingController();

  TipoPersona _tipoPersona;
  List<TipoPersona> _tipos = <TipoPersona>[
      const TipoPersona('01','Física'),
      const TipoPersona('02','Jurídica'),
      const TipoPersona('03','DIMEX'),
      const TipoPersona('04','NITE'),
  ];

  Frecuencia _frecuenciaEnvio;
  List<Frecuencia> _frecuencia = <Frecuencia>[
    const Frecuencia('1','Semanal'),
    const Frecuencia('15','Cada 15 días'),
    const Frecuencia('22','Cada 22 días'),
  ];

  List<dynamic> itemsList = List();

  String _identificacion = "";
  String _nombre = "";
  String _apellidos = "";
  String _telefono = "";
  String _celular = "";
  int _idProvincia = -1;
  int _idCanton = -1;
  int _idDistrito = -1;
  String _direccion = "";
  String _correo = "";

  bool _lunes = false;
  bool _martes = false;
  bool _miercoles = false;
  bool _jueves = false;
  bool _viernes = false;
  bool _sabado = false;
  bool _domingo = false;

  final List<DropdownMenuItem> _empresas = [];
  final List<DropdownMenuItem> _provincias = [];
  final List<DropdownMenuItem> _cantones = [];
  final List<DropdownMenuItem> _distritos = [];

  @override
  void initState(){
    this.getProvincias();
  }

  bool _mostrarIndicador = false;

  Future<String> getProvincias() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapListaProvincias,
          "Host": Constantes.host
        },
        body: Constantes.envelopeListaProvincias);

    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.listaProvinciasMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    this.setState(() {

      var _lista = parsedJson["Objeto"] as List;

      _lista.map((i)=>Provincia.fromJson(i)).toList().forEach((provincia) => {
        _provincias.add(DropdownMenuItem(
          child: Text(provincia.nombre),
          value: provincia.id,
        ))
      });

    });

    return "Success!";
  }

  Future<String> getCantones() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapListaCantones,
          "Host": Constantes.host
        },
        body: sprintf(Constantes.envelopeListaCantones, [ _idProvincia ] ));

    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.listaCantonesMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    this.setState(() {

      var _lista = parsedJson["Objeto"] as List;

      _lista.map((i)=>Canton.fromJson(i)).toList().forEach((canton) => {
        _cantones.add(DropdownMenuItem(
          child: Text(canton.nombre),
          value: canton.id,
        ))
      });

    });

    return "Success!";
  }

  Future<String> getDistritos() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapListaDistritos,
          "Host": Constantes.host
        },
        body: sprintf(Constantes.envelopeListaDistritos, [ _idProvincia, _idCanton ] ));

    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.listaDistritosMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    this.setState(() {

      var _lista = parsedJson["Objeto"] as List;

      _lista.map((i)=>Distrito.fromJson(i)).toList().forEach((distrito) => {
        _distritos.add(DropdownMenuItem(
          child: Text(distrito.nombre),
          value: distrito.id,
        ))
      });

    });

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: Text('Registro Usuario'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            image:  new DecorationImage(
              image: new AssetImage("images/background2.png"),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
            )
        ),
        child: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Form(
                key: _formKey,
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
                          contentPadding: const EdgeInsets.only(left: 5.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15.7),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15.7),
                          )
                      )
                  ),
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        DropdownButton<TipoPersona>(
                          isExpanded: true,
                          hint: Text('Seleccione el tipo de persona'),
                          value: _tipoPersona,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                            color: Constantes.colorPrimario,
                            fontSize: 16,
                          ),
                          underline: Container(
                            height: 2,
                            color: Constantes.colorPrimario
                          ),
                          onChanged: (TipoPersona value){
                            setState(() {
                              _tipoPersona = value;
                            });
                          },
                          items: _tipos.map((TipoPersona tipo) {
                            return new DropdownMenuItem<TipoPersona>(
                              value: tipo,
                              child: new Text(
                                tipo.nombre,
                                style: new TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                            labelText: "Identificación",
                            hintText: "Identificación",
                            icon: const Icon(Icons.art_track)
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 30,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar la identificación';
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            _identificacion = value;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Nombre",
                              hintText: "Nombre",
                              icon: const Icon(Icons.perm_contact_calendar)
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 100,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar el nombre';
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            _nombre = value;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Apellidos",
                              hintText: "Apellidos",
                              icon: const Icon(Icons.drag_handle)
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 100,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar los apellidos';
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            _apellidos = value;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Teléfono",
                              hintText: "Teléfono",
                              icon: const Icon(Icons.phone)
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 12,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar el teléfono';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _telefono = value;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Celular",
                              hintText: "Celular",
                              icon: const Icon(Icons.settings_cell)
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 12,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar el celular';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _celular = value;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                        ),
                        SearchableDropdown.single(
                          isExpanded: true,
                          items: _provincias,
                          value: _idProvincia,
                          hint: "Seleccione la provincia",
                          searchHint: "Seleccione la provincia",
                          onChanged: (value) {
                            setState(() {
                              _idProvincia = value;
                              getCantones();
                            });
                          },
                          validator: (value) {
                            if  (value == null){
                              return 'Debe seleccionar la provincia';
                            }
                            return null;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                        ),
                        SearchableDropdown.single(
                          isExpanded: true,
                          items: _cantones,
                          value: _idCanton,
                          hint: "Seleccione el cantón",
                          searchHint: "Seleccione el cantón",
                          onChanged: (value) {
                            setState(() {
                              _idCanton = value;
                              getDistritos();
                            });
                          },
                          validator: (value) {
                            if  (value == null){
                              return 'Debe seleccionar el cantón';
                            }
                            return null;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                        ),
                        SearchableDropdown.single(
                          isExpanded: true,
                          items: _distritos,
                          value: _idDistrito ,
                          hint: "Seleccione el distrito",
                          searchHint: "Seleccione el distrito",
                          onChanged: (value) {
                            setState(() {
                              _idDistrito = value;
                            });
                          },
                          validator: (value) {
                            if  (value == null){
                              return 'Debe seleccionar el distrito';
                            }
                            return null;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          autocorrect: false,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                            labelText: "Dirección",
                            hintText: 'Dirección',
                            icon: const Icon(Icons.map),
                            labelStyle:
                            new TextStyle(decorationStyle: TextDecorationStyle.solid),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 1000,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar la dirección';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _direccion = value;
                          },
                          maxLines: 5,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                            labelText: "Correo",
                            hintText: "Correo",
                            icon: const Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 350,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar el correo';
                            }

                            if (!EmailValidator.validate(value)){
                              return 'Correo no es válido';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _correo = value;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Divider(
                          height: 2.0,
                          color: Constantes.colorSecundario,
                          endIndent: 2.0,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Text('Preferencias Envío'),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _lunes,
                              onChanged: (value){
                                setState(() {
                                  _lunes = value;
                                });
                              },
                            ),
                            Text(
                              'Lunes'
                            )
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _martes,
                              onChanged: (value){
                                setState(() {
                                  _martes = value;
                                });
                              },
                            ),
                            Text(
                                'Martes'
                            )
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _miercoles,
                              onChanged: (value){
                                setState(() {
                                  _miercoles = value;
                                });
                              },
                            ),
                            Text(
                                'Miércoles'
                            )
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _jueves,
                              onChanged: (value){
                                setState(() {
                                  _jueves = value;
                                });
                              },
                            ),
                            Text(
                                'Jueves'
                            )
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _viernes,
                              onChanged: (value){
                                setState(() {
                                  _viernes = value;
                                });
                              },
                            ),
                            Text(
                                'Viernes'
                            )
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _sabado,
                              onChanged: (value){
                                setState(() {
                                  _sabado = value;
                                });
                              },
                            ),
                            Text(
                                'Sábado'
                            )
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _domingo,
                              onChanged: (value){
                                setState(() {
                                  _domingo = value;
                                });
                              },
                            ),
                            Text(
                                'Domingo'
                            )
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        DropdownButton<Frecuencia>(
                          isExpanded: true,
                          hint: Text('Seleccione Frecuencia envío'),
                          value: _frecuenciaEnvio,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                            color: Constantes.colorPrimario,
                          ),
                          underline: Container(
                              height: 2,
                              color: Constantes.colorPrimario
                          ),
                          onChanged: (Frecuencia value){
                            setState(() {
                              _frecuenciaEnvio = value;
                            });
                          },
                          items: _frecuencia.map((Frecuencia frecuencia) {
                            return new DropdownMenuItem<Frecuencia>(
                              value: frecuencia,
                              child: new Text(
                                frecuencia.nombre,
                                style: new TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:10.0),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: new MaterialButton(
                            color: Constantes.colorSecundario,
                            textColor: Constantes.colorTextoBoton,
                            height: 50.0,
                            minWidth: 100.0,
                            child: new Text(
                              "Registrarse",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: ()=>{

                              if (_formKey.currentState.validate()) {
                                setState((){
                                  _mostrarIndicador = true;
                                }),
                                _formKey.currentState.save(),

                                _Registarse()
                              }
                            },
                            splashColor: Constantes.colorSecundario,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                        ),
                        Visibility(
                          visible: _mostrarIndicador,
                          child: CircularProgressIndicator(),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  Future _Registarse() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapRegistro,
          "Host": Constantes.host
        },
        body: sprintf(
            Constantes.envelopeRegistro, [
                _tipoPersona.id, _identificacion, _nombre, _apellidos,
                _telefono, _celular, _idProvincia, _idCanton, _idDistrito,
                _direccion, _correo, "", Constantes.idApp,
                (_lunes==false ? 0 : 1),
                (_martes==false ? 0 : 1),
                (_miercoles==false ? 0 : 1),
                (_jueves==false ? 0 : 1),
                (_viernes==false ? 0 : 1),
                (_sabado==false ? 0 : 1),
                (_domingo==false ? 0 : 1),
                _frecuenciaEnvio.id ])).catchError((e) {
      setState((){
        _mostrarIndicador = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(sprintf("Error:%s", [e]), style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    });
    var _response = response.body;
    await _parsing(_response);

  }


  Future _parsing(var _response) async {
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.registroMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    if (!parsedJson["Error"])
    {
      setState((){
        _mostrarIndicador = false;
      });

      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Registro Clientes"),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Icon(
                              parsedJson["Error"] ? Icons.error : Icons.check_circle,
                              color: parsedJson["Error"] ? Colors.red : Colors.green,
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
                  if (!parsedJson["Error"]) {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginPage(),
                        ));
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ));
    } else
    {
      setState((){
        _mostrarIndicador = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["Mensaje"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    }

  }

}