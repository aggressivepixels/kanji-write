from aqt import mw
from aqt.qt import QAction, QMenu
from aqt.utils import qconnect, showInfo


def on_generate() -> None:
    showInfo("Placeholder")


generate_action = QAction("Generate", mw)
qconnect(generate_action.triggered, on_generate)

menu = QMenu("KanjiWrite", mw)
menu.addAction(generate_action)
mw.form.menuTools.addMenu(menu)
