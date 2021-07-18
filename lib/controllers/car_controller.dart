import 'dart:convert';

import 'package:flutter_http_demo2/models/car.dart';
import 'package:flutter_http_demo2/models/carDetails.dart';
import 'package:flutter_http_demo2/models/carImage.dart';
import 'package:flutter_http_demo2/services/car_service.dart';
import 'package:get/get.dart';

class CarController extends GetxController{

  var isLoading=false.obs;
  var carList=<Car>[].obs;
  var carDetailList=<CarDetails>[].obs;
  var carImageList=<CarImage>[].obs;


  @override
  void onInit() {
    getAllCarDetails();
    super.onInit();
  }

  void getAllCarDetails()async{
  try{
    await CarService.getCarDetails().then((response){
      isLoading(true);
      var result=(jsonDecode(response.body)["data"] as List).map((e) => CarDetails.fromJson(e)).toList();
      if(result!=null){carDetailList.addAll(result);}
    });
  }finally{isLoading(false);}
  }

  Future<void> getAllCarDetailsByColorId(int colorId)async{
  try{
    await CarService.getCarDetailsByColorId(colorId).then((response){
      isLoading(true);
      var result=(jsonDecode(response.body)["data"] as List).map((e) => CarDetails.fromJson(e)).toList();
      if(result!=null){
        carDetailList.addAll(result);
        for(int i=0; i>=carDetailList.length; i++){
          print(carDetailList[i].colorName);
          print(i.toString());
        }
      }
});
  }finally{isLoading(false);}

  }

  void getAllCarDetailsByBrandId(int brandId)async{
  try{
    await CarService.getCarDetailsByBrandId(brandId).then((response){
      isLoading(true);
      var result=(jsonDecode(response.body)["data"] as List).map((e) => CarDetails.fromJson(e)).toList();

      if(result!=null){carDetailList.addAll(result);}
    });
  }finally{isLoading(false);}

  }

  void getAllCarDetailsByBrandAndColorId(int brandId,int colorId)async{
  try{
    await CarService.getCarDetailsByBrandAndColorId(brandId,colorId).then((response){
      isLoading(true);
      var result=(jsonDecode(response.body)["data"] as List).map((e) => CarDetails.fromJson(e)).toList();
      if(result!=null){carDetailList.addAll(result);}

    });
  }finally{isLoading(false);}

  }

  Future<void> getCarImagesByCarId(int carId)async{
    carImageList.clear();
  try{
    await CarService.getCarImagesByCarId(carId).then((response){
      isLoading(true);
      var result=(jsonDecode(response.body)["data"] as List).map((e) => CarImage.fromJson(e)).toList();
      if(result!=null){
        carImageList.addAll(result);

      }
    });
  }finally{isLoading(false);}

  }




}

/*
     print("Yazdırılıyor...");
        for(int i=0;i<carImageList.length; i++){
          print(carImageList[i].carId);
          print(carImageList[i].imagePath);
        }
        */