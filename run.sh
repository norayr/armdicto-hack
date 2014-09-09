#prerequisites
# gnu coreutils	- standnard gnu file utilities
# bash		- the standard gnu bourne again shell
# wget		- network utility to retrieve files from www
# rar		- rar compressor/uncompressor
# unshield	- installshieald cab file extractor
# gnu make	- standard tool to compile source trees
# voc 		- vishap oberon compiler
# stardict	- international dictionary supporting fuzzy and glob style matching

# stardict is not necessary to use produced dictionaries.
# many other dictionaries support produced format.
# stardict is necessary in order to produce dictionary files.
# we use stardict_tabfile utility in order to convert generated tab separated file
# into dictionary form.

# in order to get stardict_tabfile on Gentoo like systems
# one needs to emerge stardict with "tools" USE flag set.


#need to build hack
make

#getting armdicto

wget -c http://users.freenet.am/~osprog1/ArmDicto%20v1.1.rar

#unrar
rar x "ArmDicto v1.1.rar"


cp ArmDicto1.1/data1.cab .

# cabextract
unshield x data1.cab
cp Program_Executable_Files/Data/main.dat .
cp main.dat maintest.dat

function replaceByte() {
    printf "$(printf '\\x%02X' $3)" | dd of="$1" bs=1 seek=$2 count=1 conv=notrunc &> /dev/null
        }
#fixing bugs in maintest.dat
# let me explain this. the word gobble contained incorrect "o", not latin, but ARMSCII armenian letter o for some reason. 
#That's why even stock armdicto was unable to show that translation. 
#fixing bf with 6f (111) - to the real ASCII o letter.
# 002170AB is 2191531
replaceByte maintest.dat 2191531 111 
#same here, instead of latin o, armscii o by mistake
# 002dc5d3 is 2999763
replaceByte maintest.dat 2999763 111

# word flance ends with strange b0 instead of 00,
# 001bb24c is 1815116
replaceByte maintest.dat 1815116 0


#running hack

./armdictohack

#removing duplicate entries
cat out.txt | sort | uniq > armdicto.txt

#preparing dict
stardict_tabfile armdicto.txt

# move to new directory
mkdir -p armdicto
mv armdicto.dict armdicto.idx armdicto.ifo armdicto

#clean
make clean
#rm ArmDicto v1.1.rar
rm -rf ArmDicto1.1 fonts Program_Executable_Files data1.cab out.txt main.dat maintest.dat armdictohack
#rm armdicto.txt
