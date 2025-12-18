import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nostrrdr/src/app/theme/app_theme.dart';
import 'package:nostrrdr/src/app/widgets/nr_icon_button.dart';
import 'package:nostrrdr/src/app/widgets/nr_text_field.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:nostrrdr/src/features/auth/presentation/widgets/auth_form.dart';

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const SingleChildScrollView(child: AuthForm()),
          ),
        ),
      ),
    );
  }

  group('AuthForm', () {
    testWidgets('renders key UI elements', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Enter your private key'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Create new identity'), findsOneWidget);
      expect(find.text('Login with Amber'), findsOneWidget);
      expect(find.byType(NrTextField), findsOneWidget);
      expect(find.byType(NrIconButton), findsOneWidget);
      expect(find.byType(OrDivider), findsOneWidget);
    });

    testWidgets(
      'dispatches NsecLoginRequested when valid nsec is entered and Login tapped',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        const nsec = 'nsec1234567890';
        await tester.enterText(find.byType(TextField), nsec);
        await tester.tap(find.text('Login'));
        await tester.pump();

        verify(
          () => mockAuthBloc.add(const NsecLoginRequested(nsec)),
        ).called(1);
      },
    );

    testWidgets(
      'does NOT dispatch NsecLoginRequested when input is empty and Login tapped',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Login'));
        await tester.pump();

        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets(
      'dispatches CreateIdentityRequested when Create new identity button is pressed',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Create new identity'));
        await tester.pump();

        verify(
          () => mockAuthBloc.add(const CreateIdentityRequested()),
        ).called(1);
      },
    );

    testWidgets(
      'shows loading indicator and disables interactions when state is AuthLoading',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthLoading());
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Login'), findsNothing);

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.readOnly, isTrue);

        await tester.tap(find.text('Create new identity'), warnIfMissed: false);
        await tester.pump();
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets(
      'populates text field with clipboard content when paste button is tapped',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());
        const clipboardContent = 'nsec_from_clipboard';

        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (methodCall) async {
            if (methodCall.method == 'Clipboard.getData') {
              return {'text': clipboardContent};
            }
            return null;
          },
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final pasteButton = find.byType(NrIconButton);
        expect(pasteButton, findsOneWidget);

        await tester.tap(pasteButton);
        await tester.pumpAndSettle();

        expect(find.text(clipboardContent), findsOneWidget);

        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        );
      },
    );

    testWidgets(
      'does NOT dispatch NsecLoginRequested when nsec format is invalid (does not start with "nsec")',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'invalid_key_format');
        await tester.tap(find.text('Login'));
        await tester
            .pumpAndSettle(); // Wait for validation and error message rendering

        // Verify error message is shown
        expect(find.text('Private key must start with "nsec"'), findsOneWidget);

        verifyNever(() => mockAuthBloc.add(any()));
      },
    );
  });
}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}
