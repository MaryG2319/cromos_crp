import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cromos do CRP',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: Color.fromRGBO(235, 98, 8, 1),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Cromo> initcromos = [];
  List<Cromo> cromos = [];
  List<String> escaloes = [
    'Todos',
    'Clube',
    'Seniores Masculinos',
    'Seniores Femininos',
    'Juniores Masculinos',
    'Juniores Femininos',
    'Juvenis',
    'Iniciados',
    'Direção',
    'Sede',
    'Infantis',
    'Benjamins',
    'Traquinas e Petizes',
    'Atletismo',
    'Ciclismo',
    'Patinagem',
  ];
  String selectedEscalao = 'Todos';
  List<String> estado = [
    'Todos',
    'Tem',
    'Não Tem',
  ];
  String selectedEstado = 'Todos';


  @override
  void initState() {
    super.initState();
    initcromos = getCromos();
    cromos = getCromos();
    loadCromoStates();  
  }

  Future<void> saveCromoState(int id, bool state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cromo_$id', state);
  }

  Future<void> loadCromoStates() async {
    final prefs = await SharedPreferences.getInstance();
    for (var cromo in cromos) {
      bool? savedState = prefs.getBool('cromo_${cromo.id}');
      if (savedState != null) {
        cromo.jaTem = savedState;
      }
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    double cardWidth = context.width() / 2;
    double cardHeight = context.height() / 3.5;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Cromos do CRP', style: TextStyle(color: white),),
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title text and dropdowns
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Text('Escalão:', style: boldTextStyle(color: black),),
          ),          
          DropdownButton(
            isExpanded: true,
            padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
            dropdownColor: Colors.white,
            value: selectedEscalao,
            items: escaloes.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedEscalao = value ?? 'Todos';
                if (selectedEscalao != 'Todos' && selectedEstado != 'Todos') {
                  if (selectedEstado == 'Tem') {
                    cromos = initcromos.where((cromo) => cromo.jaTem && selectedEscalao == cromo.escalao).toList();
                  } else {
                    cromos = initcromos.where((cromo) => !cromo.jaTem && selectedEscalao == cromo.escalao).toList();
                  }
                } if (selectedEscalao != 'Todos' && selectedEstado == 'Todos') {
                  if (selectedEstado == 'Tem') {
                    cromos = initcromos.where((cromo) => cromo.jaTem && selectedEscalao == cromo.escalao).toList();
                  } else {
                    cromos = initcromos.where((cromo) => !cromo.jaTem && selectedEscalao == cromo.escalao).toList();
                  }
                } else {
                  cromos = initcromos;
                }
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Text('Estado:', style: boldTextStyle(color: black),),
          ),  
          DropdownButton(
            isExpanded: true,
            padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
            dropdownColor: Colors.white,
            value: selectedEstado,
            items: estado.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedEstado = value ?? 'Todos';
                if (selectedEstado != 'Todos' && selectedEstado != 'Todos') {
                  if (selectedEstado == 'Tem') {
                    cromos = initcromos.where((cromo) => cromo.jaTem && selectedEscalao == cromo.escalao).toList();
                  } else {
                    cromos = initcromos.where((cromo) => !cromo.jaTem && selectedEscalao == cromo.escalao).toList();
                  }
                } if (selectedEstado != 'Todos' && selectedEstado == 'Todos') {
                  if (selectedEstado == 'Tem') {
                    cromos = initcromos.where((cromo) => cromo.jaTem).toList();
                  } else {
                    cromos = initcromos.where((cromo) => !cromo.jaTem).toList();
                  }
                } else {
                  cromos = initcromos;
                }
              });
            },
          ),
          Expanded(
            child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: cromos.length,
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: cardWidth / cardHeight),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      cromos[index].jaTem = !cromos[index].jaTem;
                      initcromos[index].jaTem = cromos[index].jaTem;
                      saveCromoState(cromos[index].id, cromos[index].jaTem);
                      setState(() {});
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: ColorFiltered(
                            colorFilter: cromos[index].jaTem 
                                ? ColorFilter.mode(
                                    Colors.transparent,
                                    BlendMode.multiply,
                                  )
                                : ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.saturation,
                                  ),
                            child: Image.asset('assets/pessoa.jpg', fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          top: 5,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black, // Change color to red for notification
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                cromos[index].id.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ]
                    ),
                  );
                }
              ),
          ),
        ],
      ),
    );
  }
}

class Cromo {
  int id;
  String imagem;
  bool jaTem;
  String escalao;

  Cromo({required this.id, required this.imagem, required this.jaTem,  required this.escalao});
}

List<Cromo> getCromos(){
  return [
    Cromo(id: 1, imagem: '1.png', jaTem: false, escalao: 'Clube'),
    Cromo(id: 2, imagem: '2.png', jaTem: false, escalao: 'Clube'),
    Cromo(id: 3, imagem: '3.png', jaTem: false, escalao: 'Clube'),
    Cromo(id: 4, imagem: '4.png', jaTem: false, escalao: 'Clube'),

    Cromo(id: 5, imagem: '5.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 6, imagem: '6.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 7, imagem: '7.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 8, imagem: '8.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 9, imagem: '9.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 10, imagem: '10.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 11, imagem: '11.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 12, imagem: '12.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 13, imagem: '13.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 14, imagem: '14.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 15, imagem: '15.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 16, imagem: '16.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 17, imagem: '17.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 18, imagem: '18.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 19, imagem: '19.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 20, imagem: '20.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 21, imagem: '21.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 22, imagem: '22.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 23, imagem: '23.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 24, imagem: '24.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 25, imagem: '25.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 26, imagem: '26.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 27, imagem: '27.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 28, imagem: '28.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 29, imagem: '29.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 30, imagem: '30.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 31, imagem: '31.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 32, imagem: '32.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 33, imagem: '33.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 34, imagem: '34.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 35, imagem: '35.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 36, imagem: '36.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 37, imagem: '37.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 38, imagem: '38.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 39, imagem: '39.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 40, imagem: '40.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 41, imagem: '41.png', jaTem: false, escalao: 'Seniores Masculinos'),
    Cromo(id: 42, imagem: '42.png', jaTem: false, escalao: 'Seniores Masculinos'),

    Cromo(id: 43, imagem: '43.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 44, imagem: '44.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 45, imagem: '45.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 46, imagem: '46.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 47, imagem: '47.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 48, imagem: '48.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 49, imagem: '49.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 50, imagem: '50.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 51, imagem: '51.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 52, imagem: '52.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 53, imagem: '53.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 54, imagem: '54.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 55, imagem: '55.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 56, imagem: '56.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 57, imagem: '57.png', jaTem: false, escalao: 'Seniores Femininos'),
    Cromo(id: 58, imagem: '58.png', jaTem: false, escalao: 'Seniores Femininos'),

    Cromo(id: 59, imagem: '59.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 60, imagem: '60.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 61, imagem: '61.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 62, imagem: '62.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 63, imagem: '63.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 64, imagem: '64.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 65, imagem: '65.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 66, imagem: '66.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 67, imagem: '67.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 68, imagem: '68.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 69, imagem: '69.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 70, imagem: '70.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 71, imagem: '71.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 72, imagem: '72.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 73, imagem: '73.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 74, imagem: '74.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 75, imagem: '75.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 76, imagem: '76.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 77, imagem: '77.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 78, imagem: '78.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 79, imagem: '79.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 80, imagem: '80.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 81, imagem: '81.png', jaTem: false, escalao: 'Juniores Masculinos'),
    Cromo(id: 82, imagem: '82.png', jaTem: false, escalao: 'Juniores Masculinos'),

    Cromo(id: 83, imagem: '83.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 84, imagem: '84.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 85, imagem: '85.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 86, imagem: '86.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 87, imagem: '87.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 88, imagem: '88.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 89, imagem: '89.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 90, imagem: '90.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 91, imagem: '91.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 92, imagem: '92.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 93, imagem: '93.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 94, imagem: '94.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 95, imagem: '95.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 96, imagem: '96.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 97, imagem: '97.png', jaTem: false, escalao: 'Juniores Femininos'),
    Cromo(id: 98, imagem: '98.png', jaTem: false, escalao: 'Juniores Femininos'),

    Cromo(id: 99, imagem: '99.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 100, imagem: '100.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 101, imagem: '101.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 102, imagem: '102.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 103, imagem: '103.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 104, imagem: '104.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 105, imagem: '105.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 106, imagem: '106.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 107, imagem: '107.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 108, imagem: '108.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 109, imagem: '109.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 110, imagem: '110.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 111, imagem: '111.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 112, imagem: '112.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 113, imagem: '113.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 114, imagem: '114.png', jaTem: false, escalao: 'Juvenis'),
    Cromo(id: 115, imagem: '115.png', jaTem: false, escalao: 'Juvenis'),

    Cromo(id: 116, imagem: '116.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 117, imagem: '117.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 118, imagem: '118.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 119, imagem: '119.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 120, imagem: '120.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 121, imagem: '121.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 122, imagem: '122.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 123, imagem: '123.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 124, imagem: '124.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 125, imagem: '125.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 126, imagem: '126.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 127, imagem: '127.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 128, imagem: '128.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 129, imagem: '129.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 130, imagem: '130.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 131, imagem: '131.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 132, imagem: '132.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 133, imagem: '133.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 134, imagem: '134.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 135, imagem: '135.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 136, imagem: '136.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 137, imagem: '137.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 138, imagem: '138.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 139, imagem: '139.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 140, imagem: '140.png', jaTem: false, escalao: 'Iniciados'),
    Cromo(id: 141, imagem: '141.png', jaTem: false, escalao: 'Iniciados'),

    Cromo(id: 142, imagem: '142.png', jaTem: false, escalao: 'Direção'),
    Cromo(id: 143, imagem: '143.png', jaTem: false, escalao: 'Direção'),
    Cromo(id: 144, imagem: '144.png', jaTem: false, escalao: 'Direção'),
    Cromo(id: 145, imagem: '145.png', jaTem: false, escalao: 'Direção'),
    Cromo(id: 146, imagem: '146.png', jaTem: false, escalao: 'Direção'),
    Cromo(id: 147, imagem: '147.png', jaTem: false, escalao: 'Direção'),

    Cromo(id: 148, imagem: '148.png', jaTem: false, escalao: 'Sede'),
    Cromo(id: 149, imagem: '149.png', jaTem: false, escalao: 'Sede'),
    Cromo(id: 150, imagem: '150.png', jaTem: false, escalao: 'Sede'),
    Cromo(id: 151, imagem: '151.png', jaTem: false, escalao: 'Sede'),
    Cromo(id: 152, imagem: '152.png', jaTem: false, escalao: 'Sede'),
    Cromo(id: 153, imagem: '153.png', jaTem: false, escalao: 'Sede'),
    Cromo(id: 154, imagem: '154.png', jaTem: false, escalao: 'Sede'),
    Cromo(id: 155, imagem: '155.png', jaTem: false, escalao: 'Sede'),
    Cromo(id: 156, imagem: '156.png', jaTem: false, escalao: 'Sede'),

    Cromo(id: 157, imagem: '157.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 158, imagem: '158.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 159, imagem: '159.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 160, imagem: '160.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 161, imagem: '161.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 162, imagem: '162.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 163, imagem: '163.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 164, imagem: '164.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 165, imagem: '165.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 166, imagem: '166.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 167, imagem: '167.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 168, imagem: '168.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 169, imagem: '169.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 170, imagem: '170.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 171, imagem: '171.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 172, imagem: '172.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 173, imagem: '173.png', jaTem: false, escalao: 'Infantis'),
    Cromo(id: 174, imagem: '174.png', jaTem: false, escalao: 'Infantis'),

    Cromo(id: 175, imagem: '175.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 176, imagem: '176.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 177, imagem: '177.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 178, imagem: '178.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 179, imagem: '179.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 180, imagem: '180.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 181, imagem: '181.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 182, imagem: '182.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 183, imagem: '183.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 184, imagem: '184.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 185, imagem: '185.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 186, imagem: '186.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 187, imagem: '187.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 188, imagem: '188.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 189, imagem: '189.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 190, imagem: '190.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 191, imagem: '191.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 192, imagem: '192.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 193, imagem: '193.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 194, imagem: '194.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 195, imagem: '195.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 196, imagem: '196.png', jaTem: false, escalao: 'Benjamins'),
    Cromo(id: 197, imagem: '197.png', jaTem: false, escalao: 'Benjamins'),

    Cromo(id: 198, imagem: '198.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 199, imagem: '199.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 200, imagem: '200.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 201, imagem: '201.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 202, imagem: '202.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 203, imagem: '203.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 204, imagem: '204.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 205, imagem: '205.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 206, imagem: '206.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 207, imagem: '207.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 208, imagem: '208.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 209, imagem: '209.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 210, imagem: '210.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 211, imagem: '211.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 212, imagem: '212.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 213, imagem: '213.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 214, imagem: '214.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 215, imagem: '215.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 216, imagem: '216.png', jaTem: false, escalao: 'Traquinas e Petizes'),
    Cromo(id: 217, imagem: '217.png', jaTem: false, escalao: 'Traquinas e Petizes'),

    Cromo(id: 218, imagem: '218.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 219, imagem: '219.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 220, imagem: '220.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 221, imagem: '221.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 222, imagem: '222.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 223, imagem: '223.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 224, imagem: '224.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 225, imagem: '225.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 226, imagem: '226.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 227, imagem: '227.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 228, imagem: '228.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 229, imagem: '229.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 230, imagem: '230.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 231, imagem: '231.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 232, imagem: '232.png', jaTem: false, escalao: 'Atletismo'),
    Cromo(id: 233, imagem: '233.png', jaTem: false, escalao: 'Atletismo'),

    Cromo(id: 234, imagem: '234.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 235, imagem: '235.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 236, imagem: '236.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 237, imagem: '237.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 238, imagem: '238.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 239, imagem: '239.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 240, imagem: '240.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 241, imagem: '241.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 242, imagem: '242.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 243, imagem: '243.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 244, imagem: '244.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 245, imagem: '245.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 246, imagem: '246.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 247, imagem: '247.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 248, imagem: '248.png', jaTem: false, escalao: 'Ciclismo'),
    Cromo(id: 249, imagem: '249.png', jaTem: false, escalao: 'Ciclismo'),

    Cromo(id: 250, imagem: '250.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 251, imagem: '251.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 252, imagem: '252.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 253, imagem: '253.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 254, imagem: '254.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 255, imagem: '255.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 256, imagem: '256.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 257, imagem: '257.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 258, imagem: '258.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 259, imagem: '259.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 260, imagem: '260.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 261, imagem: '261.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 262, imagem: '262.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 263, imagem: '263.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 264, imagem: '264.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 265, imagem: '265.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 266, imagem: '266.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 267, imagem: '267.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 268, imagem: '268.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 269, imagem: '269.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 270, imagem: '270.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 271, imagem: '271.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 272, imagem: '272.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 273, imagem: '273.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 274, imagem: '274.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 275, imagem: '275.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 276, imagem: '276.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 277, imagem: '277.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 278, imagem: '278.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 279, imagem: '279.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 280, imagem: '280.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 281, imagem: '281.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 282, imagem: '282.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 283, imagem: '283.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 284, imagem: '284.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 285, imagem: '285.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 286, imagem: '286.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 287, imagem: '287.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 288, imagem: '288.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 289, imagem: '289.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 290, imagem: '290.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 291, imagem: '291.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 292, imagem: '292.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 293, imagem: '293.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 294, imagem: '294.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 295, imagem: '295.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 296, imagem: '296.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 297, imagem: '297.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 298, imagem: '298.png', jaTem: false, escalao: 'Patinagem'),
    Cromo(id: 299, imagem: '299.png', jaTem: false, escalao: 'Patinagem')
  ];
}


