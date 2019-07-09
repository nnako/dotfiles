# https://www.ramoonus.nl/2017/05/21/installing-hplip-for-cups-on-a-raspberry-pi/




#
# install CUPS together wirh HPLIP for HP printers
#

# If you have a HP printer or scanner and you want to be able to use it on your
# Raspberryi Pi running the Raspbian operating system, you`ll have to install
# HP Linux Imaging and Printing and CUPS.

sudo apt-get update
sudo apt-get install hplip cups
sudo usermod -a -G lpadmin pi

# In a browser, on the raspberry pi you can now access the CUPS configuration
# screen at http://127.0.0.1:631/




#
# install SANE scanner control software
#

sudo apt-get install sane
sudo sane-find-scanner




#
# create some scanner scripts
#

# ADF A4 BW 200dpi SS
FILEPATH=/home/pi/scan_feed_A4_200dpi_bw_ss.sh
cat > ${FILEPATH} <<EOF
# scan original
scanadf --source=ADF --mode=Lineart --resolution=200 -x 210 -y 295 -o /home/pi/scan_%02d.pnm

# convert to PNG
convert scan_*.pnm scan_*.png
rm scan_*.pnm

# convert to PDF
convert scan_*.png scan.pdf
rm scan_*.png

# move into nextcloud
mv scan.pdf ~/NEXTCLOUD/_scan/

EOF
sudo chmod a+x ${FILEPATH}

# FLAT A4 BW 200dpi
FILEPATH=/home/pi/scan_flat_A4_200dpi_bw.sh
cat > ${FILEPATH} <<EOF
# scan original
scanimage --mode=Lineart --resolution=200 -x 210 -y 295 >/home/pi/scan.pnm

# convert to PNG
convert scan.pnm scan.png
rm scan.pnm

# convert to PDF
convert scan.png scan.pdf
rm scan.png

# move into nextcloud
mv scan.pdf ~/NEXTCLOUD/_scan/

EOF
sudo chmod a+x ${FILEPATH}

# FLAT A5 BW 200dpi
FILEPATH=/home/pi/scan_flat_A5_200dpi_bw.sh
cat > ${FILEPATH} <<EOF
# scan original
scanimage --mode=Lineart --resolution=200 -x 148 -y 210 >/home/pi/scan.pnm

# convert to PNG
convert scan.pnm scan.png
rm scan.pnm

# convert to PDF
convert scan.png scan.pdf
rm scan.png

# move into nextcloud
mv scan.pdf ~/NEXTCLOUD/_scan/

EOF
sudo chmod a+x ${FILEPATH}

