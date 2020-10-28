import os

#clears the screen independent of OS
def clear():
    if (os.sys.platform == 'win32'):
        os.system('cls')
    elif (os.sys.platform == 'linux'):
        os.system('clear')
    else:
        raise RuntimeError('System not supported')