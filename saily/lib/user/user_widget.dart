import 'package:flutter/material.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class UserWidget extends StatelessWidget {
  UserWidget({required this.settingsController});
  SettingsController settingsController;

  Widget build(BuildContext context) {
    UserInfo? currentUser = settingsController.getLoggedUser();
    return SizedBox.expand(
      child: Card(
        color: Colors.red,
        child: Row(
          children: [
            SizedBox(
              width: ctxW(context) / 2,
              height: ctxH(context),
              child: Card(
                color: SailyBlue,
                margin: EdgeInsets.all(10),
              ),
            ),
            SizedBox(
              width: ctxW(context) / 2,
              height: ctxH(context),
              child: Card(
                color: SailyBlue,
                margin: EdgeInsets.all(10),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

enum CardType {
  standard,
  tappable,
  selectable,
}

class TravelDestination {
  const TravelDestination({
    required this.assetName,
    required this.title,
    required this.description,
    required this.city,
    required this.location,
    this.cardType = CardType.standard,
  });

  final String assetName;
  final String title;
  final String description;
  final String city;
  final String location;
  final CardType cardType;
}

List<TravelDestination> destinations = [
  TravelDestination(
    assetName: 'places/india_thanjavur_market.png',
    title: 'Top 10 Cities to Visit in Tamil Nadu',
    description: 'Number 10',
    city: 'Thanjavur',
    location: 'Thanjavur, Tamil Nadu',
  ),
  TravelDestination(
    assetName: 'places/india_chettinad_silk_maker.png',
    title: 'Artisans of Southern India',
    description: 'Silk Spinners',
    city: 'Chettinad',
    location: 'Sivaganga, Tamil Nadu',
    cardType: CardType.tappable,
  ),
  TravelDestination(
    assetName: 'places/india_tanjore_thanjavur_temple.png',
    title: 'Brihadisvara Temple',
    description: 'Temples',
    city: 'Thanjavur',
    location: 'Thanjavur, Tamil Nadu',
    cardType: CardType.selectable,
  ),
];


class TravelDestinationContent extends StatelessWidget {
  const TravelDestinationContent({super.key, required this.destination});

  final TravelDestination destination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headlineSmall!.copyWith(
      color: Colors.white,
    );
    final descriptionStyle = theme.textTheme.titleMedium!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 184,
          child: Stack(
            children: [
              Positioned.fill(
                // In order to have the ink splash appear above the image, you
                // must use Ink.image. This allows the image to be painted as
                // part of the Material and display ink effects above it.
                // Using a standard Image will obscure the ink splash.
                child: 
                   Image.asset("images/water.png", fit: BoxFit.cover,),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Semantics(
                    container: true,
                    header: true,
                    child: Text(
                      "",
                      style: titleStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Description and share/explore buttons.
        Semantics(
          container: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: DefaultTextStyle(
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: descriptionStyle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // The three line description on each card demo.
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      destination.description,
                      style: descriptionStyle.copyWith(color: Colors.black54),
                    ),
                  ),
                  Text(destination.city),
                  Text(destination.location),
                ],
              ),
            ),
          ),
        ),
          // share, explore buttons
          
      ],
    );
  }
}
