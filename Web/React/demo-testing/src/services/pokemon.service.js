export async function fetchPokemon(pokeId) {
    // Récuperation des données depuis la WebAPI
    const url = `https://pokeapi.co/api/v2/pokemon/${pokeId}`;
    const data = await fetch(url).then(res => res.json());

    // Renvoyer les données
    return {
        name: data.name,
        types: data.types.map(elem => elem.type.name),
        stats: data.stats.map(elem => ({
            name: elem.stat.name,
            value: elem.base_stat
        })),
        sprites: data.sprites.front_default
    }
}