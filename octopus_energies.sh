#!/bin/bash

well=1
while [ $well -lt 49 ]
do

#cd well_$well/static/

ENERGY=`grep 'Total       =' well_$well/static/info | sed 's/^.\{,27\}//'`

KINETIC=`grep 'Kinetic     =' well_$well/static/info  | sed 's/^.\{,27\}//'`

EXTERNAL=`grep 'External    =' well_$well/static/info  | sed 's/^.\{,27\}//'`

HARTREE=`grep 'Hartree     =' well_$well/static/info | sed 's/^.\{,27\}//'`

EXCHANGE=`grep 'Exchange    =' well_$well/static/info | sed 's/^.\{,27\}//'`

CORRELATION=`grep 'Correlation =' well_$well/static/info | sed 's/^.\{,27\}//'`


table=$(paste <(echo "$well") <(echo " ") <(echo "$ENERGY") <(echo " ")  <(echo "$KINETIC")  <(echo " ")  <(echo "$EXTERNAL")  <(echo " ")   <(echo "$HARTREE") <(echo " ")   <(echo "$EXCHANGE") <(echo " ")  <(echo "$CORRELATION"))
echo "$table" >> txt.sie



well=$(($well+1))
done

sed -i -e '1 i\ DEEPNESS //  ENERGY(REAL,IMAGINARY) // KINETIC // EXTERNAL //  HARTREE //  EXCHANGE // CORRELATION' txt.sie
