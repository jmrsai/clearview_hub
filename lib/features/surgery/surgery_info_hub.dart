/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/gemini_service.dart';
import '../ai_assistant/gemini_chat_screen.dart';

class SurgeryInfoHub extends StatefulWidget {
  const SurgeryInfoHub({super.key});
  @override
  State<SurgeryInfoHub> createState() => _SurgeryInfoHubState();
}

class _SurgeryInfoHubState extends State<SurgeryInfoHub> with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _searchQuery = '';

  static const List<SurgeryProcedure> _procedures = [
    SurgeryProcedure(name: 'LASIK', icon: '👁️', category: 'Refractive', color: Color(0xFF0EA5E9)),
    SurgeryProcedure(name: 'Cataract Surgery', icon: '🔬', category: 'Lens', color: Color(0xFF8B5CF6)),
    SurgeryProcedure(name: 'Glaucoma Surgery', icon: '💧', category: 'Pressure', color: Color(0xFF10B981)),
    SurgeryProcedure(name: 'Retinal Detachment Repair', icon: '🕸️', category: 'Retina', color: Color(0xFFF59E0B)),
    SurgeryProcedure(name: 'Vitrectomy', icon: '🧬', category: 'Vitreous', color: Color(0xFFEF4444)),
    SurgeryProcedure(name: 'Corneal Transplant', icon: '🏆', category: 'Cornea', color: Color(0xFF6366F1)),
    SurgeryProcedure(name: 'Strabismus Surgery', icon: '🎯', category: 'Muscles', color: Color(0xFFEC4899)),
    SurgeryProcedure(name: 'Pterygium Excision', icon: '🌿', category: 'Conjunctiva', color: Color(0xFF14B8A6)),
    SurgeryProcedure(name: 'Dacryocystorhinostomy (DCR)', icon: '💦', category: 'Lacrimal', color: Color(0xFF3B82F6)),
    SurgeryProcedure(name: 'SMILE Surgery', icon: '✨', category: 'Refractive', color: Color(0xFFD946EF)),
    SurgeryProcedure(name: 'PRK Surgery', icon: '💡', category: 'Refractive', color: Color(0xFF22C55E)),
    SurgeryProcedure(name: 'Oculoplasty', icon: '🔧', category: 'Reconstructive', color: Color(0xFFF97316)),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    GeminiService.instance.initialize();
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  List<SurgeryProcedure> get _filtered => _searchQuery.isEmpty
      ? _procedures
      : _procedures.where((p) =>
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('Eye Surgery Guide', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.cyan,
          labelColor: AppColors.cyan,
          unselectedLabelColor: AppColors.textHint,
          tabs: const [
            Tab(text: 'Pre-Operative'),
            Tab(text: 'Post-Operative'),
          ],
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search procedures...',
              hintStyle: TextStyle(color: AppColors.textHint),
              prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
              filled: true,
              fillColor: const Color(0xFF1E2235),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _ProcedureGrid(procedures: _filtered, isPreOp: true),
              _ProcedureGrid(procedures: _filtered, isPreOp: false),
            ],
          ),
        ),
      ]),
    );
  }
}

class _ProcedureGrid extends StatelessWidget {
  final List<SurgeryProcedure> procedures;
  final bool isPreOp;
  const _ProcedureGrid({required this.procedures, required this.isPreOp});

  @override
  Widget build(BuildContext context) {
    if (procedures.isEmpty) {
      return Center(child: Text('No procedures found', style: TextStyle(color: AppColors.textSecondary)));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2,
      ),
      itemCount: procedures.length,
      itemBuilder: (_, i) {
        final p = procedures[i];
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => SurgeryDetailScreen(procedure: p, isPreOp: isPreOp),
            ));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2235),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.color.withAlpha(60)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.icon, style: const TextStyle(fontSize: 28)),
              const Spacer(),
              Text(p.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: p.color.withAlpha(30), borderRadius: BorderRadius.circular(6)),
                child: Text(p.category, style: TextStyle(color: p.color, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class SurgeryDetailScreen extends StatefulWidget {
  final SurgeryProcedure procedure;
  final bool isPreOp;
  const SurgeryDetailScreen({super.key, required this.procedure, required this.isPreOp});
  @override
  State<SurgeryDetailScreen> createState() => _SurgeryDetailScreenState();
}

class _SurgeryDetailScreenState extends State<SurgeryDetailScreen> {
  String? _content;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final content = widget.isPreOp
          ? await GeminiService.instance.getPreOpInfo(widget.procedure.name)
          : await GeminiService.instance.getPostOpInfo(widget.procedure.name);
      if (mounted) setState(() { _content = content; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.procedure.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          Text(widget.isPreOp ? 'Pre-Operative Guide' : 'Post-Operative Guide',
              style: TextStyle(color: widget.procedure.color, fontSize: 12)),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat, color: AppColors.cyan),
            tooltip: 'Ask AI',
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => GeminiChatScreen(
                initialPrompt: 'Tell me more about ${widget.procedure.name} eye surgery',
              ),
            )),
          ),
        ],
      ),
      body: _loading
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircularProgressIndicator(color: widget.procedure.color),
              const SizedBox(height: 16),
              Text('Generating ${widget.isPreOp ? "pre-op" : "post-op"} guide...',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              const Text('Powered by Gemini AI', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            ]))
          : _error != null
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to load content', style: TextStyle(color: AppColors.error)),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () { setState(() => _loading = true); _loadContent(); }, child: const Text('Retry')),
                ]))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Header card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [widget.procedure.color.withAlpha(40), const Color(0xFF1E2235)]),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: widget.procedure.color.withAlpha(60)),
                      ),
                      child: Row(children: [
                        Text(widget.procedure.icon, style: const TextStyle(fontSize: 40)),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(widget.procedure.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(widget.isPreOp ? '📋 Pre-Operative Information' : '🏥 Post-Operative Recovery',
                              style: TextStyle(color: widget.procedure.color, fontSize: 13)),
                        ])),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    // AI-generated content
                    Text(_content ?? '', style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.7)),
                    const SizedBox(height: 32),
                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warning.withAlpha(60)),
                      ),
                      child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.info_outline, color: AppColors.warning, size: 18),
                        SizedBox(width: 10),
                        Expanded(child: Text(
                          'This information is AI-generated for educational purposes. Always follow your surgeon\'s specific instructions and consult your ophthalmologist before making any decisions.',
                          style: TextStyle(color: AppColors.warning, fontSize: 12, height: 1.5),
                        )),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => GeminiChatScreen(
                          initialPrompt: 'I have questions about my ${widget.procedure.name} surgery',
                        ),
                      )),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Ask AI for More Details'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                    ),
                  ]),
                ),
    );
  }
}

class SurgeryProcedure {
  final String name;
  final String icon;
  final String category;
  final Color color;
  const SurgeryProcedure({required this.name, required this.icon, required this.category, required this.color});
}
