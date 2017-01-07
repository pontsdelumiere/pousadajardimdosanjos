#!/bin/bash

case "$1" in

github)
    OUT_PATH="$HOME/Sites/pousadajardimdosanjos/pousadajardimdosanjos/docs/"
    rm -rf $OUT_PATH
    echo "Génération des fichiers GitHub"
    hugo                                                                \
        --destination=$OUT_PATH                                         \
        --baseURL="http://pousadajardimdosanjos.com/"
    cp CNAME $OUT_PATH
    if [ -z "$2" ]
    then
        echo "##########"
        echo "site généré à $OUT_PATH"
        COMMENT="Pas de commit sans commentaires !"
    else
        COMMENT=$2
        echo -e "\n### Mise à jour du dépôt"
        git add .
        git commit -m "$COMMENT"
        git push
    fi
    echo -e "\n### COMMENTAIRE = $COMMENT"
    ;;

*)
    # Obtient l’adresse IP de l’interface utilisée par défaut.
    # L’exécution est arrêtée si le port est utilisé.
    if=$(route -n get 0.0.0.0 2>/dev/null | awk '/interface: / {print $2}')
    if [ -n "$if" ]; then
        echo "Default route is through interface $if"
    else
        echo "No default route found"
    fi
    IP=$( ipconfig getifaddr $if )
    echo $IP
    PORT=8080
    PORTINUSE=$( lsof -i tcp:$PORT )
    if [ -n "$PORTINUSE" ]; then
        echo "$IP:$PORT already in use"
        exit 1
    fi

    hugo server                 \
        --baseURL="http://$IP/" \
        --bind=$IP              \
        --port=$PORT            \
        --appendPort=true       \
        --theme pjda
    ;;

esac

exit 0
