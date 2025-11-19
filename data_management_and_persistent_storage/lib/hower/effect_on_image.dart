import 'package:flutter/material.dart';

class HoverGrowImage extends StatefulWidget {
  final String imagePath;
  final Widget destination;
  final double width;
  final double height;
  final double hoverHeight; // height when hovered

  const HoverGrowImage({
    Key? key,
    required this.imagePath,
    required this.destination,
    this.width = 200,
    this.height = 200,
    this.hoverHeight = 250,
  }) : super(key: key);

  @override
  _HoverGrowImageState createState() => _HoverGrowImageState();
}

class _HoverGrowImageState extends State<HoverGrowImage> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.destination),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: widget.width,
          height: _isHovering ? widget.hoverHeight : widget.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
