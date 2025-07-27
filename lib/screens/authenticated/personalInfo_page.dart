import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datetime_picker;

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _genderController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGender;

  bool _isLoading = true;

  final DateTime _minBirthDate = DateTime(1911, 10, 6);
  final DateTime _maxBirthDate = DateTime.now();

  final List<String> _genderOptions = [
    'Masculino',
    'Feminino',
    'Outro',
    'Prefiro não dizer',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _nameController.text = userProvider.userName ?? '';
    _emailController.text = userProvider.userEmail ?? '';
    _nicknameController.text = userProvider.userNickname ?? '';

    if (userProvider.userBirthDate != null) {
  _selectedBirthDate = userProvider.userBirthDate;
  _birthdayController.text = DateFormat('dd/MM/yyyy').format(_selectedBirthDate!);
  } else {
    _birthdayController.text = '';
    _selectedBirthDate = null;
  }

    if (userProvider.userGender != null &&
        _genderOptions.contains(userProvider.userGender)) {
      _selectedGender = userProvider.userGender;
      _genderController.text = userProvider.userGender!;
    } else {
      _selectedGender = null;
      _genderController.text = '';
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialPickerDate = _selectedBirthDate ?? _maxBirthDate;

    datetime_picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: _minBirthDate,
      maxTime: _maxBirthDate,
      onConfirm: (date) {
        setState(() {
          _selectedBirthDate = date;
          _birthdayController.text = DateFormat('dd/MM/yyyy').format(date);
          _formKey.currentState?.validate();
        });
      },
      currentTime: initialPickerDate,
      locale: datetime_picker.LocaleType.pt,
      theme: datetime_picker.DatePickerTheme(
        backgroundColor: const Color(0xFF1A2951),
        itemStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        doneStyle: const TextStyle(color: Color(0xFF6C63FF), fontSize: 16),
        cancelStyle: const TextStyle(color: Colors.white70, fontSize: 16),
        headerColor: const Color(0xFF1A2951),
      ),
    );
  }

  Future<void> _selectGender(BuildContext context) async {
    final String? selectedOption = await showModalBottomSheet<String>(
      context: context,
      backgroundColor:
          Colors.transparent, // Fundo transparente para o arredondamento
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A2951),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),

              ListView.builder(
                shrinkWrap: true,
                itemCount: _genderOptions.length,
                itemBuilder: (BuildContext context, int index) {
                  final gender = _genderOptions[index];
                  return ListTile(
                    title: Text(
                      gender,
                      style: TextStyle(
                        color:
                            _selectedGender == gender
                                ? Color(0xFF6C63FF)
                                : Colors.white,
                        fontWeight:
                            _selectedGender == gender
                                ? FontWeight.w500
                                : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    trailing:
                        _selectedGender == gender
                            ? const Icon(Icons.check, color: Color(0xFF6C63FF))
                            : null,
                    onTap: () {
                      Navigator.of(context).pop(gender);
                    },
                  );
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );

    // Se uma opção foi selecionada (selectedOption não é nulo), atualize o estado
    if (selectedOption != null) {
      setState(() {
        _selectedGender = selectedOption;
        _genderController.text =
            selectedOption; // Atualiza o controller do campo
      });
    }
  }

  Future<void> _updatePersonalInfo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final success = await userProvider.updateUser(
      newName: _nameController.text.trim(),
      newEmail:
          _emailController.text
              .trim(), // Considerar validação de email no backend
      newNickname: _nicknameController.text.trim(),
      newBirthDate: _selectedBirthDate, // Passa o objeto DateTime
      newGender: _selectedGender,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados atualizados com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Falha ao atualizar dados. Verifique sua conexão e tente novamente.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nicknameController.dispose();
    _birthdayController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C5DB7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.only(top: 25, left: 5),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 25.0),
          child: const Text(
            'Dados Pessoais',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5DB7), Color(0xFF1A2951)],
          ),
        ),
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Gerencie suas informações pessoais.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Campo Nome
                        _buildTextFormField(
                          controller: _nameController,
                          labelText: 'Nome Completo', // Mais descritivo
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'O nome não pode ser vazio.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildTextFormField(
                          controller: _emailController,
                          labelText: 'Email',
                          readOnly: true,
                          textColor: Colors.white70,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        _buildTextFormField(
                          controller: _nicknameController,
                          labelText: 'Apelido (opcional)',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),

                        _buildTextFormField(
                          controller: _birthdayController,
                          labelText: 'Data de Nascimento (opcional)',
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (_selectedBirthDate == null &&
                                value!.isNotEmpty) {
                              return 'Formato de data inválido. Selecione novamente.';
                            }
                            if (_selectedBirthDate != null) {
                              if (_selectedBirthDate!.isAfter(_maxBirthDate)) {
                                return 'Data de nascimento não pode ser no futuro.';
                              }
                              if (_selectedBirthDate!.isBefore(_minBirthDate)) {
                                return 'Data de nascimento muito antiga (min: ${DateFormat('dd/MM/yyyy').format(_minBirthDate)}).';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildTextFormField(
                          controller: _genderController,
                          labelText: 'Gênero (opcional)',
                          readOnly: true,
                          onTap: () => _selectGender(context),
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 40),

                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _updatePersonalInfo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1A2951),
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'Salvar Alterações',
                                      style: TextStyle(color: Colors.white),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    bool readOnly = false,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    Widget? suffixIcon,
    Color textColor = Colors.white,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      onTap: onTap,
      style: TextStyle(color: textColor),
      keyboardType: keyboardType,
      decoration: _inputDecoration(labelText, suffixIcon),
    );
  }

  InputDecoration _inputDecoration(String labelText, Widget? suffixIcon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white70),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 2,
        ), // Borda mais grossa ao focar
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ), // Mais padding interno
    );
  }
}
