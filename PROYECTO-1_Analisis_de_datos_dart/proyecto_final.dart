import 'dart:io';
import 'dart:convert';

// I. Modelado de datos
class Registro {
  String nombre;
  int edad;
  double salario;
  Registro({required this.nombre, required this.edad, required this.salario});
  // Constructor para convertir de JSON a Objeto Dart
  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(
      nombre: json['nombre'] ?? 'Desconocido',
      edad: json['edad'] ?? 0,
      salario: (json['salario'] ?? 0.0).toDouble(),
    );
  }
  // Método para convertir de Objeto Dart a JSON
  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'edad': edad,
        'salario': salario,
      };

  @override
  String toString() => 'Nombre: $nombre, Edad: $edad, Salario: \$${salario.toStringAsFixed(2)}';
}
void main() {
  List<Registro> listaRegistros = [];
  // Carga inicial del archivo JSON
  try {
    String contenido = File('datos.json').readAsStringSync();
    List<dynamic> jsonList = jsonDecode(contenido);
    listaRegistros = jsonList.map((item) => Registro.fromJson(item)).toList();
    print("Archivo cargado exitosamente. (${listaRegistros.length} registros encontrados)");
  } catch (e) {
    print("Error al cargar datos.json: Asegúrate de que el archivo exista en la carpeta.");
    return; // Sale del programa si no hay datos
  }

  // IV. Interfaz en consola
  while (true) {
    print("\n--- MENÚ DE ANÁLISIS DE DATOS ---");
    print("1. Ver todos los registros");
    print("2. Buscar registro por nombre");
    print("3. Filtrar por salario mayor a...");
    print("4. Generar estadísticas y exportar resumen");
    print("5. Salir");
    stdout.write("Seleccione una opción: ");
    
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        print("\n📋 Lista de Registros:");
        for (var reg in listaRegistros) {
          print(reg.toString());
        }
        break;

      case "2":
        // II. Procesamiento y búsqueda
        stdout.write("Ingrese el nombre a buscar: ");
        String busqueda = (stdin.readLineSync() ?? '').toLowerCase();
        
        var resultados = listaRegistros.where((reg) => reg.nombre.toLowerCase().contains(busqueda)).toList();
        
        if (resultados.isEmpty) {
          print("No se encontraron registros para '$busqueda'.");
        } else {
          print("\nResultados encontrados:");
          for (var reg in resultados) {
            print(reg.toString());
          }
        }
        break;

      case "3":
        stdout.write("Ingrese el salario mínimo a filtrar: ");
        
        // Forzamos a que sea un double estricto, sin signos de interrogación en absoluto
        double salarioMinimo = double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;

        var filtrados = listaRegistros.where((reg) => reg.salario > salarioMinimo).toList();
        
        print("\nEmpleados con salario mayor a \$${salarioMinimo}:");
        for (var reg in filtrados) {
          print(reg.toString());
        }
        break;

      case "4":
        // III. Generación de reportes y estadísticas
        if (listaRegistros.isEmpty) break;

        double sumaSalarios = 0;
        int edadMin = listaRegistros[0].edad;
        int edadMax = listaRegistros[0].edad;

        for (var reg in listaRegistros) {
          sumaSalarios += reg.salario;
          if (reg.edad < edadMin) edadMin = reg.edad;
          if (reg.edad > edadMax) edadMax = reg.edad;
        }

        double promedioSalario = sumaSalarios / listaRegistros.length;

        // Crear mapa del resumen
        Map<String, dynamic> resumen = {
          "total_registros": listaRegistros.length,
          "promedio_salario": promedioSalario.toStringAsFixed(2),
          "edad_minima": edadMin,
          "edad_maxima": edadMax
        };

        // Imprimir en consola
        print("\n --- ESTADÍSTICAS ---");
        print("Total de registros: ${resumen['total_registros']}");
        print("Promedio de salario: \$${resumen['promedio_salario']}");
        print("Edad mínima: ${resumen['edad_minima']} años");
        print("Edad máxima: ${resumen['edad_maxima']} años");

        // Exportar a JSON
        File('resumen.json').writeAsStringSync(jsonEncode(resumen));
        print("\n Resumen exportado exitosamente en 'resumen.json'.");
        break;

      case "5":
        print("Saliendo del sistema... ¡Hasta luego!");
        return;

      default:
        print(" Opción inválida. Intente de nuevo.");
    }
  }
}