import 'package:flutter/material.dart';
import 'bottom_navigation.dart';

class FindAlumni extends StatelessWidget{
  const FindAlumni({super.key});

  @override
  Widget build(BuildContext context){    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Alumni of you University"),
      ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
           _searchForm(),
           SizedBox(height: 20,),
          bottomNavigation(context: context),
        ],
      ),
      ),
    );
  }
}

class _searchForm extends StatelessWidget{
  const _searchForm();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
              labelText: "University",
              border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Department",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16,),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Company",
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
           const SizedBox(height: 16,),
           ElevatedButton(
            onPressed: (){
              //handle search function
            },
            child: const Text("Find Now"),
            )
          ]
        ),
        ),
    );
  }
}
