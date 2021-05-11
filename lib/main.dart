import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_http_demo2/models/brand.dart';
import 'package:flutter_http_demo2/models/car.dart';
import 'package:flutter_http_demo2/models/carDetails.dart';
import 'package:flutter_http_demo2/models/user.dart';
import 'package:flutter_http_demo2/models/color.dart';
import 'package:flutter_http_demo2/screens/car_add_screen.dart';
import 'package:flutter_http_demo2/screens/car_detail.dart';
import 'package:flutter_http_demo2/services/brand_service.dart';
import 'package:flutter_http_demo2/services/car_service.dart';
import 'package:flutter_http_demo2/services/color_service.dart';

class MyHttpOverrides extends HttpOverrides {

  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(CarAddScreen());
}

//void main() => runApp(ApiDemo());

class ApiDemo extends StatefulWidget {
  @override
  _ApiDemoState createState() => _ApiDemoState();
}

class _ApiDemoState extends State<ApiDemo> {
  var users = <User>[];
  var cars = <Car>[];
  var carDetails = <CarDetails>[];
  var userWidget = <Widget>[];
  var colors = <Color>[];
  var brands = <Brand>[];
  var _myBrandSelection;
  var _myColorSelection;

  @override
  void initState() {
    getColorsFromApi();
    getBrandsFromApi();
    getCarDetailsFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: Text("Rent a Car Flutter")),
          body: buildBody(),
        ));
  }

  Widget buildBody() {
    return Column(
      children: [
        SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(
              children: [
                Expanded(child: buildColorsDropdownList()),
                Expanded(child: buildBrandsDropdownList()),
                Expanded(
                    child: IconButton(
                  icon: Icon(Icons.search_sharp,color:Colors.blue),
                  onPressed: () {
                    setState(() {
                      if (_myBrandSelection != null &&
                          _myColorSelection != null) {
                        getCarsByBrandAndColorId(
                            int.tryParse(this._myBrandSelection),
                            int.tryParse(this._myColorSelection));
                      } else if (_myBrandSelection != null &&
                          _myColorSelection == null) {
                        getCarsByBrandId(int.tryParse(this._myBrandSelection));
                      } else {
                        getCarsByColorId(int.tryParse(this._myColorSelection));
                      }
                    });
                  },
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                      child: IconButton(
                    icon: Icon(Icons.delete,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        _myBrandSelection=null;
                        _myColorSelection=null;

                      getCarDetailsFromApi();
                      });
                    },
                  )),
                ),
              ],
            )),
        Expanded(child: buildCard()),
      ],
    );
  }

  buildColorsDropdownList() {
    return new Center(
      child: new DropdownButton(
        items: colors.map((item) {
          return new DropdownMenuItem(
            child: new Text(item.colorName),
            value: item.colorId.toString(),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            _myColorSelection = newVal;
            //getCarsByColorId(int.tryParse(newVal));
          });
        },
        value: _myColorSelection,
      ),
    );
  }

  buildBrandsDropdownList() {
    return new Center(
      child: new DropdownButton(
        items: brands.map((item) {
          return new DropdownMenuItem(
            child: new Text(item.brandName),
            value: item.brandId.toString(),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            _myBrandSelection = newVal;
            //getCarsByBrandId(int.tryParse(newVal));
          });
        },
        value: _myBrandSelection,
      ),
    );
  }

  void getCarsByColorId(int colorId) {
    CarService.getCarDetailsByColorId(colorId).then((response) {
      setState(() {
        Iterable list = json.decode(response.body)["data"];
        this.carDetails =
            list.map((carDetail) => CarDetails.fromJson(carDetail)).toList();
      });
    });
  }

  void getCarsByBrandId(int brandId) {
    CarService.getCarDetailsByBrandId(brandId).then((response) {
      setState(() {
        Iterable list = json.decode(response.body)["data"];
        this.carDetails =
            list.map((carDetail) => CarDetails.fromJson(carDetail)).toList();
      });
    });
  }

  void getCarsByBrandAndColorId(int brandId, int colorId) {
    CarService.getCarDetailsByBrandAndColorId(brandId, colorId)
        .then((response) {
      setState(() {
        Iterable list = json.decode(response.body)["data"];
        this.carDetails =
            list.map((carDetail) => CarDetails.fromJson(carDetail)).toList();
      });
    });
  }

  void getCarDetailsFromApi() {
    CarService.getCarDetails().then((response) {
      setState(() {
        Iterable list = json.decode(response.body)["data"];
        this.carDetails =
            list.map((carDetail) => CarDetails.fromJson(carDetail)).toList();
      });
    });
  }

  void getColorsFromApi() {
    ColorService.getAll().then((response) {
      setState(() {
        Iterable list = json.decode(response.body)["data"];
        this.colors = list.map((color) => Color.fromJson(color)).toList();
      });
    });
  }

  void getBrandsFromApi() {
    BrandService.getAll().then((response) {
      setState(() {
        Iterable list = json.decode(response.body)["data"];
        this.brands = list.map((brand) => Brand.fromJson(brand)).toList();
      });
    });
  }

  Widget buildCard() {
    return ListView.builder(
        itemCount: carDetails.length,
        itemBuilder: (BuildContext context, index) {
          return SizedBox(
            child: Card(
              child: Column(
                children: [
                  Image.network(
                      "https://10.0.2.2:5001/" + carDetails[index].imagePath),
                  ListTile(
                    title: Text(carDetails[index].carName,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(carDetails[index].brandName),
                    leading: Icon(
                      Icons.car_rental,
                      color: Colors.blue[500],
                    ),
                  ),
                  ListTile(
                    title: Text(carDetails[index].dailyPrice.toString(),
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    leading: Icon(
                      Icons.attach_money,
                      color: Colors.blue[500],
                    ),
                  ),
                  ListTile(
                      title: Text(carDetails[index].modelYear.toString()),
                      leading: Icon(
                        Icons.date_range,
                        color: Colors.blue,
                      ),
                      trailing: TextButton(
                        child: Text("Detail"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CarDetailScreen(carDetails[index])),
                          ).then((value) => setState(() {}));
                        },
                      )),
                ],
              ),
            ),
          );
        });
  }
}
