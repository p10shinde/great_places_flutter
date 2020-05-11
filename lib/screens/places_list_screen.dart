import 'package:flutter/material.dart';
import 'package:great_places/helpers/db_helper.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, placesSnapshot) =>
            placesSnapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<GreatPlaces>(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Got no places yet, start adding some!!'),
                          const SizedBox(
                            height: 10,
                          ),
                          RaisedButton.icon(
                            color: Theme.of(context).accentColor,
                            icon: Icon(Icons.add),
                            label: Text('Add Place'),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AddPlaceScreen.routeName),
                          )
                        ],
                      ),
                    ),
                    builder: (ctx, greatPlaces, ch) {
                      return greatPlaces.items.length <= 0
                          ? ch
                          : ListView.builder(
                              itemCount: greatPlaces.items.length,
                              itemBuilder: (ctx, index) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      FileImage(greatPlaces.items[index].image),
                                ),
                                title: Text(greatPlaces.items[index].title),
                                subtitle: Text(
                                    '${greatPlaces.items[index].location.address}'),
                                onTap: () => Navigator.of(context)
                                    .pushNamed(PlaceDetailScreen.routeName, arguments: greatPlaces.items[index].id),
                              ),
                            );
                    },
                  ),
      ),
      //   Center(
      //   child: Provider.of<GreatPlaces>(context).items.isEmpty ?  CircularProgressIndicator() : Text('I\'ll Sow'),
      // ),
    );
  }
}
