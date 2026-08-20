
import { describe, expect, test } from "vitest";
import { render, screen } from "@testing-library/react";
import Welcome from "./Welcome";

describe('Welcome', () => {
    test('displays welcome message', () => {
        // Arrange
        // - Variable
        const firstname = 'July';
        const lastname = 'Flora';
        const messageWelcome = 'Bienvenue July Flora !';
        // - Rendu du composant à tester
        render(<Welcome firstname={firstname} lastname={lastname} />)

        // Act
        // - Aucun comportement pour ce test

        // - debug du screen
        screen.debug(screen.getByRole("heading", { level: 1 }));

        // Assert
        expect(screen.getByText(messageWelcome)).toBeInTheDocument();
    })
})