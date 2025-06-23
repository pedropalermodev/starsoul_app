import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:starsoul_app/screens/services/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _verSenha = false;

  logar() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    var url = Uri.parse('https://starsoul-backend.onrender.com/api/auth/login');

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      print('Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String? token = responseData['token'];

        if (token != null && token.isNotEmpty) {
          await _sharedPreferences.setString('token', token);
          await Provider.of<UserProvider>(context, listen: false).login(token);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login realizado com sucesso!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email ou senha inválidos. Verifique suas credenciais.',
            ),
            backgroundColor: const Color.fromARGB(255, 117, 32, 25),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Erro na requisição: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível conectar ao servidor. Tente novamente.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double minBodyHeight = screenHeight - appBarHeight - statusBarHeight;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C5DB7),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3C5DB7), Color(0xFF1A2951)],
            ),
          ),

          child: SizedBox(
            width: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minBodyHeight, // Usa a altura calculada
              ),
              child: DecoratedBox(
                // Usado para aplicar o gradiente ao Child
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF3C5DB7), Color(0xFF1A2951)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),

                          Center(
                            child: Image.asset(
                              'assets/mark/logo.png',
                              width: 80,
                              height: 80,
                            ),
                          ),

                          SizedBox(height: 20),

                          Text(
                            'É bom ter você de volta!',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            'Seu diário e inspiração esperam por você.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFCDCDCD),
                            ),
                          ),

                          SizedBox(height: 40),

                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor:
                                      Colors.white, // Cor do cursor branco
                                  style: TextStyle(
                                    color: Colors.white,
                                  ), // Cor do texto digitado branco
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    floatingLabelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite seu email';
                                    }
                                    final bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                    ).hasMatch(value);
                                    if (!emailValid) {
                                      return 'Por favor, digite um email válido';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 20),

                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_verSenha,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    floatingLabelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _verSenha = !_verSenha;
                                        });
                                      },
                                      icon: Icon(
                                        _verSenha
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite sua senha';
                                    } else if (value.length < 8) {
                                      return 'A senha deve ter no mínimo 8 digitos';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 5),

                                Row(
                                  children: [
                                    Text(
                                      'Esqueceu a senha?',
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 12,
                                      ),
                                    ),

                                    SizedBox(width: 5),

                                    Text(
                                      'Recuperar senha 🔗',
                                      style: TextStyle(
                                        color: Color(0xFFA9C0FF),
                                        fontSize: 12,
                                      ),
                                    ),

                                    // TextButton(
                                    //   onPressed: () {
                                    //     final Uri url = Uri.parse(
                                    //       'https://www.sua-url-de-recuperacao.com/senha',
                                    //     );
                                    //     launchUrl(url); // Chamada sem await
                                    //   },
                                    //   child: Text(
                                    //     'Recuperar senha 🔗',
                                    //     style: TextStyle(
                                    //       color: Color(0xFFA9C0FF)
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),

                                SizedBox(height: 35),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading
                                            ? null
                                            : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                // Navigator.of(
                                                //   context,
                                                // ).pushNamed('/home');
                                                logar();
                                              }
                                            },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                            Color(0xFF20222D),
                                          ),
                                    ),
                                    child:
                                        _isLoading
                                            ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : Text(
                                              'Entrar',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Center(
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       // Lógica de login
                          //       print('Email: ${_emailController.text}');
                          //       print('Senha: ${_passwordController.text}');
                          //     },
                          //     child: Text('Login'),
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.white,
                          //       foregroundColor: Color(0xFF1A2951),
                          //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          //       textStyle: TextStyle(fontSize: 18),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),

                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ainda não possui uma conta?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),

                            SizedBox(width: 5),

                            Text(
                              'Crie-a 🔗',
                              style: TextStyle(
                                color: Color(0xFFA9C0FF),
                                fontSize: 12,
                              ),
                            ),

                            // TextButton(
                            //   onPressed: () {
                            //     final Uri url = Uri.parse(
                            //       'https://www.sua-url-de-recuperacao.com/senha',
                            //     );
                            //     launchUrl(url); // Chamada sem await
                            //   },
                            //   child: Text(
                            //     'Recuperar senha 🔗',
                            //     style: TextStyle(
                            //       color: Color(0xFFA9C0FF)
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
