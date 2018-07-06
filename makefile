# Diagnostics. Adding '-fsanitize=address' is helpful for most versions of Clang and newer versions of GCC.
#CXXFLAGS += -Wall -fsanitize=undefined
# Link libraries statically
CXXFLAGS += -static -O1 -g -std=c++11
LIBSRC = BitBuffer QrCode QrSegment compressImage sha1 layouts Adafruit_GFX
objects = image.o pbmToCompressed.o compressImage.o BitBuffer.o QrCode.o QrSegment.o sha1.o layouts.o Adafruit_GFX.o
VPATH = qr_code_generator:web:Adafruit-GFX-Library
CXX=g++
CC=gcc
CFLAGS += -static


test: genimg pbmToCompressed
	go build -o web/google/gcal web/google/gcal.go
	rm -rf ../www/test/
	mkdir ../www/test
	mkdir ../www/test/image_data
	mkdir ../www/test/voltage_monitor
	mkdir ../www/test/voltage_monitor/data
	cp -r web/google ../www/test/google
	cp -r web/config ../www/test/config
	cp -r web/device_manager ../www/test/device_manager
	cp web/.htaccess ../www/test/
	cp web/index.html ../www/test/
	cp web/genimg ../www/test/
	cp web/pbmToCompressed ../www/test/
	cp web/get_image.php ../www/test/
	cp web/get_image.sh ../www/test/
	cp web/booked.sh ../www/test/
	cp web/get_png.php ../www/test/
	cp web/rawToPng.sh ../www/test/
	cp web/unix_time.php ../www/test/
	cp web/r.php ../www/test/
	chmod -R g+rw ../www/test

deploy: genimg pbmToCompressed
	go build -o web/google/gcal web/google/gcal.go 
	rm -rf ../www/google
	rm -rf ../www/config
	rm -rf ../www/device_manager
	rm -rf ../www/image_data
	rm -rf ../www/voltage_monitor
	mkdir ../www/image_data
	mkdir ../www/voltage_monitor
	mkdir ../www/voltage_monitor/data
	cp -r web/google ../www/google
	cp -r web/config ../www/config
	cp -r web/device_manager ../www/device_manager
	cp web/.htaccess ../www/
	cp web/index.html ../www/
	cp web/genimg ../www/
	cp web/pbmToCompressed ../www/
	cp web/get_image.php ../www/
	cp web/get_image.sh ../www/
	cp web/booked.sh ../www/
	cp web/get_png.php ../www/
	cp web/rawToPng.sh ../www/
	cp web/unix_time.php ../www/
	cp web/r.php ../www/
	chmod -Rf g+rw ../www

genimg : image.o compressImage.o BitBuffer.o QrCode.o QrSegment.o layouts.o Adafruit_GFX.o
	$(CXX) image.o $(LIBSRC:=.o) $(CXXFLAGS) -o web/genimg

pbmToCompressed : pbmToCompressed.o compressImage.o
	$(CXX) pbmToCompressed.o compressImage.o sha1.o $(CXXFLAGS) -o web/pbmToCompressed

image.o : image.h qr_code_generator/QrCode.hpp layouts.o Adafruit_GFX.o
pbmToCompressed.o : pbmToCompressed.cpp compressImage.cpp compressImage.h
compressImage.o : compressImage.h sha1.o
BitBuffer.o : BitBuffer.hpp
QrCode.o : QrCode.hpp
QrSegment.o : QrSegment.hpp
sha1.o : sha1.h
layouts.o : layouts.h
Adafruit_GFX.o : Adafruit_GFX.h

debug:
	$(CXX) image.cpp $(LIBSRC:=.cpp) $(CXXFLAGS) -g -o web/genimg
	$(CXX) pbmToCompressed.cpp compressImage.cpp $(CXXFLAGS) -g -o web/pbmToCompressed

clean : 
	rm $(objects)
