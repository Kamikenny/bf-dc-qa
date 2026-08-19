# Intro au application Web (Frontend avec JavaScript)

## Client side-rendering (CSR)
Une app tourne sur le navigateur client.
Le serveur envois l'état initial (index.html + JS) et ensuite le JS anime le site.

### Technologie (Liste non exhaustive)
- React 
- Angular
- VueJS
- Ember.js
- Svelte
- Owl (Odoo)
- SolidJS

### Aventages
- L'application tournant coté client, les besoins serveurs sont minime

## Inconvénients
- Application plus lourd pour le client.
- Sécurité plus complexe (Tout est accessible dans le client)
- Mauvais reférencement et accessibilité


## Méta-Frameworks : Server side rendering (SSR) + Static Site Generation (SSG)
Reprend le fonctionnement des app CSR mais avec un partie serveur :
- Pré-génération
- Page static commune
- Rendu server possible (SSR)
- Rendu client possible (CSR)
- Code coté serveur

### Technologie (Liste non exhaustive)
- NextJS (React)
- Remix (React)
- Nuxt   (Vue)
- SvelteKit (Svelte)
- Analog (Angular)
- Angular SSR (Angular)

### Aventages
- Meilleur référencement et accessiblité
- Application legere pour le client

## Inconvénients
- Besoin serveur plus important
- Mécanisme d'hydratation
- Plus complexe (Frontend et Backend)