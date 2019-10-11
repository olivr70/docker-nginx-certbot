
Une image Docker qui exécute nginx et certbot

Elle permet de faire très facilement un serveur web avec un certificat ssl généré par Let's Encrypt et qui se renouvelle automatiquement

L'image est basé sur [phusion/baseimage - Docker Hub](https://hub.docker.com/r/phusion/baseimage).

On ajoute
- nginx, qui s'exécute avec le user nginx $UID (743 par défaut)
- certbot

UID est un "build arg". On peut le fixer :
- avec `docker build --build-arg UID=999`
- dans un docker-compose, avec 
```yml
     dockerfile: Dockerfile
     args:
       UID: 999
```

La configuration par défaut de nginx
- se trouve dans /etc/nginx/nginx.conf
- elle inclut dans _http_ tous les fichiers `conf.d/*.conf`
- conf.d/default.conf sert le contenu de `/usr/share/nginx/html`

## Utilisation de l'image
### Pour servir des pages web
On map simplement le dossier des pages web
- docker run -v $(pwd)/html:/usr/share/nginx/html

### Pour remplacer la configuration par défaut
On map simplement le répertoire conf.d
- docker run -v ($pwd)/etc/nginx:/etc/nginx
