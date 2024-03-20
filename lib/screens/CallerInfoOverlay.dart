import 'package:flutter/material.dart';
import 'package:screens/caller_id_service.dart';


import 'package:rxdart/rxdart.dart';

class CallerIdOverlay extends StatefulWidget {
  final CallerIdData callerIdData;

  const CallerIdOverlay({Key? key, required this.callerIdData}) : super(key: key);

  @override
  State<CallerIdOverlay> createState() => _CallerIdOverlayState();
}

class _CallerIdOverlayState extends State<CallerIdOverlay> {
  final _overlayEntry = OverlayEntry();
  
  @override
  void initState() {
    super.initState();

    // 将 OverlayEntry 插入到 Overlay 中
    _overlayEntry.insert(_getOverlay());

    // 监听通话状态变化
    _callStateSubject.listen((callState) {
      if (callState == CallState.ended) {
        // 通话结束后关闭浮动方块
        _overlayEntry.remove();
      }
    });
   }
  @override
  void initState() {
    super.initState();

    // 将 OverlayEntry 插入到 Overlay 中
    _overlayEntry.insert(_getOverlay());

    // 监听 callerIdData 变化并更新浮动方块
    _callerIdSubject.listen((callerIdData) {
      setState(() {
       // 更新 _callerIdData 变量
        _callerIdData = callerIdData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildCallerIdBox();
  }

  @override
  void dispose() {
    // 移除 OverlayEntry
    _overlayEntry.remove();
    super.dispose();
  }

  Overlay _getOverlay() {
    return Overlay.of(context) ?? Overlay.of(context.findRootAncestor());
  }

  Widget _buildCallerIdBox() {
    return Dismissible(
      key: ValueKey(_callerIdData.phoneNumber),
      onDismissed: (_) {
        // 关闭浮动方块
        _overlayEntry.remove();
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          // 更新浮动方块的位置
          _overlayEntry.overlay.insert(_overlayEntry.remove()..widget = _buildCallerIdBox(
            offset: details.delta,
          ));
        },
        onHorizontalDragEnd: (details) {
          // 判断用户是否想要关闭浮动窗口
          if (details.primaryVelocity > 0) {
            // 向右滑动关闭浮动窗口
            _overlayEntry.remove();
          } else if (details.primaryVelocity < 0) {
            // 向左滑动关闭浮动窗口
            _overlayEntry.remove();
          } else {
            // 点击浮动窗口外部，不关闭浮动窗口
          }
        },
        child: Container(
          // 设置浮动框尺寸
          width: 324.0,
          height: 324.0,
          margin: const EdgeInsets.all(44.0),
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(6.0, 1),
              end: Alignment(-1, 6.0),
              colors: [
                Color.fromRGBO(255, 234, 188, 1),
                Color.fromRGBO(251, 251, 251, 1)
              ],
            ),
            borderRadius: BorderRadius.circular(35.0),
          ),
          child: _buildCallerIdContent(),
        ),
      ),
    );
  }

  Widget _buildCallerIdContent() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 22,
          left: 14,
          child: Container(
            width: 296,
            height: 296,
            child: Stack(
              children: <Widget>[
                // 添加关闭按钮
                Positioned(
                  left: 23,
                  top: 18,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Color.fromRGBO(255, 0, 0, 1.0),
                    ),
                    onPressed: () {
                      // 关闭浮动窗口
                      _overlayEntry.remove();
                    },
                  ),
                ),
                    // 显示头像
                    Positioned(
                      left: 27.0,
                      top: 32.0,
                      child: ClipOval(
                        child: Image.network(
                          '${_callerIdData.avatar}',
                          width: 125,
                          height: 125,
                          fit: BoxFit.cover, // 让图像充滿所有可用空间
                         ),
                        ),
                      ),

                    // // 显示号码国家
                    Positioned(
                      left: 158.0,
                      width: 151.0,
                      top: 22.0,
                      height: 39.0,
                      child: Text(
                        textAlign: TextAlign.left,
                        '${_callerIdData.countryCode}',
                        style: const TextStyle(
                          color: Color.fromRGBO(144, 143, 157, 1),
                          fontFamily: 'Noto Sans SC',
                          fontSize: 30,
                          letterSpacing: 0.07,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          // 设置自动字体大小
                          autofontSize: true,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                     
                    // 显示运营商
                    Positioned(
                      left: 158.0,
                      width: 151.0,
                      top: 61.0,
                      height: 34.0,
                      child: Text(
                        textAlign: TextAlign.left,
                        '${_callerIdData.carrier}',
                        style: const TextStyle(
                          color: Color.fromRGBO(144, 143, 157, 1),
                          fontFamily: 'Noto Sans SC',
                          fontSize: 30,
                          letterSpacing: 0.07,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          // 设置自动字体大小
                          autofontSize: true,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                     // 显示号码类型
                    Positioned(
                      left: 158.0,
                      width: 151.0,
                      top: 96.0,
                      height: 34.0,
                      child: Text(
                        textAlign: TextAlign.left,
                        '${_callerIdData.numberType}',
                        style: const TextStyle(
                          color: Color.fromRGBO(144, 143, 157, 1),
                          fontFamily: 'Noto Sans SC',
                          fontSize: 30,
                          letterSpacing: 0.07,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          // 设置自动字体大小
                          autofontSize: true,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),          
                     // 显示名字
                    Positioned(
                      left: 158.0,
                      width: 151.0,
                      top: 137.0,
                      height: 20.0,
                      child: Text(
                        textAlign: TextAlign.left,
                        '${_callerIdData.name}',
                        style: const TextStyle(
                          color: Color.fromRGBO(44, 44, 65, 1),
                          fontFamily: 'Noto Sans SC',
                          fontSize: 20,
                          letterSpacing: 0.07,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          // 设置自动字体大小
                          autofontSize: true,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ), 
                     // 显示本地号码
                    Positioned(
                      left: 158.0,
                      width: 162.0,
                      top: 137.0,
                      height: 20.0,
                      child: Text(
                        textAlign: TextAlign.left,
                        '${_callerIdData.isLocalNumber}',
                        style: const TextStyle(
                          color: Color.fromRGBO(44, 44, 65, 1),
                          fontFamily: 'Noto Sans SC',
                          fontSize: 20,
                          letterSpacing: 0.07,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          // 设置自动字体大小
                          autofontSize: true,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),      
                     // 归属地显示本地号码
                    Positioned(
                      left: 55.0,
                      width: 255.0,
                      top: 178.0,
                      height: 47.0,
                      child: Text(
                        textAlign: TextAlign.left,
                        '${_callerIdData.region}',
                        style: const TextStyle(
                          color: Color.fromRGBO(144, 143, 157, 1),
                          fontFamily: 'Noto Sans SC',
                          fontSize: 30,
                          letterSpacing: 0.07,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          // 设置自动字体大小
                          autofontSize: true,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),         
   
                    // 归属地图标
                    Positioned(
                      left: 19.0,
                      top: 192.0,
                      child: SizedBox(
                        height: 21.0,
                        child: Icon(
                          Icons.location_on,
                          color: Color.fromRGBO(147, 203, 128, 1.0),
                        ),
                      ),
                    ),
                     // 显示标签
                    Positioned(
                      left: 55.0,
                      width: 255.0,
                      top: 230.0,
                      height: 40.0,
                      child: Text(
                        textAlign: TextAlign.left,
                        '${_callerIdData.labels.map((label) => label.name).join(', ')}',
                        style: const TextStyle(
                          color: Color.fromRGBO(242, 112, 126, 1),
                          fontFamily: 'Noto Sans SC',
                          fontSize: 30,
                          letterSpacing: 0.07,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          // 设置自动字体大小
                          autofontSize: true,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ), 

                   // 显示labels图片
                    // 显示labels图片
                    Positioned(
                      left: 14.0,
                      top: 238.0,
                      child: SizedBox(
                        height: 26.0,
                        child: Icon(
                          Icons.warning,
                          color: Color.fromRGBO(242, 112, 126, 1),
                        ),
                      ),
                    ),
                  // 显示labels图片
 
                  // 显示号码
                  Positioned(
                    left: 35.0,
                    width: 257.0,
                    top: 278.0,
                    height: 40.0,
                    child: Text(
                       textAlign: TextAlign.left,
                      '${_callerIdData.phoneNumber}',
                      style: const TextStyle(
                        color: Color.fromRGBO(44, 44, 65, 1),
                        fontFamily: 'Noto Sans SC',
                        fontSize: 30,
                        letterSpacing: 0.07,
                        fontWeight: FontWeight.normal,
                        height: 1,
                        // 设置自动字体大小
                        autofontSize: true,
                      ),
                   overflow: TextOverflow.ellipsis,
                 ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
