
import { describe, expect, test } from "vitest";
import { render, screen } from "@testing-library/react";
import Welcome from "./Welcome";

describe('Welcome component', () => {
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
        // screen.debug(screen.getByRole("heading", { level: 1 }));

        // Assert
        expect(screen.getByText(messageWelcome)).toBeInTheDocument();
    });

    test('has a heading level 1 and content ILIKE "Bienvenue"', () => {
        // Arrange
        render(<Welcome firstname={'Bi'} lastname={'Blop'} />);

        // Act
        const title = screen.getByRole('heading', { level: 1 });

        // Assert
        expect(title).toHaveTextContent('Bienvenue');
    });

    test('has a heading level 1 and content checked by regex', () => {
        // Arrange
        render(<Welcome firstname={'Jack'} lastname={'Sparrow'} />);

        // Act
        const title = screen.getByRole('heading', { level: 1 });

        // Assert
        expect(title).toHaveTextContent(/Bienvenue [a-z]+ [a-z]+ !/i);
    });

})