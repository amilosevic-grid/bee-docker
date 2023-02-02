
apt-get install axel
axel -o parcel-install.tgz -n 4 https://archive.cloudera.com/cdh7/7.1.7.0/parcels/CDH-7.1.7-1.cdh7.1.7.p0.15945976-el7.parcel
mkdir parcel
tar xzvf parcel-install.tgz --directory=parcel --strip 1 
mv parcel/jars ./jars