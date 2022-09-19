import 'package:flutter/material.dart';

class Paging extends StatefulWidget {
  const Paging({
    Key? key,
    required this.pagesCount,
    required this.onSelect,
    this.selectionColor,
  }) : super(key: key);

  final int pagesCount;
  final void Function(int pageNumber) onSelect;
  final Color? selectionColor;

  @override
  State<Paging> createState() => _PagingState();
}

class _PagingState extends State<Paging> {
  final ScrollController _controller = ScrollController();

  int selectedPage = 1;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width > 690
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 2;
    return SizedBox(
      height: size * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///Last index button
          IconButton(
              hoverColor: (selectedPage > 1)
                  ? Theme.of(context).hoverColor
                  : Colors.transparent,
              onPressed: (selectedPage > 1)
                  ? () {
                      setState(() {
                        selectedPage -= 1;
                      });
                      widget.onSelect(selectedPage - 1);

                      _controller.animateTo(
                          ((selectedPage - 2) / 4) * ((size) / 5.6),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear);
                    }
                  : () {},
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: (selectedPage > 1)
                    ? IconTheme.of(context).color
                    : Theme.of(context).disabledColor,
              )),

          /// Numbers row
          (widget.pagesCount > 4)
              ? SizedBox(
                  width: size / 5.5,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      int pageNumber = index + 1;
                      return GestureDetector(
                          child: NumberButton(
                        onTap: () {
                          if (pageNumber != selectedPage) {
                            setState(() {
                              selectedPage = pageNumber;
                            });
                            widget.onSelect(pageNumber);
                          }
                        },
                        buttonText: (pageNumber).toString(),
                        isSelected: selectedPage == pageNumber,
                        selectionColor: widget.selectionColor,
                        size: size,
                      ));
                    },
                    itemCount: widget.pagesCount,
                    shrinkWrap: true,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.pagesCount, (index) {
                    int pageNumber = index + 1;
                    return GestureDetector(
                        child: NumberButton(
                      onTap: () {
                        if (pageNumber != selectedPage) {
                          setState(() {
                            selectedPage = pageNumber;
                          });

                          widget.onSelect(pageNumber);
                        }
                      },
                      buttonText: (pageNumber).toString(),
                      isSelected: selectedPage == pageNumber,
                      selectionColor: widget.selectionColor,
                      size: size,
                    ));
                  }),
                ),

          ///Next index button
          IconButton(
              hoverColor: (selectedPage < widget.pagesCount)
                  ? Theme.of(context).hoverColor
                  : Colors.transparent,
              onPressed: (selectedPage < widget.pagesCount)
                  ? () {
                      setState(() {
                        selectedPage += 1;
                      });
                      widget.onSelect(selectedPage + 1);
                      if ((selectedPage - 1) % 4 == 0 && selectedPage != 1) {
                        _controller.animateTo(
                            ((selectedPage - 1) / 4) * ((size) / 5.6),
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear);
                      }
                    }
                  : () {},
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: (selectedPage < widget.pagesCount)
                    ? IconTheme.of(context).color
                    : Theme.of(context).disabledColor,
              )),
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  NumberButton(
      {Key? key,
      required this.buttonText,
      required this.onTap,
      required this.isSelected,
      this.selectionColor,
      required this.size})
      : super(key: key);

  final String buttonText;
  final void Function() onTap;
  final bool isSelected;
  final double size;
  Color? selectionColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size / 40,
        width: size / 40,
        margin: EdgeInsets.all(size * 0.01),
        decoration: BoxDecoration(
          color: isSelected
              ? selectionColor ?? Theme.of(context).primaryColor
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(size / 307.2),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: size / 64.2),
        ),
        alignment: AlignmentDirectional.center,
      ),
    );
  }
}
