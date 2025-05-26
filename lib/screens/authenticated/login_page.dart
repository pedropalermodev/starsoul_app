import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C5DB7),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5DB7), Color(0xFF1A2951)],
          ),
        ),

        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),

        child: SizedBox(
          width: double.infinity,
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
                    style: TextStyle(fontSize: 14, color: Color(0xFFCDCDCD)),
                  ),

                  SizedBox(height: 40),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white, // Cor do cursor branco
                    style: TextStyle(
                      color: Colors.white,
                    ), // Cor do texto digitado branco
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ), // Cor do label branco
                      floatingLabelStyle: TextStyle(
                        color: Colors.white,
                      ), // Cor do label quando flutua
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ), // Linha branca
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ), // Linha branca, um pouco mais grossa
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                    // Adicione validação se necessário, por exemplo:
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Por favor, digite seu email';
                    //   }
                    //   return null;
                    // },
                  ),

                  SizedBox(height: 30),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                      floatingLabelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                    // Adicione validação se necessário
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Por favor, digite sua senha';
                    //   }
                    //   return null;
                    // },
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
                          () => Navigator.of(context).pushNamed('/home'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF20222D),
                        ),
                      ),
                      child: Text(
                        'Entrar',
                        style: TextStyle(color: Colors.white),
                      ),
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
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),

                    Text(
                      'Crie-a 🔗',
                      style: TextStyle(color: Color(0xFFA9C0FF), fontSize: 12),
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
    );
  }
}
