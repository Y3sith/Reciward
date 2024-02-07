import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reciward_flutter_app/features/aprendiz/profile/presentation/bloc/profile_bloc.dart';
import 'package:reciward_flutter_app/features/aprendiz/tips/presentation/bloc/tip_bloc.dart';
import 'package:reciward_flutter_app/features/material/presentation/bloc/material_bloc.dart';
import 'package:uni_links/uni_links.dart';
import 'package:reciward_flutter_app/core/constants/pallete_colors.dart';
import 'package:reciward_flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:reciward_flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reciward_flutter_app/features/auth/presentation/widgets/form_button.dart';
import 'package:reciward_flutter_app/features/auth/presentation/widgets/form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String deepLink = "No se ha recibido ningún enlace profundo.";
  StreamController<String> deepLinkController = StreamController<String>();
  bool isResetPassword = false;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    String? initialLink;
    try {
      initialLink = await getInitialLink();
    } on PlatformException {
      // Manejar errores de plataforma
    }

    handleLink(initialLink);
    listenToLinks();
  }

  void listenToLinks() {
    // Escuchar eventos de enlaces profundos
    linkStream.listen((link) {
      handleLink(link);
    });
  }

  void handleLink(String? link) {
    deepLinkController.add(link ?? "No se ha recibido ningún enlace profundo.");
    if (link != null) {
      final argument = ModalRoute.of(context)?.settings.arguments;
      if (argument == null) {
        isResetPassword = true;
      } else {
        isResetPassword = false;
      }

      Uri uri = Uri.parse(link);
      String? token = uri.queryParameters['token'];
      if (uri.path == '/password-reset/' && token != null && isResetPassword) {
        Navigator.pushReplacementNamed(context, '/reset-password',
            arguments: token);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.colorWhite,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is AuthenticatedState) {
            BlocProvider.of<ProfileBloc>(context)
                .add(RecoverUserProfile(user: state.user));
            BlocProvider.of<TipBloc>(context)
                .add(GetTips(accessToken: state.user.accces_token!));
            BlocProvider.of<MaterialBloc>(context)
                .add(GetMaterialesEvent(accessToken: state.user.accces_token!, rol: state.user.rol!));
            Navigator.pushNamed(context, '/home');
          }
          if (state is AuthInitialLogin && state.message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            alignment: Alignment.center,           
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: <Widget>[
                const Image(image: 
                AssetImage("assets/images/logo_reciward.jpg")), 
                const Text(
                  "Login",
                  style: TextStyle(
                    color: Pallete.colorBlack,
                    fontSize: 25,
                    fontWeight: FontWeight.w600, 
                    fontFamily:'Ubuntu',
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10,),
                const Text(
                  "Enter your email and password.",
                  style: TextStyle(
                    color: Pallete.colorGrey3,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily:'Ubuntu',
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10,),
                AuthFormField(
                  label: 'Email',
                  controller: emailController,
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                AuthFormField(
                  label: 'Password',
                  controller: passwordController,
                  type: TextInputType.text,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/send-mail');
                  },               
                  style: const ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                      alignment: Alignment.centerRight),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Pallete.colorBlack,
                      fontSize: 13,
                      fontFamily:'Ubuntu',
                    ),
                  ),
                ),
                AuthFormButton(
                  onPressed: () {
                    UserEntity user = UserEntity(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim());
                    BlocProvider.of<AuthBloc>(context)
                        .add(AuthLoginRequested(userEntity: user));
                  },
                  text: 'Login',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Pallete.colorBlack,
                        fontFamily:'Ubuntu',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                         Navigator.popAndPushNamed(context, '/signup');
                      },
                      style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Pallete.color1)
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontFamily:'Ubuntu',
                        ),
                      ),
                    ),
                  ],
                ),
                
                
              ],
            ),
          );
        },
      ),
    );
  }
}
