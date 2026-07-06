import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/splash_screen.dart' show SplashScreen;
import '../screens/login_screen.dart' show LoginScreen;
import '../screens/cadastro/cadastro_screen.dart' show CadastroScreen;
import '../screens/home_screen.dart' show HomeScreen;
import '../screens/perfil_screen.dart' show PerfilScreen;
import '../screens/chat_screen.dart' show ChatScreen;
import '../screens/animacao_screen.dart' show AnimacaoScreen, TipoAnimacao;
import '../screens/acompanhamento/acompanhamento_screen.dart' show AcompanhamentoScreen;

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final logado = FirebaseAuth.instance.currentUser != null;
      final loc = state.matchedLocation;

      // Rotas livres de redirect
      if (loc == '/' || loc == '/animacao-login' || loc == '/animacao-logout') {
        return null;
      }
      if (!logado && loc != '/login' && loc != '/cadastro') return '/login';
      if (logado && (loc == '/login' || loc == '/cadastro')) return '/animacao-login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/cadastro',
        builder: (context, state) => const CadastroScreen(),
      ),
      // Animação de login — redireciona para /home após exibir
      GoRoute(
        path: '/animacao-login',
        builder: (context, state) =>
            const AnimacaoScreen(tipo: TipoAnimacao.login),
      ),
      // Animação de logout — redireciona para /login após exibir
      GoRoute(
        path: '/animacao-logout',
        builder: (context, state) =>
            const AnimacaoScreen(tipo: TipoAnimacao.logout),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/perfil',
        builder: (context, state) => const PerfilScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/acompanhamento/:alertaId',
        builder: (context, state) => AcompanhamentoScreen(
          alertaId: state.pathParameters['alertaId'] ?? '',
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Página não encontrada: ${state.error}'),
      ),
    ),
  );
}