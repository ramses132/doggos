// dog_card.dart

import 'package:flutter/material.dart';

import 'dog_detail_page.dart';

import 'dog_model.dart';

class DogCard extends StatefulWidget {
  final Dog dog;

  DogCard(this.dog);
  @override
  _DogCardState createState() => _DogCardState(dog);
}

class _DogCardState extends State<DogCard> {
  Dog dog;
  // A class property that represents the URL flutter will render
  // from the Dog class.
  String renderUrl;
  _DogCardState(this.dog);

  @override
  Widget build(BuildContext context) {
    // Start with a container so we can add layout and style props:
    // InkWell is a special material widget that makes its children tappable
    // and adds material design ink ripple when tapped.
    return InkWell(
      // onTap is a callback that will be triggered when tapped.
      onTap: showDogDetailPage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 50.0,
                child: dogCard,
              ),
              Positioned(
                top: 7.5, child: dogImage,
              )
            ],
          ),
        ),
      ),
    );
    /*
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 115.0,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 50.0,
              child: dogCard,
            ),
            Positioned(
              top: 7.5, child: dogImage,
            )
          ],
        ),
      ),
    );
    return Container(
      // Arbitrary number that I decided looked good:
      height: 115.0,
      // A stack takes children, with a list of widgets.
      child: Stack(
        children: <Widget>[
          // position our dog image, so we can explicitly place it.
          // We'll place it after we've made the card.
          Positioned(
            child: dogImage,
          )
        ],
      ),
    );
   */
  }

  showDogDetailPage() {
    // Navegaator.of(context) accesses the current app's navegator.
    // navegators can push new routes onto the stack,
    // as well as pop routes off the stack.
    //
    // this is the easiest way to build a new page on the fly
    // and pass that page some state from the current page.
    Navigator.of(context).push(
      MaterialPageRoute(
        // builder methods always take context!
        builder: (context) {
          return DogDetailPage(dog);
        }
      )
    );
  }

  Widget get dogCard {
    // A new container
    // The height and width are arbitrary numbers for styling.
    return Container(
      width: 290.0,
      height: 115.0,
      child: Card(
        color: Colors.black45,
        // Warap children in a Padding widget in order to give padding.
        child: Padding(
          // the class that controls padding is called 'EdgeInsets'
          // The EdgeInsets.only constructor is used to set
          // padding explicitly to each side of the child.
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 64.0,
          ),
          // Column is another layout widget -- like stack -- that
          // takes a list of widgets as children, and lays the
          // widgets out from top to bottom.
          child: Column(
            // these alignment properties function exactly like
            // CSS flexbox properties.
            // the main axis of a column is the vertical axis,
            // MainAxisAlignment.spaceAround is equivalent of
            // CSS's justifi-content: space-around in a verically
            // laid out flexbox.
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                widget.dog.name,
                // Themes are set in the MaterialApp widget at the root of your app.
                // They have defaults values -- which we're using because we didn't set our own.
                // They're great for having consistent, app-wide styling that's easily changed.
                style: Theme.of(context).textTheme.subhead
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                  ),
                  Text(': ${widget.dog.rating} / 10')
                ],
              )
            ],
          )
        ),
      ),

    );
  }

  // State classes run this method when the state is created.
  // you shouldn't do async work in initState, so we'll defer it
  // to another method.

  void initState(){
    super.initState();
    renderDogPic();
  }

  // IRL, we'd want the Dog class itself to get the image
  // but this is a simpler way to explain Flutter basics

  void renderDogPic() async {
    //this makes the service call
    await dog.getImageUrl();
    // setState tells Flutter to rerender anything that's been changed.
    // setState cannot be async, so we use a varaible that can be overwritten

    setState(() {
      renderUrl = dog.imageUrl;
    });
  }

  Widget get dogImage {
    var dogAvatar = Hero(
      // Give your hero a tag.
      //
      // Flutter looks for two widgets on two different pages,
      // and if they have the same tag it animates between them.
      tag: dog,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image:  NetworkImage(renderUrl ?? '')
          ),
        ),
      ),
    );
    // Placeholder is a  static container the same size as the dog image.

    var placeholder = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        'DOGGO',
        textAlign: TextAlign.center,
      ),
    );

    // this is an animated widget build into flutter.
    return AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: dogAvatar,
      // Then, you pass it a ternary that should be based on your state
      //
      // If renderUrl is null tell the widget to use the placeholder,
      // otherwise use the dogAvatar.
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      // Finally, pass in the amount of time the fade should take.
      duration: Duration(milliseconds: 1000),
    );
    /*
    return Container(
      // You can explicitly set heights and widths on Containers.
      // Otherwise they take up as much space as their children.
      width: 100.0,
      height: 100.0,
      // Decoration is a property that lets you style the container.
      // It expects a Box Decoration.
      decoration: BoxDecoration(
        // BoxDecorations has meny possible properties.
        // Using BoxShape with a background image is the
        // easist way to make a circle cropped avatar style image.
        shape: BoxShape.circle,
        image: DecorationImage(
          // Just like CSS's impagesize property.
          fit: BoxFit.cover,
          // A networkImage widget is a widget that
          // takes a URL to an image.
          // Image Providers (such as Netwrok Image) are ideal
          // when your image needs to be loaded ar can change.
          // use the null check to avoid an error.
          image: NetworkImage(renderUrl ?? ''),
        ),
      ),
    );
    */
  }


}
