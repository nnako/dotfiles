# https://www.ramoonus.nl/2017/05/21/installing-hplip-for-cups-on-a-raspberry-pi/




# Installing HPLIP for CUPS on a Raspberry Pi

# If you have a HP printer or scanner and you want to be able to use it on your
# Raspberryi Pi running the Raspbian operating system, you`ll have to install
# HP Linux Imaging and Printing and CUPS.

sudo apt-get update
sudo apt-get install hplip cups
sudo usermod -a -G lpadmin pi

# In a browser, on the raspberry pi you can now access the CUPS configuration
# screen at http://127.0.0.1:631/




# If you also would like to use your MFP/scanner

sudo apt-get install sane
sudo sane-find-scanner




# The configuration and applications are up to you, the requirements are now installed.
