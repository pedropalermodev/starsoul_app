import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/services/user_provider.dart'; // Ajuste o caminho conforme o seu projeto
import 'package:intl/intl.dart'; // Para formatar a data de nascimento
import 'package:flutter_localizations/flutter_localizations.dart'; // Necessário para internacionalização do DatePicker

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
  final _birthdayController =
      TextEditingController(); // Para exibir a data formatada

  DateTime?
  _selectedBirthDate; // Para guardar a data selecionada pelo DatePicker
  String? _selectedGender; // Para guardar o gênero selecionado no Dropdown

  bool _isLoading = true; // Começa como true para indicar carregamento inicial

  // Data mínima permitida para nascimento (06 de outubro de 1911)
  final DateTime _minBirthDate = DateTime(1911, 10, 6);
  // Data máxima permitida para nascimento (hoje)
  final DateTime _maxBirthDate = DateTime.now();

  // Opções para o Dropdown de gênero
  final List<String> _genderOptions = [
    'Masculino',
    'Feminino',
    'Outro',
    'Prefiro não dizer',
  ];

  @override
  void initState() {
    super.initState();
    // Chama a função para carregar os dados do usuário após o build inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  // Função para carregar os dados do UserProvider e preencher os TextControllers
  void _loadUserData() {
    // Usamos listen: false porque só precisamos dos dados uma vez para preencher os controladores.
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _nameController.text = userProvider.userName ?? '';
    _emailController.text = userProvider.userEmail ?? '';
    _nicknameController.text = userProvider.userNickname ?? '';

    // Formata e preenche a data de nascimento
    if (userProvider.userBirthDate != null) {
      _selectedBirthDate = userProvider.userBirthDate;
      // Usar DateFormat.yMd para formato localizado (ex: 20/07/2025 ou 07/20/2025)
      // ou DateFormat('dd/MM/yyyy') se quiser forçar o formato BR.
      _birthdayController.text = DateFormat.yMd().format(_selectedBirthDate!);
    } else {
      _birthdayController.text = '';
      _selectedBirthDate =
          null; // Garante que a variável esteja nula se não houver data
    }

    // Preenche o gênero, garantindo que seja uma das opções ou nulo
    if (userProvider.userGender != null &&
        _genderOptions.contains(userProvider.userGender)) {
      _selectedGender = userProvider.userGender;
    } else {
      _selectedGender =
          null; // Limpa se não houver ou se não for uma opção válida
    }

    setState(() {
      _isLoading = false; // Define como não carregando após preencher os dados
    });
  }

  // Função para abrir o DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedBirthDate ??
          _maxBirthDate, // Inicia na data atual ou na selecionada
      firstDate: _minBirthDate, // Data mínima permitida
      lastDate: _maxBirthDate, // Data máxima permitida (hoje)
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(
                0xFF6C63FF,
              ), // Cor dos botões e cabeçalho do DatePicker
              onPrimary: Colors.white, // Cor do texto nos botões e cabeçalho
              surface: Color(0xFF1A2951), // Cor de fundo do seletor de data
              onSurface: Colors.white, // Cor do texto no seletor de data
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Cor do texto dos botões
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthdayController.text = DateFormat.yMd().format(
          picked,
        ); // Formato localizado
        // Valida o campo de data de nascimento imediatamente após a seleção
        _formKey.currentState?.validate();
      });
    }
  }

  // Função para lidar com a atualização dos dados
  Future<void> _updatePersonalInfo() async {
    // Valida o formulário antes de prosseguir
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; // Mostra o indicador de carregamento no botão
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final success = await userProvider.updateUser(
      newName: _nameController.text.trim(),
      newEmail:
          _emailController.text
              .trim(), // Considerar validação de email no backend
      newNickname: _nicknameController.text.trim(),
      newBirthDate: _selectedBirthDate, // Passa o objeto DateTime
      newGender: _selectedGender, // Passa o String selecionado
    );

    setState(() {
      _isLoading = false; // Esconde o indicador de carregamento
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
                  padding: const EdgeInsets.all(
                    24.0,
                  ), // Aumentei o padding para mais respiro
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch, // Estende os campos horizontalmente
                      children: [
                        const Text(
                          'Gerencie suas informações pessoais.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
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
                        const SizedBox(height: 20), // Aumentei o espaçamento
                        // Campo Email (somente leitura)
                        _buildTextFormField(
                          controller: _emailController,
                          labelText: 'Email',
                          readOnly: true,
                          textColor: Colors.white70,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // Campo Apelido
                        _buildTextFormField(
                          controller: _nicknameController,
                          labelText: 'Apelido (opcional)',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),

                        // Campo Data de Nascimento (com DatePicker)
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
                              // Se o campo de texto não está vazio mas _selectedBirthDate é nulo, houve um erro no parse inicial.
                              return 'Formato de data inválido. Selecione novamente.';
                            }
                            if (_selectedBirthDate != null) {
                              if (_selectedBirthDate!.isAfter(_maxBirthDate)) {
                                return 'Data de nascimento não pode ser no futuro.';
                              }
                              if (_selectedBirthDate!.isBefore(_minBirthDate)) {
                                return 'Data de nascimento muito antiga (min: ${DateFormat.yMd().format(_minBirthDate)}).';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Campo Gênero (Dropdown)
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: _inputDecoration(
                            'Gênero (opcional)',
                            const Icon(Icons.person, color: Colors.white),
                          ),
                          dropdownColor: const Color(0xFF1A2951),
                          style: const TextStyle(color: Colors.white),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ), // Ícone do dropdown
                          items:
                              _genderOptions.map((String gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(
                                    gender,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                          hint: const Text(
                            'Selecione',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ), // Mais espaçamento antes do botão
                        // Botão de Salvar Alterações
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _updatePersonalInfo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 18,
                              ), // Aumentei o padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Borda mais arredondada
                              ),
                              elevation: 5, // Sombra para destaque
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'Salvar Alterações',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
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

  // --- Funções Auxiliares para Construção da UI ---

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    bool readOnly = false,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    Widget? suffixIcon,
    Color textColor = Colors.white,
    TextInputType keyboardType =
        TextInputType.text, // Adicionado tipo de teclado
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
