import 'package:flutter/material.dart';

class FlutterPagination extends StatefulWidget {
  const FlutterPagination({
    Key? key,
    required this.listCount,
    required this.onSelectCallback,
    this.selectionColor,
    this.notSelectedColor,
    this.arrowsColor,
    this.size = 32.0,
  }) : super(key: key);

  final int listCount;
  final void Function(int pageNumber) onSelectCallback;
  final double size;
  final Color? selectionColor;
  final Color? notSelectedColor;
  final Color? arrowsColor;

  @override
  State<FlutterPagination> createState() => _FlutterPaginationState();
}

class _FlutterPaginationState extends State<FlutterPagination>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();

  int selectedPage = 1;

  double _transformSize(double size) {
    return (widget.size * size) / 44.0;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int itemCount = 5;

    Color selectionColor =
        widget.selectionColor ?? Theme.of(context).primaryColor;

    Color notSelectedColor = widget.notSelectedColor ??
        Theme.of(context).primaryColor.withOpacity(0.3);

    Color arrowsColor = widget.arrowsColor ?? Theme.of(context).primaryColor;

    return SizedBox(
      height: _transformSize(44.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///Last index button
          AbsorbPointer(
            absorbing: selectedPage <= 1,
            child: IconButton(
              padding: EdgeInsets.zero,
              hoverColor: Theme.of(context).hoverColor,
              onPressed: () {
                setState(() {
                  selectedPage -= 1;
                });
                widget.onSelectCallback(selectedPage);

                _controller.animateTo(
                  ((selectedPage - 1) / itemCount) * _transformSize(259.9),
                  duration: const Duration(milliseconds: 0),
                  curve: Curves.linear,
                );
              },
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: (selectedPage > 1)
                    ? arrowsColor
                    : Theme.of(context).disabledColor,
              ),
            ),
          ),

          /// Numbers row
          Container(
            width: widget.listCount > itemCount ? _transformSize(290.0) : null,
            padding: EdgeInsets.symmetric(horizontal: _transformSize(18.0)),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: widget.listCount,
              itemBuilder: (context, index) {
                int pageNumber = index + 1;
                return Padding(
                  padding: widget.listCount - pageNumber > 0
                      ? EdgeInsetsDirectional.only(
                          end: _transformSize(8.0),
                        )
                      : EdgeInsets.zero,
                  child: IconButton(
                    onPressed: () {
                      if (pageNumber != selectedPage) {
                        setState(() {
                          selectedPage = pageNumber;
                        });
                        widget.onSelectCallback(pageNumber);
                      }
                    },
                    icon: NumberButton(
                      buttonText: (pageNumber).toString(),
                      isSelected: selectedPage == pageNumber,
                      size: widget.size,
                      selectionColor: selectionColor,
                      notSelectedColor: notSelectedColor,
                    ),
                  ),
                );
              },
            ),
          ),

          ///Next index button
          AbsorbPointer(
            absorbing: selectedPage >= widget.listCount,
            child: IconButton(
              padding: EdgeInsets.zero,
              hoverColor: Theme.of(context).hoverColor,
              onPressed: () {
                setState(() {
                  selectedPage += 1;
                });
                widget.onSelectCallback(selectedPage);
                if ((selectedPage - 1) % itemCount == 0) {
                  _controller.animateTo(
                    ((selectedPage - 1) / itemCount) * _transformSize(259.9),
                    duration: const Duration(milliseconds: 0),
                    curve: Curves.linear,
                  );
                }
              },
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: (selectedPage < widget.listCount)
                    ? arrowsColor
                    : Theme.of(context).disabledColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  const NumberButton({
    Key? key,
    required this.buttonText,
    required this.isSelected,
    required this.size,
    required this.selectionColor,
    required this.notSelectedColor,
  }) : super(key: key);

  final String buttonText;
  final bool isSelected;
  final double size;
  final Color selectionColor;
  final Color notSelectedColor;

  double _transformSize(double size) {
    return (this.size * size) / 44.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _transformSize(44.0),
      width: _transformSize(44.0),
      decoration: BoxDecoration(
        color: isSelected ? selectionColor : notSelectedColor,
        borderRadius: BorderRadius.circular(_transformSize(8.0)),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: _transformSize(18.0),
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
      alignment: AlignmentDirectional.center,
    );
  }
}
