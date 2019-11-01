import 'package:flutter/material.dart';
import 'package:nga_open_source/bloc/list_view_bloc.dart';

class AnimationFab extends StatefulWidget {
  final ListViewBloc bloc;

  final List<Function> callbacks;

  final List<Widget> icons;

  AnimationFab({this.bloc, this.icons, this.callbacks});

  @override
  State<StatefulWidget> createState() {
    return new _AnimationFabState();
  }
}

class _AnimationFabState extends State<AnimationFab>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  _FloatingActionButton _fab;

  @override
  void initState() {
    _animationController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _animation = new Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _fab = _FloatingActionButton(
      callbacks: widget.callbacks,
      icons: widget.icons,
      listenable: _animation,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ScrollState>(
        stream: widget.bloc.data,
        initialData: ScrollState.SCROLL_UP,
        builder: (BuildContext context, AsyncSnapshot<ScrollState> snapshot) {
          if (snapshot.data == ScrollState.SCROLL_UP) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
          return _fab;
        });
  }
}

class _FloatingActionButton extends AnimatedWidget {
  final List<Function> callbacks;

  final List<Widget> icons;

  _FloatingActionButton({this.icons, this.callbacks, Listenable listenable})
      : super(listenable: listenable);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    return Opacity(
        opacity: animation.value,
        child: Row(mainAxisAlignment: MainAxisAlignment.end,
            children: _buildFabWidgets()
        ));
  }

  List<Widget> _buildFabWidgets() {
    List<Widget> fabs = new List();
    for (int i = 0; i < icons.length; i++) {
      var fab = FloatingActionButton(
        mini: true,
        heroTag: "fab_${i.toString()}",
        child: icons[i],
        onPressed: () => callbacks[i](),
      );
      fabs.add(fab);
    }
    return fabs;
  }
}
