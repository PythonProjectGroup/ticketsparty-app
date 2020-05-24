import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_event.dart';
import 'package:ticketspartyapp/models/event.dart';
import 'package:ticketspartyapp/ui/screens/add_event_screen/add_event_screen.dart';
import 'package:ticketspartyapp/ui/screens/home_screen/event_tile.dart';
import 'package:ticketspartyapp/utils/data_repository.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> events = List<Event>();
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  Future loadEvents() async {
    var loadedEvents = await DataRepository.getEventsWithKey(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
    setState(() {
      events = loadedEvents;
    });
  }

  @override
  void initState() {
    loadEvents();
    super.initState();
  }

  void addKey() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventScreen()),
    );
    loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(title: Text("Home Screen"),
        centerTitle: true,
        backgroundColor: Colors.black87,),
      drawer: Drawer(
        child: Container(
          color: Colors.black87,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, 3.0),
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                      height: kToolbarHeight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Joachim Schmidt",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.list,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 50),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: addKey,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  Text(
                                    "Add Event",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Center(
                  child: GestureDetector(
                    onTap: () =>
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedOut()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.grey[100], fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: addKey,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: events.length == 0
            ? Center(
          child: Text("Press + to add event"),
        )
            : ListView.builder(
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              return new EventTile(
                event: events[index],
              );
            }),
      ),
    );
  }
}

