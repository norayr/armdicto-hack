#need to build hack
make

#getting armdicto

wget http://users.freenet.am/~osprog1/ArmDicto%20v1.1.rar

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
# 002170AB is 2191531
replaceByte maintest.dat 2191531 111 

# 002dc5d3 is 2999763
replaceByte maintest.dat 2999763 111

# word flance ends with strange b0 instead of 00,
# 001bb24c is 1815116
replaceByte maintest.dat 1815116 0


#running hack

./armdicto

#preparing dict
stardict_dictbuilder -o test out.txt

