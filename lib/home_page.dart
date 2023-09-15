// from infinite scroll items
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //state variables
  final _scrollController = ScrollController();
  List<String> items = [];
  bool isLoading = false; //true - currently loading data
  bool isAllLoaded = false; //true - when no data to be loaded

  mockFetchItems() async {
    if (isAllLoaded) {
      return;
    }
    setState(() {
      isLoading =
          true; //indicating, made a request call (or) ongoing loading operation
    });
    await Future.delayed(
        (const Duration(milliseconds: 1000))); //imitates an actual API request
    List<String> newData = items.length >= 60
        ? []  //to prevent further generation of data
        : List.generate(15, (index) => 'Data ${index + items.length + 1}');
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }
    setState(() {
      isLoading = false;
      isAllLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    mockFetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoading) //!isLoading - previous mockFetch completes
      {
        print('FETCHED NEW DATA...');
        mockFetchItems();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Listing Items'),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (items.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Stack(
              children: [
                ListView.separated(
                    controller: _scrollController, //listens to changes in list
                    itemBuilder: (context, index) {
                      if (index < items.length) {   //59 < 60
                        return ListTile(
                          title: Text(items[index]),
                        );
                      }

                      // ignore: sized_box_for_whitespace
                      return Container(
                        width: constraints.maxWidth,
                        height: 80,
                        child: const Center(
                          child: Text('No more data to load'),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1.0,
                      );
                    },
                    itemCount: items.length + (isAllLoaded ? 1 : 0)),
                if (isLoading) ...[
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    // ignore: sized_box_for_whitespace
                    child: Container(
                      width: constraints.maxWidth,
                      height: 100,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }
        },
      ),
    );
  }
}
