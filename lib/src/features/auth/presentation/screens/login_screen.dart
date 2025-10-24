import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simülasyon: API isteği gibi
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      // Login başarılıysa home ekranına yönlendir
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/app-logo.png', height: 120),
                const SizedBox(height: 24),

                // Başlık
                Text(
                  'Hoş geldin 👋',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Color(0xFFD8F8F1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lütfen giriş yap veya kayıt ol',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),

                // Form
                Card(
                  elevation: 6,
                  // color: Colors.white.withOpacity(0.9),
                  color: Color(0xFFCFEAE5).withValues(alpha: 0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailCtrl,
                            decoration: const InputDecoration(
                              labelText: 'E-posta',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'E-posta giriniz' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Şifre',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (v) =>
                                (v == null || v.length < 6)
                                    ? 'En az 6 karakter giriniz'
                                    : null,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: _isLoading ? null : _onLoginPressed,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Giriş yap',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFCFEAE5),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Şifremi unuttum'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
