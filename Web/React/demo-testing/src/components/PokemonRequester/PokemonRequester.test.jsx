import { act, render, screen } from "@testing-library/react";
import { describe, expect, test } from "vitest";
import PokemonRequester from "./PokemonRequester";



describe('PokemonRequester component', () => {
    test('Shows pokemon after request WebAPI', async () => {
        // Arrange
        const pokemonId = 100

        // Act - Rendu asynchrone (Requête réseau)
        await act(() => {
            render(<PokemonRequester id={pokemonId} />)
        })

        // Assert
        expect(screen.getByText("Nom du Pokemon : voltorb")).toBeInTheDocument()
    });

    test('Shows loading message before request', async () => {
        // Arrange
        render(<PokemonRequester id={100} />)

        // Assert
        expect(screen.getByText('Le pokemon arrive !')).toBeInTheDocument();
    });

    test('Displays error message on failed request', async () => {
        // Arrange
        const pokemonId = -42

        // Act
        await act(() => {
            render(<PokemonRequester id={pokemonId} />)
        })

        // Assert
        expect(screen.getByText('Une erreur est survenu :o')).toBeInTheDocument()
    })
})