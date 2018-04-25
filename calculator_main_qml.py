import sys

from PyQt5.QtCore import QUrl, QObject
from PyQt5.QtGui import QIcon, QWindow
from PyQt5.QtQml import QQmlApplicationEngine, QQmlProperty
from PyQt5.QtWidgets import QApplication, QMessageBox
from asteval import Interpreter

from converter import *


def connect_calc(win: QWindow):
    display = win.findChild(QObject, 'tf_calc_in')

    def update_display(symbol=None):
        content = display.property('text')

        if len(content) != 0 and symbol == 'sqrt(x)':
            display.setProperty('text', 'sqrt({0})'.format(content))
        elif len(content) != 0 and symbol == '(x+y)':
            display.setProperty('text', '({0})'.format(content))
        elif symbol:
            display.setProperty('text', content + symbol)
        else:
            display.setProperty('text', '')

    def exec_calc():
        content = display.property('text')
        if len(content) != 0:
            a_eval = Interpreter()
            res = str(a_eval(content))

            if len(a_eval.error) > 0:
                err = a_eval.error[0].get_error()
                err_box = QMessageBox()
                err_box.setWindowTitle('Evaluation Error')
                err_box.setText('An {0} occurred. Pleas check below for details.'.format(err[0]))
                err_box.setIcon(QMessageBox.Critical)
                err_list = [str(e.get_error()[1]).strip() + '\n' for e in a_eval.error]
                err_box.setDetailedText(' '.join(err_list))
                err_box.show()
            else:
                display.setProperty('text', res)

    win.findChild(QObject, 'btn_zero').clicked.connect(lambda: update_display('0'))
    win.findChild(QObject, 'btn_one').clicked.connect(lambda: update_display('1'))
    win.findChild(QObject, 'btn_two').clicked.connect(lambda: update_display('2'))
    win.findChild(QObject, 'btn_three').clicked.connect(lambda: update_display('3'))
    win.findChild(QObject, 'btn_four').clicked.connect(lambda: update_display('4'))
    win.findChild(QObject, 'btn_five').clicked.connect(lambda: update_display('5'))
    win.findChild(QObject, 'btn_six').clicked.connect(lambda: update_display('6'))
    win.findChild(QObject, 'btn_seven').clicked.connect(lambda: update_display('7'))
    win.findChild(QObject, 'btn_eight').clicked.connect(lambda: update_display('8'))
    win.findChild(QObject, 'btn_nine').clicked.connect(lambda: update_display('9'))

    win.findChild(QObject, 'btn_comma').clicked.connect(lambda: update_display('.'))
    win.findChild(QObject, 'btn_div').clicked.connect(lambda: update_display('/'))
    win.findChild(QObject, 'btn_mult').clicked.connect(lambda: update_display('*'))
    win.findChild(QObject, 'btn_sub').clicked.connect(lambda: update_display('-'))
    win.findChild(QObject, 'btn_add').clicked.connect(lambda: update_display('+'))
    win.findChild(QObject, 'btn_pow').clicked.connect(lambda: update_display('**'))
    win.findChild(QObject, 'btn_sqrt').clicked.connect(lambda: update_display('sqrt(x)'))
    win.findChild(QObject, 'btn_brackets').clicked.connect(lambda: update_display('(x+y)'))
    win.findChild(QObject, 'btn_ac').clicked.connect(lambda: update_display())
    win.findChild(QObject, 'shortcut_del').activated.connect(lambda: update_display())
    win.findChild(QObject, 'btn_equals').clicked.connect(exec_calc)
    win.findChild(QObject, 'shortcut_enter').activated.connect(exec_calc)


def connect_conv(win: QWindow):

    def set_prop_list(win, obj_name, prop_name, values):
        obj = win.findChild(QObject, obj_name)
        prop = QQmlProperty(obj, prop_name)
        prop.write(values)

    def ltr_convert(cmb_a, cmb_b, le_a, le_b, converter: ConverterBase):
        unit_a = cmb_a.property('currentText').split(' ', 1)[0]
        unit_b = cmb_b.property('currentText').split(' ', 1)[0]
        try:
            value = float(le_a.property('text'))
            le_b.setProperty('text', str(round(converter.convert(unit_a, unit_b, value), 4)))
        except ValueError as e:
            print(e)

    def rtl_convert(cmb_a, cmb_b, le_a, le_b, converter: ConverterBase):
        unit_a = cmb_a.property('currentText').split(' ', 1)[0]
        unit_b = cmb_b.property('currentText').split(' ', 1)[0]
        try:
            value = float(le_b.property('text'))
            le_a.setProperty('text', str(round(converter.convert(unit_b, unit_a, value), 4)))
        except ValueError as e:
            print(e)

    def connect_currencies(win: QWindow):
        curr_conv = CurrencyConverter()
        curr_a, curr_b = win.findChild(QObject, 'cmb_curr_a'), win.findChild(QObject, 'cmb_curr_b')
        curr_av, curr_bv = win.findChild(QObject, 'tf_curr_a'), win.findChild(QObject, 'tf_curr_b')
        currencies = list(
            ['{0}, {1} ({2})'.format(k.ljust(4), v['Country'], v['Symbol']) for k, v in
             curr_conv.get_supported().items()]
        )

        set_prop_list(win, "cmb_curr_a", "model", currencies)
        win.findChild(QObject, 'cmb_curr_a').setProperty('currentIndex', 0)
        set_prop_list(win, "cmb_curr_b", "model", currencies)
        win.findChild(QObject, 'cmb_curr_b').setProperty('currentIndex', 1)

        def l_curr_cmb_ch(converter: ConverterBase):
            unit_a = curr_a.property('currentText')[0:3]
            unit_b = curr_b.property('currentText')[0:3]
            try:
                win.findChild(QObject, 'tf_exchange') \
                    .setProperty('text', str(round(converter.conversion_rate(unit_a, unit_b), 4)))
            except ValueError:
                pass

        def r_curr_cmb_ch(converter: ConverterBase):
            unit_a = curr_a.property('currentText')[0:3]
            unit_b = curr_b.property('currentText')[0:3]
            try:
                win.findChild(QObject, 'tf_exchange') \
                    .setProperty('text', str(round(converter.conversion_rate(unit_b, unit_a), 4)))
            except ValueError:
                pass

        l_curr_cmb_ch(curr_conv)
        curr_a.currentIndexChanged.connect(lambda: l_curr_cmb_ch(curr_conv))
        curr_b.currentIndexChanged.connect(lambda: r_curr_cmb_ch(curr_conv))
        curr_av.editingFinished.connect(lambda: ltr_convert(curr_a, curr_b, curr_av, curr_bv, curr_conv))
        curr_bv.editingFinished.connect(lambda: rtl_convert(curr_a, curr_b, curr_av, curr_bv, curr_conv))
        win.findChild(QObject, 'btn_convert') \
            .clicked.connect(lambda: ltr_convert(curr_a, curr_b, curr_av, curr_bv, curr_conv))
        win.findChild(QObject, 'btn_refresh').clicked.connect(lambda: curr_conv.try_update_exchange())

    def connect_distances(win: QWindow):
        dist_conv = DistanceConverter()
        dist_a, dist_b = win.findChild(QObject, 'cmb_dist_a'), win.findChild(QObject, 'cmb_dist_b')
        dist_av, dist_bv = win.findChild(QObject, 'tf_dist_a'), win.findChild(QObject, 'tf_dist_b')
        distances = list(['{0} ({1})'.format(k.ljust(4), v['Name'])
                          for k, v in dist_conv.get_supported().items()])

        set_prop_list(win, "cmb_dist_a", "model", distances)
        win.findChild(QObject, 'cmb_dist_a').setProperty('currentIndex', 0)
        set_prop_list(win, "cmb_dist_b", "model", distances)
        win.findChild(QObject, 'cmb_dist_b').setProperty('currentIndex', 1)

        dist_a.currentIndexChanged.connect(lambda: ltr_convert(dist_a, dist_b, dist_av, dist_bv, dist_conv))
        dist_b.currentIndexChanged.connect(lambda: ltr_convert(dist_a, dist_b, dist_av, dist_bv, dist_conv))
        dist_av.editingFinished.connect(lambda: ltr_convert(dist_a, dist_b, dist_av, dist_bv, dist_conv))
        dist_bv.editingFinished.connect(lambda: rtl_convert(dist_a, dist_b, dist_av, dist_bv, dist_conv))

    def connect_speeds(win: QWindow):
        speed_conv = SpeedConverter()
        speed_a, speed_b = win.findChild(QObject, 'cmb_speed_a'), win.findChild(QObject, 'cmb_speed_b')
        speed_av, speed_bv = win.findChild(QObject, 'tf_speed_a'), win.findChild(QObject, 'tf_speed_b')
        speeds = list(['{0} ({1})'.format(k.ljust(4), v['Name'])
                       for k, v in speed_conv.get_supported().items()])

        set_prop_list(win, "cmb_speed_a", "model", speeds)
        win.findChild(QObject, 'cmb_speed_a').setProperty('currentIndex', 0)
        set_prop_list(win, "cmb_speed_b", "model", speeds)
        win.findChild(QObject, 'cmb_speed_b').setProperty('currentIndex', 1)

        speed_a.currentIndexChanged.connect(lambda: ltr_convert(speed_a, speed_b, speed_av, speed_bv, speed_conv))
        speed_b.currentIndexChanged.connect(lambda: ltr_convert(speed_a, speed_b, speed_av, speed_bv, speed_conv))
        speed_av.editingFinished.connect(lambda: ltr_convert(speed_a, speed_b, speed_av, speed_bv, speed_conv))
        speed_bv.editingFinished.connect(lambda: rtl_convert(speed_a, speed_b, speed_av, speed_bv, speed_conv))

    connect_currencies(win)
    win.findChild(QObject, 'tv_conv').currency.connect(lambda: connect_currencies(win))
    win.findChild(QObject, 'tv_conv').distance.connect(lambda: connect_distances(win))
    win.findChild(QObject, 'tv_conv').speed.connect(lambda: connect_speeds(win))


if __name__ == '__main__':
    app = QApplication(sys.argv)
    app.setWindowIcon(QIcon("./img/calculator.png"))
    engine = QQmlApplicationEngine()

    engine.load(QUrl("main.qml"))

    win = engine.rootObjects()[0]

    connect_calc(win)
    win.findChild(QObject, 'mi_calc').triggered.connect(lambda: connect_calc(win))
    win.findChild(QObject, 'mi_conv').triggered.connect(lambda: connect_conv(win))

    sys.exit(app.exec_())
