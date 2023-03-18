class ApiConstants {
  static String baseUrl = 'https://us.openfoodfacts.org';
  //Get A Product By Barcode endpoint
  static String barcodeEndpoint =
      '/api/v2/product/{barcode}?fields=allergens,brands,categories,ingredients,nutrient_levels,nutriments,nutriscore_data,product_name,nutriscore_score,nutrition_grades,product_name,traces.json';
  //Search for Products endpoint, *not finished*
  static String searchEndpoint = '/api/v2/search';
}
