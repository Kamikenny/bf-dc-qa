import { ErrorBoundary } from "react-error-boundary";
import { fetchPokemon } from "../../services/pokemon.service";
import { Suspense, use } from "react";
import Pokemon from "../Pokemon/Pokemon";

export default function PokemonRequester({ id }) {
    const pokemonPromise = fetchPokemon(id);

    return (
        <ErrorBoundary fallback={<p>Une erreur est survenu :o</p>}>
            <Suspense fallback={<p>Le pokemon arrive !</p>}>
                <PokemonRequesterInner promise={pokemonPromise} />
            </Suspense>
        </ErrorBoundary>
    )
}

function PokemonRequesterInner({ promise }) {
    const pokemon = use(promise);
    return <Pokemon data={pokemon} />
}