#!/usr/bin/python3

import uno
import time
import os
import logging

logging.basicConfig(format='%(name)s - %(levelname)s - %(message)s', level=logging.INFO)
logger = logging.getLogger(os.path.basename(__file__))

autosave_time = float(os.environ.get('AUTOSAVE_TIME', 60))

connected = False

while not connected:
    try:
        # Establish a connection with the LO API Service
        logger.debug("Establish connection with LO API")
        localContext = uno.getComponentContext()
        logger.debug("local context ready")
        resolver = localContext.ServiceManager.createInstanceWithContext("com.sun.star.bridge.UnoUrlResolver", localContext)
        logger.debug("resolver ready")
        ctx = resolver.resolve("uno:pipe,name=open365_LO;urp;StarOffice.ComponentContext")
        logger.debug("Component context ready")
        smgr = ctx.ServiceManager
        connected = True
        logger.info('Connected to libreoffice-uno')
    except Exception:
        logger.warning("Could not connect to localhost on port 2002")
        time.sleep(1)

# Get the Libreoffice Desktop
desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)
logger.debug("Desktop ready")

def saveDoc():

	# Get LibreOffice Docs from DESKTOP
	docs = desktop.getComponents()
	#print("components ready")
	enum = docs.createEnumeration()

	# Close each LibreOffice Document instance
	while ( enum.hasMoreElements() ):
	    doc = enum.nextElement()
	    url = doc.getURL()
	    if url and doc.isModified():
	        logger.info("Saving document {0}".format(url))
	        doc.store()
	return

while True:
    saveDoc()
    time.sleep(autosave_time)
