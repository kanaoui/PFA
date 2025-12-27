import 'package:flutter/material.dart';
import '../services/auth_service.dart';
// import '../widgets/local_profile_picture_widget.dart'; // Commented out for mobile
import 'welcome_screen.dart';
import 'voice_assistant_screen.dart';
import 'cnn_screen.dart';
import 'ann_screen.dart';
import 'lstm_screen.dart';
import 'rag_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final authService = AuthService();
  bool _isModelsExpanded = false;
  bool _isSidebarVisible = false;
  late AnimationController _animationController;

  final List<AIModel> _models = [
    AIModel(
      name: 'ANN Model',
      description: 'Artificial Neural Network',
      icon: Icons.hub_rounded,
      gradient: const [Color(0xFF22C55E), Color(0xFF16A34A)],
    ),
    AIModel(
      name: 'CNN Model',
      description: 'Convolutional Neural Network',
      icon: Icons.image_outlined,
      gradient: const [Color(0xFF16A34A), Color(0xFF15803D)],
    ),
    AIModel(
      name: 'Stock Prediction',
      description: 'Market Forecasting AI',
      icon: Icons.show_chart_rounded,
      gradient: const [Color(0xFF22C55E), Color(0xFF10B981)],
    ),
    AIModel(
      name: 'RAG Model',
      description: 'Retrieval-Augmented Generation',
      icon: Icons.auto_awesome_rounded,
      gradient: const [Color(0xFF10B981), Color(0xFF22C55E)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF8E7), Color(0xFFE8F5E9)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // Menu Button
                        IconButton(
                          onPressed: _toggleSidebar,
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF22C55E,
                                  ).withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'AgroSense',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isMobile ? 20 : 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main Welcome Header
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                            ).createShader(bounds),
                            child: Text(
                              'Discover AgroSense',
                              style: TextStyle(
                                fontSize: isMobile ? 32 : 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            'Intelligent Solutions Hub',
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 24,
                              color: const Color(0xFF15803D),
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Feature Cards
                          Container(
                            padding: EdgeInsets.all(isMobile ? 20 : 32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFF22C55E).withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF22C55E).withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF22C55E),
                                            Color(0xFF16A34A),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.rocket_launch_rounded,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        'Explore Capabilities',
                                        style: TextStyle(
                                          fontSize: isMobile ? 22 : 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF15803D),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 32),

                                _buildFeatureItem(
                                  icon: Icons.hub_rounded,
                                  title: 'Smart Neural Processing',
                                  description:
                                      'Harness intelligent ANN architectures for sophisticated pattern detection and comprehensive data insights',
                                  gradient: const [
                                    Color(0xFF22C55E),
                                    Color(0xFF16A34A),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                _buildFeatureItem(
                                  icon: Icons.image_outlined,
                                  title: 'Visual Intelligence Engine',
                                  description:
                                      'Transform visual data through cutting-edge convolutional networks for precise image understanding',
                                  gradient: const [
                                    Color(0xFF16A34A),
                                    Color(0xFF15803D),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                _buildFeatureItem(
                                  icon: Icons.show_chart_rounded,
                                  title: 'Predictive Analytics',
                                  description:
                                      'Unlock future trends with precision forecasting driven by sophisticated machine learning models',
                                  gradient: const [
                                    Color(0xFF22C55E),
                                    Color(0xFF10B981),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                _buildFeatureItem(
                                  icon: Icons.auto_awesome_rounded,
                                  title: 'Adaptive Intelligence',
                                  description:
                                      'Engage with contextually aware responses powered by our advanced knowledge retrieval system',
                                  gradient: const [
                                    Color(0xFF10B981),
                                    Color(0xFF22C55E),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                _buildFeatureItem(
                                  icon: Icons.mic_rounded,
                                  title: 'Conversational Interface',
                                  description:
                                      'Interact seamlessly through natural dialogue enabled by our next-generation voice technology',
                                  gradient: const [
                                    Color(0xFF16A34A),
                                    Color(0xFF22C55E),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Quick Stats
                          isMobile
                              ? Column(
                                  children: [
                                    _buildStatCard(
                                      '4',
                                      'Smart Engines',
                                      Icons.psychology_rounded,
                                      const [
                                        Color(0xFF22C55E),
                                        Color(0xFF16A34A),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildStatCard(
                                      'Always On',
                                      'Continuous Access',
                                      Icons.access_time_rounded,
                                      const [
                                        Color(0xFF16A34A),
                                        Color(0xFF15803D),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildStatCard(
                                      '∞',
                                      'Endless Potential',
                                      Icons.all_inclusive_rounded,
                                      const [
                                        Color(0xFF10B981),
                                        Color(0xFF22C55E),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        '4',
                                        'Smart Engines',
                                        Icons.psychology_rounded,
                                        const [
                                          Color(0xFF22C55E),
                                          Color(0xFF16A34A),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildStatCard(
                                        'Always On',
                                        'Continuous Access',
                                        Icons.access_time_rounded,
                                        const [
                                          Color(0xFF16A34A),
                                          Color(0xFF15803D),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildStatCard(
                                        '∞',
                                        'Endless Potential',
                                        Icons.all_inclusive_rounded,
                                        const [
                                          Color(0xFF10B981),
                                          Color(0xFF22C55E),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sidebar Overlay
          if (_isSidebarVisible)
            GestureDetector(
              onTap: _toggleSidebar,
              child: Container(color: const Color(0xFF22C55E).withOpacity(0.2)),
            ),

          // Sidebar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isSidebarVisible ? 0 : (isMobile ? -280 : -300),
            top: 0,
            bottom: 0,
            child: Container(
              width: isMobile ? 280 : 300,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF8E7), Color(0xFFE8F5E9)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(4, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Profile Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Profile Picture (temporary placeholder)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF22C55E,
                                  ).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Welcome text
                          const Text(
                            'Welcome',
                            style: TextStyle(
                              color: Color(0xFF16A34A),
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Username
                          Text(
                            user?.email?.split('@')[0] ?? 'User',
                            style: const TextStyle(
                              color: Color(0xFF15803D),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),

                          // Email
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              color: Color(0xFF16A34A),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFF22C55E).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // AI Models Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // AI Models Button
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isModelsExpanded = !_isModelsExpanded;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF22C55E).withOpacity(0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF22C55E).withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF22C55E),
                                          Color(0xFF16A34A),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.psychology_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'AI Models',
                                      style: TextStyle(
                                        color: Color(0xFF15803D),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  AnimatedRotation(
                                    turns: _isModelsExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Expandable Models List
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: _isModelsExpanded
                                ? Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      ..._models.map(
                                        (model) => _buildModelItem(model),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Voice Assistant Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () {
                          _toggleSidebar();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const VoiceAssistantScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE11D48), Color(0xFFE11D48)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE11D48).withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.mic_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Voice Assistant',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        onTap: () async {
                          await authService.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFEF4444).withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelItem(AIModel model) {
    // Map model names to their screens
    Widget? screen;
    if (model.name == 'CNN Model') {
      screen = const CNNScreen();
    } else if (model.name == 'ANN Model') {
      screen = const ANNScreen();
    } else if (model.name == 'Stock Prediction') {
      screen = const LSTMScreen();
    } else if (model.name == 'RAG Model') {
      screen = const RAGScreen();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: () {
          if (screen != null) {
            _toggleSidebar();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen!),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${model.name} coming soon!'),
                backgroundColor: model.gradient[0],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF22C55E).withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(model.icon, color: model.gradient[0], size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: const TextStyle(
                        color: Color(0xFF15803D),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      model.description,
                      style: const TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF15803D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF16A34A),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    List<Color> gradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class AIModel {
  final String name;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  AIModel({
    required this.name,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
