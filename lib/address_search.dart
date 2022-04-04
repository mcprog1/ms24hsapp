import 'package:flutter/material.dart';
import 'package:ms24hs/service/google_places.dart';

class AddresSearch extends SearchDelegate<Suggestion> {
  final sessionToken;
  late PlaceApiProvider apiClient;

  AddresSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
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
      onPressed: () {},
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("");
    /**
     *  FutureBuilder(
        future: query == "" ? null : apiClient.fetchSuggestions(query),
        builder: (context, snapshot) => query == "" ? Container(child: Text("Ingresa su direccion"),) : snapshot.hasData ? ListView.builder(itemBuilder: (context, i)=>ListTile(title: Text((snapshot.data[i] as Suggestion).description),), itemCount: snapshot.data!.lenzgth,));
     */
  }
}
