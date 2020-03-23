import 'package:flutter/material.dart';
import 'fetch_functions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COV.ID-19',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<dynamic> futureSummary;

  @override
  void initState() {
    super.initState();
    futureSummary = fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: ListView(
        children: [
          FutureBuilder(
              future: futureSummary,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var value = snapshot.data['activeCare']['value'];
                  return ActiveCaseHeader(count: value);
                }

                return ActiveCaseHeader(count: 0);
              }),
          Container(
            height: MediaQuery.of(context).size.height - 125.0,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0))),
            child: CardBody(),
          )
        ],
      ),
    );
  }
}

class ActiveCaseHeader extends StatelessWidget {
  ActiveCaseHeader({this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Container(
          height: 65.0,
          child: Column(
            children: <Widget>[
              Text('Active', style: TextStyle(color: Colors.white)),
              Text('$count Case',
                  style: TextStyle(color: Colors.white, fontSize: 40.0))
            ],
          )),
    );
  }
}

class CardBody extends StatefulWidget {
  @override
  _CardBodyState createState() => _CardBodyState();
}

class _CardBodyState extends State<CardBody> {
  Future<dynamic> futureSummary;
  Future<dynamic> futureNews;

  @override
  void initState() {
    super.initState();
    futureSummary = fetchSummary();
    futureNews = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45.0, left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Statistics',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          Statistics(futureSummary: futureSummary),
          Text('News',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          Expanded(
            child: FutureBuilder(
                future: futureNews,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var news = snapshot.data['articles'];
                    var count = snapshot.data['totalResults'] - 1;

                    return ListView.builder(
                        itemCount: count,
                        itemBuilder: (BuildContext context, int index) {
                          var singleNews = news[index];
                          var content = singleNews['content'] != null
                              ? singleNews['content']
                              : '';
                          return NewsCard(
                              title: singleNews['title'], subtitle: content);
                        });
                  }

                  return NewsCard(title: 'Loading', subtitle: '...');
                }),
          )
        ],
      ),
    );
  }
}

class Statistics extends StatelessWidget {
  const Statistics({
    Key key,
    @required this.futureSummary,
  }) : super(key: key);

  final Future futureSummary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
          height: 100.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              FutureBuilder(
                  future: futureSummary,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var value = snapshot.data['recovered']['value'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Card(
                          child: Container(
                              width: 185.0,
                              child: ListTile(
                                title: Text('Recovered'),
                                subtitle: Text(
                                  '$value Case',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 30.0),
                                ),
                              )),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Card(
                        child: Container(
                            width: 185.0,
                            child: ListTile(
                              title: Text('Recovered'),
                              subtitle: Text(
                                '0 Case',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 30.0),
                              ),
                            )),
                      ),
                    );
                  }),
              FutureBuilder(
                  future: futureSummary,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var value = snapshot.data['deaths']['value'];
                      return Card(
                        child: Container(
                            width: 185.0,
                            child: ListTile(
                              title: Text('Deaths'),
                              subtitle: Text(
                                '$value Case',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 30.0),
                              ),
                            )),
                      );
                    }

                    return Card(
                      child: Container(
                          width: 185.0,
                          child: ListTile(
                            title: Text('Deaths'),
                            subtitle: Text(
                              '0 Case',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 30.0),
                            ),
                          )),
                    );
                  })
            ],
          )),
    );
  }
}

class NewsCard extends StatelessWidget {
  NewsCard({@required this.title, this.subtitle = '...'});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('$title'),
      ),
    );
  }
}
