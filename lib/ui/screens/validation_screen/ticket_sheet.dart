import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/validation_bloc/bloc.dart';
import 'package:ticketspartyapp/blocs/validation_screen_bloc/bloc.dart';

class BottomSheetTicket extends StatefulWidget {
  const BottomSheetTicket({Key key}) : super(key: key);

  @override
  _BottomSheetTicketState createState() => _BottomSheetTicketState();
}

class _BottomSheetTicketState extends State<BottomSheetTicket> {
  // ignore: close_sinks
  ValidationBloc validationBloc;

  // ignore: close_sinks
  ValidationScreenBloc validationScreenBloc;

  Future<bool> _willPopCallback() async {
    validationScreenBloc.add(CloseSheetPressed());
    return false;
  }

  @override
  void initState() {
    validationBloc = BlocProvider.of<ValidationBloc>(context);
    validationScreenBloc = BlocProvider.of<ValidationScreenBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    validationScreenBloc.add(CloseSheetPressed());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: BlocListener<ValidationBloc, ValidationState>(
        listener: (BuildContext context, ValidationState state) {
          if (state is ShowingTicket) {
            if (state.status == ValidationStatus.Success) {
              Future.delayed(const Duration(milliseconds: 400), () {
                BlocProvider.of<ValidationScreenBloc>(context).add(
                    CloseSheetPressed());
                BlocProvider.of<ValidationBloc>(context).add(BackToScanning());
              });
            }
          }
        },
        child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 10.0),
              borderRadius: BorderRadius.circular(30),
            ),
            child: BlocBuilder<ValidationBloc, ValidationState>(
              builder: (BuildContext context, state) {
                if (state is ShowingTicket) {
                  return Column(
                    children: <Widget>[
                      Text('Ticket'),
                      Text("Name: ${state.ticket.personName}"),
                      Text(
                        "Number of people: ${state.ticket.numberOfPeople.toString()}",
                      ),
                      Text("Used: ${state.ticket.used}"),
                      Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                                color: state.status == ValidationStatus.Waiting
                                    ? Colors.black
                                    : state.status == ValidationStatus.Loading
                                        ? Colors.black
                                        : state.status ==
                                                ValidationStatus.Success
                                            ? Colors.green
                                            : Colors.red,
                                border: Border.all(
                                    color:
                                        state.status == ValidationStatus.Waiting
                                            ? Colors.blue
                                            : state.status ==
                                                    ValidationStatus.Loading
                                                ? Colors.blue
                                                : state.status ==
                                                        ValidationStatus.Success
                                                    ? Colors.black
                                                    : Colors.black,
                                    width: 2),
                                borderRadius: BorderRadius.circular(30)),
                            width: state.status == ValidationStatus.Waiting
                                ? 200
                                : state.status == ValidationStatus.Loading
                                    ? 50
                                    : state.status == ValidationStatus.Success
                                        ? 200
                                        : 200,
                            height: 50,
                            duration: Duration(milliseconds: 200),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: state.status == ValidationStatus.Waiting
                                    ? Text(
                                        "Click To Validate",
                                        style: buttonTextStyle,
                                      )
                                    : state.status == ValidationStatus.Loading
                                        ? CircularProgressIndicator()
                                        : state.status ==
                                                ValidationStatus.Success
                                            ? Text(
                                                "Success",
                                                style: buttonTextStyle,
                                              )
                                            : Text(
                                                "Failure",
                                                style: buttonTextStyle,
                                              ),
                              ),
                            ),
                          ),
                          onTap: () => {
                            BlocProvider.of<ValidationBloc>(context)
                                .add(ValidationStarted(state.ticket)),
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is ShowingError) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else if (state is LoadingTicket) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Text("Please scan QR code"),
                  );
                }
              },
            )),
      ),
    );
  }
}

TextStyle buttonTextStyle =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600);
