


		#!/bin/bash
		#Cool script for modyfing rotations in a given input. 



		createinput()
		{  cat > inp << END

ExperimentalFeatures = yes


CalculationMode = gs
TheoryLevel = dft
XCFunctional = lda_xc_cmplx

ComplexScaling = space
ComplexScalingTheta = ${theta}
MixingScheme = linear

#______________________________


Dimensions = 2

BoxShape = parallelepiped
Lsize = 8
Spacing = 0.1

Output = wfs
OutputFormat = plane_z
#______________________________

%Species
  "helium" | species_user_defined | potential_formula | "-2/(1+x^2)^(1/2)-2/(1+y^2)^(1/2)+1/(1+(x-y)^2)^(1/2)" | valence | 1
%

%Coordinates
  "helium"| 0 | 0
%

Debug = 1

END
}


	theta=0
	counter=0
        MaxCounter=17

	
	MaximumTheta=$(echo "scale=6; 7854/10000" | bc)


while [ $counter -lt $MaxCounter ]
do

	echo "------------------------Brewing...----------------------"
        echo "---------------I'm doing the $theta rotation------------"
	mkdir rot$theta
	cd rot$theta

	createinput
	octopus > out

        cd static/
	awk -v var="$theta" '/Total       =/ {print var,$3,$4}' info >> ../../angles.txt
	cd ../../

        counter=$((counter+1))
	theta=`bc -l <<< "scale=6; $theta + 0.05"`

done

echo "Provecho" 
