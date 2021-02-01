#!/bin/bash


##########################################################
# Script administracao Docker                            #
#                                                        #
# Fri Oct 26 16:14:27 BRST 2018                          #
# Carlos Castro - carlospcastro@gmail.com		 #
# Produção Projetos - TI                                 #
##########################################################


HOME_DIR=/app/scripts/application/

if [ "$1" == "" ]; then
        echo "Usage: $0 {start|stop|logs_[1-2]|status|deploy}"
        exit 1
fi

case "$1" in
        stop)
		$HOME_DIR/application_1.sh stop
		$HOME_DIR/application_2.sh stop		
        ;;
        start)
                $HOME_DIR/application_1.sh start
		$HOME_DIR/application_2.sh start
        ;;
        logs_1)
                $HOME_DIR/application_1.sh logs
        ;;
        logs_2)
                $HOME_DIR/application_2.sh logs
        ;;
        status)
                $HOME_DIR/application_1.sh status
		$HOME_DIR/application_2.sh status
		$HOME_DIR/application_lb.sh status
        ;;
        deploy)
                $HOME_DIR/application_1.sh deploy
		$HOME_DIR/application_2.sh deploy

        ;;

        *)
                echo $"Usage: $0 {start|stop|logs_[1-2]|status|deploy}"
esac

