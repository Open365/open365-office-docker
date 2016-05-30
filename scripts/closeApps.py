#!/usr/bin/python3

import LOffice

if __name__ == "__main__":
    desktop = LOffice.connect()
    LOffice.saveAllDocs(desktop)
    LOffice.disposeAllDocs(desktop)
    desktop.terminate()
