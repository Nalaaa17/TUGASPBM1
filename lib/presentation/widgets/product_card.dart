import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/product_model.dart';

// Daftar warna header kartu (bergilir berdasarkan index)
const List<List<Color>> _cardGradients = [
  [Color(0xFF1E88E5), Color(0xFF42A5F5)],
  [Color(0xFF6C63FF), Color(0xFF9C8FFF)],
  [Color(0xFF00BFA5), Color(0xFF1DE9B6)],
  [Color(0xFFFF6B35), Color(0xFFFF9A76)],
  [Color(0xFF673AB7), Color(0xFF9575CD)],
  [Color(0xFF00838F), Color(0xFF26C6DA)],
];

/// Ambil inisial dari nama produk
String _initials(String name) {
  final words = name.trim().split(' ');
  if (words.isEmpty || words[0].isEmpty) return '?';
  if (words.length == 1) return words[0][0].toUpperCase();
  return '${words[0][0]}${words[1][0]}'.toUpperCase();
}

/// Widget kartu produk kreatif — Grid mode
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onDelete;
  final bool isGridView;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    this.onDelete,
    this.isGridView = true,
    this.index = 0,
  });

  String get _formattedPrice {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(product.price);
  }

  List<Color> get _gradient =>
      _cardGradients[index % _cardGradients.length];

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(child: Text(AppStrings.deleteConfirmTitle)),
          ],
        ),
        content: const Text(AppStrings.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.btnCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(AppStrings.btnDelete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isGridView ? _buildGridCard(context) : _buildListCard(context);
  }

  Widget _buildGridCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shadowColor: Color(_gradient[0].toARGB32()).withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => _showDetailSheet(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Gradient ───────────────────────────
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _gradient,
                ),
              ),
              child: Stack(
                children: [
                  // Inisial produk
                  Positioned(
                    left: 14,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              _initials(product.name),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge DRAFT
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 1),
                      ),
                      child: const Text(
                        'DRAFT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  // Tombol delete
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _confirmDelete(context),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Konten ────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama produk
                    Text(
                      product.name,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Deskripsi
                    Expanded(
                      child: Text(
                        product.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Harga + lihat detail
                    Row(
                      children: [
                        // Badge harga
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.accent.withValues(alpha: 0.2),
                                  AppColors.accentLight,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                  width: 1),
                            ),
                            child: Text(
                              _formattedPrice,
                              style: AppTextStyles.priceTag.copyWith(
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Detail button
                        GestureDetector(
                          onTap: () => _showDetailSheet(context),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Color(_gradient[0].toARGB32())
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: _gradient[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: Color(_gradient[0].toARGB32()).withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showDetailSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar dengan inisial + gradient
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _gradient,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    _initials(product.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama + badge draft
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'DRAFT',
                            style: TextStyle(
                              fontSize: 8,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.description,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Harga + tanggal
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.4),
                                width: 1),
                          ),
                          child: Text(
                            _formattedPrice,
                            style: AppTextStyles.priceTag,
                          ),
                        ),
                        if (product.createdAt != null) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.schedule_rounded,
                              size: 11, color: AppColors.textHint),
                          const SizedBox(width: 3),
                          Text(
                            _formatDate(product.createdAt!),
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showDetailSheet(context),
                    icon: Icon(Icons.info_outline_rounded,
                        color: _gradient[0], size: 20),
                    tooltip: 'Detail',
                    constraints: const BoxConstraints(
                        minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.error, size: 20),
                    tooltip: 'Hapus',
                    constraints: const BoxConstraints(
                        minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  /// Bottom sheet untuk detail produk
  void _showDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header gradient dalam bottom sheet
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _gradient,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          _initials(product.name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formattedPrice,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Detail info
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _detailRow(Icons.description_outlined,
                        'Deskripsi', product.description),
                    const SizedBox(height: 12),
                    _detailRow(Icons.payments_outlined,
                        'Harga', _formattedPrice),
                    const SizedBox(height: 12),
                    if (product.createdAt != null)
                      _detailRow(Icons.schedule_rounded, 'Dibuat pada',
                          _fullDate(product.createdAt!)),
                    const SizedBox(height: 12),
                    _detailRow(Icons.lock_outline, 'Visibilitas',
                        'Hanya kamu & asisten praktikum'),
                    const SizedBox(height: 24),

                    // Hapus button
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _confirmDelete(context);
                      },
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: AppColors.error, size: 18),
                      label: const Text('Hapus Draft Ini'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(
                            color: AppColors.error, width: 1.5),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelMedium),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fullDate(DateTime dt) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${dt.day} ${months[dt.month]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ─── Shimmer Loading ──────────────────────────────────────────────────────────

/// Widget shimmer loading untuk grid
class ProductCardShimmer extends StatefulWidget {
  const ProductCardShimmer({super.key});

  @override
  State<ProductCardShimmer> createState() => _ProductCardShimmerState();
}

class _ProductCardShimmerState extends State<ProductCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: _animation.value,
                child: Container(
                  height: 100,
                  color: AppColors.shimmerBase,
                  child: Center(
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerHighlight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: _animation.value,
                      child: Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Opacity(
                      opacity: _animation.value,
                      child: Container(
                        height: 12,
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Opacity(
                      opacity: _animation.value,
                      child: Container(
                        height: 26,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.accentLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
