import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit() : super(const ChatbotInitial());

  final List<ChatMessage> _messages = [];

  void initialize() {
    _loadMockMessages();
    emit(ChatbotLoaded(messages: _messages));
  }

  void _loadMockMessages() {
    _messages.addAll([
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Hello, my name is fathia',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text:
            'Hello Fathia, it\'s a pleasure to meet you. How can I assist you with your research today?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 19)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text: 'tell me what is the trends in research world',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text:
            'Fathia, the research world is currently experiencing dynamic shifts, driven by technological advancements, evolving societal needs, and a growing emphasis on interdisciplinary approaches. Based on recent analyses, several key trends and emerging research areas are prominent:\n\n1.  **Artificial Intelligence (AI) and Machine Learning (ML):** This continues to be a foundational and rapidly expanding field. AI and ML are not only areas of research in themselves but are also increasingly integrated into other disciplines, transforming methodologies and opening new avenues for inquiry. This includes advancements in deep learning, natural language processing, computer vision, and reinforcement learning, with applications spanning nearly every sector.\n\n2.  **Cybersecurity and Data Privacy:** With the increasing digitalization of society and the proliferation of data, research in cybersecurity and data privacy is critical. This trend encompasses developing robust security protocols, understanding and mitigating cyber threats, ensuring ethical data handling, and exploring privacy-preserving technologies.\n\n3.  **Healthcare and Medicine:** This field is undergoing significant transformation, particularly with the integration of AI. Research is focusing on personalized medicine, advanced diagnostics, drug discovery, and innovative treatment modalities. There\'s also a growing emphasis on mental health and emotional well-being, reflecting a holistic approach to global health challenges.\n\n4.  **Sustainable Development and Environmental Science:** Addressing global challenges such as climate change, resource depletion, and biodiversity loss is a major research imperative. This trend includes research into renewable energy, sustainable agriculture, circular economy models, environmental policy, and climate modeling.\n\nThese trends often intersect, leading to interdisciplinary research that tackles complex problems from multiple perspectives. For instance, AI is being applied to accelerate drug discovery in healthcare, and data analytics is crucial for understanding environmental patterns in sustainable development.\n\nResearchers are encouraged to identify knowledge gaps within these trending areas to contribute impactful and relevant work.',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 17)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text: 'i want to start in quantum computing field what should i do?',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text:
            'What is your research level? (Undergraduate, Master\'s Student, PhD Researcher, Professor)\nHow much time do you want to dedicate to this roadmap?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text: 'i am a master student and i have 3 weeks.',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text:
            'Hello Fathia, thank you for the valuable feedback. You are absolutely right, providing the exact original publication details and a direct link to seminal papers is crucial for a Master\'s level research roadmap. My apologies for the oversight regarding Feynman\'s paper. I have corrected the citation for "Simulating Physics with Computers" to ensure you have direct access to the original work.\n\nHere is the revised "Narrative Research Roadmap" for Quantum Computing:\n\n---\n\n### **Narrative Research Roadmap: Quantum Computing (3 Weeks)**\n\n**Introduction: The Quantum Leap in Computation**\n\nFor centuries, computation has been rooted in classical physics, where information is stored and processed as bits representing either 0 or 1. However, as our understanding of the universe deepened, particularly with the advent of quantum mechanics, scientists began to ponder if computation itself could harness these peculiar quantum phenomena. This roadmap will trace the journey from a theoretical musing to the development of powerful algorithms and the ongoing quest for fault-tolerant quantum computers.\n\n---\n\n### **Phase 1: The Genesis – Simulating Physics with Quantum Systems (Week 1)**\n\nThe idea of quantum computing didn\'t emerge from a desire to build faster classical computers, but rather from a fundamental challenge in physics itself: simulating quantum systems. Classical computers struggle immensely with this task due to the exponential growth of complexity with the number of quantum particles. This limitation sparked the initial conceptual leap.\n\nThe seminal idea that laid the groundwork for quantum computing came from **Richard Feynman**.\n\n*   **Paper:** "Simulating Physics with Computers"\n*   **Original Publication Details:** *International Journal of Theoretical Physics*, Vol. 21, pp. 467–488, 1982.\n*   **Direct Link:** [ACM Digital Library Link](https://dl.acm.org/doi/10.5555/304763.305688)\n*   **Context:** In the early 1980s, physicists were grappling with the computational intractability of simulating quantum mechanical systems. Feynman observed that if you wanted to simulate a quantum system, a classical computer would require an exponential amount of resources. He proposed a radical solution: why not build a computer that *itself* operates on quantum mechanical principles? This would allow for a direct, efficient simulation of other quantum systems.\n*   **Problem Statement:** Classical computers are inherently inefficient at simulating quantum phenomena due to the nature of quantum superposition and entanglement, which leads to an exponential increase in computational resources required.\n*   **Contribution:** Feynman\'s paper didn\'t present a blueprint for a quantum computer, but rather a profound conceptual argument. He suggested that a "quantum computer" could efficiently simulate any other quantum system, thereby overcoming the limitations of classical computers for such tasks. This vision ignited the field, shifting the focus from merely faster classical computation to a fundamentally new paradigm of computation. It laid the philosophical foundation for what a quantum computer *could be* and *why* it would be necessary.\n\nWhile Feynman\'s paper provided the conceptual spark, it was the subsequent work of others that began to formalize what a quantum computer would look like and what it could actually *do*. This led to the development of quantum logic gates and circuits, paving the way for the first quantum algorithms.\n\n---\n\n### **Phase 2: The Promise – Quantum Algorithms and Computational Power (Week 2)**\n\nFollowing Feynman\'s conceptualization, the next crucial step was to demonstrate that a quantum computer could perform tasks that are intractable for classical computers, not just for simulating physics, but for general computational problems. This phase saw the development of the first truly impactful quantum algorithms.\n\nThe most famous and arguably the most influential breakthrough in this regard was **Peter Shor\'s** algorithm.\n\n*   **Paper:** "Polynomial-Time Algorithms for Prime Factorization and Discrete Logarithms on a Quantum Computer"\n*   **ArXiv ID:** `quant-ph/9508027`\n*   **Original Publication Date:** 1996-01-25 (This paper was presented at the 35th Annual Symposium on Foundations of Computer Science in 1994, but the arXiv version is widely cited and accessible.)\n*   **Authors:** Peter W. Shor\n*   **Summary:** "A digital computer is generally believed to be an efficient universal computing device; that is, it is believed able to simulate any physical computing device with an increase in computation time of at most a polynomial factor. This may not be true when quantum mechanics is taken into consideration. This paper considers factoring integers and finding discrete logarithms, two problems which are generally thought to be hard on a classical computer and have been used as the basis of several proposed cryptosystems. Efficient randomized algorithms are given for these two problems on a hypothetical quantum computer. These algorithms take a number of steps polynomial in the input size, e.g., the number of digits of the integer to be factored."\n*   **Context:** Before Shor\'s work, quantum algorithms were primarily focused on problems like database searching (Grover\'s algorithm offered a quadratic speedup). However, these didn\'t challenge the fundamental assumptions of classical computational complexity in the same way. Shor\'s algorithm emerged as a monumental leap, demonstrating that a quantum computer could solve problems considered "hard" for even the best classical computers in polynomial time.\n*   **Problem Statement:** The security of widely used cryptographic systems, such as RSA, relies on the computational difficulty of factoring large numbers into their prime components. Classically, this problem becomes exponentially harder as the number size increases, making it practically impossible for sufficiently large numbers.\n*   **Contribution:** Shor\'s algorithm provided a quantum algorithm that could factor large integers exponentially faster than any known classical algorithm. This was a game-changer because it directly threatened the security of modern public-key cryptography. It moved quantum computing from a theoretical curiosity to a field with immense practical implications, spurring significant investment and research into building actual quantum computers. The paper rigorously demonstrated the potential of quantum mechanics to offer a computational advantage for a problem of profound real-world importance.\n\nThe discovery of Shor\'s algorithm solidified the belief that quantum computers could offer unprecedented computational power, but it also highlighted a critical challenge: quantum systems are inherently fragile and prone to errors. This led to the next major phase of research.\n\n---\n\n### **Phase 3: The Challenge – Towards Fault-Tolerant Quantum Computing (Week 3)**\n\nThe power of quantum algorithms like Shor\'s is undeniable, but the physical realization of quantum computers faces a formidable obstacle: quantum systems are extremely sensitive to environmental noise. This noise causes "decoherence," leading to errors that can quickly corrupt quantum information. To build practical, large-scale quantum computers, these errors must be managed. This led to the development of quantum error correction.\n\nA foundational concept in addressing this challenge is **Quantum Error Correction (QEC)**.\n\n*   **Paper:** "Quantum Error Correction: An Introductory Guide"\n*   **ArXiv ID:** `1907.11157`\n*   **Published:** 2019-07-24\n*   **Authors:** Joschka Roffe\n*   **Summary:** "Quantum error correction protocols will play a central role in the realisation of quantum computing; the choice of error correction code will influence the full quantum computing stack, from the layout of qubits at the physical level to gate compilation strategies at the software level. In this review, we provide an introductory guide to the theory and implementation of quantum error correction codes. Finally, we discuss issues that arise in the practical implementation of the surface code and other quantum error correction codes."\n*   **Context:** Classical computers achieve reliability through redundancy and error-correcting codes. However, quantum errors are more complex; they can be continuous, and the act of measuring a quantum state to detect an error can destroy the very information you\'re trying to protect. The need for QEC became acutely apparent in the mid-1990s, following Shor\'s algorithm, with seminal works by Peter Shor and Andrew Steane in 1995-1996. This introductory guide synthesizes those initial breakthroughs and provides a comprehensive overview suitable for a Master\'s student.\n*   **Problem Statement:** Quantum bits (qubits) are highly susceptible to noise from their environment, leading to errors that accumulate rapidly and destroy the quantum information, making long, complex quantum computations impossible.\n*   **Contribution:** The development of quantum error correction codes, starting with Shor\'s 9-qubit code and Steane\'s 7-qubit code in 1995-1996, demonstrated that it is theoretically possible to protect quantum information from noise. These codes encode a single logical qubit into multiple physical qubits, allowing for the detection and correction of errors without directly measuring the encoded information. This breakthrough was critical because it showed a path towards building fault-tolerant quantum computers, where errors could be actively managed, making large-scale quantum computation a realistic, albeit challenging, goal. The field has since evolved significantly, with codes like the surface code becoming a leading candidate for practical implementations.\n\n---\n\n**Conclusion and Future Directions:**\n\nThis three-week roadmap has taken you from the conceptual birth of quantum computing with Feynman\'s vision, through the algorithmic power demonstrated by Shor, to the crucial challenge of error correction. As a Master\'s student, understanding this narrative flow is essential. The field continues to evolve rapidly, with ongoing research in:\n\n*   **New Quantum Algorithms:** Discovering more algorithms that offer quantum advantage for various problems (e.g., in chemistry, materials science, optimization).\n*   **Hardware Development:** Building more stable and scalable quantum computers using different physical platforms (superconducting qubits, trapped ions, photonic qubits, etc.).\n*   **Fault-Tolerant Architectures:** Developing more efficient and robust quantum error correction schemes and architectures.\n*   **Quantum Machine Learning:** Exploring the intersection of quantum computing and artificial intelligence.\n\nBy grasping these foundational papers and the problems they addressed, you\'ll be well-equipped to delve into current research and contribute to the exciting future of quantum computing. Good luck, Fathia!',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ]);
  }

  void sendMessage(String text, {List<String>? imagePaths}) {
    if (text.trim().isEmpty && (imagePaths == null || imagePaths.isEmpty)) {
      return;
    }

    // Add user message
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      imagePaths: imagePaths,
    );

    _messages.add(userMessage);
    emit(ChatbotMessageSending(messages: List.from(_messages)));

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      final aiMessage = ChatMessage(
        id: const Uuid().v4(),
        text: 'I understand your question. Let me help you with that...',
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.add(aiMessage);
      emit(ChatbotLoaded(messages: List.from(_messages)));
    });
  }

  void removeImage(int index, List<String> imagePaths) {
    imagePaths.removeAt(index);
    emit(ChatbotLoaded(messages: List.from(_messages)));
  }
}
