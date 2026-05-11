import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../data/services/api_service.dart';
import '../widgets/loading_overlay.dart';
import 'catalog_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nimFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _entryController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic));
    _bounceAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    _nimFocus.dispose();
    _passwordFocus.dispose();
    _entryController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      await auth.login(
        _nimController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (ctx, anim, _) => const CatalogScreen(),
          transitionsBuilder: (ctx, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      _showError(AppStrings.loginFailed);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: GoogleFonts.nunito(fontWeight: FontWeight.w600))),
          ],
        ),
        backgroundColor: AppColors.comicRed,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: AppStrings.loginLoading,
        child: Stack(
          children: [
            // ── Halftone Background ─────────────────────
            Positioned.fill(
              child: CustomPaint(
                painter: _DotPatternPainter(
                  color: AppColors.ink.withValues(alpha: 0.07),
                  spacing: 20,
                  radius: 2.5,
                ),
              ),
            ),

            // ── Decorations ────────────────────────────
            Positioned(top: 60, right: 20,
              child: AnimatedBuilder(
                animation: _bounceController,
                builder: (context, _) => Transform.translate(
                  offset: Offset(0, _bounceAnim.value),
                  child: _comicStar(size: 32, color: AppColors.comicRed),
                ),
              ),
            ),
            Positioned(top: 140, left: 16,
              child: AnimatedBuilder(
                animation: _bounceController,
                builder: (context, _) => Transform.translate(
                  offset: Offset(0, -_bounceAnim.value),
                  child: _comicStar(size: 22, color: AppColors.ink),
                ),
              ),
            ),
            Positioned(bottom: 100, right: 24,
              child: AnimatedBuilder(
                animation: _bounceController,
                builder: (context, _) => Transform.translate(
                  offset: Offset(0, _bounceAnim.value * 0.7),
                  child: _comicStar(size: 20, color: AppColors.accent),
                ),
              ),
            ),

            // ── Main Content ───────────────────────────
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height
                        - MediaQuery.of(context).padding.top
                        - MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      // ── Hero Section ─────────────────
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: _buildHeroSection(),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Login Card ────────────────────
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: _buildLoginCard(),
                        ),
                      ),

                      const SizedBox(height: 24),
                      _buildInfoNote(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        // Floating logo
        AnimatedBuilder(
          animation: _bounceController,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _bounceAnim.value * 0.5),
            child: child,
          ),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.ink, width: 4),
              boxShadow: const [
                BoxShadow(color: AppColors.ink, offset: Offset(8, 8), blurRadius: 0),
              ],
            ),
            child: const Center(
              child: Icon(Icons.storefront_rounded, color: AppColors.ink, size: 52),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Title panel
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.comicRed,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.ink, width: 3),
            boxShadow: const [
              BoxShadow(color: AppColors.ink, offset: Offset(6, 6), blurRadius: 0),
            ],
          ),
          child: Text(
            AppStrings.loginWelcome.toUpperCase().replaceAll('!', ''),
            style: GoogleFonts.bangers(
              fontSize: 28,
              color: Colors.white,
              letterSpacing: 2.5,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Speech bubble subtitle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.ink, width: 2.5),
            boxShadow: const [
              BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
            ],
          ),
          child: Text(
            AppStrings.loginSubtitle,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(8, 8), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Card Header ─────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              border: Border(bottom: BorderSide(color: AppColors.ink, width: 2.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.login_rounded, color: AppColors.ink, size: 20),
                const SizedBox(width: 8),
                Text(
                  'MASUK KE AKUN',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Form ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // NIM Field
                  _buildComicLabel('USERNAME (NIM)', Icons.badge_outlined),
                  const SizedBox(height: 6),
                  _buildComicTextField(
                    controller: _nimController,
                    focusNode: _nimFocus,
                    hint: AppStrings.hintNim,
                    prefixIcon: Icons.person_outline_rounded,
                    keyboardType: TextInputType.number,
                    nextFocus: _passwordFocus,
                    validator: Validators.nim,
                  ),

                  const SizedBox(height: 18),

                  // Password Field
                  _buildComicLabel('PASSWORD (NIM)', Icons.lock_outline_rounded),
                  const SizedBox(height: 6),
                  _buildComicTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    hint: AppStrings.hintPassword,
                    prefixIcon: Icons.lock_outline_rounded,
                    obscure: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: Validators.password,
                    onSubmit: _login,
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  _buildComicButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComicLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.ink),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildComicTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData prefixIcon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    FocusNode? nextFocus,
    String? Function(String?)? validator,
    VoidCallback? onSubmit,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
        style: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
          fontSize: 14,
          color: AppColors.textHint,
        ),
        prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.backgroundAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border, width: 2.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border, width: 2.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.comicRed, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 3),
        ),
      ),
      onFieldSubmitted: nextFocus != null
          ? (_) => FocusScope.of(context).requestFocus(nextFocus)
          : (_) => onSubmit?.call(),
      validator: validator,
    ));
  }

  Widget _buildComicButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _login,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _isLoading ? AppColors.textHint : AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.ink, width: 2.5),
          boxShadow: _isLoading
              ? []
              : const [
                  BoxShadow(color: AppColors.ink, offset: Offset(6, 6), blurRadius: 0),
                ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) ...[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 10),
            ] else ...[
              const Icon(Icons.rocket_launch_rounded, color: AppColors.ink, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              _isLoading ? 'LOADING...' : AppStrings.btnLogin.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.ink, width: 2.5),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.ink, width: 1.5),
            ),
            child: const Icon(Icons.info_outline_rounded,
                size: 14, color: AppColors.ink),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Gunakan NIM kamu sebagai username dan password',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _comicStar({required double size, required Color color}) {
    return Icon(Icons.star_rounded, size: size, color: color);
  }
}

class _DotPatternPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double radius;

  const _DotPatternPainter({
    required this.color,
    required this.spacing,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
