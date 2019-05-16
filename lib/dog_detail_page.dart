import 'package:flutter/material.dart';

import 'dog_model.dart';

class DogDetailPage extends StatefulWidget {
  final Dog dog;

  DogDetailPage(this.dog);

  @override
  _DogDetailPageState createState() => _DogDetailPageState();
}

class _DogDetailPageState extends State<DogDetailPage> {
  // Arbitrary size choice for styles
  final double dogAvatarSize = 150.0;

  // this is the starting value of the slider.
  double _sliderValue = 10.0;

  // Just like a route, this needs to be async, because it can return
  // information when the user interacts.

  Future<Null> _ratingErrorDialog() async {
    // showDialog is a built-in Flutter method.
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error!'),
            content: Text("They're good-dogs, Brant."),
            //This action uses the navigator to dismiss the dialog.
            // this is where you could return information if you wanted to.
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Widget get dogImage {
    return Hero(
      tag: widget.dog,
      child: Container(
        height: dogAvatarSize,
        width: dogAvatarSize,
        // Use Box Decoration to make the image a circle
        // and add an arbitrary shadow for styling.
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Like in CSS you often want to add multiple
            // BoxShadows for the right look so the
            // boxShadow property takes a list of BoxShadows.
            boxShadow: [
              const BoxShadow(
                // just like CSS:
                // it takes the same 4 properties
                offset: const Offset(1.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: -1.0,
                color: const Color(0x33000000),
              ),
              const BoxShadow(
                offset: const Offset(2.0, 1.0),
                blurRadius: 3.0,
                spreadRadius: 0.0,
                color: const Color(0x24000000),
              ),
              const BoxShadow(
                  offset: const Offset(3.0, 1.0),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                  color: const Color(0x1F000000)),
            ],
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(widget.dog.imageUrl))),
      ),
    );
  }

  // The rating section that says ★ 10/10.
  Widget get rating {
    // Use a row to lay out widgets horizontally.

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star,
          size: 40.0,
        ),
        Text(
          ' ${widget.dog.rating} / 10',
          style: Theme.of(context).textTheme.display2,
        ),
      ],
    );
  }

  Widget get dogProfile {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        // this would be a great opportunity to create a custom Linear Gradiant widget
        // that could be shared throughout the app but I'll leave that to you.
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.indigo[800],
            Colors.indigo[700],
            Colors.indigo[600],
            Colors.indigo[400],
          ],
        ),
      ),
      // The dog Profile informaation.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          dogImage,
          Text(
            '${widget.dog.name}  🎾',
            style: TextStyle(fontSize: 32.0),
          ),
          Text(
            widget.dog.location,
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Text(widget.dog.description),
          ),
          rating
        ],
      ),
    );
  }

  Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // In a row, column, listview, etc., a Flexible widget is a wrapper
              // that works much like CSS's flex-grow property.
              //
              // Any room left over in the main axis after
              // the widgets are given their width
              // will be distributed to all the flexible widgets
              // at a ratio based on the flex property you pass in.
              // Because this is the only Flexible widget,
              // it will take up all the extra space.
              //
              // In other words, it will expand as much as it can until
              // the all the space is taken up.
              Flexible(
                flex: 1,
                // A slider, like many form elements, needs to know its
                // own value and how to update that value.
                //
                // The slider will call onChanged whenever the value
                // changes. But it will only repaint when its value property
                // changes in the state using setState.
                //
                // The workflow is:
                // 1. User drags the slider.
                // 2. onChanged is called.
                // 3. The callback in onChanged sets the sliderValue state.
                // 4. Flutter repaints everything that relies on sliderValue,
                // in this case, just the slider at its new value.
                child: Slider(
                  activeColor: Colors.indigoAccent,
                  min: 0.0,
                  max: 15.0,
                  onChanged: (newRating) {
                    setState(() => _sliderValue = newRating);
                  },
                  value: _sliderValue,
                ),
              ),
              Container(
                width: 50.0,
                alignment: Alignment.center,
                child: Text(
                  '${_sliderValue.toInt()}',
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
            ],
          ),
        ),
        submitRatingButton,
      ],
    );
  }

  // A simple Raised Button that as of now doesn't do anything yet.
  Widget get submitRatingButton {
    return RaisedButton(
      onPressed: updateRating,
      child: Text('Submit'),
      color: Colors.indigoAccent,
    );
  }

  //Finally, the build method:
  //
  // Aside:
  // It's often much easier to build UI if you break up your widgets the way I
  // have in this file rather than trying to have one massive build method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('Meet ${widget.dog.name}'),
        ),
        body: ListView(
          children: <Widget>[dogProfile, addYourRating],
        ));
  }

  void updateRating() {
    if (_sliderValue < 10) {
      _ratingErrorDialog();
    } else {
      setState(() => widget.dog.rating = _sliderValue.toInt());
    }
  }
}
