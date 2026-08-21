import { http, HttpResponse } from "msw";
import pokemonData from '../data/pokeapi-result.json';

const pokemonHandlers = [

    http.get('https://pokeapi.co/api/v2/pokemon/100', () => {
        // Envoi des données du pokemon Voltorbe
        return HttpResponse.json(pokemonData)
    }),
    http.get('https://pokeapi.co/api/v2/pokemon/-42', () => {
        // Erreur serveur
        return HttpResponse.json(null, { status: 500 })
    }),


]

export default pokemonHandlers;