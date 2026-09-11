import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../l10n/product_l10n.dart';
import '../models/product.dart';
import '../routes/app_routes.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedCity;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectCity() async {
    // Navigate to city picker and receive result
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.cityPicker,
    );
    if (result != null && result is String) {
      setState(() {
        _selectedCity = result;
      });
    }
  }

  void _submitOrder() {
    final t = AppLocalizations.of(context)!;
    
    if (_formKey.currentState!.validate()) {
      if (_selectedCity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.cityRequired)),
        );
        return;
      }

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(t.confirmOrderTitle),
          content: Text(t.confirmOrderMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // Navigate to success screen with pushReplacement
                // This prevents the user from going back
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.success,
                  (route) => false,
                );
              },
              child: Text(t.confirm),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.checkoutTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product summary card
              Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                  title: Text(t.productName(product.id)),
                  subtitle: Text(
                    '${product.price.toStringAsFixed(0)} ${t.ils}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Shipping address section
              Text(
                t.shippingAddress,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Full name field
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: t.fullName,
                  hintText: t.fullNameHint,
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.fullNameRequired;
                  }
                  if (value.length < 3) {
                    return t.fullNameMinLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: t.email,
                  hintText: t.emailHint,
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.emailRequired;
                  }
                  if (!value.contains('@')) {
                    return t.emailInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Phone field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: t.phone,
                  hintText: t.phoneHint,
                  prefixIcon: const Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.phoneRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Address field
              TextFormField(
                controller: _addressController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: t.address,
                  hintText: t.addressHint,
                  prefixIcon: const Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.addressRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // City picker button
              InkWell(
                onTap: _selectCity,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: t.city,
                    prefixIcon: const Icon(Icons.location_city),
                    suffixIcon: const Icon(Icons.arrow_forward_ios),
                  ),
                  child: Text(
                    _selectedCity ?? t.selectCity,
                    style: TextStyle(
                      color: _selectedCity != null
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Confirm order button
              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: const Icon(Icons.check_circle),
                label: Text(t.confirmOrder),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
