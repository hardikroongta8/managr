import 'package:butlr/screens/components/appbar.dart';
import 'package:butlr/services/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:butlr/services/auth_service.dart';
import 'package:butlr/shared/constants.dart';
import 'package:butlr/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({required this.toggleView, super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String fullName = '';
  String error = '';
  bool loading = false;

  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MyAppBar(title: 'Signup')
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: (value){
                        if((value == null) || (value.length < 6)){
                          return 'Enter a valid name';
                        }
                        else{
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          fullName = value;
                        });
                      },
                      cursorWidth: 0.6,
                      cursorColor: Colors.amber[700],
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Full Name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.amber[700],
                        ),
                      ) 
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      validator: (value) => value == '' ? 'Field cannot be empty' : null,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      cursorWidth: 0.6,
                      cursorColor: Colors.amber[700],
                      keyboardType: TextInputType.emailAddress,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: Colors.amber[700]
                        ),
                      )              
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      validator: (value){
                        if((value == null) || (value.length < 6)){
                          return 'Minimum 6 characters required';
                        }
                        else{
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      obscureText: true,
                      cursorWidth: 0.6,
                      cursorColor: Colors.amber[700],
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.amber[700],
                        ),
                      ) 
                    ),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.amber[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                      onPressed: ()async{
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _authService.register(email, password, fullName);
                          if(result == null){
                            setState(() {
                              setState(() {
                                loading = false;
                              });
                              error = 'Invalid Email';
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Sign-up',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300
                        ),
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Already have an account?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
                        TextButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(const Size(0, 0))
                          ),
                          onPressed: (){
                            widget.toggleView();
                          },
                          child: Text('Login', style: TextStyle(color: Colors.amber[700]),)
                        )
                      ]
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Or'),
                    ),
                    FloatingActionButton.extended(
                      elevation: 0,
                      backgroundColor: Colors.white10,
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      extendedPadding: const EdgeInsets.fromLTRB(10, 8, 15, 8),
                      icon: Image.asset('lib/assets/google.png', width: 32, height: 32,),
                      onPressed: ()async{
                        final auth = GoogleAuthentication();
                        setState(() {
                          loading = true;
                        });
                        await auth.googleSignIn();
                        setState(() {
                          loading = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}