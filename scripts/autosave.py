#!/usr/bin/python3

import uno
import time
import os

new_document_name = "untitled-document"
default_folder = "/home/user/files/"
autosave_time = float(os.environ.get('AUTOSAVE_TIME', 60))

connected = False

while not connected:
    try:
        # Establish a connection with the LO API Service
        print("Establish connection with LO API")
        localContext = uno.getComponentContext()
        print("local context ready")
        resolver = localContext.ServiceManager.createInstanceWithContext("com.sun.star.bridge.UnoUrlResolver", localContext)
        print("resolver ready")
        ctx = resolver.resolve("uno:socket,host=localhost,port=2002;urp;StarOffice.ComponentContext")
        print("Component context ready")
        smgr = ctx.ServiceManager
        connected = True
    except Exception:
        print("Could not connect to localhost on port 2002")
        time.sleep(1)

# Get the Libreoffice Desktop
desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)
print("Desktop ready")

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
	        print("URL: " + str(url))
	        doc.store()
	return

while True:
    saveDoc()
    time.sleep(autosave_time)
