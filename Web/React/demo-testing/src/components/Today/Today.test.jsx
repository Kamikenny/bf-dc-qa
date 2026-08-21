import { describe, expect, test, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import Today from "./Today";

// ↓ On importe la méthode qui doit être "forcée" par le mock
import { getToday } from "../../tools/date.tool";

// ↓ Mock le module avec le "vi.mock"
vi.mock("../../tools/date.tool")

describe('Today component', () => {

    test('Displays the proper date', () => {
        // Setup Mock
        getToday.mockReturnValue(new Date(2026, 6, 21));

        // Arrange
        render(<Today />);

        // Act
        const elem = screen.getByRole('paragraph');

        // Assert
        expect(elem).toHaveTextContent('mardi 21 juillet 2026')
        expect(getToday).toHaveBeenCalledOnce
    })

})