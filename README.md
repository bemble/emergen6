# Projet "EMERGEN6"

Dans le cadre du hackathon NegMergitur organisé par la mairie de Paris les 15, 16 et 17 janvier 2016, nous avons réalisé ces applications.

## Equipe

* les devs : Pierre CLEMENT, Jérôme FIRLEJ, Yann BRELEUR & Benoît FONTAINE
* direction artistique iOS : Fatiha ELMOUKTAFI
* les data-scientists : Thibaud FEBRE & Félix MIKAELIAN
* les experts métier : Arnaud MANGEMATIN, Théo ROUGIER, Michel JAMMES & Christian SOMMADE

## Les applications

Le projet se divise en 3 applications différentes :

* Une application mobile (développée lors du hackathon pour iOS) pour recueillir les informations, à destination des citoyens.
D'une simple pression sur un bouton, un citoyen peut émettre une alerte. Celle-ci sera géolocalisée automatiquement.
Si le citoyen est en mesure de le faire, il pourra alors donner un maximum d'informations sur son alerte,
de façon optimisée et ergonomique (ce qui n'est pas forcément le cas tout de suite), afin de permettre de la caractériser au maximum.
Si la situation ne lui permet de donner plus de détails, il peut remettre son téléphone dans sa poche. Dernière chose, les signalements
peuvent être une simple alerte, une photo; mais également  - et ceci n'a pas pu être développé mais franchement ça enverrait du pâté de campagne
champi-noisettes - de l'audio ou de la vidéo en direct. On a prévu des notifications, un widget pour démarrer un signalement sans avoir à ouvrir
l'application, aussi pouvoir passer en mode alerte : diminuer la luminosité de l'écran, essayer d'empêcher toute sonnerie et vibration etc.
Mais ça c'est pareil, c'est sur le papier pour l'instant. Voilà ce qu'on a de concret par contre :
![Emergen6 IOS](https://raw.github.com/pierrecle/emergen6/master/resources/ios-app.jpg)
* Un serveur, qui reçoit les signalements et surtout (mais ça c'est prévu, pas fait...) les traites en direct afin de caractériser automatiquement
l'information avant de les renvoyer à différents systèmes. L'avantage de ce serveur c'est qu'il contient les informations et celle-ci sont accessibles,
du coup on peut y brancher n'importe quel outil ou système existant qui ont besoins des informations (par exemple un SIG spécialisé et existant etc.).
* Une application de supervision, à destination des autorités, qui reçoit les signalements en direct sur une carte. Les superviseurs peuvent se focaliser 
ur un cadre précis de la carte, consulter les signalements ainsi que les informations recueillies par l'application mobile et les analyses du serveur
(par un système de priorisation des signalements, mais ça non-plus c'est pas fait). Une feature plutôt sympa qui est prévue c'est de pouvoir consulter
les vidéo ou audio en live. Sachant que ceux-ci seraient enregistrés sur le serveur et gravés dans la roche pour ne pas perdre ces informations.
Par contre, ce qui est développé c'est le fait de pouvoir consulter, sur la supervision, les photos envoyées par les citoyens depuis l'application mobile.
Enfin, on s'est dit que ça serait pas mal qu'un superviseur puisse envoyer des notifications aux citoyens sur l'application : par exemple, une zone interdite
au trafic, un quartier interdit d'accès lors d'un attentat, les utilisateurs dans la zone pourraient en être averti, cool non ?
![Emergen6 Supervision](https://raw.github.com/pierrecle/emergen6/master/resources/web-supervision.jpg)

## Notes de dev

* __Pourquoi n'y a-t-il pas de tests unitaires ?__ Nos applications sont principalement des passe-plats, le reste c'est de l'interface, et sur les 2 jours de devs on a préfé faire de la feature. 
* __0 sécurité dans le transfert des informations ?__ Oui, c'était le rush, alors autant passer le temps à faire de la feature.

## Licence

C'est du LGPL 3.0 :smile_cat: