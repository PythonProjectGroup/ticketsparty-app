import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/blocs/validation_bloc/validation_bloc.dart';
import 'package:ticketspartyapp/blocs/validation_screen_bloc/validation_screen_bloc.dart';
import 'package:ticketspartyapp/constraints.dart';
import 'package:ticketspartyapp/models/event.dart';
import 'package:ticketspartyapp/ui/screens/validation_screen/validation_screen.dart';
import 'package:ticketspartyapp/utils/data_repository.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  const EventScreen({Key key, this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  Event event;
  bool isLoaded = false;
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  Future getEventInfo() async {
    event = await DataRepository.getEvent(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        id: widget.event.id);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    getEventInfo();
    super.initState();
  }

  void proceedToValidation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<ValidationBloc>(
              create: (BuildContext context) => ValidationBloc(
                  BlocProvider.of<AuthenticationBloc>(context), event.id),
            ),
            BlocProvider<ValidationScreenBloc>(
              create: (BuildContext context) => ValidationScreenBloc(),
            ),
          ],
          child: ValidationScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text("Event"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      floatingActionButton: Hero(
        tag: "fab",
        child: RaisedButton.icon(
          textColor: Colors.white,
          color: Colors.black87,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
          onPressed: proceedToValidation,
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Skanuj bilety",
              style: TextStyle(fontSize: 20),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Icon(
              Icons.search,
              size: 30,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: isLoaded
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    event.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    event.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                CarouselSlider.builder(
                  itemCount: event.pictures.length,
                  itemBuilder: (BuildContext context, int itemIndex) =>
                      Container(
                        child: Image.network("https://" +
                              serverUrl +
                              event.pictures[itemIndex]),
                        ),
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    aspectRatio: 2.0,
                    initialPage: 0,
                  ),
                ),
              ],
            ),
          ),
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
