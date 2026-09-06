import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cerrar Sesión',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: AppTheme.accentColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthService>().logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Consumer<AuthService>(
              builder: (context, auth, _) {
                final user = auth.currentUser;
                if (user == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryColor),
                  );
                }

                return CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hola, ${user.fullName.split(' ').first} 👋',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Bienvenido a tu dashboard',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: _handleLogout,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    user.fullName.isNotEmpty
                                        ? user.fullName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 28)),

                    // Profile Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: AppTheme.glassDecoration,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              // Avatar grande
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: AppTheme.glowShadow,
                                ),
                                child: Center(
                                  child: Text(
                                    user.fullName.isNotEmpty
                                        ? user.fullName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: user.isActive
                                      ? AppTheme.successColor.withValues(alpha: 0.15)
                                      : AppTheme.errorColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: user.isActive
                                            ? AppTheme.successColor
                                            : AppTheme.errorColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      user.isActive ? 'Activo' : 'Inactivo',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: user.isActive
                                            ? AppTheme.successColor
                                            : AppTheme.errorColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    // Info Cards
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.fingerprint,
                                label: 'ID',
                                value: '#${user.id.length > 8 ? user.id.substring(0, 8) : user.id}',
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.calendar_today_outlined,
                                label: 'Registro',
                                value: _formatDate(user.createdAt),
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    // Actions section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: AppTheme.glassDecoration,
                          child: Column(
                            children: [
                              _buildActionTile(
                                icon: Icons.person_outline,
                                label: 'Editar Perfil',
                                subtitle: 'Actualiza tu nombre y email',
                                onTap: () => _showEditProfile(context, auth),
                              ),
                              Divider(
                                color: Colors.white.withValues(alpha: 0.06),
                                height: 1,
                                indent: 56,
                              ),
                              _buildActionTile(
                                icon: Icons.info_outline,
                                label: 'Información de la App',
                                subtitle: 'SI2 Proyecto v1.0.0',
                                onTap: () {},
                              ),
                              Divider(
                                color: Colors.white.withValues(alpha: 0.06),
                                height: 1,
                                indent: 56,
                              ),
                              _buildActionTile(
                                icon: Icons.logout,
                                label: 'Cerrar Sesión',
                                subtitle: 'Salir de tu cuenta',
                                color: AppTheme.accentColor,
                                onTap: _handleLogout,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: AppTheme.glassDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (color ?? AppTheme.primaryColor).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color ?? AppTheme.primaryColor, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color ?? AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withValues(alpha: 0.2),
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _showEditProfile(BuildContext context, AuthService authService) {
    final user = authService.currentUser!;
    final nameCtrl = TextEditingController(text: user.fullName);
    final emailCtrl = TextEditingController(text: user.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Editar Perfil',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: nameCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: AppTheme.inputDecoration(
                label: 'Nombre completo',
                icon: Icons.person_outline,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: AppTheme.inputDecoration(
                label: 'Correo electrónico',
                icon: Icons.email_outlined,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                boxShadow: AppTheme.glowShadow,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  final success = await authService.updateProfile(
                    fullName: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                  );
                  if (success && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: AppTheme.successColor, size: 20),
                            SizedBox(width: 12),
                            Text('Perfil actualizado correctamente'),
                          ],
                        ),
                        backgroundColor: AppTheme.cardColor,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                ),
                child: const Text(
                  'Guardar Cambios',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
