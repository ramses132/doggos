// main.dart
import 'package:flutter/material.dart';

import 'dog_model.dart';
import 'dog_list.dart';
import 'new_dog_form.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// MaterialApp isthe base Widget for your Flutter Application
    /// Gives us access to routing, context, and meta info functionality.

    return MaterialApp(
      title: 'We Rate Dogs',
      // Make all our text default to white
      // and backgrounds default to dark
      theme: ThemeData(brightness: Brightness.dark),
      home: MyHomePage(title: ' We Rate Dogs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Dog> initialDoggos = []
    ..add(Dog('Ruby', 'Portland, OR, USA',
        'Ruby is a very good girl. Yes: Fetch, loungin\'. No: Dogs who get on furniture.'))
    ..add(Dog('Rex', 'Seattle, WA, USA', 'Best in Show 1999'))
    ..add(Dog('Rod Stewart', 'Prague, CZ',
        'Star good boy on international snooze team.'))
    ..add(Dog('Herbert', 'Dallas, TX, USA', 'A Very Good Boy'))
    ..add(Dog('Buddy', 'North Pole, Earth', 'Self proclaimed human lover.'));

  Future _showNewDogForm() async {
    // push a new route like you did in the last section
    Dog newDog = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddDogFormPage();
        }
      )
    );
    
    if (newDog != null){
      // Add a newDog to our mock dog-array.
      initialDoggos.add(newDog);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// scaffold is the base for a page.
    /// It gives an AppBar for the top.
    /// Space for the main body, bottom navegation and more.
    return Scaffold(
      /// App bar has a ton of functionality, but for now lets
      /// just give it a color and title.
      appBar: AppBar(
        /// Access this widgets properties with 'widget'
        title: Text(widget.title),
        backgroundColor: Colors.black87,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showNewDogForm,
          )
        ],
      ),

      /// Container is a convenience widget that lets us style it's
      /// children. It doesn't take up any space itself, so it
      /// can be used as placeholder in your code.
      body: Container(
        // Add box decoration
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.indigo[800],
              Colors.indigo[700],
              Colors.indigo[600],
              Colors.indigo[400],
            ]
          )
        ),
        ///  child: DogCard(initialDoggos[1]), // New Code
        /// remove the DogCard Widget.
        /// Instead, use your new DogList Class,
        /// Pass in the mock data from the list above.
        child: Center( // Changed code
          child: DogList(initialDoggos), // changed code
        ),
      ),
    );
  }
}
