
yum install -y zlib-devel bzip2-devel openssl-devel xz-libs xz

wget http://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz
tar xf Python-2.7.9.tar.xz

cd Python-2.7.9
./configure --prefix=/usr/local
make && make install
test -f /usr/local/bin/python && rm -f /usr/local/bin/python
ln -s /usr/local/bin/python2.7 /usr/local/bin/python

wget --no-check-certificate https://bootstrap.pypa.io/ez_setup.py -O - | python
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py -O - | python

