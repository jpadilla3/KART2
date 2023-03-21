import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('user is able to sign in', () {
    final usernameField = find.byValueKey('username');
    final passwordField = find.byValueKey('password');
    final loginButton = find.byValueKey('loginButton');
    final recoButton = find.byValueKey('recoButton');
    final searchButton = find.byValueKey('searchButton');
    final profileButton = find.byValueKey('profileButton');
    final logoutButton = find.byValueKey('logoutButton');
    final register = find.byValueKey('register');
    final confirmField = find.byValueKey('confirm');
    final signButton = find.byValueKey("signButton");
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('user can login', () async {
      //enter username
      await driver.tap(usernameField);
      await driver.enterText('test@test.com');

      //enter password
      await driver.tap(passwordField);
      await driver.enterText('abc123');

      //click login
      await driver.tap(loginButton);

      //check if on homescreen
      await driver.waitFor(find.text('HISTORY'));
    });

    test('user can click through pages', () async {
      //user is already logged in
      //user is on history page
      //user clicks on recommendation page
      await driver.tap(recoButton);

      //user clicks on search page
      await driver.tap(searchButton);

      //user clicks on profile page
      await driver.tap(profileButton);
    });

    test('user can create a new profile', () async {
      await driver.tap(logoutButton);

      //makes sure we are on login page and clicks on register button
      await driver.waitFor(find.text('Register here'));
      await driver.tap(register);

      //checks to see if we're on register page and starts filling in information
      await driver.waitFor(find.text('Welcome!'));
      await driver.tap(usernameField);

      //change this line everytime you run test
      await driver.enterText('KART150@KART.com');

      //enters password
      await driver.tap(passwordField);
      await driver.enterText("abc123");

      //enters confirm password
      await driver.tap(confirmField);
      await driver.enterText('abc123');

      //clicks sign up
      await driver.tap(signButton);

      //checks to see on intro screen 1
      await driver.waitFor(find.text('Welcome to KART!'));
    });
    test('user can click through intro screens', () async {
      final nextButton = find.byValueKey('next');
      final continueButton = find.byValueKey('continue');
      final conditionButton = find.byValueKey('conditions');
      await driver.tap(nextButton);
      await driver.tap(nextButton);
      await driver.tap(nextButton);
      await driver.tap(continueButton);

      await driver.tap(conditionButton);
      await driver.waitFor(find.byValueKey('history'));
    });
  });
}
