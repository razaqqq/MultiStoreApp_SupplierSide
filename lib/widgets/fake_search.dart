


import 'package:flutter/material.dart';

import '../main_screen/minor_screen/search_screen.dart';

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen(),));
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.yellow, width: 1.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Icon(Icons.search)),
              Text("What Are You Looking For ?", style: TextStyle(fontSize: 14, color: Colors.grey),),
            ],),
            Container(
              height: 32,
              width: 75,
              decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(25)),
              child: const Center(child: Text("Search", style: TextStyle(fontSize: 14, color: Colors.grey),)),
            )
          ],
        ),
      ),
    );
  }
}