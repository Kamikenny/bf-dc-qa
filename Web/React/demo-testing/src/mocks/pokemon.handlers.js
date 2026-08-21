import { http, HttpResponse } from "msw";
import pokemonData from '../data/pokeapi-result.json';

const pokemonHandlers = [

    http.get('https://pokeapi.co/api/v2/pokemon/100', () => {
        return HttpResponse.json(pokemonData)
    })

]

export default pokemonHandlers;