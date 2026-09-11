import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/olympics_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/neo_card.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late TextEditingController _nameController;
  late String _selectedDelegation;
  late String _selectedWhoAmI;

  @override
  void initState() {
    super.initState();
    final provider = context.read<OlympicsProvider>();
    _nameController = TextEditingController(text: provider.athlete.name);
    _selectedDelegation = provider.delegations.contains(provider.athlete.delegation)
        ? provider.athlete.delegation
        : provider.delegations.first;
    _selectedWhoAmI = provider.whoAmIOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    final provider = context.read<OlympicsProvider>();
    if (_nameController.text.trim().isNotEmpty) {
      provider.setAthleteName(_nameController.text.trim());
    }
    provider.setDelegation(_selectedDelegation);
    provider.setWhoAmI(_selectedWhoAmI);

    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OlympicsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 ATHLETE REGISTRATION'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Title Card
                  NeoCard(
                    backgroundColor: AppTheme.yellowAccent,
                    padding: 20,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderColor, width: 2),
                            ),
                            child: Image.asset(
                              'assets/images/cat_sticker.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Text('🐱', style: TextStyle(fontSize: 32))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ATHLETE CREDENTIALS',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.darkText,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tell us how unmotivated you truly are before entering the Useless Olympics.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Spacious Registration Form
                  NeoCard(
                    backgroundColor: Colors.white,
                    padding: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Name Field
                        const Text(
                          '1. ATHLETE NAME',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.pinkAccent,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Enter your name...',
                            filled: true,
                            fillColor: AppTheme.background,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: AppTheme.borderColor, width: 2.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: AppTheme.borderColor, width: 2.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: AppTheme.pinkAccent, width: 2.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 2. Country / Delegation Selector
                        const Text(
                          '2. SELECT YOUR DELEGATION / COUNTRY',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.pinkAccent,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.borderColor, width: 2.5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDelegation,
                              isExpanded: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.darkText,
                              ),
                              items: provider.delegations.map((d) {
                                return DropdownMenuItem(value: d, child: Text(d));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedDelegation = val);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 3. WHO AM I? Hilarious Dropdown Menu
                        const Text(
                          '3. WHO AM I? (PHILOSOPHICAL STATEMENT)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.pinkAccent,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0F5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.borderColor, width: 2.5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedWhoAmI,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down_circle_rounded, color: AppTheme.pinkAccent),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppTheme.darkText,
                              ),
                              items: provider.whoAmIOptions.map((opt) {
                                return DropdownMenuItem(
                                  value: opt,
                                  child: Text(
                                    opt,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedWhoAmI = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submitRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.cyanAccent,
                        foregroundColor: AppTheme.darkText,
                        side: const BorderSide(color: AppTheme.borderColor, width: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'START USELESS JOURNEY ',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          Text('🏆', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
