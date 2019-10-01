	


	#!/bin/bash
	#Cool script for applying electric field to a system 


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
