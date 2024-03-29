class ApiConstants {
  static String baseUrl = 'https://us.openfoodfacts.org';
  //Get A Product By Barcode endpoint
  static String barcodeEndpoint =
      '/api/v2/product/{barcode}?fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json';
  //Search for Products endpoint, *not finished*
  static String searchEndpoint = '/api/v2/search';
}
