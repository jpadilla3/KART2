// To parse this JSON data, do
// final barcodeData = barcodeDataFromJson(jsonString);

// Model for a bardcode with these fields: 'allergens,brands,categories,ingredients,nutrient_levels,nutriments,nutriscore_data,product_name,nutriscore_score,nutrition_grades,product_name,traces'
// https://us.openfoodfacts.org/api/v2/product/3017624010701?fields=allergens,brands,categories,ingredients,nutrient_levels,nutriments,nutriscore_data,product_name,nutriscore_score,nutrition_grades,product_name,traces.json

import 'dart:convert';

BarcodeData barcodeDataFromJson(String str) =>
    BarcodeData.fromJson(json.decode(str));

String barcodeDataToJson(BarcodeData data) => json.encode(data.toJson());

class BarcodeData {
  BarcodeData({
    this.code,
    this.product,
    this.status,
    this.statusVerbose,
  });

  String? code;
  Product? product;
  int? status;
  String? statusVerbose;

  factory BarcodeData.fromJson(Map<String, dynamic> json) => BarcodeData(
        code: json["code"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        status: json["status"],
        statusVerbose: json["status_verbose"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "product": product?.toJson(),
        "status": status,
        "status_verbose": statusVerbose,
      };
}

class Product {
  Product({
    this.allergens,
    this.brands,
    this.categories,
    this.ingredients,
    this.nutrientLevels,
    this.nutriments,
    this.nutriscoreData,
    this.nutriscoreScore,
    this.nutritionGrades,
    this.productName,
    this.traces,
  });

  String? allergens;
  String? brands;
  String? categories;
  List<Ingredient>? ingredients;
  NutrientLevels? nutrientLevels;
  Nutriments? nutriments;
  NutriscoreData? nutriscoreData;
  int? nutriscoreScore;
  String? nutritionGrades;
  String? productName;
  String? traces;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        allergens: json["allergens"],
        brands: json["brands"],
        categories: json["categories"],
        ingredients: json["ingredients"] == null
            ? []
            : List<Ingredient>.from(
                json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
        nutrientLevels: json["nutrient_levels"] == null
            ? null
            : NutrientLevels.fromJson(json["nutrient_levels"]),
        nutriments: json["nutriments"] == null
            ? null
            : Nutriments.fromJson(json["nutriments"]),
        nutriscoreData: json["nutriscore_data"] == null
            ? null
            : NutriscoreData.fromJson(json["nutriscore_data"]),
        nutriscoreScore: json["nutriscore_score"],
        nutritionGrades: json["nutrition_grades"],
        productName: json["product_name"],
        traces: json["traces"],
      );

  Map<String, dynamic> toJson() => {
        "allergens": allergens,
        "brands": brands,
        "categories": categories,
        "ingredients": ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
        "nutrient_levels": nutrientLevels?.toJson(),
        "nutriments": nutriments?.toJson(),
        "nutriscore_data": nutriscoreData?.toJson(),
        "nutriscore_score": nutriscoreScore,
        "nutrition_grades": nutritionGrades,
        "product_name": productName,
        "traces": traces,
      };
}

class Ingredient {
  Ingredient({
    this.id,
    this.percentEstimate,
    this.percentMax,
    this.percentMin,
    this.text,
    this.vegan,
    this.vegetarian,
    this.fromPalmOil,
  });

  String? id;
  double? percentEstimate;
  double? percentMax;
  double? percentMin;
  String? text;
  String? vegan;
  String? vegetarian;
  String? fromPalmOil;

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json["id"],
        percentEstimate: json["percent_estimate"]?.toDouble(),
        percentMax: json["percent_max"]?.toDouble(),
        percentMin: json["percent_min"]?.toDouble(),
        text: json["text"],
        vegan: json["vegan"],
        vegetarian: json["vegetarian"],
        fromPalmOil: json["from_palm_oil"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "percent_estimate": percentEstimate,
        "percent_max": percentMax,
        "percent_min": percentMin,
        "text": text,
        "vegan": vegan,
        "vegetarian": vegetarian,
        "from_palm_oil": fromPalmOil,
      };
}

class NutrientLevels {
  NutrientLevels({
    this.fat,
    this.salt,
    this.saturatedFat,
    this.sugars,
  });

  String? fat;
  String? salt;
  String? saturatedFat;
  String? sugars;

  factory NutrientLevels.fromJson(Map<String, dynamic> json) => NutrientLevels(
        fat: json["fat"],
        salt: json["salt"],
        saturatedFat: json["saturated-fat"],
        sugars: json["sugars"],
      );

  Map<String, dynamic> toJson() => {
        "fat": fat,
        "salt": salt,
        "saturated-fat": saturatedFat,
        "sugars": sugars,
      };
}

class Nutriments {
  Nutriments({
    this.carbohydrates,
    this.carbohydrates100G,
    this.carbohydratesUnit,
    this.carbohydratesValue,
    this.energy,
    this.energyKcal,
    this.energyKcal100G,
    this.energyKcalUnit,
    this.energyKcalValue,
    this.energyKcalValueComputed,
    this.energy100G,
    this.energyUnit,
    this.energyValue,
    this.fat,
    this.fat100G,
    this.fatUnit,
    this.fatValue,
    this.fruitsVegetablesNutsEstimateFromIngredients100G,
    this.fruitsVegetablesNutsEstimateFromIngredientsServing,
    this.novaGroup,
    this.novaGroup100G,
    this.novaGroupServing,
    this.nutritionScoreFr,
    this.nutritionScoreFr100G,
    this.proteins,
    this.proteins100G,
    this.proteinsUnit,
    this.proteinsValue,
    this.salt,
    this.salt100G,
    this.saltUnit,
    this.saltValue,
    this.saturatedFat,
    this.saturatedFat100G,
    this.saturatedFatUnit,
    this.saturatedFatValue,
    this.sodium,
    this.sodium100G,
    this.sodiumUnit,
    this.sodiumValue,
    this.sugars,
    this.sugars100G,
    this.sugarsUnit,
    this.sugarsValue,
  });

  double? carbohydrates;
  double? carbohydrates100G;
  String? carbohydratesUnit;
  double? carbohydratesValue;
  int? energy;
  int? energyKcal;
  int? energyKcal100G;
  String? energyKcalUnit;
  int? energyKcalValue;
  double? energyKcalValueComputed;
  int? energy100G;
  String? energyUnit;
  int? energyValue;
  double? fat;
  double? fat100G;
  String? fatUnit;
  double? fatValue;
  int? fruitsVegetablesNutsEstimateFromIngredients100G;
  int? fruitsVegetablesNutsEstimateFromIngredientsServing;
  int? novaGroup;
  int? novaGroup100G;
  int? novaGroupServing;
  int? nutritionScoreFr;
  int? nutritionScoreFr100G;
  double? proteins;
  double? proteins100G;
  String? proteinsUnit;
  double? proteinsValue;
  double? salt;
  double? salt100G;
  String? saltUnit;
  double? saltValue;
  double? saturatedFat;
  double? saturatedFat100G;
  String? saturatedFatUnit;
  double? saturatedFatValue;
  double? sodium;
  double? sodium100G;
  String? sodiumUnit;
  double? sodiumValue;
  double? sugars;
  double? sugars100G;
  String? sugarsUnit;
  double? sugarsValue;

  factory Nutriments.fromJson(Map<String, dynamic> json) => Nutriments(
        carbohydrates: json["carbohydrates"]?.toDouble(),
        carbohydrates100G: json["carbohydrates_100g"]?.toDouble(),
        carbohydratesUnit: json["carbohydrates_unit"],
        carbohydratesValue: json["carbohydrates_value"]?.toDouble(),
        energy: json["energy"],
        energyKcal: json["energy-kcal"],
        energyKcal100G: json["energy-kcal_100g"],
        energyKcalUnit: json["energy-kcal_unit"],
        energyKcalValue: json["energy-kcal_value"],
        energyKcalValueComputed: json["energy-kcal_value_computed"]?.toDouble(),
        energy100G: json["energy_100g"],
        energyUnit: json["energy_unit"],
        energyValue: json["energy_value"],
        fat: json["fat"]?.toDouble(),
        fat100G: json["fat_100g"]?.toDouble(),
        fatUnit: json["fat_unit"],
        fatValue: json["fat_value"]?.toDouble(),
        fruitsVegetablesNutsEstimateFromIngredients100G:
            json["fruits-vegetables-nuts-estimate-from-ingredients_100g"],
        fruitsVegetablesNutsEstimateFromIngredientsServing:
            json["fruits-vegetables-nuts-estimate-from-ingredients_serving"],
        novaGroup: json["nova-group"],
        novaGroup100G: json["nova-group_100g"],
        novaGroupServing: json["nova-group_serving"],
        nutritionScoreFr: json["nutrition-score-fr"],
        nutritionScoreFr100G: json["nutrition-score-fr_100g"],
        proteins: json["proteins"]?.toDouble(),
        proteins100G: json["proteins_100g"]?.toDouble(),
        proteinsUnit: json["proteins_unit"],
        proteinsValue: json["proteins_value"]?.toDouble(),
        salt: json["salt"]?.toDouble(),
        salt100G: json["salt_100g"]?.toDouble(),
        saltUnit: json["salt_unit"],
        saltValue: json["salt_value"]?.toDouble(),
        saturatedFat: json["saturated-fat"]?.toDouble(),
        saturatedFat100G: json["saturated-fat_100g"]?.toDouble(),
        saturatedFatUnit: json["saturated-fat_unit"],
        saturatedFatValue: json["saturated-fat_value"]?.toDouble(),
        sodium: json["sodium"]?.toDouble(),
        sodium100G: json["sodium_100g"]?.toDouble(),
        sodiumUnit: json["sodium_unit"],
        sodiumValue: json["sodium_value"]?.toDouble(),
        sugars: json["sugars"]?.toDouble(),
        sugars100G: json["sugars_100g"]?.toDouble(),
        sugarsUnit: json["sugars_unit"],
        sugarsValue: json["sugars_value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "carbohydrates": carbohydrates,
        "carbohydrates_100g": carbohydrates100G,
        "carbohydrates_unit": carbohydratesUnit,
        "carbohydrates_value": carbohydratesValue,
        "energy": energy,
        "energy-kcal": energyKcal,
        "energy-kcal_100g": energyKcal100G,
        "energy-kcal_unit": energyKcalUnit,
        "energy-kcal_value": energyKcalValue,
        "energy-kcal_value_computed": energyKcalValueComputed,
        "energy_100g": energy100G,
        "energy_unit": energyUnit,
        "energy_value": energyValue,
        "fat": fat,
        "fat_100g": fat100G,
        "fat_unit": fatUnit,
        "fat_value": fatValue,
        "fruits-vegetables-nuts-estimate-from-ingredients_100g":
            fruitsVegetablesNutsEstimateFromIngredients100G,
        "fruits-vegetables-nuts-estimate-from-ingredients_serving":
            fruitsVegetablesNutsEstimateFromIngredientsServing,
        "nova-group": novaGroup,
        "nova-group_100g": novaGroup100G,
        "nova-group_serving": novaGroupServing,
        "nutrition-score-fr": nutritionScoreFr,
        "nutrition-score-fr_100g": nutritionScoreFr100G,
        "proteins": proteins,
        "proteins_100g": proteins100G,
        "proteins_unit": proteinsUnit,
        "proteins_value": proteinsValue,
        "salt": salt,
        "salt_100g": salt100G,
        "salt_unit": saltUnit,
        "salt_value": saltValue,
        "saturated-fat": saturatedFat,
        "saturated-fat_100g": saturatedFat100G,
        "saturated-fat_unit": saturatedFatUnit,
        "saturated-fat_value": saturatedFatValue,
        "sodium": sodium,
        "sodium_100g": sodium100G,
        "sodium_unit": sodiumUnit,
        "sodium_value": sodiumValue,
        "sugars": sugars,
        "sugars_100g": sugars100G,
        "sugars_unit": sugarsUnit,
        "sugars_value": sugarsValue,
      };
}

class NutriscoreData {
  NutriscoreData({
    this.energy,
    this.energyPoints,
    this.energyValue,
    this.fiber,
    this.fiberPoints,
    this.fiberValue,
    this.fruitsVegetablesNutsColzaWalnutOliveOils,
    this.fruitsVegetablesNutsColzaWalnutOliveOilsPoints,
    this.fruitsVegetablesNutsColzaWalnutOliveOilsValue,
    this.grade,
    this.isBeverage,
    this.isCheese,
    this.isFat,
    this.isWater,
    this.negativePoints,
    this.positivePoints,
    this.proteins,
    this.proteinsPoints,
    this.proteinsValue,
    this.saturatedFat,
    this.saturatedFatPoints,
    this.saturatedFatRatio,
    this.saturatedFatRatioPoints,
    this.saturatedFatRatioValue,
    this.saturatedFatValue,
    this.score,
    this.sodium,
    this.sodiumPoints,
    this.sodiumValue,
    this.sugars,
    this.sugarsPoints,
    this.sugarsValue,
  });

  int? energy;
  int? energyPoints;
  int? energyValue;
  int? fiber;
  int? fiberPoints;
  int? fiberValue;
  int? fruitsVegetablesNutsColzaWalnutOliveOils;
  int? fruitsVegetablesNutsColzaWalnutOliveOilsPoints;
  int? fruitsVegetablesNutsColzaWalnutOliveOilsValue;
  String? grade;
  int? isBeverage;
  int? isCheese;
  int? isFat;
  int? isWater;
  int? negativePoints;
  int? positivePoints;
  double? proteins;
  int? proteinsPoints;
  double? proteinsValue;
  double? saturatedFat;
  int? saturatedFatPoints;
  double? saturatedFatRatio;
  int? saturatedFatRatioPoints;
  double? saturatedFatRatioValue;
  double? saturatedFatValue;
  int? score;
  int? sodium;
  int? sodiumPoints;
  int? sodiumValue;
  double? sugars;
  int? sugarsPoints;
  double? sugarsValue;

  factory NutriscoreData.fromJson(Map<String, dynamic> json) => NutriscoreData(
        energy: json["energy"],
        energyPoints: json["energy_points"],
        energyValue: json["energy_value"],
        fiber: json["fiber"],
        fiberPoints: json["fiber_points"],
        fiberValue: json["fiber_value"],
        fruitsVegetablesNutsColzaWalnutOliveOils:
            json["fruits_vegetables_nuts_colza_walnut_olive_oils"],
        fruitsVegetablesNutsColzaWalnutOliveOilsPoints:
            json["fruits_vegetables_nuts_colza_walnut_olive_oils_points"],
        fruitsVegetablesNutsColzaWalnutOliveOilsValue:
            json["fruits_vegetables_nuts_colza_walnut_olive_oils_value"],
        grade: json["grade"],
        isBeverage: json["is_beverage"],
        isCheese: json["is_cheese"],
        isFat: json["is_fat"],
        isWater: json["is_water"],
        negativePoints: json["negative_points"],
        positivePoints: json["positive_points"],
        proteins: json["proteins"]?.toDouble(),
        proteinsPoints: json["proteins_points"],
        proteinsValue: json["proteins_value"]?.toDouble(),
        saturatedFat: json["saturated_fat"]?.toDouble(),
        saturatedFatPoints: json["saturated_fat_points"],
        saturatedFatRatio: json["saturated_fat_ratio"]?.toDouble(),
        saturatedFatRatioPoints: json["saturated_fat_ratio_points"],
        saturatedFatRatioValue: json["saturated_fat_ratio_value"]?.toDouble(),
        saturatedFatValue: json["saturated_fat_value"]?.toDouble(),
        score: json["score"],
        sodium: json["sodium"],
        sodiumPoints: json["sodium_points"],
        sodiumValue: json["sodium_value"],
        sugars: json["sugars"]?.toDouble(),
        sugarsPoints: json["sugars_points"],
        sugarsValue: json["sugars_value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "energy": energy,
        "energy_points": energyPoints,
        "energy_value": energyValue,
        "fiber": fiber,
        "fiber_points": fiberPoints,
        "fiber_value": fiberValue,
        "fruits_vegetables_nuts_colza_walnut_olive_oils":
            fruitsVegetablesNutsColzaWalnutOliveOils,
        "fruits_vegetables_nuts_colza_walnut_olive_oils_points":
            fruitsVegetablesNutsColzaWalnutOliveOilsPoints,
        "fruits_vegetables_nuts_colza_walnut_olive_oils_value":
            fruitsVegetablesNutsColzaWalnutOliveOilsValue,
        "grade": grade,
        "is_beverage": isBeverage,
        "is_cheese": isCheese,
        "is_fat": isFat,
        "is_water": isWater,
        "negative_points": negativePoints,
        "positive_points": positivePoints,
        "proteins": proteins,
        "proteins_points": proteinsPoints,
        "proteins_value": proteinsValue,
        "saturated_fat": saturatedFat,
        "saturated_fat_points": saturatedFatPoints,
        "saturated_fat_ratio": saturatedFatRatio,
        "saturated_fat_ratio_points": saturatedFatRatioPoints,
        "saturated_fat_ratio_value": saturatedFatRatioValue,
        "saturated_fat_value": saturatedFatValue,
        "score": score,
        "sodium": sodium,
        "sodium_points": sodiumPoints,
        "sodium_value": sodiumValue,
        "sugars": sugars,
        "sugars_points": sugarsPoints,
        "sugars_value": sugarsValue,
      };
}
