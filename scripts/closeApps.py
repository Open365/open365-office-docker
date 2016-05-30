#!/usr/bin/python3

import uno;
from subprocess import call;
from os.path import expanduser;

def connectAndDestroy():

	try:
		# Establish a connection with the LO API Service
		print("Establish connection with LO API");
		localContext = uno.getComponentContext();
		print("local context ready");
		resolver = localContext.ServiceManager.createInstanceWithContext("com.sun.star.bridge.UnoUrlResolver", localContext);
		print("resolver ready");
		ctx = resolver.resolve("uno:pipe,name=open365_LO;urp;StarOffice.ComponentContext");
		print("Component context ready");
		smgr = ctx.ServiceManager;
	except Exception:
		print("Could not connect to localhost")
		return;

	print("services names:" + str(smgr.getAvailableServiceNames()));

	# Get the Libreoffice Desktop
	desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx);
	print("Desktop ready");
	#frame = smgr.createInstanceWithContext("com.sun.star.frame.Frame", ctx);
	#frame = desktop.getCurrentFrame();

	# Get LibreOffice Docs from DESKTOP
	docs = desktop.getComponents();
	print("components ready");
	enum = docs.createEnumeration();

	# Close each LibreOffice Document instance
	while ( enum.hasMoreElements() ):
		print("Disposing an element");
		doc = enum.nextElement();
		url = doc.getURL();
		if url and doc.isModified():
			print("URL: " + str(url));
			doc.store();
		doc.dispose();
		print("Element disposed");

	# Close the LibreOffice DESKTOP
	desktop.terminate();
	print("Terminating desktop");

	return;

connectAndDestroy();
