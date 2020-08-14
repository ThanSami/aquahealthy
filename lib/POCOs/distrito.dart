class Distrito {
  int id;
  String nombre;

  Distrito(
      {this.id,
        this.nombre});

  Distrito.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nombre = json['Descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['Descripcion'] = this.nombre;
    return data;
  }
}