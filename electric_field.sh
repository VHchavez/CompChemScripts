	


	#!/bin/bash
	
#Cool script for applying electric field to a system 	
#The script run a desired (iterative) calculation (scf/relax/vc-relax) and after it it calculates their respective bands.
#
#The input requires three things:
#
#1.- SCF/Relax Calculation 
#2.- Bands Calculation
#3.- Bands Plot Input
#
#All three inputs must be copied into the input under the {createrelax(), createbands(), createbands.in()} statements.
#(Both outdir address and prefix name must be the same). 
#
#
#In order to perform calculations using an electric field, the following flags must be activated:
#
#&control
#	tefield=.true. 
# 		This turns the Electric Field on as a sawlike potential (it is defined by: 'edir', 'eamp', 'emaxpos, 'eopreg').
#
#	dipfield=.true.
#		Does a dipole correction according to L. Bengtsson, PRB 59, 12301 (1999) (Turn it on while dealing with slab geometries).
#
#
#&system
#	edir = {1,2,3}
#		Direction of the electric field (1=x, 2,=y, z=3), depending on how the basis vectors are defined. 
#	eamp = {Real number}
#		Slope of the potential in Hartrees. Since the Field is the Gradient of the Potential, this constants determines the magnitud of the 
#		electric field.  (1 Hartree = 51.4220632*10^10 V/m = 514.220632 V/nm)
#	emaxpos = {Real number from 0 to 1}
#	eopreg  = {Real number from 0 to 1}
#		This two flags work together, the first 'emaxpos', will determine where (on percentage) in the cell the maximum of the tooth of the
#		sawlike potential occurrs (try placing it around 0.8). Eopreg determines where (on percentage) in the cell the structure is placed
#		the structure MUST BE PLACED in such a way that it is not near any of the change of slope (when the sawlike potential is not differentiable)
#		Try sketching the potential within the box of simulation. It gives a good idea of how the parameters must be selected.   
#
#	
#	
#Everything else is done according to the usual QE inputs. 
#
#BANDS INPUT:
#
#&bands
# prefix=' ',
# outdir=' ',
# filband=' ',
# lsym=.true.
#/
	


	createrelax()
	{
	  cat > bcke-${field}-relax.in << END 
&control
   calculation='vc-relax',
   title = 'Arsenene Buckled Bands Under Efield', 
   restart_mode = 'from_scratch',
   wf_collect = .TRUE.,
   nstep = 50,
   tefield = .true.,
   dipfield = .true.,
   tstress = .TRUE.,
   tprnfor = .TRUE.,
   outdir = '/home/vh/espresso/temporal',
   prefix = 'bcke-${field}-moved',
   etot_conv_thr = 5.0D-5,
   forc_conv_thr = 1.0D-3,
   disk_io = 'medium',
   pseudo_dir = '/home/vh/pseudo/espresso/',
/
&system
  ibrav = 0,
  a= 3.607,
  nat= 2,
  nbnd = 30,
  ntyp = 1,
  tot_charge = 0.0,
  ecutwfc = ${ecutwfc},
  ecutrho = ${ecutrho},
  noncolin = .true.,
  occupations = 'smearing',
  degauss = 0.01,
  smearing = 'm-p',
  edir = 3, 
  emaxpos = 0.8,
  eopreg = 0.2,
  eamp = ${amp},     
/
&electrons
   electron_maxstep = 800,
   conv_thr = 1.D-6,
   mixing_beta = 0.3D0, 
   mixing_mode = 'local-TF',
   diagonalization = 'david',
/
&ions
/
&cell
/


ATOMIC_SPECIES
As	74.9216 As.pbe-n-van.UPF

ATOMIC_POSITIONS {angstrom}
As     0.000      0.000     8.30565
As     1.0412     1.8035    9.69435

K_POINTS {automatic}
31 31  1  0 0 0
#4
#Gamma-K-M-gamma
#0.0000    0.0000     0.0000     100
#0.57735   0.33333    0.0000     100
#0.57735   0.0000     0.0000     100
#0.0000    0.0000     0.0000     0

CELL_PARAMETERS {alat}
   0.0      1.0        0.0
   0.866    -0.5       0.0
   0.0000   0.0000     5.0
END
}


	createbands()
	{
	  cat > bcke-${field}-bands.in << END 
&control
   calculation='bands',
   title = 'Arsenene Buckled Bands Under Efield', 
   restart_mode = 'from_scratch',
   wf_collect = .TRUE.,
   nstep = 1,
   tefield = .true.,
   dipfield = .true.,
   tstress = .TRUE.,
   tprnfor = .TRUE.,
   outdir = '/home/vh/espresso/temporal',
   prefix = 'bcke-${field}-moved',
   etot_conv_thr = 5.0D-5,
   forc_conv_thr = 1.0D-3,
   disk_io = 'medium',
   pseudo_dir = '/home/vh/pseudo/espresso/',
/
&system
  ibrav = 0,
  a= 3.607,
  nat= 2,
  nbnd = 30,
  ntyp = 1,
  tot_charge = 0.0,
  ecutwfc = ${ecutwfc},
  ecutrho = ${ecutrho},
  noncolin = .true.,
  occupations = 'smearing',
  degauss = 0.01,
  smearing = 'm-p',
  edir = 3, 
  emaxpos = 0.8,
  eopreg = 0.2,
  eamp = ${amp},   
/
&electrons
   electron_maxstep = 800,
   conv_thr = 1.D-6,
   mixing_beta = 0.3D0, 
   mixing_mode = 'local-TF',
   diagonalization = 'david',
/
&ions
/
&cell
/


ATOMIC_SPECIES
As	74.9216 As.pbe-n-van.UPF

ATOMIC_POSITIONS {angstrom}
As     0.000      0.000     8.30565
As     1.0412     1.8035    9.69435

K_POINTS {tpiba_b}
#31 31  1  0 0 0
4
#Gamma-K-M-gamma
0.0000    0.0000     0.0000     100
0.57735   0.33333    0.0000     100
0.57735   0.0000     0.0000     100
0.0000    0.0000     0.0000     0

CELL_PARAMETERS {alat}
   0.0      1.0        0.0
   0.866    -0.5       0.0
   0.0000   0.0000     5.0
END
}

	createbandsin()
        {
          cat > bands.in << END

&bands
 prefix='bcke-${field}-moved',
 outdir='/home/vh/espresso/temporal',
 filband='bcke-${field}-bands.dat',
 lsym=.true.
/
END
}
           
 
	ecutwfc=30
	ecutrho=120
        field=80

	echo "We gettin yo basis ready..."


while [ $field -lt 81 ] ;
do
	
        mkdir ${field}
        cd ${field}
         
        amp=$(echo "scale=6; ${field}/(514220632/100000)" | bc)
        
        createrelax
	mpirun -np 8 /usr/local/bin/espresso-5.2.0/PW/src/pw.x <bcke-${field}-relax.in> bcke-${field}-relax.out

        createbands
	mpirun -np 8 /usr/local/bin/espresso-5.2.0/PW/src/pw.x <bcke-${field}-bands.in> bcke-${field}-bands.out
        createbandsin
      
        mpirun -np 8 /usr/local/bin/espresso-5.2.0/bin/bands.x <bands.in> bands.out
         

        cd .. 
        field=$((field+3))      	        
        done
echo "Afiet Olsun"
