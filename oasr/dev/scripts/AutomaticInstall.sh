# java

echo "==============开始安装java=================="
jdk_dir=~/local/java
mkdir -p $jdk_dir
echo "==============解压java工具=================="
tar zxvf ../java/jdk-7u45-linux-x64.gz -C $jdk_dir
echo "==============java解压完毕=================="
echo "==============java环境变量配置=================="
echo "JAVA_HOME=$jdk_dir/jdk1.7.0_45">>~/.bash_profile
echo "PATH=\$JAVA_HOME/bin:\$PATH">>~/.bash_profile
echo "CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar">>~/.bash_profile
echo "export JAVA_HOME">>~/.bash_profile
echo "export PATH">>~/.bash_profile
echo "export CLASSPATH">>~/.bash_profile

echo "JAVA_HOME=$jdk_dir/jdk1.7.0_45">>~/.bashrc
echo "PATH=\$JAVA_HOME/bin:\$PATH">>~/.bashrc
echo "CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar">>~/.bashrc
echo "export JAVA_HOME">>~/.bashrc
echo "export PATH">>~/.bashrc
echo "export CLASSPATH">>~/.bashrc

source ~/.bash_profile 
source ~/.bashrc
echo "==============java环境变量配置完毕=================="
echo "==============java环境安装完毕=================="

# tomcat

echo "==============开始安装tomcat=================="
tomcat_dir=~/local/tomcat
mkdir -p $tomcat_dir
echo "==============解压tomcat工具=================="
tar zxvf ../tomcat/apache-tomcat-8.5.5*.tar.gz -C $tomcat_dir
echo "==============tomcat解压完毕=================="
echo "==============tomcat环境变量配置=================="
echo "TOMCAT_HOME=$tomcat_dir/apache-tomcat-8.5.5">>~/.bash_profile
echo "CATALINA_HOME=$tomcat_dir/apache-tomcat-8.5.5">>~/.bash_profile
echo "CATALINA_BASE=$tomcat_dir/apache-tomcat-8.5.5">>~/.bash_profile
echo "export TOMCAT_HOME  CATALINA_HOME  CATALINA_BASE">>~/.bash_profile

echo "TOMCAT_HOME=$tomcat_dir/apache-tomcat-8.5.5">>~/.bashrc
echo "CATALINA_HOME=$tomcat_dir/apache-tomcat-8.5.5">>~/.bashrc
echo "CATALINA_BASE=$tomcat_dir/apache-tomcat-8.5.5">>~/.bashrc
echo "export TOMCAT_HOME  CATALINA_HOME  CATALINA_BASE">>~/.bashrc

source ~/.bash_profile
source ~/.bashrc
echo "==============tomcat环境变量配置完毕=================="
echo "==============tomcat环境安装完毕=================="

# ffmpeg

#echo %time%>>time.txt
#rm -f time.txt
echo "===============开始安装ffmpeg=================="
cd ../ffmpeg
echo "==================解压ffmpeg==================="
tar -xvjf ffmpeg-3.0.tar.bz2
echo "==================ffmpeg解压完毕=========================="
# -C /home/thinkit/xiaosujie/tools_ceshi/ffmpeg
cd ffmpeg-3.0
echo "==================执行./configure命令====================="
ffmpeg_dir=~/local/ffmpeg
mkdir -p $ffmpeg_dir
./configure --disable-yasm --enable-shared --prefix=$ffmpeg_dir
echo "======================./configure命令执行完毕====================="
echo "=====================执行make命令==================="
CORE_NUM=`cat /proc/cpuinfo | grep processor | wc -l`
make clean
make -j$CORE_NUM
#echo "=========================make命令执行完毕======================="
echo "==============ffmpeg make执行完毕=============="
echo "===============执行make install命令"
make install
echo "==========ffmpeg make install执行完毕============"
echo "==============ffmpeg环境变量配置=================="
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$ffmpeg_dir/lib/">>~/.bash_profile
echo "export LIBRARY_PATH=\$LIBRARY_PATH:$ffmpeg_dir/lib/">>~/.bash_profile
echo "export PATH=\$PATH:$ffmpeg_dir/bin/">>~/.bash_profile
echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$ffmpeg_dir/include/">>~/.bash_profile
echo "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$ffmpeg_dir/include/">>~/.bash_profile
echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:$ffmpeg_dir/lib/pkgconfig/">>~/.bash_profile

echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$ffmpeg_dir/lib/">>~/.bashrc
echo "export LIBRARY_PATH=\$LIBRARY_PATH:$ffmpeg_dir/lib/">>~/.bashrc
echo "export PATH=\$PATH:$ffmpeg_dir/bin/">>~/.bashrc
echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$ffmpeg_dir/include/">>~/.bashrc
echo "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$ffmpeg_dir/include/">>~/.bashrc
echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:$ffmpeg_dir/lib/pkgconfig/">>~/.bashrc

source ~/.bash_profile
source ~/.bashrc
######################################
echo "==============ffmpeg环境变量配置完毕=================="
#echo $PATH
#ffmpeg --version>>time.txt
echo "===============安装ffmpeg结束=================="
cd ../../AutomaticInstall

# sox

echo "===============开始安装sox================="
cd ../sox
echo "==============解压sox工具=================="
tar zxvf sox-14.4.1.tar.gz
echo "==============解压sox工具完毕=================="
cd sox-14.4.1
echo "==============执行./configure命令=================="
sox_dir=~/local/sox
mkdir -p $sox_dir
./configure --prefix=$sox_dir
echo "==============执行./configure命令完毕=================="
echo "==============解压make命令=================="
CORE_NUM=`cat /proc/cpuinfo | grep processor | wc -l`
make clean
make -j$CORE_NUM
echo "==============sox make执行完毕=================="
echo "==============执行make install命令=================="
make install
echo "==============sox make install执行完毕=================="
echo "==============sox环境变量配置=================="
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$sox_dir/lib/">>~/.bash_profile
echo "export LIBRARY_PATH=\$LIBRARY_PATH:$sox_dir/lib/">>~/.bash_profile
echo "export PATH=\$PATH:$sox_dir/bin/">>~/.bash_profile
echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$sox_dir/include/">>~/.bash_profile
echo "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$sox_dir/include/">>~/.bash_profile
echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:$sox_dir/lib/pkgconfig/">>~/.bash_profile

echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$sox_dir/lib/">>~/.bashrc
echo "export LIBRARY_PATH=\$LIBRARY_PATH:$sox_dir/lib/">>~/.bashrc
echo "export PATH=\$PATH:$sox_dir/bin/">>~/.bashrc
echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$sox_dir/include/">>~/.bashrc
echo "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$sox_dir/include/">>~/.bashrc
echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:$sox_dir/lib/pkgconfig/">>~/.bashrc

source ~/.bash_profile
source ~/.bashrc
######################################
echo "==============sox环境变量配置完毕=================="
echo "==============sox安装完毕=================="
cd ../../AutomaticInstall 

# protobuf
echo "===============开始安装protobuf================="
cd ../protobuf
echo "==============解压protobuf工具=================="
tar zxvf protobuf-2.5.0.tar.gz
echo "==============解压protobuf工具完毕=================="
cd protobuf-2.5.0
echo "==============执行./configure命令=================="
protobuf_dir=~/local/protobuf
mkdir -p $protobuf_dir
./configure --prefix=$protobuf_dir
echo "==============执行./configure命令完毕=================="
echo "==============解压make命令=================="
CORE_NUM=`cat /proc/cpuinfo | grep processor | wc -l`
make clean
make -j$CORE_NUM
echo "==============protobuf make执行完毕=================="
echo "==============执行make install命令=================="
make install
echo "==============protobuf make install执行完毕=================="
echo "==============protobuf环境变量配置=================="
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$protobuf_dir/lib/">>~/.bash_profile
echo "export LIBRARY_PATH=\$LIBRARY_PATH:$protobuf_dir/lib/">>~/.bash_profile
echo "export PATH=\$PATH:$protobuf_dir/bin/">>~/.bash_profile
echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$protobuf_dir/include/">>~/.bash_profile
echo "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$protobuf_dir/include/">>~/.bash_profile
echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:$protobuf_dir/lib/pkgconfig/">>~/.bash_profile

echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$protobuf_dir/lib/">>~/.bashrc
echo "export LIBRARY_PATH=\$LIBRARY_PATH:$protobuf_dir/lib/">>~/.bashrc
echo "export PATH=\$PATH:$protobuf_dir/bin/">>~/.bashrc
echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$protobuf_dir/include/">>~/.bashrc
echo "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$protobuf_dir/include/">>~/.bashrc
echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:$protobuf_dir/lib/pkgconfig/">>~/.bashrc

source ~/.bash_profile
source ~/.bashrc
######################################
echo "==============protobuf环境变量配置完毕=================="
echo "==============protobuf安装完毕=================="
cd ../../AutomaticInstall 

# redis

echo "==============开始安装redis=================="
redis_dir=~/local/redis
mkdir -p $redis_dir
echo "==============解压redis工具=================="
tar zxvf ../redis/redis-3.2.0.tar.gz -C $redis_dir
echo "==============redis解压完毕=================="
echo "==============redis环境安装完毕=================="
