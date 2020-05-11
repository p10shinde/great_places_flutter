import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double latitude, double longitude) {
    final _staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude,
      longitude,
    );
    setState(() {
      _previewImageUrl = _staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapsScreen(
          isSelecting: true,
        ),
      ),
    );

    if (selectedLocation == null) return;

    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(_previewImageUrl,
                  fit: BoxFit.cover, width: double.infinity),
        ),
        Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FlatButton.icon(
                icon: Icon(Icons.location_on),
                label: Text('Current Location'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _getCurrentUserLocation,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FlatButton.icon(
                icon: Icon(Icons.map),
                label: Text('Select on Map'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _selectOnMap,
              ),
            ),
          ],
        )
      ],
    );
  }
}
