      import 'package:flutter/material.dart';

      class AppLocalizations {
        AppLocalizations(this.locale);
        final Locale locale;

        static AppLocalizations of(BuildContext context) =>
            Localizations.of<AppLocalizations>(context, AppLocalizations)!;

        static const LocalizationsDelegate<AppLocalizations> delegate =
            _Delegate();
        static const supported = [Locale('en'), Locale('ar')];

        Map<String, String> get _en => const {
              'appTitle': 'Rushly Scanner',
              'appTagline': 'Dedicated barcode / RFID scanning for anywhere in the pipeline',
              'email': 'Email',
              'password': 'Password',
              'signIn': 'Sign in',
              'loginFailed': 'Invalid credentials',
              'required': 'Required',
              'emailInvalid': 'Invalid email',
              'passwordTooShort': 'Min 6 characters',
              'chooseWorkspace': 'Choose workspace',
              'chooseWorkspaceHint':
                  'Enter the workspace your Rushly account belongs to. Ask your admin if you\'re not sure.',
              'workspaceName': 'Workspace name',
              'workspaceNameInvalid':
                  'Use lowercase letters, digits and hyphens only.',
              'apiUrl': 'API URL',
              'invalidUrl': 'Invalid URL',
              'simpleMode': 'Use workspace name',
              'advancedMode': 'Enter full URL',
              'connect': 'Connect',
              'workspace': 'Workspace',
              'changeWorkspace': 'Change workspace',
              'changeWorkspaceConfirm':
                  'Sign out and connect to a different workspace?',
              'cancel': 'Cancel',
              'logout': 'Log out',
              'comingSoon': 'Coming soon',
              'comingSoonHint':
                  'This surface is scaffolded — features land in follow-up releases.',
              'tab_0': 'Scan',
      'tab_1': 'History',
              'tab_0_desc': 'Camera scanner — shipments, inventory, assets',
      'tab_1_desc': 'Recent scans, tap to see the referenced record',
            };

        Map<String, String> get _ar => const {
              'appTitle': 'رشلي Scanner',
              'appTagline': 'Dedicated barcode / RFID scanning for anywhere in the pipeline',
              'email': 'البريد الإلكتروني',
              'password': 'كلمة المرور',
              'signIn': 'تسجيل الدخول',
              'loginFailed': 'بيانات غير صحيحة',
              'required': 'مطلوب',
              'emailInvalid': 'بريد غير صالح',
              'passwordTooShort': 'الحد الأدنى 6 أحرف',
              'chooseWorkspace': 'اختيار مساحة العمل',
              'chooseWorkspaceHint':
                  'أدخل اسم مساحة العمل التابع لها حسابك.',
              'workspaceName': 'اسم مساحة العمل',
              'workspaceNameInvalid':
                  'استخدم أحرفًا لاتينية صغيرة وأرقامًا وواصلات فقط.',
              'apiUrl': 'عنوان الخادم',
              'invalidUrl': 'عنوان غير صالح',
              'simpleMode': 'استخدام اسم مساحة العمل',
              'advancedMode': 'إدخال عنوان كامل',
              'connect': 'اتصال',
              'workspace': 'مساحة العمل',
              'changeWorkspace': 'تغيير مساحة العمل',
              'changeWorkspaceConfirm':
                  'تسجيل الخروج والاتصال بمساحة عمل مختلفة؟',
              'cancel': 'إلغاء',
              'logout': 'تسجيل الخروج',
              'comingSoon': 'قريبًا',
              'comingSoonHint':
                  'الشاشة مُجهّزة كهيكل — الميزات ستضاف في إصدارات لاحقة.',
              'tab_0': 'Scan',
      'tab_1': 'History',
              'tab_0_desc': 'Camera scanner — shipments, inventory, assets',
      'tab_1_desc': 'Recent scans, tap to see the referenced record',
            };

        String _t(String k) {
          final m = locale.languageCode == 'ar' ? _ar : _en;
          return m[k] ?? _en[k] ?? k;
        }

        String get appTitle => _t('appTitle');
        String get appTagline => _t('appTagline');
        String get email => _t('email');
        String get password => _t('password');
        String get signIn => _t('signIn');
        String get loginFailed => _t('loginFailed');
        String get required => _t('required');
        String get emailInvalid => _t('emailInvalid');
        String get passwordTooShort => _t('passwordTooShort');
        String get chooseWorkspace => _t('chooseWorkspace');
        String get chooseWorkspaceHint => _t('chooseWorkspaceHint');
        String get workspaceName => _t('workspaceName');
        String get workspaceNameInvalid => _t('workspaceNameInvalid');
        String get apiUrl => _t('apiUrl');
        String get invalidUrl => _t('invalidUrl');
        String get simpleMode => _t('simpleMode');
        String get advancedMode => _t('advancedMode');
        String get connect => _t('connect');
        String get workspace => _t('workspace');
        String get changeWorkspace => _t('changeWorkspace');
        String get changeWorkspaceConfirm => _t('changeWorkspaceConfirm');
        String get cancel => _t('cancel');
        String get logout => _t('logout');
        String get comingSoon => _t('comingSoon');
        String get comingSoonHint => _t('comingSoonHint');
        String get tab0Label => _t('tab_0');
String get tab0Desc => _t('tab_0_desc');
String get tab1Label => _t('tab_1');
String get tab1Desc => _t('tab_1_desc');
      }

      class _Delegate extends LocalizationsDelegate<AppLocalizations> {
        const _Delegate();
        @override
        bool isSupported(Locale locale) =>
            ['en', 'ar'].contains(locale.languageCode);
        @override
        Future<AppLocalizations> load(Locale locale) async =>
            AppLocalizations(locale);
        @override
        bool shouldReload(_Delegate old) => false;
      }
