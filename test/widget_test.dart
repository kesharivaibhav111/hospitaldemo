import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hospitaldemo/main.dart';
import 'package:hospitaldemo/screens/dashboard_screen.dart';

void main() {
  testWidgets('Hospital Management System Login screen smoke test (Desktop)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    expect(find.text('CityCare Hospital'), findsWidgets);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in to continue to Hospital Management System'), findsOneWidget);
    expect(find.text('Username or Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Select Role'), findsWidgets);
    expect(find.text('Remember Me'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Admin (Full)'), findsOneWidget);
    expect(find.text('Doctor (Clinical)'), findsOneWidget);
    expect(find.text('Nurse (Ward/Vitals)'), findsOneWidget);
  });

  testWidgets('Hospital Management System Login screen smoke test (Standard Mobile 390x844)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    expect(find.text('CityCare Hospital'), findsWidgets);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Small Android Mobile Screen (360x640) - Zero Overflow on Login',
      (WidgetTester tester) async {
    // 360x640 is classic budget Android screen dimension (e.g. Redmi 9)
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    expect(find.text('CityCare Hospital'), findsWidgets);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Small Android Mobile Screen (360x640) - Zero Overflow on Dashboard',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    // Auto-fill Doctor role (scroll down in SingleChildScrollView if needed)
    await tester.ensureVisible(find.text('Doctor (Clinical)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Doctor (Clinical)'));
    await tester.pumpAndSettle();

    // Tap Login
    await tester.ensureVisible(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify dashboard renders cleanly on 360x640 with zero RenderFlex overflow
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Welcome back, doctor!'), findsOneWidget);
    expect(find.text('Assigned Patients'), findsOneWidget);
  });

  testWidgets('Validation error on empty submit', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your username'), findsOneWidget);
  });

  testWidgets('Admin Login has Full System Access and sees ALL hospital sections',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    // Auto-fill admin
    await tester.tap(find.text('Admin (Full)'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Welcome back, admin!'), findsOneWidget);
    expect(find.text('Full System Access (Unrestricted)'), findsOneWidget);

    // Admin sees ALL sections across all departments
    expect(find.text('Patient Directory & Demographics'), findsOneWidget);
    expect(find.text('Clinical Consultations & EHR'), findsOneWidget);
    expect(find.text('Prescriptions & e-Rx'), findsOneWidget);
    expect(find.text('Diagnostic Lab & Imaging Orders'), findsOneWidget);
    expect(find.text('Inpatient Wards & Bed Allocation'), findsOneWidget);
    expect(find.text('Patient Vitals & Nurse Charting'), findsOneWidget);
    expect(find.text('Appointments & OPD Scheduling'), findsOneWidget);
    expect(find.text('Billing, Invoicing & Insurance'), findsOneWidget);
    expect(find.text('Hospital Settings & Staff Roster'), findsOneWidget);
  });

  testWidgets('Doctor Login shows only Doctor sections and hides non-clinical sections',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    // Auto-fill doctor
    await tester.tap(find.text('Doctor (Clinical)'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Welcome back, doctor!'), findsOneWidget);
    expect(find.text('Clinical & Diagnostic Access'), findsOneWidget);
    expect(find.text('Assigned Patients'), findsOneWidget);

    // Doctor SEES clinical sections
    expect(find.text('Clinical Consultations & EHR'), findsOneWidget);
    expect(find.text('Diagnostic Lab & Imaging Orders'), findsOneWidget);
    expect(find.text('Prescriptions & e-Rx'), findsOneWidget);

    // Doctor DOES NOT SEE non-belonging sections
    expect(find.text('Hospital Settings & Staff Roster'), findsNothing);
    expect(find.text('Billing, Invoicing & Insurance'), findsNothing);
    expect(find.text('Inpatient Wards & Bed Allocation'), findsNothing);
  });

  testWidgets('Nurse Login shows only Nurse sections and hides non-belonging sections',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    // Auto-fill nurse
    await tester.tap(find.text('Nurse (Ward/Vitals)'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Welcome back, nurse!'), findsOneWidget);
    expect(find.text('Ward Care & Vitals Charting Access'), findsOneWidget);
    expect(find.text('Vitals Checks Due'), findsOneWidget);

    // Nurse SEES ward & care sections
    expect(find.text('Inpatient Wards & Bed Allocation'), findsOneWidget);
    expect(find.text('Patient Vitals & Nurse Charting'), findsOneWidget);

    // Nurse DOES NOT SEE doctor/admin sections
    expect(find.text('Clinical Consultations & EHR'), findsNothing);
    expect(find.text('Diagnostic Lab & Imaging Orders'), findsNothing);
    expect(find.text('Billing, Invoicing & Insurance'), findsNothing);
    expect(find.text('Hospital Settings & Staff Roster'), findsNothing);
  });

  testWidgets('Receptionist Login shows only Front Desk sections and hides clinical/admin sections',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    // Auto-fill receptionist via demo chip
    await tester.ensureVisible(find.text('Reception (OPD)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reception (OPD)'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Welcome back, reception!'), findsOneWidget);

    // Receptionist SEES front desk sections
    expect(find.text('Patient Directory & Demographics'), findsOneWidget);
    expect(find.text('Appointments & OPD Scheduling'), findsOneWidget);
    expect(find.text('Billing, Invoicing & Insurance'), findsOneWidget);

    // Receptionist DOES NOT SEE clinical, nurse or admin sections
    expect(find.text('Clinical Consultations & EHR'), findsNothing);
    expect(find.text('Diagnostic Lab & Imaging Orders'), findsNothing);
    expect(find.text('Inpatient Wards & Bed Allocation'), findsNothing);
    expect(find.text('Hospital Settings & Staff Roster'), findsNothing);
  });
}
