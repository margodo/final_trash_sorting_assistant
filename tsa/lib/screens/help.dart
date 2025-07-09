import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCAFFDD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: MediaQuery.of(context).size.width / 2 - 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/text_bubble.png',
                    width: 280,
                  ),
                  const Positioned(
                    top: 90,
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        "I can answer most\ncommon questions\nregarding trash sorting",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 140,
              left: MediaQuery.of(context).size.width / 2 - 75,
              child: Image.asset(
                'assets/images/lapo.png',
                width: 150,
              ),
            ),
            Positioned(
              top: 360,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  _buildFaqButton(context, "Local regulations?", "Here are a few basics of waste sorting: plastic belongs to yellow containers, paper to blue ones, white glass to white and colored glass to green. In your area you can also find a container for beverage cartons, metal waste and electronic waste."),
                  _buildFaqButton(context, "Where to throw electronics?", "Take them to an e-waste recycling center."),
                  _buildFaqButton(context, "What is the fine for not sorting?", "Fines vary by region, but they can be hefty!"),
                  _buildFaqButton(context, "What is waste fee?", "The waste tax is 900 CZK per person per year. The fee is paid once a year by May 31. If you arrive later in a year than that (after May), you are obliged to pay within 15 days after your arrival."),
                  _buildFaqButton(context, "What are littering fines?", "Actions such as throwing garbage or placing posters outside of permitted areas will be considered as punishable. People who refuse to clean up after their dogs will be fined as well. The general rule will be - everybody has to clean up the trash they produce."),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqButton(BuildContext context, String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _showAnswerDialog(context, question, answer),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
            minimumSize: const Size(50, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(question, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  void _showAnswerDialog(BuildContext context, String question, String answer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(answer),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
