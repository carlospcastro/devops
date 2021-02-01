#!/bin/bash


##########################################################
# Script administracao Docker                            #
#                                                        #
# Fri Oct 26 16:14:27 BRST 2018                          #
# Carlos Castro - carlospcastro@gmail.com		         #
# Produção Projetos - TI                                 #
##########################################################



APP=application_1
CONTAINER=`docker ps | grep application-api_1 | awk '{print $1}'`
STATUS=`docker ps | grep application-api_1| wc -l`
HOME_DIR=/app/carlos/application/api_1/
APP_ORI=/app/carlos/deploy/application/application.api.war
LOG_FILE=/app/scripts/application/logs/application_exec_1.log
DATA_H="`date +%Y-%m-%d\ %H:%M:%S` ---"

if [ "$1" == "" ]; then
        echo "Usage: $0 {start|stop|logs|status|deploy}"
        exit 1
fi

case "$1" in
	stop)
		docker stop $CONTAINER > /dev/null
		if [ $? -ne 0 ]; then
   			echo "$DATA_H Ocorreu um erro ao parar o container $APP." | tee -a $LOG_FILE
   			exit 0
		else
			echo "$DATA_H Container $APP is Stopped"| tee -a $LOG_FILE
		fi 
	;;
	start)
		docker run --dns 172.22.164.1 -d -p 8080:8080 -v /app/logs/application/api_1:/app/logs/application carlos/application-api_1 > /dev/null
                if [ $? -ne 0 ]; then
                        echo "$DATA_H Ocorreu um erro ao subir o container $APP."| tee -a $LOG_FILE
                        exit 0
                else
                        echo "$DATA_H Container $APP is Running"| tee -a $LOG_FILE
                fi
	;;
	logs)
		docker logs -f  $CONTAINER 
	;;
	status)
		if [ $STATUS -eq 1 ] ; then
			echo "$DATA_H Container $APP is Running"
		else
			echo "$DATA_H Container $APP Stopped"
		fi
	;;
	deploy)
		echo "$DATA_H *** Iniciando  deploy - $APP   *** " | tee -a  $LOG_FILE

		if [ -e $APP_ORI ]; then
			chmod 755 $APP_ORI
                	mv $HOME_DIR/application.api.war $HOME_DIR/application.api.war_`date +%Y-%m-%d`
			mv $APP_ORI $HOME_DIR 2> /dev/null
			docker stop $CONTAINER > /dev/null
			docker build -t carlos/application-api_1:latest $HOME_DIR > /dev/null
				if [ $? -ne 0 ]; then
                        		echo "$DATA_H Ocorreu um erro ao geral build, verificar manualmente: $APP." | tee -a $LOG_FILE
                        	exit 0
                		else
					docker run --dns 172.22.164.1 -d -p 8080:8080 -v /app/logs/application/api_1:/app/logs/application carlos/application-api_1 > /dev/null
					echo "$DATA_H Deploy realizado com sucesso - Container $APP is Running" | tee -a $LOG_FILE
                		fi
		else
			echo "$DATA_H ERROR - Arquivo de origem ($APP_ORI) não encontrado" | tee -a $LOG_FILE
			exit 0
		fi

	;;

		
	*)
		echo $"Usage: $0 {start|stop|logs|status|deploy}"
esac
