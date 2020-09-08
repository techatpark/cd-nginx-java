import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import sys
import os

import re

# test_string = 'a1b2cdefg'




class Watcher:
    DIRECTORY_TO_WATCH = sys.argv[1] 

    def __init__(self):
        self.observer = Observer()

    def run(self):
        event_handler = Handler()
        self.observer.schedule(event_handler, self.DIRECTORY_TO_WATCH, recursive=True)
        self.observer.start()
        try:
            while True:
                time.sleep(5)
        except:
            self.observer.stop()
            print ("Error")

        self.observer.join()


class Handler(FileSystemEventHandler):

    @staticmethod
    def on_any_event(event):
        # print (event)
        if event.is_directory:
            return None

        elif event.event_type == 'created':
            # Taken any action here when a file is modified or created.
            print ("Received modified event - %s." % event.src_path)
            # rename here your bash file path
            os.system("bash /home/aravind/personal/cd-nginx-java/deploy.sh %s %s %s " %(sys.argv[2],sys.argv[3], sys.argv[1]))
            
if __name__ == '__main__':

    w = Watcher()
    w.run()