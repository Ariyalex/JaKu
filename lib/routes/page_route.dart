import 'package:get/get.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/screens/add_matkul.dart';
import 'package:jaku/screens/auth_screen/recovery_pass.dart';
import 'package:jaku/screens/auth_screen/sign_in_screen.dart';
import 'package:jaku/screens/auth_screen/sign_up_screen.dart';
import 'package:jaku/screens/detail_matkul.dart';
import 'package:jaku/screens/guide/guide_general.dart';
import 'package:jaku/screens/guide/guide_pdf.dart';
import 'package:jaku/screens/home_screen.dart';
import 'package:jaku/screens/pdf_parsing.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteNamed.homePage,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: RouteNamed.addMatkul,
      page: () => const AddMatkul(),
    ),
    GetPage(
      name: RouteNamed.editMatkul,
      page: () => const DetailMatkul(),
    ),
    GetPage(
      name: RouteNamed.signInScreen,
      page: () => const SignIn(),
    ),
    GetPage(
      name: RouteNamed.signUpScreen,
      page: () => const SignUp(),
    ),
    GetPage(
      name: RouteNamed.recoveryPass,
      page: () => const RecoveryPass(),
    ),
    GetPage(
      name: RouteNamed.pdfParsing,
      page: () => const PdfParsing(),
    ),
    GetPage(
      name: RouteNamed.guidePdf,
      page: () => const GuidePdf(),
    ),
    GetPage(
      name: RouteNamed.guideGeneral,
      page: () => const GuideGeneral(),
    ),
  ];
}
