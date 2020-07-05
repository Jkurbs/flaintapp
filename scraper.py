import requests
import sys
import shutil
import re
import threading
from bs4 import BeautifulSoup as soup 
import os

THREAD_COUNTER = 0
THREAD_MAX     = 5

def get_source( link ):
    r = requests.get( link )
    if r.status_code == 200:
        return soup( r.text )
    else:
        sys.exit( "[~] Invalid Response Received." )

def filter( html ):
    imgs = html.findAll( "img" )
    if imgs:
        return imgs
    else:
        sys.exit("[~] No images detected on the page.")


def requesthandle( link, name ):
    global THREAD_COUNTER
    THREAD_COUNTER += 1

    if not os.path.exists('Realism/'): #check if the folder is exist 
        os.mkdir('Realism/') # if not let create one xD
    try:
        r = requests.get( link, stream=True )
        if r.status_code == 200:
            r.raw.decode_content = True
            f = open( "Realism/"+str(name) , "wb" ) # And here change where the file will be saved xD
            shutil.copyfileobj(r.raw, f)
            f.close()
            print ("[*] Downloaded Image: %s" % name)
    except Exception as error:
        print ("[~] Error Occured with %s : %s" % (name, error))
    THREAD_COUNTER -= 1

def main():
    for page in range(20):
        html = get_source("https://www.saatchiart.com/all?page=" + str(page) + "&query=realism")
        tags = filter( html )
        for tag in tags:
            src = tag.get( "src" )
            if src:
                src = re.match( r"((?:https?:\/\/.*)?\/(.*\.(?:png|jpg)))", src )
                if src:
                    (link, name) = src.groups()
                    if not link.startswith("http"):
                        link = "https://www.saatchiart.com" + link
                    _t = threading.Thread( target=requesthandle, args=(link, name.split("/")[-1]) )
                    _t.daemon = True
                    _t.start()

                    while THREAD_COUNTER >= THREAD_MAX:
                        pass

    while THREAD_COUNTER > 0:
        pass

    while THREAD_COUNTER > 0:
        pass

if __name__ == "__main__":
    main()