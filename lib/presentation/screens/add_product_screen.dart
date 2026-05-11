import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/api_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_overlay.dart';

const List<List<Color>> _previewGradients = [
  [Color(0xFF1E88E5), Color(0xFF42A5F5)],
  [Color(0xFF6C63FF), Color(0xFF9C8FFF)],
  [Color(0xFF00BFA5), Color(0xFF1DE9B6)],
  [Color(0xFFFF6B35), Color(0xFFFF9A76)],
  [Color(0xFF673AB7), Color(0xFF9575CD)],
];

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  static const routeName = '/add-product';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  int _selectedGradient = 0;

  late AnimationController _previewController;
  late Animation<double> _previewAnimation;

  @override
  void initState() {
    super.initState();
    _previewController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _previewAnimation = CurvedAnimation(
      parent: _previewController,
      curve: Curves.easeOutBack,
    );

    _nameController.addListener(() => setState(() {}));
    _priceController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _previewController.dispose();
    super.dispose();
  }

  String get _previewName => _nameController.text.trim().isEmpty
      ? 'Nama Produk'
      : _nameController.text.trim();

  String get _previewPrice {
    final raw = _priceController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (raw.isEmpty) return 'Rp 0';
    final num = double.tryParse(raw) ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(num);
  }

  String get _previewDesc => _descriptionController.text.trim().isEmpty
      ? 'Deskripsi produk kamu akan muncul di sini...'
      : _descriptionController.text.trim();

  String get _initials {
    final name = _nameController.text.trim();
    if (name.isEmpty) return '?';
    final words = name.split(' ');
    if (words.length == 1) return name[0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  List<Color> get _gradient => _previewGradients[_selectedGradient];

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final rawPrice = _priceController.text.replaceAll(RegExp(r'[^\d]'), '');
      final price = double.parse(rawPrice);

      await AuthService.addProduct(
        name: _nameController.text.trim(),
        price: price,
        description: _descriptionController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(AppStrings.addSuccess),
            ],
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      _showError(AppStrings.addFailed);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.addProductTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: 'Menyimpan draft produk...',
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildLivePreview(),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.warningLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                AppStrings.warningNoEdit,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.accentDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildColorPicker(),
                      const SizedBox(height: 20),

                      _buildSectionHeader(
                        'Informasi Produk',
                        Icons.inventory_2_outlined,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _nameController,
                        label: AppStrings.labelProductName,
                        hint: AppStrings.hintProductName,
                        prefixIcon: Icons.label_outline,
                        textInputAction: TextInputAction.next,
                        validator: Validators.productNameSafe,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        style: AppTextStyles.bodyMedium,
                        decoration: InputDecoration(
                          labelText: AppStrings.labelPrice,
                          hintText: AppStrings.hintPrice,
                          prefixIcon: const Icon(
                            Icons.payments_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          prefixText: 'Rp  ',
                          prefixStyle: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        validator: Validators.price,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _descriptionController,
                        label: AppStrings.labelDescription,
                        hint: AppStrings.hintDescription,
                        prefixIcon: Icons.description_outlined,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        validator: Validators.descriptionSafe,
                      ),
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.block_rounded,
                              size: 13,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Dilarang: konten politik, SARA, pornografi, atau ujaran kebencian',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _saveProduct,
                        icon: const Icon(Icons.save_rounded, size: 18),
                        label: const Text(AppStrings.btnSave),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        label: const Text(AppStrings.btnCancel),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLivePreview() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _gradient[0].withValues(alpha: 0.15),
            _gradient[1].withValues(alpha: 0.05),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.preview_rounded, size: 16, color: _gradient[0]),
              const SizedBox(width: 6),
              Text(
                'Preview Kartu Produk',
                style: AppTextStyles.labelMedium.copyWith(
                  color: _gradient[0],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ScaleTransition(
            scale: _previewAnimation,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: _gradient[0].withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _gradient,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              _initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'DRAFT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _previewName,
                            style: AppTextStyles.headingSmall.copyWith(
                              fontSize: 14,
                              color: _nameController.text.isEmpty
                                  ? AppColors.textHint
                                  : AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              _previewDesc,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: _descriptionController.text.isEmpty
                                    ? AppColors.textHint
                                    : AppColors.textSecondary,
                                fontSize: 11,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              _previewPrice,
                              style: AppTextStyles.priceTag,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.palette_outlined,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'Warna Kartu',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(_previewGradients.length, (i) {
            final isSelected = _selectedGradient == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedGradient = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                width: isSelected ? 44 : 36,
                height: isSelected ? 44 : 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _previewGradients[i],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(isSelected ? 14 : 10),
                  border: isSelected
                      ? Border.all(
                          color: _previewGradients[i][0].withValues(alpha: 0.6),
                          width: 3,
                        )
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _previewGradients[i][0].withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.headingSmall),
      ],
    );
  }
}
