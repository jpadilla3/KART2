// To parse this JSON data, do
// final searchData = searchDataFromJson(jsonString);

// Model for search with these fields: '_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces'
//https://us.openfoodfacts.org/api/v2/search?categories_tags_en=dairies&nutrition_grades_tags=a&sort_by=nutriscore_score&fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,code,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json

import 'dart:convert';

SearchData searchDataFromJson(String str) =>
    SearchData.fromJson(json.decode(str));

String searchDataToJson(SearchData data) => json.encode(data.toJson());

class SearchData {
  SearchData({
    this.count,
    this.page,
    this.pageCount,
    this.pageSize,
    this.products,
    this.skip,
  });

  String? count;
  String? page;
  String? pageCount;
  String? pageSize;
  List<Product>? products;
  String? skip;

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        count: json["count"]?.toString(),
        page: json["page"]?.toString(),
        pageCount: json["page_count"]?.toString(),
        pageSize: json["page_size"]?.toString(),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
        skip: json["skip"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "page": page,
        "page_count": pageCount,
        "page_size": pageSize,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "skip": skip,
      };
}

class Product {
  Product({
    this.keywords,
    this.allergens,
    this.allergensTagsEn,
    this.brands,
    this.categories,
    this.categoriesTagsEn,
    this.code,
    this.comparedToCategory,
    this.foodGroups,
    this.foodGroupsTagsEn,
    this.imageFrontThumbUrl,
    this.ingredients,
    this.nutrientLevels,
    this.nutrientLevelsTagsEn,
    this.nutriments,
    this.nutriscoreData,
    this.nutriscoreGrade,
    this.nutriscoreScore,
    this.nutritionGrades,
    this.productName,
    this.selectedImages,
    this.traces,
  });

  List<String>? keywords;
  String? allergens;
  List<String>? allergensTagsEn;
  String? brands;
  String? categories;
  List<String>? categoriesTagsEn;
  String? code;
  String? comparedToCategory;
  String? foodGroups;
  List<String>? foodGroupsTagsEn;
  String? imageFrontThumbUrl;
  List<Ingredients>? ingredients;
  NutrientLevels? nutrientLevels;
  List<String>? nutrientLevelsTagsEn;
  Nutriments? nutriments;
  NutriscoreData? nutriscoreData;
  String? nutriscoreGrade;
  String? nutriscoreScore;
  String? nutritionGrades;
  String? productName;
  SelectedImages? selectedImages;
  String? traces;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        keywords: json["_keywords"] == null
            ? []
            : List<String>.from(json["_keywords"]!.map((x) => x)),
        allergens: json["allergens"]?.toString(),
        allergensTagsEn: json["allergens_tags_en"] == null
            ? []
            : List<String>.from(json["allergens_tags_en"]!.map((x) => x)),
        brands: json["brands"]?.toString(),
        categories: json["categories"]?.toString(),
        categoriesTagsEn: json["categories_tags_en"] == null
            ? []
            : List<String>.from(json["categories_tags_en"]!.map((x) => x)),
        comparedToCategory: json["compared_to_category"]?.toString(),
        code: json["code"]?.toString(),
        foodGroups: json["food_groups"]?.toString(),
        foodGroupsTagsEn: json["food_groups_tags_en"] == null
            ? []
            : List<String>.from(json["food_groups_tags_en"]!.map((x) => x)),
        imageFrontThumbUrl: json["image_front_thumb_url"]?.toString(),
        ingredients: json["ingredients"] == null
            ? []
            : List<Ingredients>.from(
                json["ingredients"]!.map((x) => Ingredients.fromJson(x))),
        nutrientLevels: json["nutrient_levels"] == null
            ? null
            : NutrientLevels.fromJson(json["nutrient_levels"]),
        nutrientLevelsTagsEn: json["nutrient_levels_tags_en"] == null
            ? []
            : List<String>.from(json["nutrient_levels_tags_en"]!.map((x) => x)),
        nutriments: json["nutriments"] == null
            ? null
            : Nutriments.fromJson(json["nutriments"]),
        nutriscoreData: json["nutriscore_data"] == null
            ? null
            : NutriscoreData.fromJson(json["nutriscore_data"]),
        nutriscoreGrade: json["nutriscore_grade"]?.toString(),
        nutriscoreScore: json["nutriscore_score"]?.toString(),
        nutritionGrades: json["nutrition_grades"]?.toString(),
        productName: json["product_name"]?.toString(),
        selectedImages: json["selected_images"] == null
            ? null
            : SelectedImages.fromJson(json["selected_images"]),
        traces: json["traces"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "_keywords":
            keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
        "allergens": allergens,
        "allergens_tags_en": allergensTagsEn == null
            ? []
            : List<dynamic>.from(allergensTagsEn!.map((x) => x)),
        "brands": brands,
        "categories": categories,
        "categories_tags_en": categoriesTagsEn == null
            ? []
            : List<dynamic>.from(categoriesTagsEn!.map((x) => x)),
        "compared_to_category": comparedToCategory,
        "food_groups": foodGroups,
        "food_groups_tags_en": foodGroupsTagsEn == null
            ? []
            : List<dynamic>.from(foodGroupsTagsEn!.map((x) => x)),
        "image_front_thumb_url": imageFrontThumbUrl,
        "ingredients": ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
        "nutrient_levels": nutrientLevels?.toJson(),
        "nutrient_levels_tags_en": nutrientLevelsTagsEn == null
            ? []
            : List<dynamic>.from(nutrientLevelsTagsEn!.map((x) => x)),
        "nutriments": nutriments?.toJson(),
        "nutriscore_data": nutriscoreData?.toJson(),
        "nutriscore_grade": nutriscoreGrade,
        "nutriscore_score": nutriscoreScore,
        "nutrition_grades": nutritionGrades,
        "product_name": productName,
        "selected_images": selectedImages?.toJson(),
        "traces": traces,
      };
}

class Ingredients {
  Ingredients({
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
  String? percentEstimate;
  String? percentMax;
  String? percentMin;
  String? text;
  String? vegan;
  String? vegetarian;
  String? fromPalmOil;

  factory Ingredients.fromJson(Map<String, dynamic> json) => Ingredients(
        id: json["id"]?.toString(),
        percentEstimate: json["percent_estimate"]?.toString(),
        percentMax: json["percent_max"]?.toString(),
        percentMin: json["percent_min"]?.toString(),
        text: json["text"]?.toString(),
        vegan: json["vegan"]?.toString(),
        vegetarian: json["vegetarian"]?.toString(),
        fromPalmOil: json["from_palm_oil"]?.toString(),
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
        fat: json["fat"]?.toString(),
        salt: json["salt"]?.toString(),
        saturatedFat: json["saturated-fat"]?.toString(),
        sugars: json["sugars"]?.toString(),
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
    this.fiber,
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

  String? carbohydrates;
  String? carbohydrates100G;
  String? carbohydratesUnit;
  String? carbohydratesValue;
  String? energy;
  String? energyKcal;
  String? energyKcal100G;
  String? energyKcalUnit;
  String? energyKcalValue;
  String? energyKcalValueComputed;
  String? energy100G;
  String? energyUnit;
  String? energyValue;
  String? fat;
  String? fat100G;
  String? fatUnit;
  String? fatValue;
  String? fruitsVegetablesNutsEstimateFromIngredients100G;
  String? fruitsVegetablesNutsEstimateFromIngredientsServing;
  String? novaGroup;
  String? novaGroup100G;
  String? novaGroupServing;
  String? nutritionScoreFr;
  String? nutritionScoreFr100G;
  String? proteins;
  String? proteins100G;
  String? proteinsUnit;
  String? proteinsValue;
  String? salt;
  String? salt100G;
  String? saltUnit;
  String? saltValue;
  String? fiber;
  String? saturatedFat;
  String? saturatedFat100G;
  String? saturatedFatUnit;
  String? saturatedFatValue;
  String? sodium;
  String? sodium100G;
  String? sodiumUnit;
  String? sodiumValue;
  String? sugars;
  String? sugars100G;
  String? sugarsUnit;
  String? sugarsValue;

  factory Nutriments.fromJson(Map<String, dynamic> json) => Nutriments(
        carbohydrates: json["carbohydrates"]?.toString(),
        carbohydrates100G: json["carbohydrates_100g"]?.toString(),
        carbohydratesUnit: json["carbohydrates_unit"]?.toString(),
        carbohydratesValue: json["carbohydrates_value"]?.toString(),
        energy: json["energy"]?.toString(),
        energyKcal: json["energy-kcal"]?.toString(),
        energyKcal100G: json["energy-kcal_100g"]?.toString(),
        energyKcalUnit: json["energy-kcal_unit"]?.toString(),
        energyKcalValue: json["energy-kcal_value"]?.toString(),
        energyKcalValueComputed: json["energy-kcal_value_computed"]?.toString(),
        energy100G: json["energy_100g"]?.toString(),
        energyUnit: json["energy_unit"]?.toString(),
        energyValue: json["energy_value"]?.toString(),
        fat: json["fat"]?.toString(),
        fat100G: json["fat_100g"]?.toString(),
        fatUnit: json["fat_unit"]?.toString(),
        fatValue: json["fat_value"]?.toString(),
        fiber: json["fiber"]?.toString(),
        fruitsVegetablesNutsEstimateFromIngredients100G:
            json["fruits-vegetables-nuts-estimate-from-ingredients_100g"]
                ?.toString(),
        fruitsVegetablesNutsEstimateFromIngredientsServing:
            json["fruits-vegetables-nuts-estimate-from-ingredients_serving"]
                ?.toString(),
        novaGroup: json["nova-group"]?.toString(),
        novaGroup100G: json["nova-group_100g"]?.toString(),
        novaGroupServing: json["nova-group_serving"]?.toString(),
        nutritionScoreFr: json["nutrition-score-fr"]?.toString(),
        nutritionScoreFr100G: json["nutrition-score-fr_100g"]?.toString(),
        proteins: json["proteins"]?.toString(),
        proteins100G: json["proteins_100g"]?.toString(),
        proteinsUnit: json["proteins_unit"]?.toString(),
        proteinsValue: json["proteins_value"]?.toString(),
        salt: json["salt"]?.toString(),
        salt100G: json["salt_100g"]?.toString(),
        saltUnit: json["salt_unit"]?.toString(),
        saltValue: json["salt_value"]?.toString(),
        saturatedFat: json["saturated-fat"]?.toString(),
        saturatedFat100G: json["saturated-fat_100g"]?.toString(),
        saturatedFatUnit: json["saturated-fat_unit"]?.toString(),
        saturatedFatValue: json["saturated-fat_value"]?.toString(),
        sodium: json["sodium"]?.toString(),
        sodium100G: json["sodium_100g"]?.toString(),
        sodiumUnit: json["sodium_unit"]?.toString(),
        sodiumValue: json["sodium_value"]?.toString(),
        sugars: json["sugars"]?.toString(),
        sugars100G: json["sugars_100g"]?.toString(),
        sugarsUnit: json["sugars_unit"]?.toString(),
        sugarsValue: json["sugars_value"]?.toString(),
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

  String? energy;
  String? energyPoints;
  String? energyValue;
  String? fiber;
  String? fiberPoints;
  String? fiberValue;
  String? fruitsVegetablesNutsColzaWalnutOliveOils;
  String? fruitsVegetablesNutsColzaWalnutOliveOilsPoints;
  String? fruitsVegetablesNutsColzaWalnutOliveOilsValue;
  String? grade;
  String? isBeverage;
  String? isCheese;
  String? isFat;
  String? isWater;
  String? negativePoints;
  String? positivePoints;
  String? proteins;
  String? proteinsPoints;
  String? proteinsValue;
  String? saturatedFat;
  String? saturatedFatPoints;
  String? saturatedFatRatio;
  String? saturatedFatRatioPoints;
  String? saturatedFatRatioValue;
  String? saturatedFatValue;
  String? score;
  String? sodium;
  String? sodiumPoints;
  String? sodiumValue;
  String? sugars;
  String? sugarsPoints;
  String? sugarsValue;

  factory NutriscoreData.fromJson(Map<String, dynamic> json) => NutriscoreData(
        energy: json["energy"]?.toString(),
        energyPoints: json["energy_points"]?.toString(),
        energyValue: json["energy_value"]?.toString(),
        fiber: json["fiber"]?.toString(),
        fiberPoints: json["fiber_points"]?.toString(),
        fiberValue: json["fiber_value"]?.toString(),
        fruitsVegetablesNutsColzaWalnutOliveOils:
            json["fruits_vegetables_nuts_colza_walnut_olive_oils"]?.toString(),
        fruitsVegetablesNutsColzaWalnutOliveOilsPoints:
            json["fruits_vegetables_nuts_colza_walnut_olive_oils_points"]
                ?.toString(),
        fruitsVegetablesNutsColzaWalnutOliveOilsValue:
            json["fruits_vegetables_nuts_colza_walnut_olive_oils_value"]
                ?.toString(),
        grade: json["grade"]?.toString(),
        isBeverage: json["is_beverage"]?.toString(),
        isCheese: json["is_cheese"]?.toString(),
        isFat: json["is_fat"]?.toString(),
        isWater: json["is_water"]?.toString(),
        negativePoints: json["negative_points"]?.toString(),
        positivePoints: json["positive_points"]?.toString(),
        proteins: json["proteins"]?.toString(),
        proteinsPoints: json["proteins_points"]?.toString(),
        proteinsValue: json["proteins_value"]?.toString(),
        saturatedFat: json["saturated_fat"]?.toString(),
        saturatedFatPoints: json["saturated_fat_points"]?.toString(),
        saturatedFatRatio: json["saturated_fat_ratio"]?.toString(),
        saturatedFatRatioPoints: json["saturated_fat_ratio_points"]?.toString(),
        saturatedFatRatioValue: json["saturated_fat_ratio_value"]?.toString(),
        saturatedFatValue: json["saturated_fat_value"]?.toString(),
        score: json["score"]?.toString(),
        sodium: json["sodium"]?.toString(),
        sodiumPoints: json["sodium_points"]?.toString(),
        sodiumValue: json["sodium_value"]?.toString(),
        sugars: json["sugars"]?.toString(),
        sugarsPoints: json["sugars_points"]?.toString(),
        sugarsValue: json["sugars_value"]?.toString(),
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

class SelectedImages {
  SelectedImages({
    this.front,
  });
  Front? front;
  factory SelectedImages.fromJson(Map<String, dynamic> json) => SelectedImages(
        front: json["front"] == null ? null : Front.fromJson(json["front"]),
      );
  Map<String, dynamic> toJson() => {
        "front": front?.toJson(),
      };
}

class Front {
  Front({
    this.display,
    this.small,
    this.thumb,
  });
  Display? display;
  Small? small;
  Thumb? thumb;
  factory Front.fromJson(Map<String, dynamic> json) => Front(
        display:
            json["display"] == null ? null : Display.fromJson(json["display"]),
        small: json["small"] == null ? null : Small.fromJson(json["small"]),
        thumb: json["thumb"] == null ? null : Thumb.fromJson(json["thumb"]),
      );
  Map<String, dynamic> toJson() => {
        "display": display?.toJson(),
        "small": small?.toJson(),
        "thumb": thumb?.toJson(),
      };
}

class Display {
  Display({
    this.en,
  });
  String? en;
  factory Display.fromJson(Map<String, dynamic> json) => Display(
        en: json["en"]?.toString(),
      );
  Map<String, dynamic> toJson() => {
        "en": en,
      };
}

class Small {
  Small({
    this.en,
  });
  String? en;
  factory Small.fromJson(Map<String, dynamic> json) => Small(
        en: json["en"]?.toString(),
      );
  Map<String, dynamic> toJson() => {
        "en": en,
      };
}

class Thumb {
  Thumb({
    this.en,
  });
  String? en;
  factory Thumb.fromJson(Map<String, dynamic> json) => Thumb(
        en: json["en"]?.toString(),
      );
  Map<String, dynamic> toJson() => {
        "en": en,
      };
}
