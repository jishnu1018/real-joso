import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mytutor extends StatefulWidget {
  const Mytutor({super.key});

  @override
  State<Mytutor> createState() => _MytutorState();
}

class _MytutorState extends State<Mytutor> {
  final _userStream =
      FirebaseFirestore.instance.collection('tutorvacant').snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsetsDirectional.all(5),
        // decoration: const BoxDecoration(
        //   image:
        // DecorationImage(image: AssetImage('assets/images/joso2.jpg'))),
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 234, 234, 234),
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: AppBar(
                    //  flexibleSpace: Container(
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //   image:
                    //const AssetImage('assets/images/cook1.png'),
                    //fit: BoxFit.fill,
                    //  colorFilter: ColorFilter.mode(
                    //   const Color.fromARGB(255, 230, 216, 226)
                    //    .withOpacity(0.2),
                    //BlendMode.modulate)))),
                    backgroundColor: Color.fromARGB(255, 1, 0, 27),
                    title: const Text(
                      'TUTOR',
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SearchPage()),
                        ),
                        icon: const Icon(Icons.search),
                      )
                    ])),
            body: Stack(children: [
              StreamBuilder(
                  stream: _userStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('connection error');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...');
                    }
                    var docs = snapshot.data!.docs;
                    //return Text('${docs.length}');
                    return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) async {
                                var i = docs[index];
                                FirebaseFirestore.instance
                                    .collection('tutorvacant')
                                    .doc(i.id)
                                    .delete();

                                docs.removeAt(index);
                              },
                              background: Container(
                                color: Colors.red,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(
                                  docs[index]['Name'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      docs[index]['place'],
                                    ),
                                    Text(docs[index]['duration']),
                                    Text(docs[index]['comments']),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pushNamed(
                                            context, 'Tutorapply');
                                      });
                                    },
                                    child: Text(
                                      'apply',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 252, 251, 251),
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(255, 1, 0, 27)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 1, 0, 27),
                                                ))))),
                              ));
                        });
                  }),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'tutoradd');
                    },
                    child: const Icon(Icons.add),
                    backgroundColor: Color.fromARGB(255, 1, 0, 27)),
              ),
            ])));
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 0, 27),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.black,
                  onPressed: () {
                    /* Clear the search field */
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
