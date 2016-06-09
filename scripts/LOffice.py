#!/usr/bin/python3

import uno
import time
import os
import logging

logging.basicConfig(format='%(name)s - %(levelname)s - %(message)s', level=logging.INFO)
logger = logging.getLogger(os.path.basename(__file__))

autosave_time = float(os.environ.get('AUTOSAVE_TIME', 60))

def connect():

    while True:
        try:
            logger.debug("Establish connection with LO API")
            localContext = uno.getComponentContext()
            logger.debug("local context ready")
            resolver = localContext.ServiceManager.createInstanceWithContext("com.sun.star.bridge.UnoUrlResolver", localContext)
            logger.debug("resolver ready")
            ctx = resolver.resolve("uno:pipe,name=open365_LO;urp;StarOffice.ComponentContext")
            logger.debug("Component context ready")
            logger.info('Connected to libreoffice-uno')
            smgr = ctx.ServiceManager
            # Get the Libreoffice Desktop
            desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)
            logger.debug("Desktop ready")

            return desktop

        except Exception:
            logger.warning("Could not connect to LibreOffice")
            time.sleep(1)

def saveAllDocs(desktop):

    # Get LibreOffice Docs from DESKTOP
    docs = desktop.getComponents()
    enum = docs.createEnumeration()

    # Close each LibreOffice Document instance
    while ( enum.hasMoreElements() ):
        doc = enum.nextElement()
        url = doc.getURL()
        if url and doc.isModified():
            logger.info("Saving document {0}".format(url))
            doc.store()
    return

def disposeAllDocs(desktop):
    docs = desktop.getComponents()
    enum = docs.createEnumeration()

    while (enum.hasMoreElements()):
        doc = enum.nextElement()
        doc.dispose()
