import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const CropGuideApp());

const forest = Color(0xFF174B35);
const leaf = Color(0xFF3C8058);
const canvas = Color(0xFFF6F7F1);
const ink = Color(0xFF1C2B22);
const muted = Color(0xFF6B786F);

class CropGuideApp extends StatelessWidget {
  const CropGuideApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CropCare Guide',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: forest, primary: forest, surface: canvas),
      scaffoldBackgroundColor: canvas,
      appBarTheme: const AppBarTheme(backgroundColor: canvas, foregroundColor: ink, elevation: 0),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ink, height: 1.12),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ink),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
        bodyLarge: TextStyle(fontSize: 15, color: ink, height: 1.45),
        bodyMedium: TextStyle(fontSize: 13, color: muted, height: 1.4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE4E9E1))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: leaf, width: 1.5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        backgroundColor: forest, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      )),
    ),
    home: const OnboardingScreen(),
  );
}

class Disease {
  final String name, crop, category, symptoms, treatment, tag;
  final Color tint;
  final IconData icon;
  const Disease(this.name, this.crop, this.category, this.symptoms, this.treatment, this.tag, this.tint, this.icon);
}

final List<Disease> diseases = [
  const Disease('Rice blast', 'Rice', 'Fungal disease', 'Diamond-shaped grey lesions with brown edges on leaves. Severe cases may affect stems and panicles.', 'Use clean seed, avoid excess nitrogen, and follow local agricultural guidance for suitable control.', 'Common', Color(0xFFE8F0D7), Icons.grass_rounded),
  const Disease('Tomato leaf spot', 'Tomato', 'Fungal disease', 'Small dark spots with yellow halos, often appearing on older leaves first.', 'Remove badly affected leaves, keep foliage dry, and rotate crops where possible.', 'Watch for', Color(0xFFF4E8D8), Icons.eco_rounded),
  const Disease('Corn rust', 'Maize', 'Fungal disease', 'Raised orange-brown pustules scattered across the leaf surface.', 'Monitor nearby plants and ask a local extension officer about resistant varieties.', 'Seasonal', Color(0xFFF0E6C8), Icons.spa_rounded),
  const Disease('Powdery mildew', 'Cucumber', 'Fungal disease', 'White powder-like patches on leaves that may spread over time.', 'Improve spacing and airflow; remove heavily affected plant material safely.', 'Common', Color(0xFFE2EEE8), Icons.grain_rounded),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override State<OnboardingScreen> createState() => _OnboardingScreenState();
}
class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController(); int page = 0;
  final items = const [
    ('Know what to look for', 'Learn common crop symptoms with clear, practical guide cards.', Icons.spa_rounded, Color(0xFFE6EFDC)),
    ('Explore crop guides', 'Browse simple information for rice, tomato, maize and more.', Icons.menu_book_rounded, Color(0xFFF2E9D8)),
    ('Start with a photo', 'Choose a crop image to begin a guided observation. This prototype does not diagnose.', Icons.add_a_photo_rounded, Color(0xFFDDECE4)),
  ];
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Column(children: [
    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('Skip'))),
    Expanded(child: PageView.builder(controller: controller, itemCount: items.length, onPageChanged: (i) => setState(() => page = i), itemBuilder: (_, i) {
      final item = items[i];
      return Padding(padding: const EdgeInsets.fromLTRB(28, 18, 28, 22), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(height: 260, width: 260, decoration: BoxDecoration(color: item.$4, borderRadius: BorderRadius.circular(90)), child: Icon(item.$3, size: 112, color: forest)),
        const SizedBox(height: 38), Text(item.$1, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 14), Text(item.$2, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: muted)),
      ]));
    })),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.all(4), width: page == i ? 24 : 8, height: 8, decoration: BoxDecoration(color: page == i ? forest : const Color(0xFFD5DDD4), borderRadius: BorderRadius.circular(9))))),
    Padding(padding: const EdgeInsets.fromLTRB(24, 20, 24, 24), child: ElevatedButton(onPressed: () { if (page < 2) { controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut); } else { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); } }, child: Text(page == 2 ? 'Get started' : 'Continue'))),
  ])));
}

class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(key: formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const BrandMark(), const SizedBox(height: 32), Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 8), const Text('Sign in to continue to your crop guides.'), const SizedBox(height: 28),
    const _Label('Email address'), const SizedBox(height: 8), TextFormField(keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'you@example.com', prefixIcon: Icon(Icons.mail_outline)), validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email address' : null), const SizedBox(height: 16),
    const _Label('Password'), const SizedBox(height: 8), TextFormField(obscureText: true, decoration: const InputDecoration(hintText: 'Enter your password', prefixIcon: Icon(Icons.lock_outline)), validator: (v) => (v == null || v.isEmpty) ? 'Enter your password' : null), const SizedBox(height: 24),
    ElevatedButton(onPressed: () { if (formKey.currentState!.validate()) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell())); }, child: const Text('Log in')),
    const SizedBox(height: 12), Center(child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('New here? Create an account'))),
    Center(child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell())), child: const Text('Explore as a guest')),
  )]))))));
}

class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key}); @override State<RegisterScreen> createState() => _RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen> {
  final keyForm = GlobalKey<FormState>();
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Create account')), body: SafeArea(child: Form(key: keyForm, child: ListView(padding: const EdgeInsets.all(24), children: [
    Text('Join CropCare', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 8), const Text('Save your favourite crop guides in one place.'), const SizedBox(height: 24),
    const _Label('Full name'), const SizedBox(height: 8), TextFormField(decoration: const InputDecoration(hintText: 'Your name'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null), const SizedBox(height: 16),
    const _Label('Email address'), const SizedBox(height: 8), TextFormField(keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'you@example.com'), validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email address' : null), const SizedBox(height: 16),
    const _Label('Password'), const SizedBox(height: 8), TextFormField(obscureText: true, decoration: const InputDecoration(hintText: 'At least 6 characters'), validator: (v) => (v == null || v.length < 6) ? 'Use at least 6 characters' : null), const SizedBox(height: 24),
    ElevatedButton(onPressed: () { if (keyForm.currentState!.validate()) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell())); }, child: const Text('Create account')),
  ]))));
}

class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState() => _MainShellState(); }
class _MainShellState extends State<MainShell> {
  int index = 0;
  @override Widget build(BuildContext context) {
    final screens = [DashboardScreen(onNavigate: (i) => setState(() => index = i)), const GuideListScreen(), const PhotoReviewScreen()];
    return Scaffold(body: IndexedStack(index: index, children: screens), bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (i) => setState(() => index = i), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book_rounded), label: 'Guides'),
      NavigationDestination(icon: Icon(Icons.camera_alt_outlined), selectedIcon: Icon(Icons.camera_alt_rounded), label: 'Photo'),
    ]));
  }
}

class DashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate; const DashboardScreen({super.key, required this.onNavigate});
  @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 24), children: [
    Row(children: [const BrandMark(compact: true), const Spacer(), IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded))]),
    const SizedBox(height: 20), Text('Good morning, farmer', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 6), const Text('A little knowledge helps every field thrive.'),
    const SizedBox(height: 22), Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [forest, Color(0xFF357350)]), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: forest.withValues(alpha: .14), blurRadius: 18, offset: const Offset(0, 8))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('FIELD NOTE  •  TODAY', style: TextStyle(color: Color(0xFFD2E5D6), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)), const SizedBox(height: 14), const Text('Spot changes early.', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('Check both sides of leaves for new spots or colour changes.', style: TextStyle(color: Colors.white70, height: 1.45)), const SizedBox(height: 16), InkWell(onTap: () => onNavigate(2), borderRadius: BorderRadius.circular(14), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.camera_alt_outlined, color: forest, size: 18), SizedBox(width: 8), Text('Review a crop photo', style: TextStyle(color: forest, fontWeight: FontWeight.w700))]))),
    ])),
    const SizedBox(height: 26), _SectionTitle('Explore by crop', action: 'See all', onTap: () => onNavigate(1)), const SizedBox(height: 12),
    SizedBox(height: 102, child: ListView(scrollDirection: Axis.horizontal, children: const [CropChip('Rice', '🌾', Color(0xFFE9F0DC)), CropChip('Tomato', '🍅', Color(0xFFF6E8DF)), CropChip('Maize', '🌽', Color(0xFFF4EBCF)), CropChip('Cucumber', '🥒', Color(0xFFE0EEE6))])),
    const SizedBox(height: 25), _SectionTitle('Popular guides', action: 'View all', onTap: () => onNavigate(1)), const SizedBox(height: 12),
    ...diseases.take(2).map((d) => DiseaseTile(disease: d, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseDetailScreen(disease: d))))),
  ]));
}

class GuideListScreen extends StatefulWidget { const GuideListScreen({super.key}); @override State<GuideListScreen> createState() => _GuideListScreenState(); }
class _GuideListScreenState extends State<GuideListScreen> {
  String query = '';
  @override Widget build(BuildContext context) {
    final filtered = diseases.where((d) => '${d.name} ${d.crop}'.toLowerCase().contains(query.toLowerCase())).toList();
    return SafeArea(child: Column(children: [Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Crop guides', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 6), const Text('Browse common symptoms and practical next steps.'), const SizedBox(height: 16), TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(hintText: 'Search crop or disease', prefixIcon: Icon(Icons.search_rounded))) ])),
      Expanded(child: ListView.builder(padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), itemCount: filtered.length, itemBuilder: (context, i) => DiseaseTile(disease: filtered[i], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseDetailScreen(disease: filtered[i])))))),
      Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 14), child: OutlinedButton.icon(onPressed: () async { final saved = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => const AddGuideScreen())); if (saved == true && mounted) setState(() {}); }, icon: const Icon(Icons.add), label: const Text('Add a guide entry')),
    )]));
  }
}

class DiseaseDetailScreen extends StatelessWidget {
  final Disease disease; const DiseaseDetailScreen({super.key, required this.disease});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Guide details'), actions: [IconButton(tooltip: 'Edit guide', icon: const Icon(Icons.edit_outlined), onPressed: () async { final saved = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => AddGuideScreen(existing: disease))); if (saved == true && context.mounted) Navigator.pop(context); })]), body: ListView(padding: const EdgeInsets.all(20), children: [
    Container(height: 190, decoration: BoxDecoration(color: disease.tint, borderRadius: BorderRadius.circular(28)), child: Icon(disease.icon, size: 92, color: forest)), const SizedBox(height: 20),
    Text(disease.crop.toUpperCase(), style: const TextStyle(color: leaf, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.1)), const SizedBox(height: 8), Text(disease.name, style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 8), Text(disease.category, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 24),
    _InfoBlock(title: 'What to look for', text: disease.symptoms, icon: Icons.visibility_outlined), const SizedBox(height: 12), _InfoBlock(title: 'Practical next steps', text: disease.treatment, icon: Icons.lightbulb_outline_rounded), const SizedBox(height: 14),
    Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF4D9), borderRadius: BorderRadius.circular(16)), child: const Text('Information is educational. Confirm suspected disease with a local agriculture expert before treatment.', style: TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF725821)))),
  ]));
}

class PhotoReviewScreen extends StatefulWidget { const PhotoReviewScreen({super.key}); @override State<PhotoReviewScreen> createState() => _PhotoReviewScreenState(); }
class _PhotoReviewScreenState extends State<PhotoReviewScreen> {
  final picker = ImagePicker(); XFile? selected;
  Future<void> choose(ImageSource source) async { final image = await picker.pickImage(source: source, imageQuality: 85); if (image != null && mounted) setState(() => selected = image); }
  @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 24), children: [
    Text('Photo review', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 6), const Text('Add a clear crop photo to begin observing symptoms.'), const SizedBox(height: 22),
    Container(height: 290, decoration: BoxDecoration(color: const Color(0xFFE8EFE5), borderRadius: BorderRadius.circular(26), border: Border.all(color: const Color(0xFFD7E2D5))), clipBehavior: Clip.antiAlias, child: selected == null ? Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.add_a_photo_outlined, size: 58, color: leaf), SizedBox(height: 14), Text('Your crop photo will appear here', style: TextStyle(fontWeight: FontWeight.w700, color: forest)), SizedBox(height: 5), Text('Choose camera or image gallery', style: TextStyle(color: muted, fontSize: 12))]) : Image.file(File(selected!.path), fit: BoxFit.cover)),
    const SizedBox(height: 16), Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () => choose(ImageSource.camera), icon: const Icon(Icons.camera_alt_outlined), label: const Text('Camera'))), const SizedBox(width: 10), Expanded(child: OutlinedButton.icon(onPressed: () => choose(ImageSource.gallery), icon: const Icon(Icons.photo_library_outlined), label: const Text('Gallery')))]),
    const SizedBox(height: 20), Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Photo tips', style: TextStyle(fontWeight: FontWeight.w800, color: ink)), SizedBox(height: 8), Text('• Use natural light\n• Keep the affected leaf in focus\n• Include one leaf at a time', style: TextStyle(height: 1.6, color: muted))])),
    const SizedBox(height: 14), const Text('This prototype does not identify disease automatically. Use the guide library and consult an agriculture officer.', style: TextStyle(fontSize: 12, color: muted, height: 1.4)),
  ]));
}

class AddGuideScreen extends StatefulWidget { final Disease? existing; const AddGuideScreen({super.key, this.existing}); @override State<AddGuideScreen> createState() => _AddGuideScreenState(); }
class _AddGuideScreenState extends State<AddGuideScreen> {
  final formKey = GlobalKey<FormState>(); late final TextEditingController name; late final TextEditingController crop; late final TextEditingController symptoms; late final TextEditingController treatment;
  @override void initState() { super.initState(); final d = widget.existing; name = TextEditingController(text: d?.name ?? ''); crop = TextEditingController(text: d?.crop ?? ''); symptoms = TextEditingController(text: d?.symptoms ?? ''); treatment = TextEditingController(text: d?.treatment ?? ''); }
  @override void dispose() { name.dispose(); crop.dispose(); symptoms.dispose(); treatment.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(widget.existing == null ? 'Add guide entry' : 'Edit guide entry')), body: Form(key: formKey, child: ListView(padding: const EdgeInsets.all(20), children: [
    Text(widget.existing == null ? 'Create a guide' : 'Edit this guide', style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800, color: ink)), const SizedBox(height: 6), const Text('Add a crop disease note to your local prototype.'), const SizedBox(height: 22),
    const _Label('Disease name'), const SizedBox(height: 7), TextFormField(controller: name, decoration: const InputDecoration(hintText: 'e.g. Leaf blight'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a disease name' : null), const SizedBox(height: 16),
    const _Label('Crop'), const SizedBox(height: 7), TextFormField(controller: crop, decoration: const InputDecoration(hintText: 'e.g. Rice'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a crop name' : null), const SizedBox(height: 16),
    const _Label('Symptoms'), const SizedBox(height: 7), TextFormField(controller: symptoms, maxLines: 3, decoration: const InputDecoration(hintText: 'Describe visible symptoms'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Add symptom details' : null), const SizedBox(height: 16),
    const _Label('Suggested next steps'), const SizedBox(height: 7), TextFormField(controller: treatment, maxLines: 3, decoration: const InputDecoration(hintText: 'Add safe, practical guidance'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Add next steps' : null), const SizedBox(height: 24),
    ElevatedButton(onPressed: () { if (formKey.currentState!.validate()) { final old = widget.existing; final item = Disease(name.text.trim(), crop.text.trim(), old?.category ?? 'Guide entry', symptoms.text.trim(), treatment.text.trim(), old?.tag ?? 'New', old?.tint ?? const Color(0xFFE2EEE8), old?.icon ?? Icons.eco_rounded); if (old == null) { diseases.add(item); } else { final index = diseases.indexOf(old); if (index >= 0) diseases[index] = item; } ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guide entry saved for this session.'))); Navigator.pop(context, true); } }, child: Text(widget.existing == null ? 'Save guide' : 'Save changes')),
  ])));
}

class BrandMark extends StatelessWidget { final bool compact; const BrandMark({super.key, this.compact = false});
  @override Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [Container(width: compact ? 40 : 48, height: compact ? 40 : 48, decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.eco_rounded, color: Colors.white)), const SizedBox(width: 10), Text(compact ? 'CropCare' : 'CropCare Guide', style: TextStyle(fontWeight: FontWeight.w800, color: forest, fontSize: compact ? 17 : 20))]);
}
class _Label extends StatelessWidget { final String text; const _Label(this.text); @override Widget build(BuildContext context) => Text(text, style: const TextStyle(color: ink, fontWeight: FontWeight.w700, fontSize: 13)); }
class _SectionTitle extends StatelessWidget { final String title, action; final VoidCallback onTap; const _SectionTitle(this.title, {required this.action, required this.onTap}); @override Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)), InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10), child: Padding(padding: const EdgeInsets.all(6), child: Text(action, style: const TextStyle(color: leaf, fontWeight: FontWeight.w700))))]); }
class CropChip extends StatelessWidget { final String name, emoji; final Color tint; const CropChip(this.name, this.emoji, this.tint); @override Widget build(BuildContext context) => Container(width: 92, margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(emoji, style: const TextStyle(fontSize: 22)), const SizedBox(height: 5), Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ink))])); }
class DiseaseTile extends StatelessWidget { final Disease disease; final VoidCallback onTap; const DiseaseTile({super.key, required this.disease, required this.onTap}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE7ECE5)), boxShadow: [BoxShadow(color: ink.withValues(alpha: .03), blurRadius: 10, offset: const Offset(0, 4))]), child: Row(children: [Container(width: 58, height: 58, decoration: BoxDecoration(color: disease.tint, borderRadius: BorderRadius.circular(16)), child: Icon(disease.icon, color: forest, size: 28)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(disease.name, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 15)), const SizedBox(height: 4), Text('${disease.crop}  •  ${disease.category}', style: const TextStyle(color: muted, fontSize: 11)), const SizedBox(height: 7), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEDF4E9), borderRadius: BorderRadius.circular(8)), child: Text(disease.tag, style: const TextStyle(color: forest, fontSize: 10, fontWeight: FontWeight.w700)))])), const Icon(Icons.chevron_right_rounded, color: muted)]))); }
class _InfoBlock extends StatelessWidget { final String title, text; final IconData icon; const _InfoBlock({required this.title, required this.text, required this.icon}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: leaf), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)), const SizedBox(height: 7), Text(text, style: const TextStyle(color: muted, height: 1.45))]))])); }
