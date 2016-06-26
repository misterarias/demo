echo "Construimos los contenedores"
cd db && ./build.sh
cd ../server && ./build.sh
cd ../tsung && ./build.sh
