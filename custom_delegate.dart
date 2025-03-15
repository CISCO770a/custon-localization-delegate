
class MyLocalizationDelagate {
  /// Current App Locale Value
  /// That Will be catched in the "load" method in the Delegate class
  /// Will be used to catch the current Json file
  /// The json file of each language should be the same as the langCode
  /// "en", "ar", "fr" .......

  final Locale? locale;

  // Create a constructor and pass the locale to cach it from the load

  MyLocalizationDelagate({required this.locale});

  /// Create the of method that will tell flutter the this class is responsible for the Localization
  /// Pass the context to trigger the data of the current rout in the widget tree

  static MyLocalizationDelagate? of({required BuildContext context}) {
    MyLocalizationDelagate? localization =
        Localizations.of<MyLocalizationDelagate>(
      context,
      MyLocalizationDelagate,
    );

    return localization;
  }

  /// Create the Map that willl Store the localized text loaded from json
  /// It will be initalized after catching the data from json

  late Map<String, String> _localizedText;

  /// Create the method that will :-
  /// [1] Catch the name of the json file of the Selected Language
  /// [2] Load this json from the file
  /// [3] Decode this json to convert it to Map
  /// [4] The Catched Map genirecs from <String, dynamic>
  /// [5] map it to make it geniric from <String, String>
  /// [6] Initialize the _localizedText map

  Future<void> get loadAdnCatchJson async {
    final String jsonPath = "assets/languages/${locale!.languageCode}.json";

    final String jsonLoader = await rootBundle.loadString(jsonPath);

    final Map<String, dynamic> texts = json.decode(jsonLoader);

    _localizedText = texts.map(
      (key, value) {
        return MapEntry(
          key,
          value.toString(),
        );
      },
    );
  }

  /// Create a method the take "key" param and return String
  /// With this "key" I will catch is's value from the localizedText Map
  /// If the kwy is not found it will return "Not found Key" String

  String getLocaliedText({required String key}) {
    String value = _localizedText[key] ?? "Not Found Key";
    return value;
  }

  static const LocalizationsDelegate<MyLocalizationDelagate> delegate =
      _AppDelegate();
}

class _AppDelegate extends LocalizationsDelegate<MyLocalizationDelagate> {
  const _AppDelegate();

  // Needs to Check if the Seelcted Locale is Supported from the App
  @override
  bool isSupported(Locale locale) {
    List<Locale> supportedLocales = const <Locale>[
      Locale("en"),
      Locale("ar"),
    ];

    bool isSupported = supportedLocales.contains(locale);

    return isSupported;
  }

  /// Load the resources for this delegate should be loaded
  /// Like the cusrrent locale of the app
  /// The json Files of eatch language
  /// again by calling the [load] method.
  ///
  /// This method is called whenever its [Localizations] widget is
  /// rebuilt. If it returns true then dependent widgets will be rebuilt
  /// after [load] has completed.

  @override
  Future<MyLocalizationDelagate> load(Locale locale) async {
    MyLocalizationDelagate delegate = MyLocalizationDelagate(locale: locale);

    await delegate.loadAdnCatchJson;

    return delegate;
  }

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<MyLocalizationDelagate> old,
  ) {
    return false;
  }
}

// Create a Function to catch the key and return the value

// Before : MyLocalizationDelagate.of(context: context,)!.getLocaliedText(key: key)
// After  : localizaedText(key: key)

String localizaedText({required String key}) {
  final BuildContext context = navigatorkey.currentContext as BuildContext;

  MyLocalizationDelagate localization = MyLocalizationDelagate.of(
    context: context,
  )!;

  String targetVal = localization.getLocaliedText(key: key);

  return targetVal;
}
