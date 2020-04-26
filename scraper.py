import requests
import sys
import shutil
import re
import threading
from bs4 import beautifulSoup4 as soup 
import os

THREAD_COUNTER = 0
THREAD_MAX     = 5

def requesthandle( link, name ):
    global THREAD_COUNTER
    THREAD_COUNTER += 1

    if not os.path.exists('/Realism'): #check if the folder is exist 
        os.makedir('/Realism') # if not let create one xD
    try:
        r = requests.get( link, stream=True )
        if r.status_code == 200:
            r.raw.decode_content = True
            f = open( "/Realism/"+str(name) , "wb" ) # And here change where the file will be saved xD
            shutil.copyfileobj(r.raw, f)
            f.close()
            print ("[*] Downloaded Image: %s" % name)
    except Exception as error:
        print ("[~] Error Occured with %s : %s" % (name, error))
    THREAD_COUNTER -= 1

def main():
    html = get_source( "https://www.drivespark.com/wallpapers/" )
    tags = filter( html )
    for tag in tags:
        src = tag.get( "src" )
        if src:
            (link, name) = re.match( r"((?:https?:\/\/.*)?\/(.*\.(?:png|jpg)))", src )
            if link:
                if not link.startswith("http"):
                    link = "https://www.drivespark.com" + link
                _t = threading.Thread( target=requesthandle, args=(link, name.split("/")[-1]) )
                _t.daemon = True
                _t.start()

                while THREAD_COUNTER >= THREAD_MAX:
                    pass

    while THREAD_COUNTER > 0:
        pass

if __name__ == "__main__":
    main()