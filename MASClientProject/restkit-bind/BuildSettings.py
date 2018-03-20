#!/usr/bin/python

import sys
import traceback
import json
import os
import plistlib

def environmentPlist( env_names, default, key ):
	pl = dict(
    	PreferenceSpecifiers=[
	    dict(
	    	Title = "Choose environment",
    		Type = "PSMultiValueSpecifier",
    		Titles = env_names,
	    	Values = env_names,
    		DefaultValue = default,
    		Key = key
	    )]
	)
	return pl
	
def eventuallyInjectAppSettings(plistFile, name):
	pl = plistlib.readPlist(plistFile)
	found = False
	
	for pref in pl['PreferenceSpecifiers']:
		if ('File' in pref.keys()):
			if (pref['File'] == name):
				if ('Title' in pref.keys()):
					if (pref['Title'] == name):
						found = True
	
	if (found != True):
		pl['PreferenceSpecifiers'].append(dict(
			Type = "PSChildPaneSpecifier",
			File = name,
			Title = name
		))

	plistlib.writePlist(pl, plistFile)
	return

def main():
	try:
		for arg in sys.argv:
			print arg
        
		environmentConfFile = sys.argv[1]
		defaultValue = os.getenv('IK_ENVIRONMENT_DEFAULT', 'STUB') #sys.argv[2]
		plistKey = sys.argv[2]        #sys.argv[3]
		appSettingsFile = sys.argv[3] #sys.argv[4]
		print defaultValue

		path, file = os.path.split(appSettingsFile)
		childPaneFilePath = path + "/" + plistKey + ".plist"

		print childPaneFilePath

		with open(environmentConfFile) as data_file:    
			data = json.load(data_file)

		env_names = []
		for environment in data['configurations']:
			env_names.append(environment['name'])

		print "Writing " + childPaneFilePath
		plistlib.writePlist(environmentPlist(env_names, defaultValue, plistKey), childPaneFilePath)
		eventuallyInjectAppSettings(appSettingsFile, plistKey)

	except KeyboardInterrupt:
		print "Shutdown requested...exiting"


if __name__ == "__main__":
    main()
