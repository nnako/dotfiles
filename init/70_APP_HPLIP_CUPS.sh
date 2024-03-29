# https://www.ramoonus.nl/2017/05/21/installing-hplip-for-cups-on-a-raspberry-pi/




#
# install CUPS together wirh HPLIP for HP printers
#

# If you have a HP printer or scanner and you want to be able to use it on your
# Raspberryi Pi running the Raspbian operating system, you`ll have to install
# HP Linux Imaging and Printing and CUPS.

sudo apt update
sudo apt install hplip cups
sudo usermod -a -G lpadmin pi

# user instructions
echo ''
echo ''
echo '##############################'
echo ''
echo 'IN ORDER TO COMPLETELY SETUP CUPS,'
echo 'PLEASE MAKE SURE TO DO THE FOLLOWING'
echo 'ACTIONS:'
echo ''
echo '$ sudo cupsctl --remote-any'
echo '$ sudo /etc/init.d/cups restart'
echo ''
echo 'then open http://192.168.1.<?>:631 using web browser'
echo 'and go to tab "Drucker", recognize printer / scanner,'
echo 'click on printer name, then "Verwaltung" and lastly,'
echo '"Als Standarddrucker festlegen". this is the same as'
echo 'issuing "$ lpoptions -d Officejet_Pro_8600".'
echo ''
echo 'now, connect local drivers to printer via its ip'
echo ''
echo '$ hp-setup -i 192.168.1.48'
echo ''
echo '##############################'
echo ''
echo ''

# now, the SCANNER should work

# user instructions
echo ''
echo ''
echo '##############################'
echo ''
echo 'IN ORDER TO COMPLETELY SETUP IMAGEMAGICK'
echo 'AND ITS CONVERT FUNCTION, THE FOLLOWING'
echo 'MODIFICATIONS HAVE TO BE MADE:'
echo ''
echo '1. open the convert configuration file:'
echo ''
echo '$ sudo vim /etc/ImageMagick-6/policy.xml'
echo ''
echo '2. comment out the one uncommented line'
echo '   containing "PDF"'
echo ''
echo '3. save XML file'
echo ''
echo '##############################'
echo ''
echo ''

# now, the convert function should not throw an error




#
# install SANE scanner control software
#

sudo apt install sane
#sudo sane-find-scanner

# the specific scanner should now be found




#
# create some scanner scripts
#

# ADF A4 BW 200dpi DS
FILEPATH=/home/pi/scan_feed_A4_200dpi_bw_ds.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    pdf_filename=$2
else
    pdf_filename=scan
fi




#
# wait for user to place the document stack
#

read -p "PLEASE PUT PAGES WITH CONTENT FACING UP INTO THE FEEDER" -n1




#
# scan front pages in forward sequence
#

# unfortunately, when using ADF, the current implementation of SCANADF
# mismatches the PNM output in the way that subsequent tools like imagemagick
# cannot identify the necessaty file format. this seems to be the case when
# scanning with a y range of about 295 mm when more than 1 page is scanned.
# when scanning at a slightly lower y range, this effect is not visible anymore.
# so, instead of using the full range of 210x295 mm for a DIN A4 page, here,
# a reduced range of 210x291 mm is used.

scanadf --source=ADF --mode=Lineart --resolution=200 -x 210 -y 291 -o /home/pi/scan_%02d.pnm




#
# convert all scanned pages to PNG and rename files
#

let filecount=1
let maxfilecount=0
filenames=`ls ./*.pnm`
for f in $filenames; do

    # create basename
    filename=${f##*/}
    basename=${filename%%.*}
    echo "$f -> scan_$(printf %02d $filecount).png"

    # convert image and remove original file
    convert $f scan_$(printf %02d $filecount).png
    rm $f

    # counters
    let maxfilecount=$maxfilecount+1
    let filecount=$filecount+2

done




#
# wait for user to place the document stack
#

read -p "PLEASE PUT PAGES WITH CONTENT TOP FACING DOWN INTO THE FEEDER" -n1




#
# scan back pages in forward sequence
#

# unfortunately, when using ADF, the current implementation of SCANADF
# mismatches the PNM output in the way that subsequent tools like imagemagick
# cannot identify the necessaty file format. this seems to be the case when
# scanning with a y range of about 295 mm when more than 1 page is scanned.
# when scanning at a slightly lower y range, this effect is not visible anymore.
# so, instead of using the full range of 210x295 mm for a DIN A4 page, here,
# a reduced range of 210x291 mm is used.

scanadf --source=ADF --mode=Lineart --resolution=200 -x 210 -y 291 -o /home/pi/scan_%02d.pnm




#
# convert all scanned pages to PNG and rename files
#

let filecount=$maxfilecount*2
filenames=`ls ./*.pnm`
for f in $filenames; do

    # create basename
    filename=${f##*/}
    basename=${filename%%.*}
    echo "$f -> scan_$(printf %02d $filecount).png"

    # convert image and remove original file
    convert $f scan_$(printf %02d $filecount).png
    rm $f

    # counters
    let filecount=$filecount-2

done




#
# convert to PDF
#

convert scan_*.png $pdf_filename.pdf
rm scan_*.png

# move into nextcloud
mv $pdf_filename.pdf ~/NEXTCLOUD/_scan/
EOF
sudo chmod a+x ${FILEPATH}

# ADF A4 BW 200dpi SS
FILEPATH=/home/pi/scan_feed_A4_200dpi_bw_ss.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    pdf_filename=$2
else
    pdf_filename=scan
fi




#
# wait for user to place the document stack
#

read -p "PLEASE PUT PAGES WITH CONTENT FACING UP INTO THE FEEDER" -n1




#
# scan front pages in forward sequence
#

# unfortunately, when using ADF, the current implementation of SCANADF
# mismatches the PNM output in the way that subsequent tools like imagemagick
# cannot identify the necessaty file format. this seems to be the case when
# scanning with a y range of about 295 mm when more than 1 page is scanned.
# when scanning at a slightly lower y range, this effect is not visible anymore.
# so, instead of using the full range of 210x295 mm for a DIN A4 page, here,
# a reduced range of 210x291 mm is used.

scanadf --source=ADF --mode=Lineart --resolution=200 -x 210 -y 291 -o /home/pi/scan_%02d.pnm




#
# convert all scanned pages to PNG and rename files
#

let filecount=1
filenames=`ls ./*.pnm`
for f in $filenames; do

    # create basename
    filename=${f##*/}
    basename=${filename%%.*}
    echo "$f -> scan_$(printf %02d $filecount).png"

    # convert image and remove original file
    convert $f scan_$(printf %02d $filecount).png
    rm $f

    # counters
    let filecount=$filecount+1

done




#
# convert to PDF
#

convert scan_*.png $pdf_filename.pdf
rm scan_*.png

# move into nextcloud
mv $pdf_filename.pdf ~/NEXTCLOUD/_scan/

EOF
sudo chmod a+x ${FILEPATH}

# ADF A5 COLOR 100dpi SS
FILEPATH=/home/pi/scan_flat_A5_100dpi_color.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wished number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Color --resolution=100 -x 148 -y 210 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Color --resolution=100 -x 148 -y 210 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/
fi
EOF
sudo chmod a+x ${FILEPATH}

# FLAT A5 LANDSCAPE BW 200dpi DARK
FILEPATH=/home/pi/scan_flat_A5L_200dpi_bw_dark.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wish of number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Lineart --resolution=200 --brightness=100 --contrast=300 -x 210 -y 148 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Lineart --resolution=200 --brightness=700 -x 210 -y 148 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

fi
EOF
sudo chmod a+x ${FILEPATH}




# FLAT A5 BW 200dpi DARK
FILEPATH=/home/pi/scan_flat_A5_200dpi_bw_dark.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wish of number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Lineart --resolution=200 --brightness=100 --contrast=300 -x 148 -y 210 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Lineart --resolution=200 --brightness=100 --contrast=300 -x 148 -y 210 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

fi
EOF
sudo chmod a+x ${FILEPATH}




# FLAT A4 PORTRAIT BW 200dpi
FILEPATH=/home/pi/scan_flat_A4_200dpi_bw.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wished number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Lineart --resolution=200 -x 210 -y 295 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Lineart --resolution=200 -x 210 -y 295 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/
fi
EOF
sudo chmod a+x ${FILEPATH}

# FLAT A5 PORTRAIT BW 200dpi
FILEPATH=/home/pi/scan_flat_A5_200dpi_bw.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wish of number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Lineart --resolution=200 -x 148 -y 210 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Lineart --resolution=200 -x 148 -y 210 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

fi
EOF
sudo chmod a+x ${FILEPATH}

# FLAT A5 LANDSCAPE BW 200dpi
FILEPATH=/home/pi/scan_flat_A5L_200dpi_bw.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wish of number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Lineart --resolution=200 -x 210 -y 148 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Lineart --resolution=200 -x 210 -y 148 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

fi
EOF
sudo chmod a+x ${FILEPATH}

# FLAT A6 PORTRAIT BW 200dpi
FILEPATH=/home/pi/scan_flat_A6_200dpi_bw.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wish of number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Lineart --resolution=200 -x 105 -y 148 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Lineart --resolution=200 -x 105 -y 148 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

fi
EOF
sudo chmod a+x ${FILEPATH}

# FLAT A6 LANDSCAPE BW 200dpi
FILEPATH=/home/pi/scan_flat_A6L_200dpi_bw.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wish of number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Lineart --resolution=200 -x 148 -y 105 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Lineart --resolution=200 -x 148 -y 105 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

fi
EOF
sudo chmod a+x ${FILEPATH}

# FLAT A4 PORTRAIT COLOR 200dpi
FILEPATH=/home/pi/scan_flat_A4_200dpi_color.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wished number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Color --resolution=200 -x 210 -y 295 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Color --resolution=200 -x 210 -y 295 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/
fi
EOF
sudo chmod a+x ${FILEPATH}

# FLAT A4 PORTRAIT COLOR 100dpi
FILEPATH=/home/pi/scan_flat_A4_100dpi_color.sh
cat > ${FILEPATH} <<'EOF'
#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wished number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Color --resolution=100 -x 210 -y 295 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Color --resolution=100 -x 210 -y 295 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/
fi
EOF
sudo chmod a+x ${FILEPATH}
