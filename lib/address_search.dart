import 'package:flutter/material.dart';
import 'package:ms24hs/service/google_places.dart';

class AddresSearch extends SearchDelegate<Suggestion> {
  final sessionToken;
  late PlaceApiProvider apiClient;

  AddresSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  PlaceDetail(String placeId) {
    apiClient.getPlaceDetailFromId(placeId);
    return apiClient;
  }

  currentLocation(String lat, String long) {
    apiClient.getCurrentLocation(lat, long);
    return apiClient;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        Suggestion? sug = Suggestion("", "");
        close(context, sug);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: query == "" ? null : apiClient.fetchSuggestions(query),
        builder: (context, AsyncSnapshot<List<Suggestion>> snapshot) =>
            query == ""
                ? Container(
                    child: Text("Ingrese su localidad"),
                  )
                : snapshot.hasData
                    ? ListView.builder(
                        itemBuilder: (context, i) => ListTile(
                          title: Text((snapshot.data![i]).description),
                          onTap: () {
                            apiClient.getPlaceDetailFromId(
                                snapshot.data![i].placeId);
                            close(context, snapshot.data![i]);
                          },
                        ),
                        itemCount: snapshot.data!.length,
                      )
                    // ignore: avoid_unnecessary_containers
                    : Container(
                        child: const Center(child: CircularProgressIndicator()),
                      ));
  }
}
