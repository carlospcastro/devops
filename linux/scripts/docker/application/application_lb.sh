#!/bin/bash


##########################################################
# Script administracao Docker                            #
#                                                        #
# Fri Oct 26 16:14:27 BRST 2018                          #
# Carlos Castro - carlospcastro@gmail.com		         #
# Produção Projetos - TI                                 #
##########################################################

APP=application_lb
CONTAINER=`docker ps | grep application-lb | awk '{print $1}'`
STATUS=`docker ps | grep application-lb| wc -l`
HOME_DIR=/app/carlos/application/lb/
LOG_FILE=/app/scripts/application/logs/application_lb.log
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
		docker run -d -p 8181:80 carlos/application-lb  > /dev/null
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

			docker stop $CONTAINER > /dev/null
			docker build -t carlos/application-lb:latest $HOME_DIR > /dev/null
				if [ $? -ne 0 ]; then
                        		echo "$DATA_H Ocorreu um erro ao geral build, verificar manualmente: $APP." | tee -a $LOG_FILE
                        	exit 0
                		else
					docker run -d -p 8181:80 carlos/application-lb  > /dev/null
					echo "$DATA_H Deploy realizado com sucesso - Container $APP is Running" | tee -a $LOG_FILE
                		fi
			exit 0

	;;

		
	*)
		echo $"Usage: $0 {start|stop|logs|status|deploy}"
esac
