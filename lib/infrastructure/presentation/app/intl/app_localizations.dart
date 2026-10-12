import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    
    if (localizations == null) {
      return AppLocalizations(const Locale('en', 'US'));
    }
    
    return localizations;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Login Screen
      'welcome_back': 'Welcome Back!',
      'sign_in_subtitle': 'Sign in to continue your journey',
      'email': 'Email',
      'password': 'Password',
      'sign_in': 'Sign In',
      'no_account': "Doesn't have an account? Click here to create one!",
      'no_account_question': "Don't have an account? ",
      'sign_up_link': 'Sign Up',
      'or': 'or',
      'login_successful': 'Login Successful',
      'welcome_user': 'Welcome, {0}!',
      'continue': 'Continue',
      'login_failed': 'Login Failed',
      'email_password_incorrect': 'Email or password incorrect',
      'try_again': 'Try Again',
      
      // Register Screen
      'create_account': 'Create Your Account',
      'sign_up_subtitle': 'Join us and start planning your trips',
      'name': 'Name',
      'sign_up': 'Sign Up',
      'have_account': 'Already have an account? Click here to login!',
      'have_account_question': 'Already have an account? ',
      'sign_in_link': 'Sign In',
      'register_successful': 'Register Successful',
      'can_login_now': 'You can now login with your credentials',
      'go_to_login': 'Go to Login',
      
      // Validation Errors
      'field_required': 'This field is required',
      'name_required': 'Name cannot be blank',
      'email_required': 'Email cannot be blank',
      'password_required': 'Password cannot be blank',
      'invalid_email': 'Invalid email format',
      'password_too_short': 'Password must be at least 8 characters',
      'password_too_long': 'Password must not exceed 72 UTF-8 bytes',
      'email_already_registered': "There's already a register with this email",
      'register_error': 'Error during registration',
      'delete_user_error': 'Error deleting user',
      
      // Home Screen
      'plan_your_next_adventure': 'Plan your next adventure',
      'searching': 'Searching...',
      'search_results': 'Search Results',
      'found': '{0} found',
      'location_selected': 'Location Selected',
      'select_trip': 'Select Trip?',
      'use_trip_template': 'Would you like to use this trip as a template?',
      'cancel': 'Cancel',
      'select': 'Select',
      'try_different_words': 'Try searching with different words',
      'recommended_trips': 'Recommended Trips',
      'welcome': 'Welcome, {0}',
      'search_destinations': 'Search destinations...',
      'no_results_found': 'No results found',
      'selected': 'Selected: {0}',
      'days': '{0} days',
      'brazilian_northeast': 'Brazilian Northeast',
      'southern_brazil': 'Southern Brazil',
      
      // Trip Register Screen
      'new_trip': 'New Trip',
      'trip_data': 'Trip Data',
      'trip_title': 'Trip Title',
      'transport': 'Transport',
      'car': 'Car',
      'motorcycle': 'Motorcycle',
      'bus': 'Bus',
      'airplane': 'Airplane',
      'ship': 'Ship',
      'group_data': 'Group Data',
      'age': 'Age',
      'add_person': 'Add Person',
      'group_members': 'Group Members ({0})',
      'map': 'Map',
      'fullscreen_map': 'Fullscreen Map',
      'register_trip': 'Register Trip',
      'success': 'Success!',
      'trip_created_successfully': 'Trip created successfully!',
      'error': 'Error',
      'ok': 'Ok',
      
      // Trip Validations
      'trip_title_required': 'Trip title is required.',
      'group_empty': 'Please add at least one person to the group.',
      'stops_empty': 'Please add at least one stop to the trip.',
      'age_required': 'Age is required.',
      'age_invalid': 'Age must be a valid number.',
      'start_date_required': 'Start date is required.',
      'end_date_required': 'End date is required.',
      'end_date_error': 'End date cannot be before start date.',

      // Map Screen
      'selectDates': 'Select Dates',
      'startDate': 'Start Date',
      'endDate': 'End Date',
      'selectExperiences': 'Select Experiences',
      'immersionDifferentCulture': 'Immersion in a Different Culture',
      'exploreAlternativeCuisines': 'Explore Alternative Cuisines',
      'visitHistoricalSites': 'Visit Historical Sites',
      'visitLocalEstablishments': 'Visit Local Establishments',
      'contactWithNature': 'Contact With Nature',
      'saveChanges': 'Save Changes',
      'edit': 'Edit',
      'delete': 'Delete',
      'addStop': 'Add Stop',
      'deleteStop': 'Delete Stop',
      'deleteStopConfirm': 'Are you sure you want to delete this stop? This action cannot be undone.',
      'errorAddStopTitle': 'Error in Add Stop',
      'errorAddStopMsg': 'You need to have, at least, one experience.',
      'dates': 'Dates',
      'experiences': 'Experiences',
      'unknownPlace': 'Unknown Place',
      
      // List Trips
      'yourTrips': 'Your Trips',
      'activeTrips': 'Active Trips',
      'concludedTrips': 'Concluded Trips',
      'noActiveTrips': 'No active trips',
      'startPlanning': 'Start planning your next adventure!',
      'noConcludedTrips': 'No concluded trips',
      'completeTrips': 'Complete your trips to see them here',
      'ended': 'Ended',
      'markAsConcluded': 'Mark as Concluded',
      'concludeTrip': 'Conclude Trip',
      'tripEndedOn': 'The trip "{title}" has ended on {date}.',
      'confirmConclude': 'Would you like to mark it as concluded?',
      'notNow': 'Not Now',
      'tripConcludedSuccess': 'Trip marked as concluded!',
      'tripConcludedError': 'Error concluding trip',
      'fieldRequired': 'Field required.',

      // Trip Details Screen
      'deleteTrip': 'Delete Trip',
      'deleteTripConfirm':
          'Are you sure you want to delete "{0}"? This action cannot be undone.',
      'deletingTrip': 'Deleting trip...',
      'tripDeletedSuccess': 'Trip deleted successfully!',
      'tripBooklet': 'Trip Booklet',
      'tripBookletQuestion': 'Would you like to create a booklet for this trip?',
      'create': 'Create',
      'concluded': 'Concluded',
      'tripDetails': 'Trip Details',
      'travelGroup': 'Travel Group',
      'yearsOld': 'years old',
      'tripStops': 'Trip Stops',
      'noStopsAdded': 'No stops added',
      'culture': 'Culture',
      'cuisine': 'Cuisine',
      'history': 'History',
      'local': 'Local',
      'nature': 'Nature',

      'pleaseAddAllPersonPhotos': 'Please add photos for all group members',
      'pleaseAddAllStopData': 'Please add photos and descriptions for all stops',
      'generatingPdf': 'Generating PDF...',
      'tripRoute': 'Trip Route',
      'mapNotAvailable': 'Map not available',
      'citiesVisited': 'Cities Visited ({0})',
      'ourExperience': 'Our Experience',
      'photoGallery': 'Photo Gallery',
      'tripPlanner': 'Trip Planner',
      'quote':
          'A trip is not measured in miles, but in moments. Each page of this booklet holds more than landscapes: spontaneous smiles, unexpected discoveries, conversations that touched the soul, and silences that spoke louder than words.',
      'pdfGeneratedSuccess': 'PDF generated successfully!',
      'pdfGenerationError': 'Error generating PDF: {0}',

      'createBooklet': 'Create Trip Booklet',
      'tripSummary': 'Trip Summary',
      'groupMembersPhotos': 'Group Members Photos',
      'addPhoto': 'Add Photo',
      'writeExperience': 'Write about your experience at',
      'generateBooklet': 'Generate PDF Booklet',
      'errorGeneratingPdf': 'Error generating PDF',
      'addPhotosAllMembers': 'Please add photos for all group members',
      'missingData': 'Missing data',
      'successGeneratingPdf': 'PDF booklet successfully generated!',
      'creatingPdf': 'Creating booklet...',
      'noPhotos': 'No photos added',
      
      'preferences': 'Preferences',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'english': 'English',
      'portuguese': 'Portuguese',
      'spanish': 'Spanish',
      'account': 'Account',
      'your_information': 'Your Information',
      'update_info': 'Update Information',
      'information_updated': 'Information updated successfully!',
      'delete_account': 'Delete Account',
      'delete_account_confirm': 'Delete',
      'delete_account_question': 'Are you sure you want to delete your account? This action cannot be undone.',
      'log_out': 'Log Out',
      'log_out_confirm': 'Confirm',
      'log_out_question': 'Are you sure you want to log out?',
    },
    'pt': {
      // Login Screen
      'welcome_back': 'Bem-vindo de Volta!',
      'sign_in_subtitle': 'Entre para continuar sua jornada',
      'email': 'E-mail',
      'password': 'Senha',
      'sign_in': 'Entrar',
      'no_account': 'Não tem uma conta? Clique aqui para criar uma!',
      'no_account_question': 'Não tem uma conta? ',
      'sign_up_link': 'Cadastre-se',
      'or': 'ou',
      'login_successful': 'Login Realizado',
      'welcome_user': 'Bem-vindo, {0}!',
      'continue': 'Continuar',
      'login_failed': 'Falha no Login',
      'email_password_incorrect': 'E-mail ou senha incorretos',
      'try_again': 'Tentar Novamente',
      
      // Register Screen
      'create_account': 'Crie Sua Conta',
      'sign_up_subtitle': 'Junte-se a nós e comece a planejar suas viagens',
      'name': 'Nome',
      'sign_up': 'Cadastrar',
      'have_account': 'Já tem uma conta? Clique aqui para entrar!',
      'have_account_question': 'Já tem uma conta? ',
      'sign_in_link': 'Entre',
      'register_successful': 'Cadastro Realizado',
      'can_login_now': 'Agora você pode fazer login com suas credenciais',
      'go_to_login': 'Ir para Login',
      
      // Validation Errors
      'field_required': 'Este campo é obrigatório',
      'name_required': 'Nome não pode estar em branco',
      'email_required': 'E-mail não pode estar em branco',
      'password_required': 'Senha não pode estar em branco',
      'invalid_email': 'Formato de e-mail inválido',
      'password_too_short': 'A senha deve ter pelo menos 8 caracteres',
      'password_too_long': 'A senha não deve exceder 72 bytes em UTF-8',
      'email_already_registered': 'Já existe um cadastro com este e-mail',
      'register_error': 'Erro ao realizar cadastro',
      'delete_user_error': 'Erro ao deletar usuário',
      
      // Home Screen
      'plan_your_next_adventure': 'Planeje sua próxima aventura',
      'searching': 'Buscando...',
      'search_results': 'Resultados da Busca',
      'found': '{0} encontrados',
      'location_selected': 'Local Selecionado',
      'select_trip': 'Selecionar Viagem?',
      'use_trip_template': 'Deseja usar esta viagem como modelo?',
      'cancel': 'Cancelar',
      'select': 'Selecionar',
      'try_different_words': 'Tente buscar com outras palavras',
      'recommended_trips': 'Viagens Recomendadas',
      'welcome': 'Bem-vindo, {0}',
      'search_destinations': 'Buscar destinos...',
      'no_results_found': 'Nenhum resultado encontrado',
      'selected': 'Selecionado: {0}',
      'days': '{0} dias',
      'brazilian_northeast': 'Nordeste Brasileiro',
      'southern_brazil': 'Sul do Brasil',
      
      'new_trip': 'Nova Viagem',
      'trip_data': 'Dados da Viagem',
      'trip_title': 'Título da Viagem',
      'transport': 'Transporte',
      'car': 'Carro',
      'motorcycle': 'Moto',
      'bus': 'Ônibus',
      'airplane': 'Avião',
      'ship': 'Navio',
      'group_data': 'Dados do Grupo',
      'age': 'Idade',
      'add_person': 'Adicionar Pessoa',
      'group_members': 'Integrantes do Grupo ({0})',
      'map': 'Mapa',
      'fullscreen_map': 'Mapa em Tela Cheia',
      'register_trip': 'Cadastrar Viagem',
      'success': 'Sucesso!',
      'trip_created_successfully': 'Viagem criada com sucesso!',
      'error': 'Erro',
      'ok': 'Ok',
      
      // Trip Validations
      'trip_title_required': 'O título da viagem é obrigatório.',
      'group_empty': 'Adicione pelo menos uma pessoa ao grupo.',
      'stops_empty': 'Adicione pelo menos uma parada à viagem.',
      'age_required': 'A idade é obrigatória.',
      'age_invalid': 'A idade deve ser um número válido.',
      'start_date_required': 'A data de início é obrigatória.',
      'end_date_required': 'A data de término é obrigatória.',
      'end_date_error': 'A data de término não pode ser anterior à data de início.',

      'selectDates': 'Selecionar Datas',
      'startDate': 'Data de Início',
      'endDate': 'Data de Término',
      'selectExperiences': 'Selecionar Experiências',
      'immersionDifferentCulture': 'Imersão em uma Cultura Diferente',
      'exploreAlternativeCuisines': 'Explorar Culinárias Alternativas',
      'visitHistoricalSites': 'Visitar Locais Históricos',
      'visitLocalEstablishments': 'Visitar Estabelecimentos Locais',
      'contactWithNature': 'Contato com a Natureza',
      'saveChanges': 'Salvar Alterações',
      'edit': 'Editar',
      'delete': 'Excluir',
      'addStop': 'Adicionar Parada',
      'deleteStop': 'Excluir Parada',
      'deleteStopConfirm': 'Tem certeza de que deseja excluir esta parada? Essa ação não pode ser desfeita.',
      'errorAddStopTitle': 'Erro ao Adicionar Parada',
      'errorAddStopMsg': 'Você precisa ter pelo menos uma experiência selecionada.',
      'dates': 'Datas',
      'experiences': 'Experiências',
      'unknownPlace': 'Local Desconhecido',
      
      // List Trips
      'yourTrips': 'Suas Viagens',
      'activeTrips': 'Viagens Ativas',
      'concludedTrips': 'Viagens Concluídas',
      'noActiveTrips': 'Nenhuma viagem ativa',
      'startPlanning': 'Comece a planejar sua próxima aventura!',
      'noConcludedTrips': 'Nenhuma viagem concluída',
      'completeTrips': 'Conclua suas viagens para vê-las aqui',
      'ended': 'Encerrada',
      'markAsConcluded': 'Marcar como Concluída',
      'concludeTrip': 'Concluir Viagem',
      'tripEndedOn': 'A viagem "{title}" terminou em {date}.',
      'confirmConclude': 'Deseja marcá-la como concluída?',
      'notNow': 'Agora não',
      'tripConcludedSuccess': 'Viagem marcada como concluída!',
      'tripConcludedError': 'Erro ao concluir viagem',
      'fieldRequired': 'Campo obrigatório.',

      // Trip Details Screen
      'deleteTrip': 'Excluir Viagem',
      'deleteTripConfirm':
          'Tem certeza de que deseja excluir "{0}"? Essa ação não pode ser desfeita.',
      'deletingTrip': 'Excluindo viagem...',
      'tripDeletedSuccess': 'Viagem excluída com sucesso!',
      'tripBooklet': 'Caderneta de Viagem',
      'tripBookletQuestion': 'Deseja criar uma caderneta para esta viagem?',
      'create': 'Criar',
      'concluded': 'Concluída',
      'tripDetails': 'Detalhes da Viagem',
      'travelGroup': 'Grupo de Viagem',
      'yearsOld': 'anos',
      'tripStops': 'Paradas da Viagem',
      'noStopsAdded': 'Nenhuma parada adicionada',
      'culture': 'Cultura',
      'cuisine': 'Culinária',
      'history': 'História',
      'local': 'Local',
      'nature': 'Natureza',

      'pleaseAddAllPersonPhotos': 'Adicione fotos para todos os membros do grupo',
      'pleaseAddAllStopData': 'Adicione fotos e descrições para todas as paradas',
      'generatingPdf': 'Gerando PDF...',
      'tripRoute': 'Rota da Viagem',
      'mapNotAvailable': 'Mapa não disponível',
      'citiesVisited': 'Cidades Visitadas ({0})',
      'ourExperience': 'Nossa Experiência',
      'photoGallery': 'Galeria de Fotos',
      'tripPlanner': 'Trip Planner',
      'quote':
          'Uma viagem não se mede em milhas, mas em momentos. Cada página deste livreto guarda mais do que paisagens: são sorrisos espontâneos, descobertas inesperadas, conversas que ficaram na alma e silêncios que falaram mais que palavras.',
      'pdfGeneratedSuccess': 'PDF gerado com sucesso!',
      'pdfGenerationError': 'Erro ao gerar PDF: {0}',

      'createBooklet': 'Criar Caderneta da Viagem',
      'tripSummary': 'Resumo da Viagem',
      'groupMembersPhotos': 'Fotos dos Integrantes',
      'addPhoto': 'Adicionar Foto',
      'writeExperience': 'Escreva sobre sua experiência em',
      'generateBooklet': 'Gerar Caderneta em PDF',
      'errorGeneratingPdf': 'Erro ao gerar o PDF',
      'addPhotosAllMembers': 'Adicione fotos para todos os integrantes',
      'missingData': 'Dados faltando',
      'successGeneratingPdf': 'Caderneta gerada com sucesso!',
      'creatingPdf': 'Criando caderneta...',
      'noPhotos': 'Nenhuma foto adicionada',
      
      // Config Screen
      'preferences': 'Preferências',
      'dark_mode': 'Modo Escuro',
      'language': 'Idioma',
      'english': 'Inglês',
      'portuguese': 'Português',
      'spanish': 'Espanhol',
      'account': 'Conta',
      'your_information': 'Suas Informações',
      'update_info': 'Atualizar Informações',
      'information_updated': 'Informações atualizadas com sucesso!',
      'delete_account': 'Excluir Conta',
      'delete_account_confirm': 'Excluir',
      'delete_account_question': 'Tem certeza de que deseja excluir sua conta? Esta ação não pode ser desfeita.',
      'log_out': 'Sair',
      'log_out_confirm': 'Confirmar',
      'log_out_question': 'Tem certeza de que deseja sair?',
    },
    'es': {
      // Login Screen
      'welcome_back': '¡Bienvenido de Nuevo!',
      'sign_in_subtitle': 'Inicia sesión para continuar tu viaje',
      'email': 'Correo Electrónico',
      'password': 'Contraseña',
      'sign_in': 'Iniciar Sesión',
      'no_account': '¿No tienes una cuenta? ¡Haz clic aquí para crear una!',
      'no_account_question': '¿No tienes una cuenta? ',
      'sign_up_link': 'Regístrate',
      'or': 'o',
      'login_successful': 'Inicio de Sesión Exitoso',
      'welcome_user': '¡Bienvenido, {0}!',
      'continue': 'Continuar',
      'login_failed': 'Error de Inicio de Sesión',
      'email_password_incorrect': 'Correo o contraseña incorrectos',
      'try_again': 'Intentar de Nuevo',
      
      // Register Screen
      'create_account': 'Crea Tu Cuenta',
      'sign_up_subtitle': 'Únete a nosotros y comienza a planificar tus viajes',
      'name': 'Nombre',
      'sign_up': 'Registrarse',
      'have_account': '¿Ya tienes una cuenta? ¡Haz clic aquí para iniciar sesión!',
      'have_account_question': '¿Ya tienes una cuenta? ',
      'sign_in_link': 'Inicia Sesión',
      'register_successful': 'Registro Exitoso',
      'can_login_now': 'Ahora puedes iniciar sesión con tus credenciales',
      'go_to_login': 'Ir al Inicio de Sesión',
      
      // Validation Errors
      'field_required': 'Este campo es obligatorio',
      'name_required': 'El nombre no puede estar en blanco',
      'email_required': 'El correo no puede estar en blanco',
      'password_required': 'La contraseña no puede estar en blanco',
      'invalid_email': 'Formato de correo inválido',
      'password_too_short': 'La contraseña debe tener al menos 8 caracteres',
      'password_too_long': 'La contraseña no debe superar 72 bytes en UTF-8',
      'email_already_registered': 'Ya existe un registro con este correo',
      'register_error': 'Error al realizar el registro',
      'delete_user_error': 'Error al eliminar usuario',
      
      // Home Screen
      'plan_your_next_adventure': 'Planifica tu próxima aventura',
      'searching': 'Buscando...',
      'search_results': 'Resultados de la Búsqueda',
      'found': '{0} encontrados',
      'location_selected': 'Ubicación Seleccionada',
      'select_trip': '¿Seleccionar Viaje?',
      'use_trip_template': '¿Quieres usar este viaje como plantilla?',
      'cancel': 'Cancelar',
      'select': 'Seleccionar',
      'try_different_words': 'Intenta buscar con otras palabras',
      'recommended_trips': 'Viajes Recomendados',
      'welcome': 'Bienvenido, {0}',
      'search_destinations': 'Buscar destinos...',
      'no_results_found': 'No se encontraron resultados',
      'selected': 'Seleccionado: {0}',
      'days': '{0} días',
      'brazilian_northeast': 'Nordeste Brasileño',
      'southern_brazil': 'Sur de Brasil',
      
      // Trip Register Screen
      'new_trip': 'Nuevo Viaje',
      'trip_data': 'Datos del Viaje',
      'trip_title': 'Título del Viaje',
      'transport': 'Transporte',
      'car': 'Coche',
      'motorcycle': 'Motocicleta',
      'bus': 'Autobús',
      'airplane': 'Avión',
      'ship': 'Barco',
      'group_data': 'Datos del Grupo',
      'age': 'Edad',
      'add_person': 'Agregar Persona',
      'group_members': 'Miembros del Grupo ({0})',
      'map': 'Mapa',
      'fullscreen_map': 'Mapa en Pantalla Completa',
      'register_trip': 'Registrar Viaje',
      'success': '¡Éxito!',
      'trip_created_successfully': '¡Viaje creado con éxito!',
      'error': 'Error',
      'ok': 'Ok',
      
      // Trip Validations
      'trip_title_required': 'El título del viaje es obligatorio.',
      'group_empty': 'Agrega al menos una persona al grupo.',
      'stops_empty': 'Agrega al menos una parada al viaje.',
      'age_required': 'La edad es obligatoria.',
      'age_invalid': 'La edad debe ser un número válido.',
      'start_date_required': 'La fecha de inicio es obligatoria.',
      'end_date_required': 'La fecha de finalización es obligatoria.',
      'end_date_error': 'La fecha de finalización no puede ser anterior a la fecha de inicio.',

      'selectDates': 'Seleccionar Fechas',
      'startDate': 'Fecha de Inicio',
      'endDate': 'Fecha de Finalización',
      'selectExperiences': 'Seleccionar Experiencias',
      'immersionDifferentCulture': 'Inmersión en una Cultura Diferente',
      'exploreAlternativeCuisines': 'Explorar Cocinas Alternativas',
      'visitHistoricalSites': 'Visitar Sitios Históricos',
      'visitLocalEstablishments': 'Visitar Establecimientos Locales',
      'contactWithNature': 'Contacto con la Naturaleza',
      'saveChanges': 'Guardar Cambios',
      'edit': 'Editar',
      'delete': 'Eliminar',
      'addStop': 'Agregar Parada',
      'deleteStop': 'Eliminar Parada',
      'deleteStopConfirm': '¿Estás seguro de que deseas eliminar esta parada? Esta acción no se puede deshacer.',
      'errorAddStopTitle': 'Error al Agregar Parada',
      'errorAddStopMsg': 'Debes tener al menos una experiencia seleccionada.',
      'dates': 'Fechas',
      'experiences': 'Experiencias',
      'unknownPlace': 'Lugar Desconocido',
      
      // List Trips
      'yourTrips': 'Tus Viajes',
      'activeTrips': 'Viajes Activos',
      'concludedTrips': 'Viajes Concluidos',
      'noActiveTrips': 'No hay viajes activos',
      'startPlanning': '¡Comienza a planear tu próxima aventura!',
      'noConcludedTrips': 'No hay viajes concluidos',
      'completeTrips': 'Completa tus viajes para verlos aquí',
      'ended': 'Finalizado',
      'markAsConcluded': 'Marcar como Concluido',
      'concludeTrip': 'Concluir Viaje',
      'tripEndedOn': 'El viaje "{title}" terminó el {date}.',
      'confirmConclude': '¿Deseas marcarlo como concluido?',
      'notNow': 'Ahora no',
      'tripConcludedSuccess': '¡Viaje marcado como concluido!',
      'tripConcludedError': 'Error al concluir el viaje',
      'fieldRequired': 'Campo obligatorio.',

      // Trip Details Screen
      'deleteTrip': 'Eliminar Viaje',
      'deleteTripConfirm':
          '¿Estás seguro de que deseas eliminar "{0}"? Esta acción no se puede deshacer.',
      'deletingTrip': 'Eliminando viaje...',
      'tripDeletedSuccess': '¡Viaje eliminado exitosamente!',
      'tripBooklet': 'Libreta de Viaje',
      'tripBookletQuestion': '¿Deseas crear una libreta para este viaje?',
      'create': 'Crear',
      'concluded': 'Concluido',
      'tripDetails': 'Detalles del Viaje',
      'travelGroup': 'Grupo de Viaje',
      'yearsOld': 'años',
      'tripStops': 'Paradas del Viaje',
      'noStopsAdded': 'No se agregaron paradas',
      'culture': 'Cultura',
      'cuisine': 'Cocina',
      'history': 'Historia',
      'local': 'Local',
      'nature': 'Naturaleza',

      'pleaseAddAllPersonPhotos': 'Agrega fotos para todos los miembros del grupo',
      'pleaseAddAllStopData': 'Agrega fotos y descripciones para todas las paradas',
      'generatingPdf': 'Generando PDF...',
      'tripRoute': 'Ruta del Viaje',
      'mapNotAvailable': 'Mapa no disponible',
      'citiesVisited': 'Ciudades Visitadas ({0})',
      'ourExperience': 'Nuestra Experiencia',
      'photoGallery': 'Galería de Fotos',
      'tripPlanner': 'Trip Planner',
      'quote':
          'Un viaje no se mide en millas, sino en momentos. Cada página de este cuaderno guarda más que paisajes: sonrisas espontáneas, descubrimientos inesperados, conversaciones que quedaron en el alma y silencios que hablaron más que las palabras.',
      'pdfGeneratedSuccess': '¡PDF generado con éxito!',
      'pdfGenerationError': 'Error al generar el PDF: {0}',

      'createBooklet': 'Crear Libreta del Viaje',
      'tripSummary': 'Resumen del Viaje',
      'groupMembersPhotos': 'Fotos de los Integrantes',
      'addPhoto': 'Agregar Foto',
      'writeExperience': 'Escribe sobre tu experiencia en',
      'generateBooklet': 'Generar Libreta en PDF',
      'errorGeneratingPdf': 'Error al generar el PDF',
      'addPhotosAllMembers': 'Agrega fotos para todos los integrantes',
      'missingData': 'Faltan datos',
      'successGeneratingPdf': '¡Libreta generada con éxito!',
      'creatingPdf': 'Creando libreta...',
      'noPhotos': 'No se agregaron fotos',
      
      'preferences': 'Preferencias',
      'dark_mode': 'Modo Oscuro',
      'language': 'Idioma',
      'english': 'Inglés',
      'portuguese': 'Portugués',
      'spanish': 'Español',
      'account': 'Cuenta',
      'your_information': 'Tu Información',
      'update_info': 'Actualizar Información',
      'information_updated': '¡Información actualizada con éxito!',
      'delete_account': 'Eliminar Cuenta',
      'delete_account_confirm': 'Eliminar',
      'delete_account_question': '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.',
      'log_out': 'Cerrar Sesión',
      'log_out_confirm': 'Confirmar',
      'log_out_question': '¿Estás seguro de que deseas cerrar sesión?',
    },
  };

  String translate(String key, [List<String>? args]) {
    String translation = _localizedValues[locale.languageCode]?[key] ?? key;
    
    if (args != null) {
      for (int i = 0; i < args.length; i++) {
        translation = translation.replaceAll('{$i}', args[i]);
      }
    }
    
    return translation;
  }

  // Getters for Login Screen
  String get welcomeBack => translate('welcome_back');
  String get signInSubtitle => translate('sign_in_subtitle');
  String get email => translate('email');
  String get password => translate('password');
  String get signIn => translate('sign_in');
  String get noAccount => translate('no_account');
  String get noAccountQuestion => translate('no_account_question');
  String get signUpLink => translate('sign_up_link');
  String get or => translate('or');
  String get loginSuccessful => translate('login_successful');
  String welcomeUser(String name) => translate('welcome_user', [name]);
  String get continueText => translate('continue');
  String get loginFailed => translate('login_failed');
  String get emailPasswordIncorrect => translate('email_password_incorrect');
  String get tryAgain => translate('try_again');
  
  // Getters for Register Screen
  String get createAccount => translate('create_account');
  String get signUpSubtitle => translate('sign_up_subtitle');
  String get name => translate('name');
  String get signUp => translate('sign_up');
  String get haveAccount => translate('have_account');
  String get haveAccountQuestion => translate('have_account_question');
  String get signInLink => translate('sign_in_link');
  String get registerSuccessful => translate('register_successful');
  String get canLoginNow => translate('can_login_now');
  String get goToLogin => translate('go_to_login');
  
  // Getters for Validation Errors
  String get fieldRequired => translate('field_required');
  String get nameRequired => translate('name_required');
  String get emailRequired => translate('email_required');
  String get passwordRequired => translate('password_required');
  String get invalidEmail => translate('invalid_email');
  String get passwordTooShort => translate('password_too_short');
  String get passwordTooLong {
    return translate('password_too_long');
  }
  String get emailAlreadyRegistered => translate('email_already_registered');
  String get registerError => translate('register_error');
  String get deleteUserError => translate('delete_user_error');
  
  // Home Screen
  String welcome(String name) => translate('welcome', [name]);
  String get planYourNextAdventure => translate('plan_your_next_adventure');
  String get searchDestinations => translate('search_destinations');
  String get searching => translate('searching');
  String get searchResults => translate('search_results');
  String found(String count) => translate('found', [count]);
  String get locationSelected => translate('location_selected');
  String get selectTrip => translate('select_trip');
  String get useTripTemplate => translate('use_trip_template');
  String get cancel => translate('cancel');
  String get select => translate('select');
  String get noResultsFound => translate('no_results_found');
  String get tryDifferentWords => translate('try_different_words');
  String get recommendedTrips => translate('recommended_trips');
  String selected(String name) => translate('selected', [name]);
  String days(String count) => translate('days', [count]);
  String get brazilianNortheast => translate('brazilian_northeast');
  String get southernBrazil => translate('southern_brazil');
  
  // Getters for Trip Register Screen
  String get newTrip => translate('new_trip');
  String get tripData => translate('trip_data');
  String get tripTitle => translate('trip_title');
  String get transport => translate('transport');
  String get car => translate('car');
  String get motorcycle => translate('motorcycle');
  String get bus => translate('bus');
  String get airplane => translate('airplane');
  String get ship => translate('ship');
  String get groupData => translate('group_data');
  String get age => translate('age');
  String get addPerson => translate('add_person');
  String groupMembers(String count) => translate('group_members', [count]);
  String get map => translate('map');
  String get fullscreenMap => translate('fullscreen_map');
  String get registerTrip => translate('register_trip');
  String get success => translate('success');
  String get tripCreatedSuccessfully => translate('trip_created_successfully');
  String get error => translate('error');
  String get ok => translate('ok');
  
  String get tripTitleRequired => translate('trip_title_required');
  String get groupEmpty => translate('group_empty');
  String get stopsEmpty => translate('stops_empty');
  String get ageRequired => translate('age_required');
  String get ageInvalid => translate('age_invalid');
  String get startDateRequired => translate('start_date_required');
  String get endDateRequired => translate('end_date_required');
  String get endDateError => translate('end_date_error');
  String get unexpectedError => translate('unexpected_error');

  String get selectDates => translate('selectDates');
  String get startDate => translate('startDate');
  String get endDate => translate('endDate');
  String get selectExperiences => translate('selectExperiences');
  String get immersionDifferentCulture => translate('immersionDifferentCulture');
  String get exploreAlternativeCuisines => translate('exploreAlternativeCuisines');
  String get visitHistoricalSites => translate('visitHistoricalSites');
  String get visitLocalEstablishments => translate('visitLocalEstablishments');
  String get contactWithNature => translate('contactWithNature');
  String get saveChanges => translate('saveChanges');
  String get edit => translate('edit');
  String get delete => translate('delete');
  String get addStop => translate('addStop');
  String get deleteStop => translate('deleteStop');
  String get deleteStopConfirm => translate('deleteStopConfirm');
  String get errorAddStopTitle => translate('errorAddStopTitle');
  String get errorAddStopMsg => translate('errorAddStopMsg');
  String get dates => translate('dates');
  String get experiences => translate('experiences');
  String get unknownPlace => translate('unknownPlace');
  
  // Getters for List Trips Screen
  String get yourTrips => translate('yourTrips');
  String get activeTrips => translate('activeTrips');
  String get concludedTrips => translate('concludedTrips');
  String get noActiveTrips => translate('noActiveTrips');
  String get startPlanning => translate('startPlanning');
  String get noConcludedTrips => translate('noConcludedTrips');
  String get completeTrips => translate('completeTrips');
  String get ended => translate('ended');
  String get markAsConcluded => translate('markAsConcluded');
  String get concludeTrip => translate('concludeTrip');
  String tripEndedOn(String title, String date) =>
      translate('tripEndedOn').replaceAll('{title}', title).replaceAll('{date}', date);
  String get confirmConclude => translate('confirmConclude');
  String get notNow => translate('notNow');
  String get tripConcludedSuccess => translate('tripConcludedSuccess');
  String get tripConcludedError => translate('tripConcludedError');
  
  String get deleteTrip => translate('deleteTrip');
  String deleteTripConfirm(String title) =>
      translate('deleteTripConfirm', [title]);
  String get deletingTrip => translate('deletingTrip');
  String get tripDeletedSuccess => translate('tripDeletedSuccess');
  String get tripBooklet => translate('tripBooklet');
  String get tripBookletQuestion => translate('tripBookletQuestion');
  String get create => translate('create');
  String get concluded => translate('concluded');
  String get tripDetails => translate('tripDetails');
  String get travelGroup => translate('travelGroup');
  String get yearsOld => translate('yearsOld');
  String get tripStops => translate('tripStops');
  String get noStopsAdded => translate('noStopsAdded');
  String get culture => translate('culture');
  String get cuisine => translate('cuisine');
  String get history => translate('history');
  String get local => translate('local');
  String get nature => translate('nature');

  String get pleaseAddAllPersonPhotos => translate('pleaseAddAllPersonPhotos');
  String get pleaseAddAllStopData => translate('pleaseAddAllStopData');
  String get generatingPdf => translate('generatingPdf');
  String get tripRoute => translate('tripRoute');
  String get mapNotAvailable => translate('mapNotAvailable');
  String citiesVisited(int count) =>
      translate('citiesVisited', [count.toString()]);
  String get ourExperience => translate('ourExperience');
  String get photoGallery => translate('photoGallery');
  String get tripPlanner => translate('tripPlanner');
  String get quote => translate('quote');
  String get pdfGeneratedSuccess => translate('pdfGeneratedSuccess');
  String pdfGenerationError(String error) =>
      translate('pdfGenerationError', [error]);

  String get createBooklet => translate('createBooklet');
  String get tripSummary => translate('tripSummary');
  String get groupMembersPhotos => translate('groupMembersPhotos');
  String get addPhoto => translate('addPhoto');
  String get writeExperience => translate('writeExperience');
  String get generateBooklet => translate('generateBooklet');
  String get errorGeneratingPdf => translate('errorGeneratingPdf');
  String get addPhotosAllMembers => translate('addPhotosAllMembers');
  String get missingData => translate('missingData');
  String get successGeneratingPdf => translate('successGeneratingPdf');
  String get creatingPdf => translate('creatingPdf');
  String get noPhotos => translate('noPhotos');

  String get preferences => translate('preferences');
  String get darkMode => translate('dark_mode');
  String get language => translate('language');
  String get english => translate('english');
  String get portuguese => translate('portuguese');
  String get spanish => translate('spanish');
  String get account => translate('account');
  String get yourInformation => translate('your_information');
  String get updateInfo => translate('update_info');
  String get informationUpdated => translate('information_updated');
  String get deleteAccount => translate('delete_account');
  String get deleteAccountConfirm => translate('delete_account_confirm');
  String get deleteText => translate('delete');
  String get deleteAccountQuestion => translate('delete_account_question');
  String get logOut => translate('log_out');
  String get logOutConfirm => translate('log_out_confirm');
  String get logOutQuestion => translate('log_out_question');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'pt', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
