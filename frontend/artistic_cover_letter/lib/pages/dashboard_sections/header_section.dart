import 'package:artistic_cover_letter/services/auth_service.dart';
import 'package:artistic_cover_letter/repositories/client_repository.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final clientService = getIt<ClientRepository>();

  HeaderSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            "Welcome ${clientService.firstName} ",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            clipBehavior: Clip.none,
            onPressed: () => getIt.get<AuthService>().logout(),
            icon: const Icon(Icons.logout, size: 24.0),
            label: const Text('Logout', textAlign: TextAlign.left),
          )
        ],
      ),
    );
  }
}
