import '../repositories/weather_repository.dart';
import '../providers/weather_provider.dart';

class WeatherServiceLocator {
  static WeatherRepository? _weatherRepository;
  static WeatherProvider? _weatherProvider;

  static WeatherRepository get weatherRepository {
    _weatherRepository ??= WeatherRepositoryImpl();
    return _weatherRepository!;
  }

  static WeatherProvider get weatherProvider {
    _weatherProvider ??= WeatherProvider(weatherRepository: weatherRepository);
    return _weatherProvider!;
  }

  static void reset() {
    _weatherRepository = null;
    _weatherProvider = null;
  }
}
