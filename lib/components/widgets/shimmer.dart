import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final BoxShape shape;
  const ShimmerWidget(
      {Key? key,
      this.width = double.infinity,
      required this.height,
      required this.shape})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Color(0xFFF4F4F4),
        highlightColor: Color.fromARGB(255, 212, 212, 219),
        child: Container(
          width: width,
          height: height,
          decoration: new BoxDecoration(
            color: Colors.grey,
            shape: shape,
          ),
        ),
      );
}

class ControlShimmer extends StatelessWidget {
  const ControlShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ShimmerWidget(
            height: size.height * 0.3,
            shape: BoxShape.rectangle,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Padding(
          padding: const EdgeInsets.only(right: 12.0, left: 12.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 3),
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                child: ShimmerWidget(
                  height: 10,
                  shape: BoxShape.rectangle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ScheduleTabShimmer extends StatelessWidget {
  const ScheduleTabShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.56,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ShimmerWidget(
          height: 10,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}

class ControlTabShimmer extends StatelessWidget {
  const ControlTabShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.37,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ShimmerWidget(
          height: 10,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}

class OverviewShimmer extends StatelessWidget {
  const OverviewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.3),
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return ShimmerWidget(height: 1, shape: BoxShape.rectangle);
            },
          ),
        ),
      ],
    );
  }
}

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ShimmerWidget(
                height: size.height * 0.3,
                shape: BoxShape.rectangle,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Center(
            child: Container(
              child: ShimmerWidget(
                height: size.height * 0.3,
                shape: BoxShape.rectangle,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Center(
            child: Container(
              child: ShimmerWidget(
                height: size.height * 0.3,
                shape: BoxShape.rectangle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticShimmer extends StatelessWidget {
  const StatisticShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(32.0),
              topRight: const Radius.circular(32.0),
              bottomLeft: const Radius.circular(0.0),
              bottomRight: const Radius.circular(0.0),
            ),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.30,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                height: MediaQuery.of(context).size.width * 0.56,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0),
                    bottomLeft: const Radius.circular(0.0),
                    bottomRight: const Radius.circular(0.0),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.blue.withOpacity(0.5),
                  //     spreadRadius: 1,
                  //     blurRadius: 10,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    right: 25,
                    left: 25,
                    bottom: 30,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        child: ShimmerWidget(
                          height: size.height,
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        for (int i = 0; i < 2; i++)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 25,
                  left: 25,
                ),
                child: ShimmerWidget(
                  height: size.height / 5,
                  shape: BoxShape.rectangle,
                ),
              ),
              SizedBox(
                height: size.height * 0.005,
              )
            ],
          )
      ],
    );
  }
}
