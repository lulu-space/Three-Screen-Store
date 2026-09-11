import 'app_localizations.dart';

// Looks up product and category names in the .arb files so that
// nothing user-visible stays hard-coded in the data or the widgets.
extension ProductL10n on AppLocalizations {
  String productName(String id) {
    switch (id) {
      case 'headphones':
        return productHeadphones;
      case 'smartWatch':
        return productSmartWatch;
      case 'speaker':
        return productSpeaker;
      case 'mouse':
        return productMouse;
      case 'keyboard':
        return productKeyboard;
      case 'monitor':
        return productMonitor;
      case 'earbuds':
        return productEarbuds;
      case 'tracker':
        return productTracker;
      default:
        return id;
    }
  }

  String categoryName(String category) {
    switch (category) {
      case 'All':
        return all;
      case 'Audio':
        return audio;
      case 'Watches':
        return watches;
      case 'Accessories':
        return accessories;
      case 'Screens':
        return screens;
      default:
        return category;
    }
  }
}
