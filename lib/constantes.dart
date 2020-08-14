import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class Constantes {

  static final Color colorPrimario = Colors.indigo[900];
  static final Color colorSecundario = Colors.indigo;
  static final Color colorTextoBoton = Colors.white;

  static final String idApp = 'aquahealthy';

  //Produccion
  /*static String host = "facturas.opuscr.com";
  static String ulrWebService = sprintf("https://%s/wsFEBuilder/wsFEBuilder.asmx", [host]);
  static String ulrSitio = sprintf("https://%s/", [host]);*/

  //Pruebas
  static String host = "thanworld";
  static String ulrWebService = sprintf("http://%s/wsFEBuilder/wsFEBuilder.asmx", [host]);
  static String ulrSitio = sprintf("http://%s/Facturarte/", [host]);

  static String soap = "http://tempuri.org/%s";

  /* Region Provincias */
  static String listaProvinciasMethod = "getProvincias";
  static String urlSoapListaProvincias = sprintf(soap, [listaProvinciasMethod]);
  static String envelopeListaProvincias =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getProvincias xmlns=\"http://tempuri.org/\"> </getProvincias></soap:Body></soap:Envelope>";

  /* Region Cantones */
  static String listaCantonesMethod = "getCantones";
  static String urlSoapListaCantones = sprintf(soap, [listaCantonesMethod]);
  static String envelopeListaCantones =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getCantones xmlns=\"http://tempuri.org/\"> <idProvincia>%s</idProvincia> </getCantones></soap:Body></soap:Envelope>";

  /* Region Distritos */
  static String listaDistritosMethod = "getDistritos";
  static String urlSoapListaDistritos = sprintf(soap, [listaDistritosMethod]);
  static String envelopeListaDistritos =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getDistritos xmlns=\"http://tempuri.org/\"> <idProvincia>%s</idProvincia> <idCanton>%s</idCanton> </getDistritos></soap:Body></soap:Envelope>";

  static String registroMethod = "setRegistroApp";
  static String urlSoapRegistro = sprintf(soap, [registroMethod]);
  static String envelopeRegistro =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <setRegistroApp xmlns=\"http://tempuri.org/\"> <pTipoPersona>%s</pTipoPersona> <pIdentificacion>%s</pIdentificacion> <pNombre>%s</pNombre> <pApellidos>%s</pApellidos> <pTelefono>%s</pTelefono> <pCelular>%s</pCelular> <pIdProvincia>%s</pIdProvincia> <pIdCanton>%s</pIdCanton> <pIdDistrito>%s</pIdDistrito> <pDireccion>%s</pDireccion> <pCorreo>%s</pCorreo> <pComentario>%s</pComentario> <pIdApp>%s</pIdApp> <pLunes>%s</pLunes> <pMartes>%s</pMartes> <pMiercoles>%s</pMiercoles> <pJueves>%s</pJueves> <pViernes>%s</pViernes> <pSabado>%s</pSabado> <pDomingo>%s</pDomingo> <pFrecuencia>%s</pFrecuencia> </setRegistroApp></soap:Body></soap:Envelope>";

  /* Region Cantones */
  static String getCategoriasMethod = "getCategorias";
  static String urlSoapGetCategorias = sprintf(soap, [getCategoriasMethod]);
  static String envelopeGetCategorias =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getCategorias xmlns=\"http://tempuri.org/\"> <pIdApp>%s</pIdApp> </getCategorias></soap:Body></soap:Envelope>";

}

const FOOD_DATA = [
  {
    "name":"Bidon 1",
    "brand":"Manantial",
    "price":2600,
    "image":"bidon.png"
  },{
    "name":"Bidon 2",
    "brand":"Manantial",
    "price":2600,
    "image":"bidon2.png"
  },
  {
    "name":"Bidon 3",
    "brand":"Manantial",
    "price":2600,
    "image":"bidon3.png"
  },
  {
    "name":"Dispensador",
    "brand":"Manantial",
    "price":2000,
    "image":"dispensador1.png"
  },
  {
    "name":"Enfriador",
    "brand":"Manantial",
    "price":25000,
    "image":"enfriador.png"
  }

];
