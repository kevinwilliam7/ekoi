import 'package:flutter/material.dart';

class ContainerListControl extends StatelessWidget {
  const ContainerListControl({
    Key? key,
    required this.startColor,
    required this.midColor,
    required this.endColor,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.textStatus,
    required this.textTitle,
    required this.width,
    required this.statusColor,
    required this.textMode,
    required this.textDateTime,
    required this.switchButton,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final double width;
  final int startColor, endColor, midColor;
  final Widget switchButton;
  final Color textColor;
  final Color statusColor;
  final String textStatus, textTitle, textMode, textDateTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(startColor),
              Color(midColor),
              Color(endColor),
              Color(endColor),
            ],
            stops: const [0.1, 0.3, 0.9, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 15,
              child: switchButton,
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width / 1,
                    child: Text(
                      textTitle,
                      style: TextStyle(
                        color: textColor,
                        fontFamily: 'Lato',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    'Mode: ' + textMode,
                    style: TextStyle(
                      color: statusColor,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: width / 1,
                    child: Text(
                      'Terakhir: ',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontFamily: 'Lato',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    '$textDateTime',
                    style: TextStyle(
                      color: statusColor,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
