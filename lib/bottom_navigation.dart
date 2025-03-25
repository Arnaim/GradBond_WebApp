import 'package:flutter/material.dart';

class bottomNavigation extends StatelessWidget{
  final BuildContext context;
  const bottomNavigation({super.key, required this.context});  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: (){}, 
          child: const Text("Find Alumni")
        ),
        TextButton(
          onPressed: (){},
          child: const Text("Events")
        ),
        TextButton(
          onPressed: (){
             _showLogoutDialog(context);
          },
          child: const Text("Log out")
        ),
        TextButton(
          onPressed: (){
           // Navigator.push(context, 
           // MaterialPageRoute(builder: (context) => const ProfilePage()));
          },
          child: const Text("You")
        ),
      ],
    );
  }
}

void _showLogoutDialog(BuildContext context){
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: (){},
          child: const Text("Cancel")
        ),
        TextButton(
          onPressed: (){
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text("Logout")
        )
      ],
    )
  );
}