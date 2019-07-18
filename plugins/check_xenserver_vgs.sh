#!/bin/sh

#set -xv


CRITICAL=10
WARNING=20

if [ -z $1 ] 
then
  
  vgs --noheadings -o vg_name
  exit 3

else

  VOLUMES=$1

fi

convert() { 

	sed -e s/'\...T'/000G/ $1 | sed -e s/'\...G'/G/ | sed -e s/G// | sed -e s/' '//

}

getSize() {

	if [ -z $1 ]
	then
		echo "Use: $0 vg_name"
		return 1
	fi	

	vgs --noheadings -o vg_size $1

}

getFree() {

	if [ -z $1 ]
        then
                echo "Use: $0 vg_name"
                return 1
        fi

        vgs --noheadings -o vg_free $1  


}


check() {

	if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]
	then
		echo -n "Use: $0 free size vg"
		return 3
	fi

	
	RESULT=`echo "$1 / $2 * 100" | bc -l | cut -d . -f 1 | sed s/^$/0/`

	if [ $RESULT -le $CRITICAL ]; then
		echo -n "Critical: $3 is $RESULT % free | value=$RESULT"
		return 2
	fi

	if [ $RESULT -le $WARNING ]; then
		echo -n "Warning: $3 is $RESULT % free | value=$RESULT"
		return 1
	fi

	if [ $RESULT -gt $WARNING ]; then
		echo -n "OK: $3 is $RESULT % free | value=$RESULT "
		return 0
	else 
		echo -n "Unknow: $3 is $RESULT % free | value=$RESULT "
		return 3
	fi

}

for volume in $VOLUMES
do

    SIZE=`getSize $volume | convert`
	
	FREE=`getFree $volume | convert`
	
	OUTPUT=`check $FREE $SIZE $volume`
	
	EXIT=$?
	
	echo $OUTPUT
	
	exit $EXIT

done


