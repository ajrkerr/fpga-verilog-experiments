watch:
	fswatch -0 *.v | xargs -0 -n 1 -I {} sh -c "basename {} | sed 's/.v//' | cat" | xargs -n 1 -I {} sh -c "./build.sh {}; date"

check-usb:
	kextstat | grep FTDIUSBSerialDriver

remove-usb:
	sudo kextunload -b com.FTDI.driver.FTDIUSBSerialDriver
	sudo kextunload -b com.apple.driver.AppleUSBFTDI
