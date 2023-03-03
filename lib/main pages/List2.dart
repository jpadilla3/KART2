import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final List<Map<String, String>> items;

  ItemList({required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 550.0,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.network(
                    items[index]['image']!,
                    height: 65.0,
                    width: 65.0,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          items[index]['title']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Image.network(
                          items[index]['image2']!,
                          height: 65.0,
                          width: 65.0,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 25,
                    ),
                    color: Colors.indigo[400],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
