import 'package:flutter_dotenv/flutter_dotenv.dart';

class GraphQLSetup {
  GraphQLSetup._();

  static Map<String, String> get graphQLHeader => {
        'X-Parse-Application-Id': dotenv.env['APP_ID']!,
        'X-Parse-Master-Key': dotenv.env['MASTER_KEY']!,
        'X-Parse-Client-Key': dotenv.env['CLIENT_KEY']!,
      };

  static String get graphqlAPI => dotenv.env['GRAPHQL_API']!;
}
