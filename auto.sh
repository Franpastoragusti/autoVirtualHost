
echo "Fran Pastor productions"
echo "SCRIPT PARA INSTALAR SERVIDORES VIRTUALES"

echo -n "Introduce una contraseña para el root de mysql -> "
read mysql_pass
echo -n "Introduce el nombre del sitio -> "
read sitio
echo -n "Introduce la url del repositorio -> "
read repositorio
echo -n "Introduce un email -> "
read email
echo -n "Introduce el dominio del sitio -> "
read url_sitio

echo "sudo apt-get -y update

#instalación de apache
sudo apt-get -y install apache2

#instalación de git
sudo apt-get -y install git

#instalación de mysql
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password $mysql_pass'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password $mysql_pass'
sudo apt-get -y install mysql-server libapache2-mod-auth-mysql php5-mysql

#borramos posibles carpetas con el mismo nombre y la creada por apache
sudo rm -rf /var/www/$sitio
sudo rm -rf /var/www/index.html
#clonar las paginas de ejemplo
git clone $repositorio . /var/www/$sitio" >> provisioner.sh

echo "<VirtualHost *:80>
    ServerAdmin $email
    ServerName $sitio.com
    ServerAlias $url_sitio
    DocumentRoot /var/www/$sitio
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> $sitio.conf

echo "#movemos los archivos de configuracion al apache
sudo mv $sitio.conf /etc/apache2/sites-available/$sitio.conf
cd /etc/apache2/sites-available/
sudo a2ensite $sitio.conf
sudo a2dissite default
sudo service apache2 reload" >> provisioner.sh
